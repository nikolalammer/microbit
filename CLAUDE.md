# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A German-language STEM/Maker education project for schools, built around the **BBC micro:bit** microcontroller. It contains lesson plans, worksheets, project guides, pre-compiled firmware, and 3D-printable hardware files — not a traditional software codebase.

The school context is **Austria** (Eberschwang). All materials are in German.

---

## Repository structure

```
Arbeitsblätter/      Structured lesson worksheets (PNG images), two levels + intro
  Einführung/        Intro: hardware overview, MakeCode IDE
  Level 1/           5 guided exercises: output, text, input, random, radio
  Level 2/           2 project exercises: digital pet, Morse code
  Unterrichtsplanung.docx

Lernboxen/           Self-contained project boxes (thematic units)
  SkyBit/            Weather station — PDF guide
  MicroCar/          Radio-controlled car — PDF guide + pre-built HEX
  Musik/             Music programming — sheet music (.docx) + lesson plan
  PlantBit/          Plant moisture monitor — PDF guide
  Bildschirm/        OLED display programming — JavaScript code snippet
  Auto Lego/         LEGO car build — 3D-print STLs + MakeCode PDF

Programme/           Ready-to-flash .hex firmware files
3D Druck Files/      Printable enclosures (STL + OpenSCAD source)
3D Model/            Blender model of the micro:bit (for visuals/presentations)
Roboter bipedal/     EASY:bit biped robot — full STL set + firmware
Schulbuch/           Theory reference: algorithms, programming languages
Homepage/            AI-generated artwork, GIMP project, research diary
```

---

## File types and tooling

| Extension | Tool | Purpose |
|-----------|------|---------|
| `.hex` | micro:bit USB drag-and-drop | Compiled MakeCode firmware, flash by copying to the micro:bit drive |
| `.scad` | OpenSCAD | Parametric 3D source for the micro:bit case (`3D Druck Files/Case/`) |
| `.stl` / `.3mf` | Slicer (e.g. Cura, PrusaSlicer) | 3D print files |
| `.blend` | Blender | 3D model of the micro:bit |
| `.docx` | Word / LibreOffice | Lesson plans and sheet music |
| `.xcf` | GIMP | Homepage artwork |
| JavaScript snippets (`.txt`) | MakeCode online editor | Paste into MakeCode JavaScript view |

---

## MakeCode workflow

Programs are authored at **makecode.microbit.org** — no local toolchain needed.

- Blocks mode and JavaScript mode are interchangeable in MakeCode.
- JavaScript snippets (e.g. `Lernboxen/bildschirm.txt`) can be pasted directly into the JavaScript view of a new MakeCode project.
- Compiled output is a `.hex` file — download and copy to the micro:bit USB drive to flash.
- Radio (Funk) projects require **two** micro:bits: one running the sender HEX, one the receiver HEX (see `Programme/`).

---

## 3D print notes

- `3D Druck Files/Case/microbitcase.scad` is the parametric OpenSCAD source for the V1 case. The variables `pins_accessable` and `logo_accessable` at the top toggle cutouts.
- The V2 case is pre-exported as `BBC_TOP.stl` + `BBC_BOTTOM.stl` — no source edits needed.
- The EASY:bit robot (`Roboter bipedal/`) supports both **SG90** and **MS18** servo variants — choose the matching STL files accordingly.

---

## Adding new materials

- Worksheet images go in `Arbeitsblätter/Level X/` as numbered PNGs matching the existing naming convention.
- New Lernboxen get their own subfolder under `Lernboxen/` with a PDF guide and optionally a HEX file.
- New HEX files belong in `Programme/` with descriptive names (`microbit-<ProjektName>[-Senden|-Empfangen].hex`).
