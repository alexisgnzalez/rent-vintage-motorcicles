const initUpdateNavbarOnScroll = () => {
  const navbar = document.querySelector('#navbar-home');
  if (navbar) {
    navbar.classList.remove('navbar-color');

    window.addEventListener('scroll', () => {
      if (window.scrollY >= window.innerHeight) {
        navbar.classList.add('navbar-color');
      } else {
        navbar.classList.remove('navbar-color');
      }
    });
  }
}

export { initUpdateNavbarOnScroll };
