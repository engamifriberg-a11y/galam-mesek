var CACHE="galam-v4";
var CORE=["./manifest.webmanifest","./icon-192.png","./icon-512.png","./icon-512-maskable.png"];
self.addEventListener("install",function(e){e.waitUntil((async function(){var c=await caches.open(CACHE);try{await c.addAll(CORE);}catch(_){}self.skipWaiting();})());});
self.addEventListener("activate",function(e){e.waitUntil(caches.keys().then(function(ks){return Promise.all(ks.map(function(k){return k!==CACHE?caches.delete(k):null;}));}).then(function(){return self.clients.claim();}));});
self.addEventListener("fetch",function(e){
  var req=e.request; if(req.method!=="GET")return;
  var u; try{u=new URL(req.url);}catch(_){return;}
  // never intercept API/CDN calls — always network
  if(u.hostname.indexOf("supabase")>=0||u.hostname.indexOf("open-meteo")>=0||u.origin!==location.origin){return;}
  var isHTML=req.mode==="navigate"||u.pathname==="/"||u.pathname==="/index.html"||u.pathname.endsWith("/index.html");
  if(isHTML){
    // network-first so new versions show immediately
    e.respondWith(fetch(req).then(function(res){try{var c=res.clone();caches.open(CACHE).then(function(ch){ch.put(req,c);});}catch(_){}return res;}).catch(function(){return caches.match(req).then(function(h){return h||caches.match("./index.html");});}));
    return;
  }
  // assets: cache-first
  e.respondWith(caches.match(req).then(function(hit){if(hit)return hit;return fetch(req).then(function(res){try{var c=res.clone();caches.open(CACHE).then(function(ch){ch.put(req,c);});}catch(_){}return res;}).catch(function(){return hit;});}));
});
