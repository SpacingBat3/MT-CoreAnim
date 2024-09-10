# Unified API documentation

This documents the API for all mods included in this modpack.

## Core API

### `coreanim.set_bone_position([player, bone, position, rotation, scale, interpolation])`

A convenient wrapper around `ObjectRef:set_bone_override` with the
backwards-compatible syntax to `ObjectRef:set_bone_position`. This
enables interpolation by the default, if you not wish to, you may set
further `interpolation` arg as 0.

> [!WARNING]
> This API is still being not stabilized, args other than `player`, `bone`,
> `position` and `rotation` might change in a breaking manner. Please bear that
> in mind and avoid using them by the time being, unless you are ready for the
> API breakages and to resolve them in your mod / game.

### `coreanim.set_bone_override([player, bone, override])`

Basically `ObjectRef:set_bone_override`, but passes the args to
`ObjectRef:set_bone_position` in case API is not available for any reason and
enables interpolation by the default. It is supposed to be useful, if you don't
want to introduce *radians → degrees → radians* conversion that happens in
`coreanim.set_bone_position` to remain compatible with the old API syntax.

### `coreanim.register_fn(name,fn)`

Overrides functions used by CoreAnim APIs for bone override and position APIs.
This is extremely useful when integrating CoreAnim with mods that replace this,
or use CoreAnim as a replacement to the APIs provided by the engine, so it won't
infinitely call itself over and over (unless Lua works differently than what
I assume, I'm rather beginner at it).

> [!WARNING]
> This API is under considerations to become protected at the modpack scope.
> It might be unavailable in the future releases, if such decision will be made
> and it is actually possible to do so.

---
<div align=right><sub><i>More is TODO!</i> 😕️ --- SpacingBat3</sub></div>