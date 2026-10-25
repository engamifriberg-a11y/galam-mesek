var CACHE="galam-v2";
var CORE=["./","./index.html","./manifest.webmanifest","./icon-192.png","./icon-512.png","./icon-512-maskable.png"];
var CDN=["https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"];
self.addEventListener("install",function(e){e.waitUntil((async function(){var c=await caches.open(CACHE);try{await c.addAll(CORE);}catch(_){}for(var i=0;i<CDN.length;i++){try{var r=await fetch(CDN[i],{mode:"no-cors"});await c.put(CDN[i],r);}catch(_){}}self.skipWaiting();})());});
self.addEventListener("activate",function(e){e.waitUntil(caches.keys().then(function(ks){return Promise.all(ks.map(function(k){return k!==CACHE?caches.delete(k):null;}));}).then(function(){return self.clients.claim();}));});
self.addEventListener("fetch",function(e){var req=e.request;if(req.method!=="GET")return;var u;try{u=new URL(req.url);}catch(_){return;}if(u.hostname.indexOf("open-meteo")>=0)return;e.respondWith(caches.match(req).then(function(hit){if(hit)return hit;return fetch(req).then(function(res){try{if(u.origin===location.origin){var c=res.clone();caches.open(CACHE).then(function(ch){ch.put(req,c);});}}catch(_){}return res;}).catch(function(){return hit;});}));});
