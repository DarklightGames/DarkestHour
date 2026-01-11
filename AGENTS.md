# AGENTS.md

This is Darkest Hour: Europe '44-'45's agent guidelines document.

This repository is written in UnrealScript.

# Localization
* Use `localized string` for any text that will be shown to the player.
* Debug or logging text does not need to be localized.

# UnrealScript
* This project uses UnrealScript 2 syntax and conventions.
* `local` variables must be declared at the start of a function.
* `var` variables are class or struct member variables.
* All `*.uc` files must be encoded with Windows-1252.
* All `Object` and `Actor` references can be `None`, so always check for `None` before using them.
* The names of classes must correspond to the filenames exactly, including capitalization.
* Class references should prefer to use unqualified class names when possible. For example, use `Class'DHGerVoice'` instead of `Class'DH_GerPlayers.DHGerVoice'` when the class is unambiguous.

# Style
* Use 4 spaces for indentation. Do not use tab characters.
* Use braces `{}` for all control structures, even if they are optional.
* Avoid repetitive casting by storing the result of a cast in a local variable.
* Blocks of variable declarations usually share the same indentation level for the name and type. For example:
```
var     int      VariableOne;
var()   float    VariableTwo;
var     string   VariableThree;
```

## String Manipulation
* Use `$` to concatenate strings. For example: `FullString = "StringA" $ "StringB";` will result in `FullString` being `"StringAStringB"`.
* Use `@` to concatenate strings with a space character in between. For example: `FullString = "StringA" @ "StringB";` will result in `FullString` being `"StringA StringB"`.
* Use `Len(StringVar)` to get the length of a string.

# Naming Conventions
* Unless otherwise specified, use `PascalCase` for all class names, function names, and variable names.
* Prefix boolean variables with `b`. For example: `bIsActive`, `bHasAmmo`.
* Boolean variables and functions should be named as yes/no questions (e.g., `bIsVisible`, `IsReady()`, `CanFire()`).
* All constants should be in `SCREAMING_SNAKE_CASE`.
* All DH-specific classes should be prefixed with `DH_` or `DH`, depending on how class names are typically formed in the relevant package.
* The units for all variable names should be indicated as a suffix where appropriate (e.g., `SpeedKPH`, `DistanceMeters`, `TimeSeconds`).

# Building
* Use `./tools/make/make.sh` to build the project on Linux.
* Use `./tools/make/make.bat` to build the project on Windows.
