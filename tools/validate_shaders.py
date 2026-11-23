#!/usr/bin/env python3
"""Compile every shader with glslangValidator (Iris #include expanded) across option presets."""
import glob, os, re, subprocess, sys, tempfile

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "shaders")
SETTINGS = os.path.join(ROOT, "lib", "settings.glsl")

def expand(path):
    out = []
    for line in open(path, encoding="utf-8").read().split("\n"):
        m = re.match(r'\s*#include\s+"(.+)"', line)
        out.append(expand(ROOT + m.group(1)) if m else line)
    return "\n".join(out)

def variant(text, values, off):
    for k, v in values.items():
        text = re.sub(rf"^(#define {k}) \S+", rf"\g<1> {v}", text, flags=re.M)
    for k in off:
        text = re.sub(rf"^#define {k}\b.*$", "", text, flags=re.M)
    return text

VARIANTS = {
    "default": ({}, []),
    "low": ({"CLOUD_QUALITY": "1", "SHADOW_QUALITY": "0", "GODRAY_SAMPLES": "6"}, ["BLOOM"]),
    "high": ({"CLOUD_QUALITY": "3", "SHADOW_QUALITY": "2", "GODRAY_SAMPLES": "14"}, []),
    "no-shadows-clouds": ({"CLOUD_MODE": "0"}, ["SHADOWS", "GODRAYS", "NIGHT_STARS"]),
}

def main():
    original = open(SETTINGS, encoding="utf-8").read()
    failed = 0
    try:
        for name, (vals, off) in VARIANTS.items():
            open(SETTINGS, "w", encoding="utf-8").write(variant(original, vals, off))
            for f in sorted(glob.glob(ROOT + "/*.fsh") + glob.glob(ROOT + "/*.vsh")):
                ext = "frag" if f.endswith("fsh") else "vert"
                with tempfile.NamedTemporaryFile("w", suffix="." + ext, delete=False) as t:
                    t.write(expand(f))
                r = subprocess.run(["glslangValidator", t.name], capture_output=True, text=True)
                os.unlink(t.name)
                if r.returncode:
                    failed += 1
                    print(f"FAIL [{name}] {os.path.basename(f)}\n{r.stdout}")
            print(f"variant {name}: done")
    finally:
        open(SETTINGS, "w", encoding="utf-8").write(original)
    sys.exit(1 if failed else 0)

main()
