# vmsetup

Using dotter to deploy bashrc and basic comfort in new temporary VMs

## Install:
Check `.dotter/global.toml` for settings
Edit:
```md
[bash.variables]
cwd = "~/Documents/genesis"
```
Then deploy with settings from the toml file.
`./dotter_x64 deploy`

https://github.com/SuperCuber/dotter


## vmsetip includes
 - Bashfiles like aliases and functions
 - Prompt for bash
 - Wallpaper
 - LightDM Greeter styling
 - Scripts
    - VibeCheck

---------------------

<details>
  <summary>Dotter help text</summary>

```md
A dotfile manager and templater written in rust

Usage: dotter [OPTIONS] [COMMAND]

Commands:
  deploy           Deploy the files to their respective targets. This is the default subcommand
  undeploy         Delete all deployed files from their target locations. Note that this operates on all files that are currently in cache
  init             Initialize global.toml with a single package containing all the files in the current directory pointing to a dummy value and a local.toml that selects that package
  watch            Run continuously, watching the repository for changes and deploying as soon as they happen. Can be ran with `--dry-run`
  gen-completions  Generate shell completions
  help             Print this message or the help of the given subcommand(s)

Options:
  -g, --global-config <GLOBAL_CONFIG>
          Location of the global configuration [default: .dotter/global.toml]
  -l, --local-config <LOCAL_CONFIG>
          Location of the local configuration [default: .dotter/local.toml]
      --cache-file <CACHE_FILE>
          Location of cache file [default: .dotter/cache.toml]
      --cache-directory <CACHE_DIRECTORY>
          Directory to cache into [default: .dotter/cache]
      --pre-deploy <PRE_DEPLOY>
          Location of optional pre-deploy hook [default: .dotter/pre_deploy.sh]
      --post-deploy <POST_DEPLOY>
          Location of optional post-deploy hook [default: .dotter/post_deploy.sh]
      --pre-undeploy <PRE_UNDEPLOY>
          Location of optional pre-undeploy hook [default: .dotter/pre_undeploy.sh]
      --post-undeploy <POST_UNDEPLOY>
          Location of optional post-undeploy hook [default: .dotter/post_undeploy.sh]
  -d, --dry-run
          Dry run - don't do anything, only print information. Implies -v at least once
  -v, --verbose...
          Verbosity level - specify up to 3 times to get more detailed output. Specifying at least once prints the differences between what was before and after Dotter's run
  -q, --quiet
          Quiet - only print errors
  -f, --force
          Force - instead of skipping, overwrite target files if their content is unexpected. Overrides --dry-run
  -y, --noconfirm
          Assume "yes" instead of prompting when removing empty directories
  -p, --patch
          Take standard input as an additional files/variables patch, added after evaluating `local.toml`. Assumes --noconfirm flag because all of stdin is taken as the patch
      --diff-context-lines <DIFF_CONTEXT_LINES>
          Amount of lines that are printed before and after a diff hunk [default: 3]
  -h, --help
          Print help
  -V, --version
          Print version
```
</details>
