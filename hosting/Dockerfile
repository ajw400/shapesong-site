# The site on the Hetzner server (fallback to GitHub Pages): plain nginx serving the same files.
FROM nginx:1.27-alpine
COPY hosting/nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html 404.html style.css robots.txt sitemap.xml favicon.ico icon-192.png apple-touch-icon.png og-image.png /usr/share/nginx/html/
COPY privacy /usr/share/nginx/html/privacy
COPY contact /usr/share/nginx/html/contact
