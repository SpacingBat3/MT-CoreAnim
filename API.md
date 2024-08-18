# Unified API documentation

This documents the API for all mods included in this modpack.

## Core API

### `coreanim.set_bone_position([player, bone, position, rotation, scale, interpolation])`

A convenient wrapper around `ObjectRef:set_bone_override` with the
backwards-compatible syntax to `ObjectRef:set_bone_position`. This
enables interpolation by the default, if you not wish to, you may set
further `interpolation` arg as 0.

> [WARNING]
>
> This API is still being not stabilized, args other than `player`, `bone`,
> `position` and `rotation` might change in a breaking manner. Please bear that
> in mind and avoid using them by the time being, unless you are ready for the
> API breakages and to resolve them in your mod / game.

---
<div align=right><sub><i>More is TODO!</i> 😕️ --- SpacingBat3</sub></div>