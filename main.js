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
