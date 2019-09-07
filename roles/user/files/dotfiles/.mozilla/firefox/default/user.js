//

// experimental
user_pref("gfx.webrender.all", true);

// Density as Compact
user_pref("browser.uidensity", 1);

user_pref("browser.sessionstore.warnOnQuit", true);
user_pref("browser.startup.page", 3);  // Resume the previous browser session
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.activity-stream.showTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// HiDPI tweak
user_pref("layout.css.devPixelsPerPx", "1.6");

// Enable spellchecker for multi-line controls and single-line controls
user_pref("layout.spellcheckDefault", 2);
user_pref("spellchecker.dictionary", "en-US");

user_pref("browser.ctrlTab.recentlyUsedOrder", false);
user_pref("findbar.highlightAll", true);

user_pref("middlemouse.paste", false);

user_pref("browser.contentblocking.category", "strict");
user_pref("permissions.default.desktop-notification", 2);  // deny by default
user_pref("permissions.default.geo", 2);  // deny by default
user_pref("accessibility.force_disabled", 1);

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
