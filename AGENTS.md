# AGENTS.md

This is Darkest Hour: Europe '44-'45's agent guidelines document.

This repository is written in UnrealScript.

# Localization
* Use `localized string` for any text that will be shown to the player.
* Debug or logging text does not need to be localized.

# UnrealScript
* This project uses UnrealScript 2 syntax and conventions.
* `local` variables must be declared at the top of functions.
* `var` variables are class or struct member variables.
* All `*.uc` files must be encoded with Windows-1252.
* NEVER use em-dashes (—) in code comments. Always use double hyphens (--).
* All `Object` and `Actor` references can be `None`, so always check for `None` before using them.
* The names of classes must correspond to the filenames exactly, including capitalization.
* If no return statement is provided in a function, it will implicity return a default value based on the return type:
    * `int` and `float` return types default to `0` and `0.0` respectively.
    * `bool` return types default to `false`.
    * `string` return types default to an empty string `""`.
    * Reference types (e.g., `Object` and `Actor`) return types default to `None`.
    * Dynamic arrays (e.g., `array<int>`) return types default to an empty array.

# Style
* Use 4 spaces for indentation. Do not use tab characters.
* Use braces `{}` for all control structures, even if they are optional.
* Avoid repetitive casting by storing the result of a cast in a local variable.
* Blocks of variable declarations usually share the same indentation leve for the name and type. For example:
```
var     int      VariableOne;
var()   float    VariableTwo;
var     string   VariableThree;
```
* Class references should prefer to use unqualified class names when possible. For example, use `Class'DHGerVoice'` instead of `Class'DH_GerPlayers.DHGerVoice'` when the class is unambiguous.
* It is preferable to avoid nested control structures when possible. Consider refactoring code to use early returns or continue statements to reduce nesting depth.

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
* Enums should be prefixed with `E`. For example: `EGameMode`, `EWeaponType`.

# Arrays
* Use static arrays (e.g., `var int MyFixedArray[10];`) when the size is known and fixed.
* Use dynamic arrays (e.g., `var array<int> MyDynamicArray;`) when the size is variable or unknown.
* When adding items to dynamic arrays, use the syntax `MyDynamicArray[MyDynamicArray.Length] = NewItem;`.

# Replication
* Dynamic arrays (`array<T>`) cannot be replicated and should not be used for replicated variables. Use static arrays instead.
* In public functions, all references must be checked for `None` before being used.
* In public functions, all array indices must be checked to ensure they are within bounds before being accessed.

# Comments
* Functions must have a comment block with a brief description of their purpose, parameters, and return values (if any).
* Use `//` for single-line comments.
* Use `/* ... */` for multi-line comments.
* All explanatory comments should be complete sentences and use proper punctuation.

# Building
* Use `./tools/make/make` to build the project on Linux.
* Use `./tools/make/make.bat` to build the project on Windows.

# Testing & Debugging
* The game code has no built-in unit testing framework and relies on manual testing.
* Use logging and debug messages to assist with testing and debugging.
* Functions with the `exec` modifier can be invoked from the console and are often used to run debug commands. `exec` functions are only invokable if the player is possessing the appropriate `Pawn` or `Controller`.

# Debugging
* Remove unreferenced local variables to avoid compiler warnings.