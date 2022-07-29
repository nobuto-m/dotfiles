//

// experimental
//user_pref("gfx.webrender.all", true);
//user_pref("gfx.webrender.compositor", true);
// unavailable by runtime: Wayland support missing
//user_pref("gfx.webrender.compositor.force-enabled", true);
//user_pref("gfx.x11-egl.force-enabled", true);

// legacy
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// UI
user_pref("browser.uidensity", 1);  // Density as Compact
user_pref("browser.tabs.drawInTitlebar", false);  // Show the titlebar instead of CSD
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("layout.css.devPixelsPerPx", "1.05");  // HiDPI tweak
user_pref("browser.ctrlTab.recentlyUsedOrder", false);
user_pref("findbar.highlightAll", true);
user_pref("accessibility.typeaheadfind.timeout", 300000);
user_pref("middlemouse.paste", false);

// Startup and exit
user_pref("browser.sessionstore.warnOnQuit", true);
user_pref("browser.startup.page", 3);  // Resume the previous browser session
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// Top sites and Highlights
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);

// Enable spellchecker for multi-line controls and single-line controls
user_pref("layout.spellcheckDefault", 2);
user_pref("spellchecker.dictionary", "en-US");

// Privacy and Security
user_pref("browser.contentblocking.category", "strict");
user_pref("permissions.default.geo", 2);  // deny by default
user_pref("media.autoplay.default", 5);  // block autoplay of audio and video
user_pref("accessibility.force_disabled", 1);
user_pref("dom.security.https_first", true);
//user_pref("dom.security.https_only_mode", true);

// Firefox Sync
user_pref("services.sync.engine.history", false);
user_pref("services.sync.engine.prefs", false);
user_pref("services.sync.engine.tabs", false);

user_pref("media.eme.enabled", true);  // Play DRM-controlled content

// Fonts
user_pref("font.default.x-unicode", "sans-serif");
user_pref("font.name.monospace.x-unicode", "DejaVu Sans Mono");
user_pref("font.name.sans-serif.x-unicode", "DejaVu Sans");
user_pref("font.name.serif.x-unicode", "DejaVu Serif");

user_pref("font.default.x-western", "sans-serif");
user_pref("font.name.monospace.x-western", "DejaVu Sans Mono");
user_pref("font.name.sans-serif.x-western", "DejaVu Sans");
user_pref("font.name.serif.x-western", "DejaVu Serif");

user_pref("font.name.monospace.ja", "DejaVu Sans Mono");
user_pref("font.name.sans-serif.ja", "DejaVu Sans");
user_pref("font.name.serif.ja", "DejaVu Serif");

// override fallback order since Firefox doesn't look for LC_CTYPE or
// follow the language of the page content to display tab titles
user_pref("font.cjk_pref_fallback_order", "ja,zh-cn,zh-hk,zh-tw,ko");
