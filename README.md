<div align="center">
  <h1>✨ Celestia Mobile</h1>
  <strong>See more. Feel the atmosphere. Keep it mobile.</strong><br><br>
  Lightweight Iris shader pack for Minecraft Java Edition, built with Android and lower-end GPUs in mind.
</div>

---

## 🔖 Releases & versions

One universal zip covers **Minecraft 1.20.1 → 26.3** (Iris, or OptiFine/Oculus on older versions). Push a tag like `v1.2.0` to build, create a GitHub release and publish to Modrinth (needs the `MODRINTH_TOKEN` repo secret). The workflow tags every release version in that range automatically.

## What is Celestia?

Celestia is a mobile-focused shader pack that aims for an atmospheric look without relying on an expensive desktop-style rendering stack. It ships boxy volumetric clouds, real-time shadows, godrays, bloom and selectable color schemes.

## Visual features

- **Boxy volumetric clouds:** mounds of stacked cubes marched with a 3D DDA. Every cube has a crisp face normal (bright tops, dim sides, dark undersides), a silver sun-edge, one-cell self-shadowing and rain darkening. Cube size is adjustable.
- **Real-time shadows:** shadow map with distortion (sharper near you), rotated-disc soft edges (1/4/8 taps), normal-offset bias and cool-tinted shade. Sun and moon both cast shadows.
- **Godrays:** occlusion-based screen-space shafts toward the sun or moon, cut by terrain and trees, faded in caves and rain.
- **Bloom:** soft bright-area glow plus an emissive mask, so torches, lava and glowstone glow properly.
- **Color schemes:** Natural, Warm Golden, Cool Moonlit, Pastel Cozy and Vivid grades (Shader Pack Settings → Color Scheme).
- **Atmospheric sky:** day/night gradients, warm twilight, sun halo and twinkling stars.
- **Lighting:** correct lightmap handling (dark caves), directional shading, emissive blocks and a lit hand.

Godrays and bloom are screen-space effects and can show limitations around screen edges or occluders. Everything is a low-step approximation tuned for phones, not a full atmosphere renderer.

## Quality presets

| Preset | Intended use | Cloud steps | Shadows | Post effects |
|---|---|---:|---|---|
| Low | Mobile / battery-conscious | 10 | 1 tap | Godrays (6 samples), no bloom |
| Medium | Balanced starting point | 16 | 4-tap soft | Godrays (10) + bloom |
| High | More visual detail | 24 | 8-tap soft | Stronger godrays (14) + bloom |

Start with **Low** on phones, then try Medium if frame pacing and temperature remain comfortable. High can be demanding on mobile GPUs.

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

GitHub Actions runs the compatibility workflow whenever shader files or this README change. It discovers the Minecraft versions that currently have both **Iris and Sodium Fabric releases**, limited to **1.20.1 through 26.3**, then checks every matching version against the same shared shader source. Celestia is not split into per-version shader folders or separate downloads: one universal ZIP is produced after the complete version matrix passes.

For each version, the workflow:
- Confirms that Modrinth lists a Fabric release of Iris and Sodium for that exact Minecraft version.
- Expands the shader pack's shared GLSL includes and statically compiles every vertex and fragment stage.
- Builds one installable `Celestia_Mobile.zip` artifact after the complete matrix passes. The ZIP includes a `COMPATIBILITY.txt` file listing the Minecraft versions checked by that run.

**What PASS means:** the loader ecosystem publishes matching releases and Celestia's shader stages pass GLSL static compilation. This is a useful automated compatibility gate, but it is **not a full Minecraft launch or visual-render test**. It cannot prove that the shader looks correct in-game, or that every GPU/Android driver supports every effect. Those still need manual testing in Iris on the target Minecraft version and device.

To run it manually, open the repository's **Actions → Celestia compatibility → Run workflow**. The single universal ZIP is available in the successful run's **Artifacts** section. There are no separate per-version ZIPs.

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
