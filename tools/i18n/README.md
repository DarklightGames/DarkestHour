# `i18n` Tool

This is an in-house tool for managing continuous localization files for Darkest Hour: Europe '44-'45, though it will mostly work for any other game on the Unreal 2.5 engine.

This tool is designed to work with our game's [Weblate platform](https://weblate.darklightgames.com/), but it can be adapted for used with any other translation platform that supports gettext `.po` files.

## Installation
1. Install Python 3.12 or later.
2. Create a virtual environment and activate it.
3. Install the required packages with `pip install -r requirements.txt`.

## Workflow

1. The game's `.int` files are exported to `.po` files using the `export_directory` command.
2. The `.po` files are uploaded to a Weblate repository.
3. Translators create translations on Weblate.
4. The files from Weblate are then downloaded and converted back to the appropriate translation files for the game (e.g., `.rus` for Russian etc.).

## `i18n.yaml`

The `i18n.yaml` file is the configuration file that should live in the mod folder. For example, `./DarkestHourDev/i18n.yaml`.

This is used, for now, only with the `sync` command so that it knows where to download the translations from.

```yaml
repository:
  url: https://github.com/your-weblate-repository.git
  branch: branch-name
```

## Font Generation

The `i18n` tool also has a `generate_font_scripts` command to generate a script file that can be executed within the SDK to generate fonts.

1. Run `generate_fonts.bat` to generate the font scripts file.
2. In the SDK, run `exec C:\path\to\font\script.txt` from the console.

See the `fonts.yaml` file for how to the font configuration is handled.
