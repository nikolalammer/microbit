# CLAUDE.md, Micro:bit Schulwebsite (nikolalammer/microbit)

## Projektkontext
GitHub-Pages-Seite für die MS Eberschwang. Schüler scannen QR-Codes auf physischen Lernboxen und landen direkt auf der passenden Anleitung. Zugriff primär über Smartphone, Mobilfreundlichkeit ist deshalb kritisch. Sprache durchgehend Deutsch.

## Live-URL
https://nikolalammer.github.io/microbit/

## Struktur
1. index.html: Startseite mit allen Levels und Lernboxen als Karten
2. aufgabe-1.html bis aufgabe-5.html: Grundlagen Level 1
3. skybit/, microcar/, musik/, plantbit/, bildschirm/, autolego/: je eine Lernbox-Seite
4. Lernboxen/: PDFs, HEX-Dateien, Bilder als Quelldateien, nicht deployed
5. Arbeitsblätter/Bilder/: Roboter-Bilder zur Wiederverwendung

## Design-Grundsätze
1. Kein generisches KI-Design. Kein Inter oder Roboto, kein lila Verlauf auf Weiß.
2. Mobil zuerst. Touch-Ziele mindestens 48px, große Schrift, große Buttons.
3. Progressiver Reveal. Schüler sehen Schritt für Schritt, nicht alles auf einmal.
4. HEX-Dateien immer als direkter Download-Button.
5. Farbe pro Box unterschiedlich, Layout einheitlich.
6. Vor jeder Design-Arbeit /mnt/skills/public/frontend-design/SKILL.md lesen.

## Datenschutz (nicht verhandelbar)
Die Nutzer sind Kinder. Deshalb:
1. Kein Backend, keine Datenbank, keine Accounts.
2. Keine Live-Aufrufe an eine KI-API aus Schülerseiten heraus.
3. Alle interaktiven Inhalte (Quizze, Varianten) werden statisch vorgeneriert und liegen fertig im HTML.
4. Fortschritt nur lokal im Browser über localStorage, ohne personenbezogene Daten.
5. Keine Fotos, keine Namen, keine Standortdaten erfassen.

## Workflow-Regeln
1. Für alles Nicht-Triviale zuerst Plan Mode (Shift und Tab), Plan zeigen, Freigabe abwarten, dann bauen.
2. PDFs immer über den Subagent pdf-leser lesen, damit der Hauptkontext frei bleibt.
3. Einfachster möglicher Ansatz. Keine unnötigen Abstraktionen, kein Framework wo pures HTML reicht.
4. Erfolg belegen statt behaupten. Seite öffnen, Screenshot im Handy-Viewport zeigen.
5. Eine Aufgabe nie vorschnell als fertig erklären. Erst wenn der Beleg da ist.
6. /clear zwischen zwei unabhängigen Boxen. Nie alle PDFs gleichzeitig laden.

## Neue Lernbox-Seite bauen
1. Passendes PDF aus Lernboxen/<Name>/ per Subagent lesen und Schritte extrahieren.
2. Phasen trennen, zum Beispiel Verdrahtung und Programmierung.
3. Schritt für Schritt mit Fortschrittsanzeige und progressivem Reveal.
4. MakeCode-Link einbauen, HEX-Download falls vorhanden.
5. QR-Code-URL am Ende ausgeben.
6. git add, commit, push.

## Git
Commit-Nachrichten kurz und auf Deutsch, im Präsens, zum Beispiel "Fügt SkyBit-Seite hinzu".
