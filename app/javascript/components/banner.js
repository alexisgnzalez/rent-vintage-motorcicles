import Typed from 'typed';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["On a beautiful motorcycle"],
    typeSpeed: 80,
    loop: true
  });
}

export { loadDynamicBannerText };
