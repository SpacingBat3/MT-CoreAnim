<div align=center>

[![CoreAnim]](#https://github.com/SpacingBat3/MT-CoreApi)
---

[![ContentDB](https://content.luanti.org/packages/SpacingBat3/coreanim/shields/downloads/)](https://content.luanti.org/packages/SpacingBat3/coreanim/)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/SpacingBat3/MT-CoreAnim?label=Code%20Size&color=%2322aa88)

Interpolated animation modpack, using Luanti 5.9+ API with backwards
compatible syntax.


</div>

## About the modpack

This modpack contains library that wraps new [`ObjectRef:set_bone_override`]
API into the backwards-compatible function with [`ObjectRef:set_bone_position`]
and aims to generalise animation API, so you may use it for bone-based
animations as you please.

The API is still being worked on, so it may have a breaking changes for any kind
of extensions to [`ObjectRef:set_bone_position`] API. It may take a modders'
opinions to stabilize itself.

## Goals (and TODOs):

- [X] Provide interpolated bone-based animations for players' heads.

- [X] Basic compatibility with other mods and games, by not overwritting
  other bones animations and avoiding game-specific APIs.

> [!NOTE]
> This means, I do not plan to implement anything that is
> not hardly dependant on `default` and `player_api` mods, those may
> be an optional dependencies, but should not be used for the core
> part of the mod.

- [X] Try to provide a backwards compatibility API, so bone overwrite
  mechanism is generalised and uses older API for older clients.

- [X] Consider making this a modpack over a single mod, to modularise
  it a bit and to alow to provide this as a library with backwards
  compatible syntax.

- [X] Consider replacing the official API once the modpack is
  activated, or find another way to make older mods use this over
  old API calls.

- [ ] Avoid *game exceptions*, *rule exceptions* etc. Make code generic
  enough so it can figure out any abnormalities on its own.

> [!NOTE]
> The idea of this point is to make animations as much fitting
> into other games than MTG as possible. Some stuff however may be limited,
> due to conflicts with the game animations.

- [ ] Provide *monoids* API to resolve conflicts between game and mod
  animations.
    
## License

This project is distributed under the terms of ISC license, distributed as
[`COPYING`] file. Under no circumstances shall this project be distributed
without the license file, or shared in any way that violates license terms and
conditions.

[CoreAnim]: ./screenshot.png
[`COPYING`]: ./COPYING
[`ObjectRef:set_bone_override`]: https://api.minetest.net/class-reference/#:~:text=set_bone_override(bone%2C%20override)
[`ObjectRef:set_bone_position`]: https://api.minetest.net/class-reference/#:~:text=set_bone_position(%5Bbone%2C%20position%2C%20rotation%5D)
