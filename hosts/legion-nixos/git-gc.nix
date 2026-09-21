# Periodic `git gc` across the Syncthing-mirrored work tree.
#
# ~/Work is a receiveonly Syncthing mirror of the MBP. When the MBP runs gc it
# packs loose objects and deletes the now-empty .git/objects/XX dirs, then tells
# this machine to delete them too. Those dirs are still populated here, and
# Syncthing refuses to delete a non-empty directory -- so the pull fails and
# retries every 75s, forever. Left alone this pegged a core for 35 days and held
# the CPU at ~100degC.
#
# Running gc locally packs the same objects away, emptying the dirs so the
# pending deletes can finally apply. Weekly keeps the two sides converged.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  systemd.services.git-gc-work = {
    description = "Run git gc across ~/Work repos to settle Syncthing deletions";

    serviceConfig = {
      Type = "oneshot";
      User = "rid9";
      Group = "users";
      # Housekeeping, never at the expense of interactive work.
      Nice = 19;
      IOSchedulingClass = "idle";
      CPUSchedulingPolicy = "idle";
      # gc is CPU-heavy on large repos; cap it so it cannot pin the box.
      CPUQuota = "50%";
    };

    path = [
      pkgs.git
      pkgs.findutils
      pkgs.coreutils
    ];

    script = ''
      set -u

      root="$HOME/Work"
      [ -d "$root" ] || { echo "no $root, nothing to do"; exit 0; }

      failed=0

      # -prune so we never descend into a .git we have already matched.
      while IFS= read -r gitdir; do
        repo="$(dirname "$gitdir")"

        # Skip repos with a gc/rebase/merge in flight rather than fighting them.
        if [ -e "$repo/.git/gc.pid" ] || [ -e "$repo/.git/index.lock" ]; then
          echo "skip (busy): $repo"
          continue
        fi

        if git -C "$repo" rev-parse --git-dir >/dev/null 2>&1; then
          if git -C "$repo" gc --quiet --prune=now 2>&1; then
            echo "ok: $repo"
          else
            echo "FAILED: $repo"
            failed=$((failed + 1))
          fi
        fi
      done < <(find "$root" -type d -name .git -prune 2>/dev/null)

      echo "done; $failed repo(s) failed"
      # A single bad repo should not mark the whole run as failed.
      exit 0
    '';
  };

  systemd.timers.git-gc-work = {
    description = "Weekly git gc across ~/Work";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "Sun 04:00";
      # Catch up if the machine was asleep at the scheduled time.
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
  };
}
