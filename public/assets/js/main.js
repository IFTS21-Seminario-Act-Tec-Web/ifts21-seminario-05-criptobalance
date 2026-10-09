// ============================================================
// CRIPTOBALANCE — main.js
// Identidad: Estudio Contable Fintech & Web3
//
// Este script gestiona la interactividad del frontend bajo una
// arquitectura desacoplada, orientada a conectarse con una API
// REST construida en FastAPI durante los sprints de backend.
//
// Responsabilidades de este archivo:
//   1. Actualización automática del año en el footer.
//   2. Comportamiento del Navbar dinámico y botón Back-to-Top.
//   3. Detección de sección activa mediante IntersectionObserver API.
//   4. Lógica de cálculo en tiempo real (Simulador Fiscal / Encuadre).
//   5. Consulta pública de estado de legajo contable (GET sin login).
//   6. Validación y preparación del Formulario de Contacto (HTML5 API).
// ============================================================

"use strict";


// ─── 1. AÑO DINÁMICO EN EL FOOTER ───────────────────────────
const yearSpan = document.getElementById('year');
if (yearSpan) {
  yearSpan.textContent = new Date().getFullYear();
}


// ─── 2. NAVBAR SCROLLED & BOTÓN "VOLVER ARRIBA" ──────────────
const siteNav   = document.getElementById('siteNav');
const backToTop = document.getElementById('backToTop');

function handleScrollEffects() {
  const currentScrollY = window.scrollY;
  siteNav?.classList.toggle('scrolled', currentScrollY > 30);
}

window.addEventListener('scroll', handleScrollEffects, { passive: true });
handleScrollEffects();




// ─── 3. SECCIÓN ACTIVA EN EL NAV (IntersectionObserver API) ──
const navLinks = document.querySelectorAll('.cr-nav-link[data-section]');
const sections = document.querySelectorAll('section[id]');

const observerConfig = {
  root: null,
  rootMargin: '-25% 0px -65% 0px',
  threshold: 0
};

const navSectionObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      navLinks.forEach(link => link.classList.remove('active'));
      const activeSectionId = entry.target.id;
      const matchedLink = document.querySelector(
        `.cr-nav-link[data-section="${activeSectionId}"]`
      );
      if (matchedLink) {
        matchedLink.classList.add('active');
      }
    }
  });
}, observerConfig);

sections.forEach(section => navSectionObserver.observe(section));


// ─── 4. SIMULADOR FISCAL INTERACTIVO ────────────────────────
//
// REGLA DE NEGOCIO IMPLEMENTADA:
// - Matriz cruzada entre tipo de actividad y monto facturado:
//     * Devs Exterior (< 3000 USD): Monotributo Cat. E/H (Exportación).
//     * Devs Exterior (> 6000 USD): Responsable Inscripto + Cupo MULC.
//     * Traders Cripto: Régimen de Impuesto Cedular + Ganancias.
//
// GUÍA DE INTEGRACIÓN BACKEND (SPRINT 2):
// En FastAPI, este cálculo se reemplazará por una llamada a:
// POST /api/fiscal/simular -> { "tipo": "dev_ext", "monto": 3000 }

const actividadSelect   = document.getElementById('actividadSelect');
const montoSelect       = document.getElementById('montoSelect');
const categoriaSugerida = document.getElementById('categoriaSugerida');
const costoEstimado     = document.getElementById('costoEstimado');
const btnSimular        = document.getElementById('btnSimular');
const simMessage        = document.getElementById('simMessage');

function recalcularEsquemaFiscal() {
  if (!actividadSelect || !montoSelect || !categoriaSugerida || !costoEstimado) return;

  const tipo = actividadSelect.value;
  const monto = parseInt(montoSelect.value, 10);

  let categoria = "Monotributo Cat. A";
  let costo = "$35.000 / mes";

  if (tipo === "dev_ext") {
    if (monto <= 1500) {
      categoria = "Monotributo Cat. D (Cupo USD)";
      costo = "$45.000 / mes";
    } else if (monto <= 3000) {
      categoria = "Monotributo Cat. H (Tech)";
      costo = "$68.000 / mes";
    } else if (monto <= 6000) {
      categoria = "Monotributo Cat. K (Máxima)";
      costo = "$95.000 / mes";
    } else {
      categoria = "Responsable Inscripto (RI)";
      costo = "$140.000 / mes";
    }
  } else if (tipo === "crypto_trader") {
    categoria = "Impuesto Cedular + Bienes Pers.";
    costo = "$110.000 / mes";
  } else if (tipo === "pyme_tech") {
    categoria = "Régimen Sociedades (SAS/SRL)";
    costo = "$180.000 / mes";
  } else {
    categoria = "Monotributo Servicios Local";
    costo = "$40.000 / mes";
  }

  categoriaSugerida.textContent = categoria;
  costoEstimado.textContent = costo;
}

actividadSelect?.addEventListener('change', recalcularEsquemaFiscal);
montoSelect?.addEventListener('change', recalcularEsquemaFiscal);
recalcularEsquemaFiscal();

btnSimular?.addEventListener('click', () => {
  if (!simMessage) return;
  simMessage.textContent = '✓ Esquema precargado. En el próximo hito este botón iniciará la solicitud de alta en FastAPI.';
  setTimeout(() => { simMessage.textContent = ''; }, 4500);
});


// ─── 5. CONSULTA DE LEGAJO EN TIEMPO REAL (GET BY ID) ────────
//
// MODELO: Consulta pública de estado sin login
//
// GUÍA DE INTEGRACIÓN BACKEND (SPRINT 2):
// Reemplazar el dataset mock 'DEMO_LEGAJOS' por:
// const res = await fetch(`/api/legajos/${codigoLegajo}`);
// const data = await res.json();

const expedienteInput   = document.getElementById('expedienteInput');
const consultarBtn      = document.getElementById('consultarBtn');
const consultaResultado = document.getElementById('consultaResultado');

const DEMO_LEGAJOS = {
  'CB-001234': {
    cliente: 'Estudio Alpha Devs SRL',
    estado: 'DECLARACIÓN PRESENTADA',
    vencimiento: '30/08/2026',
    detalle: 'IVA y Facturación E del período presentados con éxito. Sin observaciones AFIP.',
    pasoActual: 3
  },
  'CB-002345': {
    cliente: 'Martín Gómez (Contractor)',
    estado: 'PENDIENTE DOCUMENTACIÓN',
    vencimiento: '15/09/2026',
    detalle: 'Falta adjuntar extracto bancario de cuenta extranjera (Wise/Deel) de julio.',
    pasoActual: 2
  },
  'CB-003456': {
    cliente: 'Solana Labs AR',
    estado: 'EN AUDITORÍA',
    vencimiento: '12/09/2026',
    detalle: 'Procesando balance contable para certificación de firma en CPCECABA.',
    pasoActual: 2
  }
};

function procesarConsultaLegajo() {
  if (!expedienteInput || !consultaResultado) return;

  const codigo = expedienteInput.value.trim().toUpperCase();

  if (!codigo || codigo.length < 4) {
    consultaResultado.innerHTML = `
      <div class="alert alert-danger p-2 small mt-2" role="alert">
        <i class="bi bi-exclamation-triangle-fill"></i> Ingresá un número de legajo válido (Ej: CB-001234).
      </div>
    `;
    return;
  }

  consultaResultado.innerHTML = `
    <div class="text-center py-3">
      <div class="spinner-border spinner-border-sm text-info" role="status"></div>
      <span class="small text-muted ms-2">Validando con el servidor fiscal...</span>
    </div>
  `;

  setTimeout(() => {
    const data = DEMO_LEGAJOS[codigo] || {
      cliente: 'Cliente Registrado',
      estado: 'AL DÍA',
      vencimiento: 'Sin vencimientos urgentes',
      detalle: 'Demo: en la etapa backend este resultado vendrá de FastAPI. No se detectan inconsistencias.',
      pasoActual: 3
    };

    consultaResultado.innerHTML = `
      <div class="cr-track-card mt-3">
        <div class="cr-track-header">
          <span class="cr-track-code">${codigo} · ${data.cliente}</span>
          <span class="cr-track-badge">${data.estado}</span>
        </div>
        <p class="small mb-1 text-light">
          <strong>Próximo Vencimiento:</strong> ${data.vencimiento}
        </p>
        <p class="small text-muted mb-0">${data.detalle}</p>
        
        <div class="cr-timeline mt-3">
          <div class="cr-step ${data.pasoActual >= 1 ? 'completed' : ''}">
            <div class="cr-step-dot"></div>Recepción
          </div>
          <div class="cr-step ${data.pasoActual >= 2 ? 'completed' : ''}">
            <div class="cr-step-dot"></div>Liquidación
          </div>
          <div class="cr-step ${data.pasoActual >= 3 ? 'completed' : ''}">
            <div class="cr-step-dot"></div>Presentado
          </div>
        </div>
      </div>
    `;
  }, 600);
}

consultarBtn?.addEventListener('click', procesarConsultaLegajo);

expedienteInput?.addEventListener('keydown', (event) => {
  if (event.key === 'Enter') {
    event.preventDefault();
    procesarConsultaLegajo();
  }
});


// ─── 6. FORMULARIO DE CONTACTO ───────────────────────────────
const contactForm = document.getElementById('contactForm');
const formMessage = document.getElementById('formMessage');

contactForm?.addEventListener('submit', (event) => {
  event.preventDefault();

  if (!contactForm.checkValidity()) {
    contactForm.reportValidity();
    return;
  }

  if (formMessage) {
    formMessage.textContent = '✓ Consulta enviada. Te responderemos en menos de 24 hs hábiles.';
  }

  contactForm.reset();

  setTimeout(() => {
    if (formMessage) formMessage.textContent = '';
  }, 5000);
});