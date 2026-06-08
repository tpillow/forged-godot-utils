# forged-godot-utils

A collection of common Godot 4.5+ scripts/nodes/scenes that I commonly use between multiple projects.

## Usage in a Godot project

In your Godot project's main directory (`res://`), copy this repository into a folder named `forged_godot_utils` or use git submodules to do so: `git submodule add git@github.com:tpillow/forged-godot-utils.git forged_godot_utils`

Note that this source is not a traditional Godot addon, and must be at the path `res://forged_godot_utils/` to work properly.

## Globals

Some classes can be used immediately as a registered global (in addition to a member of the scene tree). Common ones:

- `SceneManager` as `GScenes`
- `SoundManager` as `GSounds`
