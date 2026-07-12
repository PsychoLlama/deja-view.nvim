<div align="center">
  <h1>Deja View</h1>
  <p><em>Buffers, just how you left them.</em></p>
</div>

<h2>
  Purpose
  <a href="https://github.com/PsychoLlama/deja-view.vim/actions/workflows/test.yml">
    <img alt="Test status badge" align="right" src="https://github.com/PsychoLlama/deja-view.vim/actions/workflows/test.yml/badge.svg" />
  </a>
</h2>

This plugin remembers where you left off in a file, restoring your cursor and viewport.

Vim can kind of do this already, so if you're looking for something simple, just read `:help last-position-jump`. It'll get you 90% of the way there.

What it _doesn't_ do is restore your scroll position, a detail which finally got annoying enough that I wrote my own plugin. It uses `winsaveview()` under the hood.

## Installation

Deja View is compatible with vim & neovim.

**[packer](https://github.com/wbthomason/packer.nvim)**

```lua
use 'PsychoLlama/deja-view.vim'
```

**[vim-plug](https://github.com/junegunn/vim-plug)**

```vim
Plug 'PsychoLlama/deja-view.vim'
```

**[pathogen](https://www.merriam-webster.com/dictionary/plebs)**

```bash
git clone https://github.com/PsychoLlama/deja-view.vim ~/.vim/bundle/deja-view.vim
```
