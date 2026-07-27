# Contributing

Thank you for contributing to topsbot_msgs.

## Getting Started

1. Fork the repository and create a feature branch from `main`.
2. Place the repo under a ROS 2 workspace `src/` directory.
3. Build message packages:

```bash
colcon build --packages-select tb_img_msgs tb_det_msgs
source install/setup.bash
```

4. Rebuild downstream packages that depend on changed messages.

## Message Changes

- ROS 2 message file names must be PascalCase (`TbMsg480P.msg`).
- Keep field semantics documented in README when adding or renaming fields.
- Avoid breaking ABI without a version bump and changelog entry.
- If message design references external projects (e.g. hbm_img_msgs), note it in the MR description.

## Pull Requests

- Describe the motivation, the message/schema change, and migration impact.
- Update `README.md`, `README_cn.md`, and sub-package docs when user-facing behavior changes.
- Add an entry under `CHANGELOG.md` (Unreleased section).
- Do not commit build artifacts (`build/`, `install/`, `log/`).

## Reporting Issues

Please include:

- ROS 2 distro (e.g. Humble)
- Package version or git commit
- Expected vs actual message layout or generated header names
- Steps to reproduce (build command, dependent package)

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.
