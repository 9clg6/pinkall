export function Nav() {
  return (
    <header className="site-header">
      <nav className="page-shell nav-shell" aria-label="Navigation principale">
        <a className="wordmark" href="#main-content" aria-label="Pinkall, accueil">
          <img className="wordmark-mark" src="/brand/pinkall-mark.svg" alt="" />
          <span className="wordmark-text">pinkall</span>
        </a>

        <div className="nav-links">
          <a href="#produit">Produit</a>
          <a href="#sources">Sources</a>
        </div>

        <a className="button nav-cta" href="#waitlist">
          Rejoindre la waitlist
        </a>
      </nav>
    </header>
  );
}
