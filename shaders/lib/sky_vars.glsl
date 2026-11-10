// Sky state shared by vertex + fragment stages. It only depends on uniforms, so it
// is computed per vertex (a handful of vertices for the sky) and costs nothing per pixel.
varying vec3 vZenith;   // sky colour straight up
varying vec4 vHorizon;  // rgb = sky colour at the horizon (also the distance-fog colour), a = sun glow visibility
varying vec4 vSkyA;     // xyz = sun direction (world space), w = twilight amount
varying vec4 vSkyB;     // xyz = moon direction (world space), w = moon glow visibility
