user_pref("dom.battery.enabled",false); // Web applications have no access to battery status
user_pref("dom.event.clipboardevents.enabled", false); // Web applications have no access to the clipboard 
user_pref("plugin.state.flash", 0); // Turn off the Flash plugin
user_pref("plugin.state.java", 0); // Turn of the Java plugin
user_pref("plugin.scan.plid.all", false); // Disable reporting about installed plugins
user_pref("geo.enabled", false); // Disable location aware browsing
user_pref("media.peerconnection.enabled",false); // Disable WebRTC
user_pref("browser.search.geoip.url", "");


// enable security features, and disable weak encryption
user_pref("browser.sessionstore.privacy_level", 2);
user_pref("privacy.trackingprotection.enabled", true); // Enable Firefox tracking protection 
user_pref("browser.safebrowsing.enabled", true); // Check URLs that are opened against a web forgery database
user_pref("browser.safebrowsing.malware.enabled", true); // Use malware information to determine if downloads are malicious
user_pref("browser.privatebrowsing.autostart", true); // Enable private browsing mode on start
user_pref("extensions.update.enabled", true);
user_pref("extensions.blocklist.enabled", true);
user_pref("security.warn_entering_weak", true);
user_pref("security.ssl.warn_missing_rfc5746", 1);
user_pref("network.stricttransportsecurity.preloadlist", true);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("security.OCSP.enabled", true);
user_pref("security.ssl.enable_ocsp_stapling", true);
user_pref("security.OCSP.require", true);
user_pref("security.enable_tls_session_tickets", false);
user_pref("security.tls.version.min", 1);
user_pref("security.tls.version.max", 3);
user_pref("security.enable_ssl3", false);
user_pref("security.cert_pinning.enforcement_level", 2);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);

// disable cache, cleanup
user_pref("browser.sessionstore.postdata", 0);
user_pref("browser.sessionstore.enabled", false);
user_pref("browser.cache.offline.enable", false);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.passwords", true);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.siteSettings", true);
user_pref("network.cookie.lifetimePolicy", 2); // Number of days cookies are stored
user_pref("browser.cache.disk.enable", false); // Don't use local disk cache
user_pref("browser.cache.disk_cache_ssl", false); // Don't cache contents from SSL pages 
user_pref("layout.css.visited_links_enabled", false);

// ----------------------------------------------------------
// Netowork
//

user_pref("browser.goBrowsing.enabled", false); // Don't use Google to resolve DNS 
user_pref("network.prefetch-next", false); // Disable link prefetching directives by websites

// ----------------------------------------------------------
// user interface
//
user_pref("browser.shell.checkDefaultBrowser", false);  
user_pref("security.ask_for_password", 0); // Never ask for passwords
user_pref("clipboard.autocopy", false); // Don't paste selected text automatically to clipboard
user_pref("browser.fixup.alternate.enabled", false); // Disable URL completion in address bar
user_pref("browser.formfill.enable", false); // Don't remember text entered into forms
user_pref("browser.formfill.expire_days", 0);
user_pref("browser.search.suggest.enabled");
// Don't display site suggestions in new empty tabs
user_pref("browser.newtab.url", "about:blank");         
user_pref("browser.newtabpage.enabled", false);
user_pref("services.sync.prefs.sync.browser.newtabpage.enabled", false)
// Download menu
user_pref("browser.download.folderList", 2); // Download to the location last specified
user_pref("browser.download.useDownloadDir", false); // Ask where to save every file
user_pref("browser.download.manager.retention", 0); // Forget files upon successful download
user_pref("browser.download.manager.showAlertOnComplete", false); // No alert upon download completion
// Location Bar
user_pref("browser.urlbar.autoFill", false); // Disable auto completion
user_pref("browser.urlbar.maxRichResults", 0); // Don't show suggestions 
user_pref("browser.urlbar.autocomplete.enabled", false); // No auto completion


// ---------------------------------------------------------
// Javascript

user_pref("browser.urlbar.filter.javascript", true);  // Don't remember Javascript in address bar
user_pref("browser.link.open_newwindow.restriction", 0); // Force windows opened by Javascript into tabs


// ----------------------------------------------------------
// disable telemetry, analytics, history, etc. 
user_pref("beacon.enabled", false); // Don't send data to servers when leaving pages.
user_pref("browser.send_pings",false); // Don't send data to servers about links that get clicked on by the user
user_pref("signon.rememberSignons", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("browser.selfsupport.url", false); // Disable Heartbeat feedback send to Mozilla
user_pref("browser.search.suggest.enabled", false);
user_pref("media.webspeech.recognition.enable", false);
// Don't remember visited pages
user_pref("places.history.enabled", false);  
user_pref("browser.history_expire_days", 0); 
user_pref("browser.history_expire_sites", 0);
user_pref("browser.history_expire_visits", 0); 


// --------------------------------------------------------------
// Disable weak encyption
//
user_pref("security.ssl3.rsa_seed_sha", false);
user_pref("security.ssl3.rsa_rc4_40_md5", false);
user_pref("security.ssl3.rsa_rc2_40_md5", false);
user_pref("security.ssl3.rsa_1024_rc4_56_sha", false);
user_pref("security.ssl3.rsa_camellia_128_sha", false);
user_pref("security.ssl3.ecdhe_rsa_aes_128_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_aes_128_sha", false);
user_pref("security.ssl3.ecdh_rsa_aes_128_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_aes_128_sha", false);
user_pref("security.ssl3.dhe_rsa_camellia_128_sha", false);
user_pref("security.ssl3.dhe_rsa_aes_128_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdh_rsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_rc4_128_sha", false);
user_pref("security.ssl3.ecdhe_rsa_rc4_128_sha", false);
user_pref("security.ssl3.rsa_rc4_128_md5", false);
user_pref("security.ssl3.rsa_rc4_128_sha", false);
user_pref("security.tls.unrestricted_rc4_fallback", false);
user_pref("security.ssl3.dhe_dss_des_ede3_sha", false);
user_pref("security.ssl3.dhe_rsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdh_rsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdhe_ecdsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdhe_rsa_des_ede3_sha", false);
user_pref("security.ssl3.rsa_des_ede3_sha", false);
user_pref("security.ssl3.rsa_fips_des_ede3_sha", false);
user_pref("security.ssl3.ecdh_rsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdh_rsa_aes_256_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_des_ede3_sha", false);
user_pref("security.ssl3.ecdh_ecdsa_aes_256_sha", false);
user_pref("security.ssl3.rsa_camellia_256_sha", false);
user_pref("security.ssl3.rsa_aes_256_sha", false);
user_pref("security.ssl3.ecdhe_rsa_aes_256_sha", true);
user_pref("security.ssl3.ecdhe_ecdsa_aes_256_sha", true);
user_pref("security.ssl3.ecdhe_ecdsa_aes_128_gcm_sha256", true);
user_pref("security.ssl3.ecdhe_rsa_aes_128_gcm_sha256", true);
user_pref("security.ssl3.dhe_rsa_camellia_256_sha", false);
user_pref("security.ssl3.dhe_rsa_aes_256_sha", false);
user_pref("security.ssl3.dhe_dss_aes_128_sha", false);
user_pref("security.ssl3.dhe_dss_aes_256_sha", false);
user_pref("security.ssl3.dhe_dss_camellia_128_sha", false);
user_pref("security.ssl3.dhe_dss_camellia_256_sha", false);
user_pref("security.ssl3.dhe_dss_des_ede3_sha", false);
user_pref("security.ssl3.rsa_aes_256_sha", true);
user_pref("security.ssl3.rsa_aes_128_sha", true);

