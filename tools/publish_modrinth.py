#!/usr/bin/env python3
"""Upload the built zip to Modrinth, tagged for every release from MC_FROM to MC_TO."""
import json, os, sys, urllib.request

API = "https://api.modrinth.com/v2"
UA = "hackfireoffical/Celestia (github actions)"
FROM, TO = os.environ.get("MC_FROM", "1.20.1"), os.environ.get("MC_TO", "26.3")
SLUG = os.environ.get("MODRINTH_SLUG", "celestiasky")

def get(path):
    req = urllib.request.Request(API + path, headers={"User-Agent": UA})
    return json.load(urllib.request.urlopen(req))

def game_versions():
    tags = get("/tag/game_version")
    rel = {t["version"]: t["date"] for t in tags if t["version_type"] == "release"}
    lo = rel[FROM]
    hi = rel.get(TO, max(rel.values()))   # 26.3 not out yet -> everything up to latest
    picked = sorted((v for v, d in rel.items() if lo <= d <= hi), key=lambda v: rel[v])
    print(f"{len(picked)} versions: {picked[0]} .. {picked[-1]}")
    return picked

def main():
    token = os.environ["MODRINTH_TOKEN"]
    zip_path, version = sys.argv[1], sys.argv[2]
    project_id = get(f"/project/{SLUG}")["id"]
    data = {
        "name": f"Celestia Mobile {version}",
        "version_number": version,
        "changelog": os.environ.get("CHANGELOG", "See GitHub release notes."),
        "dependencies": [],
        "game_versions": game_versions(),
        "version_type": os.environ.get("VERSION_TYPE", "release"),
        "loaders": ["iris", "optifine"],
        "featured": True,
        "project_id": project_id,
        "file_parts": ["file"],
        "primary_file": "file",
    }
    boundary = "----celestia"
    body = b""
    body += f'--{boundary}\r\nContent-Disposition: form-data; name="data"\r\nContent-Type: application/json\r\n\r\n'.encode()
    body += json.dumps(data).encode() + b"\r\n"
    body += (f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="{os.path.basename(zip_path)}"\r\n'
             "Content-Type: application/zip\r\n\r\n").encode()
    body += open(zip_path, "rb").read() + f"\r\n--{boundary}--\r\n".encode()
    req = urllib.request.Request(API + "/version", data=body, method="POST", headers={
        "Authorization": token, "User-Agent": UA,
        "Content-Type": f"multipart/form-data; boundary={boundary}"})
    print(urllib.request.urlopen(req).read().decode()[:300])

main()
