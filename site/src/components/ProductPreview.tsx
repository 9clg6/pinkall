import {
  Desktop,
  MicrophoneSlash,
  PhoneCall,
  Play,
  Sparkle,
  SpeakerHigh,
} from "@phosphor-icons/react";

const waveformBars = Array.from({ length: 17 }, (_, index) => index);

export function ProductPreview() {
  return (
    <div className="product-visual" aria-label="Aperçu du coaching IA pendant un appel sur macOS et iPhone">
      <div className="liquid-flow liquid-flow-back" aria-hidden="true" />
      <div className="liquid-flow liquid-flow-mid" aria-hidden="true" />

      <article className="call-window" aria-label="Coaching en direct pendant un appel de démonstration">
        <header className="call-window-header">
          <div className="window-dots" aria-hidden="true">
            <span />
            <span />
            <span />
          </div>
          <div className="call-title">
            <PhoneCall aria-hidden="true" />
            <span>Coaching en direct</span>
          </div>
          <div className="call-platform">
            <Desktop aria-hidden="true" />
            <span>macOS</span>
            <time>34:17</time>
          </div>
        </header>

        <div className="call-tabs" aria-label="Contenu du coaching">
          <span data-active="true">Moments clés</span>
          <span>Questions</span>
          <span>Débrief</span>
        </div>

        <div className="transcript-list">
          <div className="transcript-row">
            <div>
              <strong>Toi</strong>
              <time>02:11</time>
            </div>
            <p>Qu’est-ce qui vous prend le plus de temps aujourd’hui ?</p>
          </div>
          <div className="transcript-row transcript-row-highlighted">
            <div>
              <strong>Prospect</strong>
              <time>02:14</time>
            </div>
            <p>On qualifie encore les demandes à la main, même avec notre outil actuel.</p>
            <span className="transcript-signal" aria-hidden="true" />
          </div>
          <div className="transcript-row">
            <div>
              <strong>Toi</strong>
              <time>02:23</time>
            </div>
            <p>Je vais vous montrer comment nous automatisons ça.</p>
          </div>
          <div className="transcript-row transcript-row-last">
            <div>
              <strong>Prospect</strong>
              <time>02:27</time>
            </div>
            <p>D’accord, mais je dois d’abord en parler à mon associé.</p>
          </div>
        </div>

        <div className="playback" aria-hidden="true">
          <Play weight="fill" />
          <span>00:00</span>
          <div className="playback-track">
            <span />
          </div>
          <span>34:17</span>
        </div>
      </article>

      <svg className="product-signal" viewBox="0 0 180 190" aria-hidden="true">
        <path d="M8 8 C142 12 42 168 172 182" />
        <circle cx="8" cy="8" r="4" />
        <circle cx="172" cy="182" r="4" />
      </svg>

      <div className="phone-shell" aria-label="Appel en cours sur iPhone">
        <div className="phone-speaker" aria-hidden="true" />
        <span className="phone-time">9:41</span>
        <div className="phone-contact">
          <strong>Marie</strong>
          <span>34:17</span>
        </div>
        <div className="phone-waveform" aria-hidden="true">
          {waveformBars.map((bar) => (
            <span key={bar} />
          ))}
        </div>
        <div className="phone-controls" aria-hidden="true">
          <span>
            <MicrophoneSlash />
          </span>
          <span className="phone-control-end">
            <PhoneCall weight="fill" />
          </span>
          <span>
            <SpeakerHigh weight="fill" />
          </span>
        </div>
      </div>

      <div className="liquid-flow liquid-flow-front" aria-hidden="true" />

      <aside className="advice-card" aria-label="Exemple de suggestion contextuelle pendant l’appel">
        <span className="advice-card-glow" aria-hidden="true" />
        <div className="advice-card-label">
          <Sparkle weight="fill" aria-hidden="true" />
          <span>Suggestion en direct</span>
        </div>
        <h3>Creuse son expérience avant de présenter ta solution.</h3>
        <p>Le prospect vient de mentionner son outil actuel. C’est le bon moment pour comprendre ce qui lui manque.</p>
        <div className="advice-card-link">
          <time>02:14</time>
          <span>Pourquoi cette question ?</span>
        </div>
      </aside>

      <p className="visual-disclaimer">Produit en préparation. Écrans illustratifs.</p>
    </div>
  );
}
