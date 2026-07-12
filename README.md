# deja-view.nvim

Buffers, just how you left them.

## Purpose

This plugin remembers where you left off in a file, restoring your cursor and viewport.

Neovim can kind of do this already, so if you're looking for something simple, just read `:help restore-cursor`. It'll get you 90% of the way there.

What it _doesn't_ do is restore your scroll position, a detail which finally got annoying enough that I wrote my own plugin. It uses `winsaveview()` under the hood.

## Installation

The plugin works out of the box. No configuration required.

<details>
  <summary><strong>lazy.nvim</strong></summary>

```lua
{ "PsychoLlama/deja-view.nvim" }
```

</details>

<details>
  <summary><strong>mini.deps</strong></summary>

```lua
add({ source = 'PsychoLlama/deja-view.nvim' })
```

</details>

<details>
  <summary><strong>home-manager</strong></summary>

Deja View is available as a flake:

```nix
# flake.nix
{
  inputs.deja-view-nvim.url = "github:PsychoLlama/deja-view.nvim";
}
```

```nix
# home-configuration.nix
programs.neovim = {
  plugins = [
    flake-inputs.deja-view-nvim.packages.${pkgs.system}.default
  ];
};
```

</details>

## Configuration

Configuration is optional. Views are saved under Neovim's state directory unless you say otherwise:

```lua
require('deja-view').setup({
  save_dir = vim.fs.joinpath(vim.fn.stdpath('state'), 'deja-view'),
})
```

See [:help deja-view](https://github.com/PsychoLlama/deja-view.nvim/blob/main/doc/deja-view.txt) for the full documentation, including how to control or disable persistence per buffer.
