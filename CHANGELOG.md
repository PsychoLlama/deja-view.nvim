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

### Added

- An optional `setup()` function controls where views are saved. The plugin
  works without it.
- A `driver` option for `setup()` decides where each buffer's view is stored,
  replacing the `deja_view_mode` variables. It's a function of the buffer
  number that returns a driver (or `nil` to skip the buffer).
- Help docs: `:help deja-view`.

### Removed

- **Breaking:** `g:deja#backup_path` no longer exists. Use
  `setup({ save_dir = ... })` instead.

## [0.1.0] - 2021-11-24

Initial release (unstable).

[Unreleased]: https://github.com/PsychoLlama/deja-view.nvim/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/PsychoLlama/deja-view.nvim/commits/v0.1.0
