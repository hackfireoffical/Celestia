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

Designed for **Minecraft Java Edition with Iris + Sodium**. The repository targets the GLSL 1.20 compatibility shader pipeline. Compatibility depends on the exact Minecraft, Iris and Sodium versions. See the automated compatibility workflow below for the versions whose Iris/Sodium metadata and GLSL static checks pass; that is not a substitute for in-game rendering tests.

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

## Automated compatibility checks

GitHub Actions runs the compatibility workflow whenever shader files or this README change. It discovers the Minecraft versions that currently have both **Iris and Sodium Fabric releases**, limited to **1.20.1 through 26.3**, then creates a separate check for every matching version.

For each version, the workflow:
- Confirms that Modrinth lists a Fabric release of Iris and Sodium for that exact Minecraft version.
- Expands the shader pack's shared GLSL includes and statically compiles every vertex and fragment stage.
- Builds an installable `Celestia_Mobile.zip` artifact after the complete matrix passes.

**What PASS means:** the loader ecosystem publishes matching releases and Celestia's shader stages pass GLSL static compilation. This is a useful automated compatibility gate, but it is **not a full Minecraft launch or visual-render test**. It cannot prove that the shader looks correct in-game, or that every GPU/Android driver supports every effect. Those still need manual testing in Iris on the target Minecraft version and device.

To run it manually, open the repository's **Actions → Celestia compatibility → Run workflow**. The generated ZIP is available in the successful run's **Artifacts** section.

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
