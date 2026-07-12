# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- **Breaking:** Rewrote the plugin in Lua. Vim is no longer supported; only
  Neovim going forward.
- **Breaking:** Views are saved under Neovim's state directory
  (`stdpath('state') .. '/deja-view'`) instead of `/tmp`. Old views are not
  migrated; you lose your saved scroll positions once.
- **Breaking:** The save mode override variables are renamed from
  `deja_save_mode` to `deja_view_mode` (`vim.g` or `vim.b`).

### Added

- An optional `setup()` function controls where views are saved. The plugin
  works without it.
- Help docs: `:help deja-view`.

### Removed

- **Breaking:** `g:deja#backup_path` no longer exists. Use
  `setup({ save_dir = ... })` instead.

## [0.1.0] - 2021-11-24

Initial release (unstable).

[Unreleased]: https://github.com/PsychoLlama/deja-view.nvim/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/PsychoLlama/deja-view.nvim/commits/v0.1.0
