<div align="center">
  <h1>✨ Celestia Mobile</h1>
  <strong>See more. Feel the atmosphere. Keep it mobile.</strong><br><br>
  Lightweight Iris shader pack for Minecraft Java Edition, built with Android and lower-end GPUs in mind.
</div>

---

## What is Celestia?

Celestia is a mobile-focused shader pack that aims for an atmospheric look without relying on an expensive desktop-style rendering stack. This version rebuilds the missing shader stages and adds a working baseline for shadows, volumetric-style clouds and screen-space post effects.

## Visual features

- **Volumetric cloud layer:** a short, quality-scaled ray-march through a cloud slab, with layered procedural density and sculpted, deliberately boxy lighting normals.
- **Real-time sun shadows:** depth-map shadows with configurable quality, strength and a small multi-tap softening option.
- **Godrays:** lightweight screen-space sun shafts, enabled separately from the cloud renderer.
- **Bloom:** restrained bright-area extraction and a compact neighbourhood blur.
- **Atmospheric sky:** day/night gradients, warm twilight, sun halo and a simple night-star layer.
- **Basic material lighting:** texture and lightmap support, directional shading and alpha-tested shadow casters.

The cloud renderer is a deliberately low-step volumetric approximation, not a physically complete atmosphere or a full-resolution cloud-shadow system. Godrays and bloom are screen-space effects and can show limitations around screen edges or occluders.

## Quality presets

| Preset | Intended use | Cloud steps | Shadows | Post effects |
|---|---|---:|---|---|
| Low | Mobile / battery-conscious | 5 | Reduced | Bloom only, subtle |
| Medium | Balanced starting point | 7 | Softened | Godrays + bloom |
| High | More visual detail | 10 | Higher quality | Stronger godrays + bloom |

Start with **Low** on phones, then try Medium if frame pacing and temperature remain comfortable. The High preset can be demanding on mobile GPUs.

## Compatibility

Designed for **Minecraft Java Edition with Iris + Sodium**. The repository targets the GLSL 1.20 compatibility shader pipeline. Compatibility depends on the exact Minecraft, Iris and Sodium versions; the pack has not been verified across every 1.21.x release or every Android renderer.

Android launchers such as Zalith and Pojav may expose different OpenGL capabilities. Results can vary by GPU driver. If a feature fails to compile or render on a particular device, switch to Low and report the launcher, Minecraft version, Iris version and renderer with the issue.

## Install

1. Install Fabric, Sodium and a matching Iris version.
2. Download the shader ZIP from the repository's Releases page.
3. Put the ZIP (do not extract it) in `.minecraft/shaderpacks`.
4. Select **Celestia Mobile** in Video Settings → Shader Packs.
5. Open Shader Pack Settings and select Low, Medium or High.

## Build locally

The `shaders/` directory is the shader-pack root. From the repository root:

```bash
zip -r Celestia_Mobile.zip shaders LICENSE README.md
```

## Current limitations

- Clouds are rendered as a low-step volumetric sky layer; they do not yet cast a separate cloud-shadow pass onto the terrain.
- Shadow filtering is a compact depth comparison approximation rather than a high-sample PCF implementation.
- Godrays are screen-space and are not a full volumetric atmospheric scattering solution.
- Water uses the shared material-lighting baseline; planar reflections and animated wave normals are not implemented in this rebuild.
- This repository update has been statically checked, but still needs an in-game Iris test on desktop and Android before being called fully verified.

## License

MIT. See [LICENSE](LICENSE). Include the copyright and license notice in redistributed derivatives.

## Contributing

Bug reports and pull requests are welcome. Include your Minecraft, Iris, Sodium, launcher and renderer versions, plus a log or screenshot where possible.
