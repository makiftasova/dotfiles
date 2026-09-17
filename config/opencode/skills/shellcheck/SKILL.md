---
name: shellcheck
description: Use when running ShellCheck, linting or reviewing sh/bash/dash/ksh/BusyBox scripts, fixing or explaining SC#### diagnostics, configuring .shellcheckrc, resolving sourced-file warnings, or evaluating ShellCheck suppressions. Do not use for shell formatting alone or general runtime debugging without static analysis.
compatibility: Requires shellcheck on PATH; validated with ShellCheck 0.11.0.
metadata:
  version: "0.1.0"
  category: Development Workflow
  audience: developers
  workflow: local
---

# ShellCheck

Use the installed ShellCheck as the authority for static analysis of shell
scripts. Preserve project behavior and shell portability while resolving
findings; do not treat ShellCheck as a formatter.

## Version Authority

- Check `shellcheck --version` before relying on version-sensitive behavior.
- Treat the host's `man shellcheck` and `shellcheck --help` output as the
  primary references for supported options, formats, directives, and exit
  statuses.
- Use the official wiki as a secondary source for explanations and examples.
  Web documentation may describe a newer ShellCheck release than the installed
  binary.
- When local and web documentation differ, follow the local documentation. Do
  not recommend an option or directive that the installed version does not
  support.

## Procedure

1. Read applicable project instructions and existing lint scripts. Prefer the
   project's established ShellCheck command when one exists.
2. Confirm `shellcheck` is available with `command -v shellcheck`. If it is
   absent, report the missing prerequisite; do not install it unless asked.
3. Select only the requested or changed shell files. Include extensionless
   files when their shebang identifies `sh`, `bash`, `dash`, `ksh`, or BusyBox
   shell. ShellCheck has no recursive `-r` option, so use explicit file lists or
   a carefully scoped `find` command and exclude generated or vendored files.
4. Honor the nearest `.shellcheckrc` or `shellcheckrc`, existing directives,
   and the intended shell dialect. By default ShellCheck derives the dialect
   from a `shell` directive, shebang, or recognized extension. Do not force
   `--shell` or use `--norc` unless project policy or the task requires it.
5. Run the selected files together when practical:

   ```sh
   shellcheck --format=gcc path/to/script.sh path/to/other-script
   ```

   Quote or otherwise safely construct every path. Do not enable optional
   checks, change severity, or exclude codes without a project rule or explicit
   reason.
6. Interpret status `0` as clean and status `1` as successfully scanned with
   findings. Statuses `2`, `3`, and `4` indicate processing, invocation-syntax,
   or option errors; correct those before evaluating the scripts.
7. For each `SC####` finding, understand the affected command and intended
   runtime behavior before editing. Consult the matching official wiki page
   when the rationale or safe fix is unclear.
8. Apply semantic fixes, preserve the declared dialect, and rerun the same
   command until clean or until only justified findings remain. Report the
   checked files, exact command, and any unresolved diagnostics.

## Sourced Files

- ShellCheck does not follow unspecified sourced files by default. For dynamic
  paths, prefer an accurate `source=...` directive or a project-level
  `source-path`, using `SCRIPTDIR` when appropriate.
- Use `--external-sources`/`-x` only when following project sources is intended
  and the paths are trusted. Do not blanket-disable SC1090 or SC1091 merely to
  make a run pass.

## Suppressions And Fixes

- Fix the code when practical. If a warning is intentionally inapplicable, use
  the narrowest `# shellcheck disable=SC####` directive and document why, as
  recommended by the ShellCheck wiki.
- Use file-wide or `.shellcheckrc` exclusions only for an established project
  policy. Never add `disable=all` merely to obtain a clean result.
- `--format=diff` emits proposed patches. Inspect every patch before applying
  it; do not pipe ShellCheck fixes directly into `git apply` or `patch` without
  review.
- Optional checks are opt-in. Inspect them with `shellcheck --list-optional`
  and enable only those requested or adopted by the project.

## Sources

- Installed-version reference: `man shellcheck` and `shellcheck --help`
- Official wiki: <https://github.com/koalaman/shellcheck/wiki>
- Directives: <https://github.com/koalaman/shellcheck/wiki/Directive>
- Suppressions: <https://github.com/koalaman/shellcheck/wiki/Ignore>
- File discovery: <https://github.com/koalaman/shellcheck/wiki/Recursiveness>
