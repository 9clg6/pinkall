import {
  ArrowUpRight,
  CheckCircle,
  FileText,
  Quotes,
  Target,
} from "@phosphor-icons/react";
import { useEffect } from "react";
import { Nav } from "./components/Nav";
import { ProductPreview } from "./components/ProductPreview";
import { WaitlistEmailForm } from "./components/WaitlistEmailForm";

const callFlow = [
  {
    icon: Quotes,
    title: "Il comprend le contexte",
    text: "Pinkall suit le fil de l’échange, les besoins exprimés et les objections déjà abordées.",
  },
  {
    icon: FileText,
    title: "Il repère ce qui compte",
    text: "Il détecte les phrases clés et les moments où une question peut vraiment faire avancer le call.",
  },
  {
    icon: Target,
    title: "Il te guide au bon moment",
    text: "Il te suggère une question utile sans commenter chaque phrase ni détourner ton attention du prospect.",
  },
];

const sources = [
  {
    name: "MIT OpenCourseWare",
    title: "15.387 Entrepreneurial Sales, MIT Sloan",
    detail: "Supports publics sur la vente de produits techniques et l’organisation commerciale.",
    href: "https://ocw.mit.edu/courses/15-387-entrepreneurial-sales-spring-2015/",
  },
  {
    name: "Program on Negotiation at Harvard Law School",
    title: "Negotiation Skills for Win-Win Negotiations",
    detail: "Article du PON Staff sur l’écoute active en négociation.",
    href: "https://www.pon.harvard.edu/daily/negotiation-skills-daily/listening-skills-for-maximum-success/",
  },
  {
    name: "Google Skillshop",
    title: "Formations officielles aux produits Google",
    detail: "Références réservées aux sujets d’acquisition, de publicité et de mesure.",
    href: "https://skillshop.withgoogle.com/",
  },
  {
    name: "Ouvrages et playbooks professionnels",
    title: "Prospection, découverte, objections et suivi",
    detail: "Chaque référence indiquera l’auteur, l’édition, la date et le passage consulté.",
  },
];

function App() {
  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return undefined;

    const elements = Array.from(document.querySelectorAll<HTMLElement>("[data-reveal]"));
    document.documentElement.classList.add("motion-enabled");

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        });
      },
      { rootMargin: "0px 0px -8%", threshold: 0.12 },
    );

    elements.forEach((element) => observer.observe(element));

    return () => {
      observer.disconnect();
      document.documentElement.classList.remove("motion-enabled");
    };
  }, []);

  return (
    <div className="marketing-site">
      <a className="skip-link" href="#main-content">
        Aller au contenu
      </a>
      <Nav />

      <main id="main-content">
        <section className="hero-section" aria-labelledby="hero-title">
          <div className="hero-grain" aria-hidden="true" />
          <div className="hero-grid-lines" aria-hidden="true" />
          <div className="hero-aurora" aria-hidden="true">
            <span className="hero-aurora-core" />
            <span className="hero-aurora-wing hero-aurora-wing-left" />
            <span className="hero-aurora-wing hero-aurora-wing-right" />
          </div>

          <div className="page-shell hero-grid">
            <div className="hero-copy">
              <p className="hero-command" aria-label="Pinkall écoute l’appel en direct">
                <span aria-hidden="true">$</span>
                <span>pinkall listen --live</span>
              </p>
              <h1 id="hero-title">
                <span>Le coach IA qui t’aide à</span>
                <em>réussir chaque call.</em>
              </h1>
              <p className="hero-subtitle">
                Pinkall comprend la conversation, repère les moments décisifs et te
                suggère la bonne question quand elle peut faire avancer l’échange.
                Après l’appel, son analyse sourcée t’aide à progresser concrètement.
              </p>
              <WaitlistEmailForm idPrefix="waitlist" source="hero" />
            </div>

            <div className="hero-product">
              <ProductPreview />
            </div>

            <div className="hero-capabilities" aria-label="Ce que Pinkall réunit pendant un appel">
              <span>Appel natif</span>
              <span>Notes automatiques</span>
              <span>Coaching en direct</span>
              <span>Débrief sourcé</span>
            </div>
          </div>
        </section>

        <section className="flow-section" id="produit" aria-labelledby="flow-title">
          <div className="page-shell">
            <div className="section-intro section-intro-centered">
              <p className="section-eyebrow">Pendant l’appel</p>
              <h2 id="flow-title">Il n’intervient pas à chaque phrase. Seulement quand ça compte.</h2>
              <p>Tu gardes une conversation naturelle. Pinkall écoute, comprend et choisit les moments où son aide peut changer la suite du call.</p>
            </div>

            <div className="flow-rail">
              {callFlow.map((step, index) => {
                const Icon = step.icon;
                return (
                  <article className="flow-step" data-reveal key={step.title}>
                    <div className="flow-step-top">
                      <span>{String(index + 1).padStart(2, "0")}</span>
                      <Icon aria-hidden="true" />
                    </div>
                    <h3>{step.title}</h3>
                    <p>{step.text}</p>
                  </article>
                );
              })}
            </div>
          </div>
        </section>

        <section className="method-section" aria-labelledby="method-title">
          <div className="page-shell">
            <div className="section-intro coaching-intro">
              <p className="section-eyebrow">Comment ça marche</p>
              <h2 id="method-title">Pendant le call, il t’aide à poser la prochaine bonne question.</h2>
              <p>
                Pinkall relie ce que le prospect vient de dire au reste de l’échange, puis te guide uniquement lorsqu’une relance mérite d’être posée.
              </p>
            </div>

            <div className="coaching-sequence">
              <div className="sequence-track" aria-hidden="true">
                <span />
              </div>

              <article className="sequence-stage sequence-passage" data-reveal>
                <div className="sequence-heading">
                  <span>Moment clé détecté</span>
                  <time>02:14</time>
                </div>
                <blockquote>
                  <span>Prospect</span>
                  « On utilise déjà un outil pour ça. »
                </blockquote>
                <blockquote>
                  <span>Toi</span>
                  « Le nôtre est plus simple et plus complet. »
                </blockquote>
              </article>

              <article className="sequence-stage sequence-insight" data-reveal>
                <span className="sequence-label">Ce que Pinkall comprend</span>
                <h3>Le prospect utilise déjà une solution, mais tu ne sais pas encore ce qui lui convient ni ce qui lui manque.</h3>
                <p>Le bon moment pour approfondir, avant de présenter.</p>
              </article>

              <article className="sequence-stage sequence-test" data-reveal>
                <span className="sequence-label">Question suggérée maintenant</span>
                <blockquote>« Qu’est-ce qui fonctionne bien avec votre outil actuel, et qu’est-ce qui vous manque encore ? »</blockquote>
                <a href="#sources">Comprendre la méthode utilisée</a>
              </article>
            </div>
          </div>
        </section>

        <section className="sources-section" id="sources" aria-labelledby="sources-title">
          <div className="page-shell sources-layout">
            <div className="section-intro sources-intro">
              <p className="section-eyebrow">Méthode</p>
              <h2 id="sources-title">Un coaching fondé sur des méthodes vérifiables.</h2>
              <p>
                Les recommandations ne sortent pas d’un score générique. Le corpus de coaching est construit à partir de travaux académiques et de méthodes professionnelles, avec la référence, la date et le passage consulté pour chaque règle retenue.
              </p>
            </div>

            <div className="source-list">
              {sources.map((source) => {
                const content = (
                  <>
                    <div className="source-name">
                      <strong>{source.name}</strong>
                      <span>{source.title}</span>
                    </div>
                    <p>{source.detail}</p>
                    {source.href ? <ArrowUpRight aria-hidden="true" /> : <span className="source-status">Bibliographie en cours</span>}
                  </>
                );

                return source.href ? (
                  <a className="source-row" data-reveal href={source.href} key={source.name} rel="noreferrer" target="_blank">
                    {content}
                  </a>
                ) : (
                  <div className="source-row" data-reveal key={source.name}>
                    {content}
                  </div>
                );
              })}
            </div>

            <p className="sources-disclaimer">
              Les noms, marques et œuvres cités identifient uniquement les références consultées. Leur mention n’implique aucune affiliation, certification, approbation ou partenariat.
            </p>
          </div>
        </section>

        <section className="control-section" aria-labelledby="control-title">
          <div className="page-shell control-panel">
            <CheckCircle aria-hidden="true" />
            <div>
              <p className="section-eyebrow">Toujours sous ton contrôle</p>
              <h2 id="control-title">Tu restes maître de la conversation.</h2>
              <p>Pinkall ne te dicte pas chaque réponse. Il fait ressortir les moments décisifs, te propose une piste claire et te laisse choisir comment mener l’échange. Après le call, tu peux relire les passages clés, corriger les notes et valider les brouillons.</p>
            </div>
            <p className="product-disclaimer">
              Produit en préparation. Écrans et contenus illustratifs. Les modalités d’enregistrement, de transcription et de consentement seront validées avant les tests.
            </p>
          </div>
        </section>

        <section className="waitlist-section" aria-labelledby="waitlist-title">
          <div className="page-shell waitlist-panel">
            <div>
              <p className="section-eyebrow">Bêta privée</p>
              <h2 id="waitlist-title">Teste ton prochain call avec un vrai coach IA.</h2>
              <p>Laisse ton email. Nous t’écrirons quand la bêta sera prête à t’accompagner pendant tes appels.</p>
            </div>
            <WaitlistEmailForm idPrefix="waitlist-bottom" source="footer" />
          </div>
        </section>
      </main>

      <footer className="site-footer">
        <div className="page-shell footer-inner">
          <a className="wordmark" href="#main-content" aria-label="Pinkall, retour en haut">
            <img className="wordmark-mark" src="/brand/pinkall-mark.svg" alt="" />
            <span className="wordmark-text">pinkall</span>
          </a>
          <p>Bêta en préparation pour macOS et iPhone.</p>
          <span>© 2026 Pinkall.</span>
        </div>
      </footer>
    </div>
  );
}

export default App;
