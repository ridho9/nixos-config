{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      -- VSCode Neovim integration
      if vim.g.vscode then
          -- VSCode extension configuration
          vim.opt.clipboard = "unnamedplus"
          
          -- Make y and p use system clipboard
          vim.keymap.set({'n', 'v'}, 'y', '"+y', { noremap = true })
          vim.keymap.set({'n', 'v'}, 'Y', '"+Y', { noremap = true })
          vim.keymap.set({'n', 'v'}, 'p', '"+p', { noremap = true })
          vim.keymap.set({'n', 'v'}, 'P', '"+P', { noremap = true })
      else
          -- Regular Neovim configuration
          vim.opt.clipboard = "unnamedplus"
      end
    '';
  };
}
