-- Hyprland Lua config (migrated from hyprland.conf + windowrules.conf for 0.55+/0.57)
-- hyprlang .conf support is removed in Hyprland 0.57; this file is the replacement.
-- Reference: /usr/share/hypr/hyprland.lua and /usr/share/hypr/stubs/hl.meta.lua


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "DP-1",
    mode     = "5120x1440@120.00",
    position = "0x0",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "ghostty -e yazi" -- yazi is a TUI: must run inside a terminal
local menu        = "wofi --show drun"
local mainMod     = "SUPER"


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")  -- Zen/Discord/Spotify render natively on Wayland (not XWayland)
hl.env("QT_QPA_PLATFORM", "wayland")               -- Qt apps use Wayland
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1") -- cleaner Qt windows


-----------------------
----- PERMISSIONS -----
-----------------------

-- Permission changes require a Hyprland restart and are not applied on-the-fly
-- for security reasons.
-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------
---- PLUGINS ----
-----------------

-- hy3 (tree/tab layout plugin, loaded via `hyprpm reload -n` in autostart).
-- Guarded: the plugin isn't loaded yet when the config first parses.
-- Layout is currently `master` (switched 2026-07-16); flip general.layout to
-- "hy3" to restore the tree/tab layout.
if hl.plugin.hy3 ~= nil then
    hl.config({
        plugin = {
            hy3 = {
                no_gaps_when_only     = 0,   -- 0 always show gaps, 1 hide with single window, 2 = 1 + border
                node_collapse_policy  = 2,   -- keep nested group only if parent is a tab group
                group_inset           = 10,
                tab_first_window      = false,

                tabs = {
                    height        = 22,
                    padding       = 6,
                    from_top      = false,
                    radius        = 6,
                    border_width  = 2,
                    render_text   = true,
                    text_center   = true,
                    text_font     = "Sans",
                    text_height   = 8,
                    text_padding  = 3,

                    -- hy3 uses a FLAT colors table: <state>, <state>_border, <state>_text
                    -- (schema dumped from the plugin binary: strings hy3.so | grep plugin:hy3:)
                    colors = {
                        active             = "rgba(33ccff40)", active_border             = "rgba(33ccffee)", active_text             = "rgba(ffffffff)",
                        active_alt_monitor = "rgba(60606040)", active_alt_monitor_border = "rgba(808080ee)", active_alt_monitor_text = "rgba(ffffffff)",
                        focused            = "rgba(60606040)", focused_border            = "rgba(808080ee)", focused_text            = "rgba(ffffffff)",
                        inactive           = "rgba(30303020)", inactive_border           = "rgba(606060aa)", inactive_text           = "rgba(ffffffff)",
                        urgent             = "rgba(ff223340)", urgent_border             = "rgba(909033ee)", urgent_text             = "rgba(ffffffff)",
                        locked             = "rgba(ff223340)", locked_border             = "rgba(909033ee)", locked_text             = "rgba(ffffffff)",
                    },

                    blur    = true,
                    opacity = 1.0,
                },

                autotile = {
                    enable            = true,
                    ephemeral_groups  = true,
                    trigger_width     = 0,
                    trigger_height    = 0,
                    workspaces        = "all",
                },
            },
        },
    })
end


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 5,

        border_size = 1,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,

        allow_tearing = true, -- permit tearing protocol for fullscreen games (per-game: windowrule immediate)

        -- layout = "hy3" -- switch back to hy3 to restore the tree/tab layout
        layout = "master",
    },

    -- Centered master: 25% | 50% | 25% for 3 windows
    master = {
        orientation                  = "center", -- master in the middle, slaves flank left/right
        mfact                        = 0.5,      -- center = 50% of width, each side = 25%
        slave_count_for_center_master = 2,       -- centering activates with >=2 slaves (i.e. 3 windows)
        center_master_fallback       = "left",   -- 1-2 windows use a normal left/master look
        new_status                   = "slave",  -- new windows join the sides; center master stays put
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    misc = {
        force_default_wallpaper = 0,    -- 0/1 disables the anime mascot wallpapers
        disable_hyprland_logo   = false,
    },

    debug = {
        disable_logs = false,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},   {0.32, 1}  } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},      {1, 1}     } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},  {0.75, 1}  } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},   {0.1, 1}   } })

hl.animation({ leaf = "global",           enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",           enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",          enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",           enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",          enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",             enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",           enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",         enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",     enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",     enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        repeat_rate  = 50,   -- faster key repeat (default 25)
        repeat_delay = 300,  -- (default 600)

        sensitivity = 0,     -- -1.0 - 1.0, 0 means no modification

        touchpad = {
            natural_scroll = false,
        },
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" })) -- moved off Super+V (Super+V is clipboard)
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Centered master layout controls (25/50/25)
hl.bind(mainMod .. " + O",           hl.dsp.layout("orientationcenter"))  -- force centered master on this workspace
hl.bind(mainMod .. " + SHIFT + O",   hl.dsp.layout("orientationnext"))    -- cycle left/top/right/bottom/center
hl.bind(mainMod .. " + bracketleft", hl.dsp.layout("mfact -0.05"))        -- shrink the center pane
hl.bind(mainMod .. " + bracketright", hl.dsp.layout("mfact +0.05"))       -- grow the center pane
hl.bind(mainMod .. " + CTRL + M",    hl.dsp.layout("mfact exact 0.5"))    -- snap the center pane back to 50%

-- Switch workspaces with mainMod + [0-9]; move window with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Programs
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("wofi --sort-order=alphabetical"))
hl.bind("SUPER + V",       hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

-- Music: Super+N launches the official client; the spotify-workspace rule
-- routes it by class at map time (real GUI window — no script/pid-binding needed)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("spotify-launcher"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys for volume (locked + repeating = old bindel)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
-- (XF86MonBrightness* binds removed 2026-09-04: brightnessctl not installed; DP-1 desktop has no backlight)

-- Requires playerctl (locked = old bindl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Workspaces 2, 4, 5 explicitly bound to DP-1 (fixes "apps spawning on wrong monitor")
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })

-- Global maximize, excluding Discord and Spotify (they get their own rules below).
-- REMOVED 2026-08-16: in the old conf this rule used a PCRE lookahead
-- `(?i)^(?!discord|spotify).*$` which RE2 cannot compile — it never matched, so
-- nothing was ever globally maximized. Re-expressing it with `negative:` (which
-- RE2 DOES support) made it actually match every window → every new window
-- (terminals included) opened maximized instead of tiling. Intentionally gone:
-- only Discord/Spotify maximize, via their workspace rules below.
--
-- Apps that request maximize themselves are suppressed instead (Hyprland's
-- shipped default — "You'll probably like this"): the WM decides tiling, not apps.
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Discord + Spotify share ws4 side by side: no maximize, so the master layout
-- tiles them 50/50 (master left, slave right — centering only kicks in at 3+).
hl.window_rule({
    name      = "discord-workspace",
    match     = { class = "(?i)^discord$" },
    workspace = "4",
})

hl.window_rule({
    name      = "spotify-workspace",
    match     = { class = "(?i)^spotify$" },
    workspace = "4",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- App workspace rules (window rules don't take `monitor`; workspaces are bound
-- to monitors via workspace_rule above)
-- zen's actual window class is "zen" (not "zen-browser" — that rule never
-- matched; autostart's exec rule was doing all the work). Fixed so wofi/other
-- launches also land on ws2.
hl.window_rule({
    name      = "browser-workspace",
    match     = { class = "^zen$" },
    workspace = "2",
})


---------------
---- AUTOSTART ----
---------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload -n")

    -- export Wayland session to systemd so xdg-desktop-portal works (screen share, file pickers)
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 2>/dev/null")

    hl.exec_cmd(terminal)
    hl.exec_cmd("zen-browser",         { workspace = "2 silent" })
    hl.exec_cmd("discord",             { workspace = "4 silent" })
    hl.exec_cmd("spotify-launcher",    { workspace = "4 silent" })
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")   -- stores only text data
    hl.exec_cmd("wl-paste --type image --watch cliphist store")  -- stores only image data
    hl.exec_cmd("mako")                                          -- notification daemon (for update alerts)
end)
