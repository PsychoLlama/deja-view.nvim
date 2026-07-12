# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-07-12

### Changed

- **Breaking:** Rewrote the plugin in Lua. Vim is no longer supported; only Neovim going forward.
- **Breaking:** Views are saved under Neovim's state directory (`stdpath('state') .. '/deja-view'`) instead of `/tmp`. Views in `/tmp` don't survive a reboot, so there's nothing to migrate; you lose your saved scroll positions once.

### Fixed

- Reloading a buffer (`:edit`, `:checktime`, …) no longer yanks the cursor back to the last saved position. Views are now saved when a buffer unloads, so the stored view stays fresh through reloads, `:bdelete`, and `'nohidden'` abandons.

### Added

- An optional `setup()` function controls where views are saved.
- A `driver` option for `setup()` decides where each buffer's view is stored — a function of the buffer number that returns a driver (or `nil` to skip the buffer).
- Help docs: `:help deja-view`.

### Removed

- **Breaking:** `g:deja#backup_path` no longer exists. Use `setup({ save_dir = ... })` instead.
- **Breaking:** The `b:deja_save_mode` / `g:deja_save_mode` variables no longer exist. Pass a `driver` function to `setup()` instead.

## [0.1.0] - 2021-11-24

Initial release (unstable).

[Unreleased]: https://github.com/PsychoLlama/deja-view.nvim/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/PsychoLlama/deja-view.nvim/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/PsychoLlama/deja-view.nvim/commits/v0.1.0
