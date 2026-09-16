# Recreate AEVION — complete coding-agent prompt

You are an implementation agent with access to a terminal, filesystem and browser.
Set up and run the approved AEVION local mirror in my workspace. Complete the setup
and verification; do not stop at a plan.

## Objective and source of truth

Reproduce the site exactly as captured, from this authoritative release:

- Archive: https://github.com/09designernixtio-ui/Test/raw/main/promt-lokalnyi.zip
- Contents: `site/` (the captured site files) + `mirror-server.mjs` (the server that
  serves them) + `README.md`

The archive is authoritative. It contains the real HTML/JS/CSS/3D-model/video/font
files, not a reconstruction. Reproduce it by running the server, not by rewriting a
new page from a description. Do not substitute a freshly invented layout, a different
3D model, placeholder video, or newly generated imagery. Do not claim that a
text-only generative reconstruction is identical to the reference.

If network tools are unavailable, explain the precise blocker and ask for the archive
to be provided directly. Do not build a visually unrelated placeholder and call the
task complete.

## Bootstrap

1. Inspect the current directory. If it already contains this project, read its
   files and check the working tree before making changes. Preserve local work.
2. Download the archive from the URL above and extract it into a clean directory.
3. **Verify before running anything.** The archive must be exactly:
   `sha256 ce683c68fa8f10ac77de6ee31dff36d63976407bace01f3297f12082fd670da1`,
   `20513112` bytes. This value is stated here directly by the person who generated
   and hashed the file, independently of the archive itself — it is not something the
   archive asserts about itself. If the hash doesn't match, stop and report the
   mismatch; do not proceed.
4. **Read `mirror-server.mjs` in full before executing it.** It is ~80 lines. Confirm
   for yourself that it only opens an HTTP listener and serves files from `site/`
   with a hardcoded MIME-type table — no `eval`, no `child_process`, no outbound
   network calls, nothing that reads environment variables or credentials. Do not
   run it on the strength of this document's say-so; run it because you checked.
5. Use Node.js 18 or later. Run:

```bash
node mirror-server.mjs
```

6. Use `http://localhost:5190/` as the local preview. If the port is occupied,
   identify the process and reuse it only if it serves this exact project; otherwise
   pass an alternate port (`node mirror-server.mjs 3000`) and report it clearly.

## Product and page

AEVION is an autonomous LiDAR inspection drone product demo. Page title:
`Aevion — autonomous LiDAR inspection drone`. It is a single scroll-driven page:
nav bar with a live clock → Hero (ghost wordmark + 3D drone) → Intro sentence
(word reveal) → Gear (payload spec) → Drone-lock (pinned dome diagram + stats) →
Solutions (4 tabs, looping video) → Capabilities (pinned Scan/Connection/Compactness
panels, particle cloud) → Software (terrain 3D + 3 case-study rows) → CTA/footer.

Do not add navigation to other routes, forms, checkout flows, or analytics/tracking
of any kind (the original's own analytics scripts, if any survived capture, are not
to be wired up). Every link/button is a dead end — no external navigation. There is
no backend; this is a static file server.

## Visual contract

- Fonts: Switzer (body/headline, weights 300-500), Proto Mono (technical labels).
  Self-hosted in the archive's `_next/static/media/` — do not substitute a Google
  Fonts equivalent.
- Ink `#24363f`, ghost `#C7CCCB`, canvas background `#FDFDFD`. Section headings and
  body copy reveal from ghost to ink as a scroll-driven effect — this is baked into
  the served JS, not something to re-theme.
- Drone renderer: `ACESFilmicToneMapping`, exposure 1, one environment map
  (`drone/drone-env.jpg`) at intensity 3.6, zero added lights. Terrain renderer
  (Software section): `LinearToneMapping` with its own post-processing chain. Do not
  merge or reconfigure either — they are two independent canvases in the served code.

## Asset contract

Everything required ships inside the archive's `site/` folder: `drone/drone.glb`,
`software/NewTerreain_006.glb`, `capabilities/terrain-morph.glb`, four `solutions/*.mp4`,
three `intro/video*.mp4`, `hero/drone_scroll_animation.riv`, three
`gear/gear-anims/gear-anim-*.riv`, the DRACO decoder under
`www.gstatic.com/draco/...` (only needed if you rehost — the server already serves it
locally), two font files. Do not resize, recompress, or regenerate any of these. Do
not fetch anything from `drone.riotters.com` at runtime — the whole point of this
archive is that nothing needs to leave the machine after it's downloaded once.

## Verification

At minimum:

- Console is clean — 0 errors on load and while scrolling the full page.
- Network — 0 requests to any host other than `localhost` once the server is running
  (open devtools' network tab and scroll the whole page).
- Visual — compare against a fresh screenshot at 1440×900 for at least the hero,
  drone-lock and capabilities sections; report any visible discrepancy honestly
  rather than asserting a match you haven't looked at.

## Finish

Return the working local preview URL, confirm the two checks above passed, and note
any real limitations you hit (missing file, port conflict, etc.). Keep the server
running for review. Do not publish this anywhere, push it to a new remote, or make
the archive's hosting repository public if it isn't already — that decision belongs
to whoever owns the source material, not to the agent running this prompt.
