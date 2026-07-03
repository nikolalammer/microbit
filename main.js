// ── Tipp / Lösung Toggle ──────────────────────────────────────
let tippShown = false;

function toggleTipp() {
  const btn   = document.getElementById('btnTipp');
  const panel = document.getElementById('panelTipp');
  if (!btn || !panel) return;
  const open = panel.classList.toggle('open');
  btn.setAttribute('aria-expanded', open);

  if (open && !tippShown) {
    tippShown = true;
    const btnL = document.getElementById('btnLoesung');
    if (btnL) {
      btnL.disabled = false;
      btnL.style.animation = 'pulse 0.6s ease';
    }
  }
}

function toggleLoesung() {
  const btn   = document.getElementById('btnLoesung');
  const panel = document.getElementById('panelLoesung');
  if (!btn || !panel) return;
  const open = panel.classList.toggle('open');
  btn.setAttribute('aria-expanded', open);
}

function toggleAnders() {
  const btn   = document.getElementById('btnAnders');
  const panel = document.getElementById('panelAnders');
  if (!btn || !panel) return;
  const open = panel.classList.toggle('open');
  btn.setAttribute('aria-expanded', open);
}

// ── localStorage-Helfer ───────────────────────────────────────
function lsGet(prefix, key) {
  try { return localStorage.getItem(prefix + ':' + key); } catch (e) { return null; }
}
function lsSet(prefix, key, value) {
  try { localStorage.setItem(prefix + ':' + key, value); } catch (e) {}
}

// ── Mini-Quiz ─────────────────────────────────────────────────
function initQuiz() {
  const quiz = document.querySelector('.quiz-section');
  if (!quiz) return;
  const prefix = quiz.dataset.lsPrefix || 'quiz';
  const fragen = [...quiz.querySelectorAll('.quiz-frage')];

  function frageGeloest(frage) {
    frage.classList.add('geloest');
    frage.querySelectorAll('.quiz-antwort').forEach(b => { b.disabled = true; });
  }

  function checkFertig(speichern) {
    if (!fragen.every(f => f.classList.contains('geloest'))) return;
    const panel = quiz.querySelector('.quiz-done');
    if (panel) panel.classList.add('open');
    if (speichern) lsSet(prefix, 'quiz', '1');
  }

  quiz.querySelectorAll('.quiz-antwort').forEach(btn => {
    btn.addEventListener('click', () => {
      if (btn.hasAttribute('data-richtig')) {
        btn.classList.add('richtig');
        frageGeloest(btn.closest('.quiz-frage'));
        checkFertig(true);
      } else {
        btn.classList.add('falsch');
        btn.disabled = true;
      }
    });
  });

  // Gespeicherten Zustand wiederherstellen
  if (lsGet(prefix, 'quiz') === '1') {
    fragen.forEach(f => {
      const richtig = f.querySelector('[data-richtig]');
      if (richtig) richtig.classList.add('richtig');
      frageGeloest(f);
    });
    checkFertig(false);
  }
}
initQuiz();

// ── Differenzierung: Stufen-Umschalter ────────────────────────
function initStufen() {
  const schalter = document.querySelector('.stufen-schalter');
  if (!schalter) return;
  const buttons  = [...schalter.querySelectorAll('.stufe-btn')];
  const inhalte  = [...document.querySelectorAll('[data-stufe-inhalt]')];
  const gueltig  = buttons.map(b => b.dataset.stufe);

  function setzeStufe(stufe, speichern) {
    if (!gueltig.includes(stufe)) stufe = 'standard';
    buttons.forEach(b => {
      const aktiv = b.dataset.stufe === stufe;
      b.classList.toggle('aktiv', aktiv);
      b.setAttribute('aria-pressed', aktiv);
    });
    inhalte.forEach(el => { el.hidden = el.dataset.stufeInhalt !== stufe; });
    if (speichern) lsSet('einstellung', 'stufe', stufe);
  }

  buttons.forEach(b => {
    b.addEventListener('click', () => setzeStufe(b.dataset.stufe, true));
  });

  // URL-Parameter (?stufe=leicht) gewinnt gegen gespeicherte Wahl
  const param = new URLSearchParams(location.search).get('stufe');
  setzeStufe(param || lsGet('einstellung', 'stufe') || 'standard', false);
}
initStufen();

// ── Checkliste Fortschritt ────────────────────────────────────
function updateProgress() {
  const items = document.querySelectorAll('#checklist input[type="checkbox"]');
  if (!items.length) return;
  const total = items.length;
  const done  = [...items].filter(cb => cb.checked).length;
  const pct   = Math.round((done / total) * 100);

  const fill  = document.getElementById('progressFill');
  const label = document.getElementById('progressLabel');
  if (fill)  fill.style.width = pct + '%';
  if (label) label.textContent = done + ' / ' + total;
}
