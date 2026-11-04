// Service worker: red primero para la app, caché como respaldo sin conexión.
var CACHE = 'diario-v1';
var CORE = ['./', 'index.html', 'firebase-config.js', 'manifest.webmanifest', 'privacidad.html', 'icons/icon-192.png', 'icons/icon-512.png'];
self.addEventListener('install', function (e) {
  e.waitUntil(caches.open(CACHE).then(function (c) { return c.addAll(CORE); }).then(function () { return self.skipWaiting(); }));
});
self.addEventListener('activate', function (e) {
  e.waitUntil(caches.keys().then(function (ks) {
    return Promise.all(ks.filter(function (k) { return k !== CACHE; }).map(function (k) { return caches.delete(k); }));
  }).then(function () { return self.clients.claim(); }));
});
self.addEventListener('fetch', function (e) {
  var r = e.request, u = new URL(r.url);
  if (r.method !== 'GET') return;
  // Las llamadas a Firebase (Firestore/Auth) no se cachean aquí: Firestore ya tiene su propia caché offline
  if (/googleapis\.com|firebaseio\.com|identitytoolkit/.test(u.hostname)) return;
  var cacheable = u.origin === location.origin || /gstatic\.com|fonts\.googleapis\.com/.test(u.hostname);
  if (!cacheable) return;
  e.respondWith(fetch(r).then(function (res) {
    if (res && (res.ok || res.type === 'opaque')) { var cp = res.clone(); caches.open(CACHE).then(function (c) { c.put(r, cp); }); }
    return res;
  }).catch(function () {
    return caches.match(r).then(function (m) { return m || (r.mode === 'navigate' ? caches.match('index.html') : undefined); });
  }));
});
