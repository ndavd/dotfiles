-- hl.config({ debug = { disable_logs = false } })

local terminal = 'kitty'
local menu = 'tofi-drun --drun-launch=true'
local browser =
  'brave --ozone-platform-hint=auto --gtk-version=4 --disable-features=WaylandWpColorManagerV1'

local mainMod = 'SUPER'

local internal_monitor = {
  output = 'eDP-1',
  width = 1920,
  height = 1080,
  refresh_rate = 120,
}
local external_monitor = {
  output = 'HDMI-A-1',
  width = 2560,
  height = 1440,
  high_refresh_rate = 240,
  hdr_compatible_refresh_rate = 144,
}

local u = {
  ---@param width integer
  ---@param height integer
  ---@param refresh_rate integer
  monitor_mode = function(width, height, refresh_rate)
    return ('%dx%d@%d'):format(width, height, refresh_rate)
  end,

  ---@param x integer
  ---@param y integer
  monitor_position = function(x, y)
    return ('%dx%d'):format(x, y)
  end,

  ---@param ... string
  keys = function(...)
    return table.concat({ ... }, ' + ')
  end,
}

-- MONITORS AND WORKSPACES

hl.monitor({
  output = internal_monitor.output,
  mode = u.monitor_mode(
    internal_monitor.width,
    internal_monitor.height,
    internal_monitor.refresh_rate
  ),
  position = u.monitor_position(external_monitor.width, 0),
  scale = '1',
})

hl.config({
  render = { cm_auto_hdr = 1 },
})

-- workaround while https://github.com/hyprwm/Hyprland/pull/14523 isn't released
-- then hl.get_monitor will expose cm to check for hdr
local hdr_desktop = false

local external_monitor_setup = {
  hdr_fullscreen = function()
    hl.monitor({
      output = external_monitor.output,
      mode = u.monitor_mode(
        external_monitor.width,
        external_monitor.height,
        external_monitor.high_refresh_rate
      ),
      position = u.monitor_position(0, 0),
      scale = '1',
      bitdepth = 8,
      cm = 'srgb',
      sdr_min_luminance = 0.2,
      sdr_max_luminance = 80,
      supports_wide_color = false,
    })
  end,
  hdr_desktop = function()
    -- better SDR -> HDR mapping
    hl.monitor({
      output = external_monitor.output,
      mode = u.monitor_mode(
        external_monitor.width,
        external_monitor.height,
        external_monitor.hdr_compatible_refresh_rate
      ),
      position = u.monitor_position(0, 0),
      scale = '1',
      bitdepth = 10,
      cm = 'hdr',
      sdr_min_luminance = 0.005,
      sdr_max_luminance = 250,
      supports_wide_color = true,
    })
  end,
}
if hdr_desktop then
  external_monitor_setup.hdr_desktop()
else
  external_monitor_setup.hdr_fullscreen()
end

for i = 1, 10 do
  local key = i % 10
  hl.workspace_rule({
    workspace = tostring(i),
    monitor = i % 2 == 0 and internal_monitor.output or external_monitor.output,
  })
  hl.bind(u.keys(mainMod, key), hl.dsp.focus({ workspace = i }))
  hl.bind(u.keys(mainMod, 'SHIFT', key), hl.dsp.window.move({ workspace = i, follow = false }))
end

-- AUTOSTART

hl.on('hyprland.start', function()
  hl.exec_cmd('waybar')
  hl.exec_cmd('hyprpaper')
  hl.exec_cmd('hypridle')
  hl.exec_cmd('/usr/lib/hyprpolkitagent/hyprpolkitagent')
  hl.exec_cmd('opensnitch-ui')
end)

-- ENVIRONMENT VARIABLES

hl.env('XCURSOR_SIZE', '24')
hl.env('HYPRCURSOR_SIZE', '24')
hl.env('LIBVA_DRIVER_NAME', 'nvidia')
hl.env('__GLX_VENDOR_LIBRARY_NAME', 'nvidia')
hl.env('NVD_BACKEND', 'direct')
hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')
hl.env('QT_QPA_PLATFORM', 'wayland')
hl.env('QT_QPA_PLATFORMTHEME', 'qt6ct')

-- STYLE

hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 2,
    col = {
      active_border = {
        colors = { 'rgba(cf0704ff)', 'rgba(af5704ff)' },
        angle = 45,
      },
      inactive_border = 'rgba(595959aa)',
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = 'dwindle',
  },
  cursor = {
    no_warps = true,
  },
  decoration = {
    rounding = 0,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 'rgba(1a1a1aee)',
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },
  animations = {
    enabled = true,
  },
})

local easeOutQuint = 'easeOutQuint'
local linear = 'linear'
local almostLinear = 'almostLinear'
local quick = 'quick'

local curves = {
  [easeOutQuint] = { { 0.23, 1 }, { 0.32, 1 } },
  [linear] = { { 0, 0 }, { 1, 1 } },
  [almostLinear] = { { 0.5, 0.5 }, { 0.75, 1.0 } },
  [quick] = { { 0.15, 0 }, { 0.1, 1 } },
}
for name, points in pairs(curves) do
  hl.curve(name, { type = 'bezier', points = points })
end

local animations = {
  { leaf = 'global', speed = 10, bezier = 'default' },
  { leaf = 'border', speed = 5.39, bezier = easeOutQuint },
  { leaf = 'windows', speed = 4.79, bezier = easeOutQuint },
  { leaf = 'windowsIn', speed = 4.1, bezier = easeOutQuint, style = 'popin 87%' },
  { leaf = 'windowsOut', speed = 1.49, bezier = linear, style = 'popin 87%' },
  { leaf = 'fadeIn', speed = 1.73, bezier = almostLinear },
  { leaf = 'fadeOut', speed = 1.46, bezier = almostLinear },
  { leaf = 'fade', speed = 3.03, bezier = quick },
  { leaf = 'layers', speed = 3.81, bezier = easeOutQuint },
  { leaf = 'layersIn', speed = 4, bezier = easeOutQuint, style = 'fade' },
  { leaf = 'layersOut', speed = 1.5, bezier = linear, style = 'fade' },
  { leaf = 'fadeLayersIn', speed = 1.79, bezier = almostLinear },
  { leaf = 'fadeLayersOut', speed = 1.39, bezier = almostLinear },
  { leaf = 'workspaces', speed = 6, bezier = 'default', style = 'slide' },
  { leaf = 'workspacesIn', speed = 4, bezier = 'default', style = 'slide' },
  { leaf = 'workspacesOut', speed = 6, bezier = 'default', style = 'slide' },
}
for _, anim in ipairs(animations) do
  anim.enabled = true
  hl.animation(anim)
end

hl.config({
  dwindle = {
    preserve_split = true,
    force_split = 2,
    precise_mouse_move = false,
  },
  master = {
    new_status = 'master',
  },
  scrolling = {
    fullscreen_on_one_column = true,
  },
  misc = {
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    animate_manual_resizes = true,
  },
})

-- INPUT

hl.config({
  input = {
    kb_layout = 'us',
    kb_variant = '',
    kb_model = '',
    kb_options = 'compose:ralt',
    kb_rules = '',
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = false,
    },
  },
  gestures = {
    workspace_swipe_touch = false,
  },
})

hl.device({
  name = 'epic-mouse-v1',
  sensitivity = -0.5,
})

-- KEYBINDINGS

hl.bind(u.keys(mainMod, 'return'), hl.dsp.exec_cmd(terminal))
hl.bind(u.keys(mainMod, 'w'), hl.dsp.window.close())
hl.bind(u.keys(mainMod, 'o'), hl.dsp.window.float({ action = 'toggle' }))
hl.bind(u.keys(mainMod, 'f'), hl.dsp.window.fullscreen({ mode = 'fullscreen' }))
hl.bind(
  u.keys(mainMod, 'SHIFT', 'f'),
  hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = 'toggle' })
)

hl.bind(u.keys(mainMod, 'r'), hl.dsp.exec_cmd(menu))
hl.bind(u.keys(mainMod, 'b'), hl.dsp.exec_cmd(browser))
hl.bind(
  u.keys(mainMod, 'p'),
  hl.dsp.exec_cmd(
    'notify-send "mpv" "Playing $(wl-paste)" && mpv --ytdl-raw-options=cookies-from-browser=brave+gnomekeyring "$(wl-paste)"'
  )
)
hl.bind(u.keys(mainMod, 'c'), hl.dsp.exec_cmd('obs --startvirtualcam --minimize-to-tray'))
hl.bind(u.keys(mainMod, 'q'), hl.dsp.exec_cmd('qalculate-gtk'))

-- toggle high refresh rate for HDR compatibility
hl.bind(u.keys(mainMod, 'SHIFT', 'm'), function()
  local refresh_rate = math.ceil(hl.get_monitor(external_monitor.output).refresh_rate)

  local output = external_monitor.output
  local width = external_monitor.width
  local height = external_monitor.height
  local high_refresh_rate = external_monitor.high_refresh_rate
  local hdr_compatible_refresh_rate = external_monitor.hdr_compatible_refresh_rate
  local notify_cmd = 'notify-send "%s set to %dHz"'

  if refresh_rate == high_refresh_rate then
    hl.monitor({
      output = output,
      mode = u.monitor_mode(width, height, hdr_compatible_refresh_rate),
    })
    hl.dispatch(hl.dsp.exec_cmd(notify_cmd:format(output, hdr_compatible_refresh_rate)))
  elseif refresh_rate == hdr_compatible_refresh_rate then
    hl.monitor({
      output = output,
      mode = u.monitor_mode(width, height, high_refresh_rate),
    })
    hl.dispatch(hl.dsp.exec_cmd(notify_cmd:format(output, high_refresh_rate)))
  end
end)

hl.bind(u.keys(mainMod, 'h'), hl.dsp.focus({ direction = 'l' }))
hl.bind(u.keys(mainMod, 'j'), hl.dsp.focus({ direction = 'd' }))
hl.bind(u.keys(mainMod, 'k'), hl.dsp.focus({ direction = 'u' }))
hl.bind(u.keys(mainMod, 'l'), hl.dsp.focus({ direction = 'r' }))

hl.bind(u.keys(mainMod, 'SHIFT', 'h'), hl.dsp.window.swap({ direction = 'l' }))
hl.bind(u.keys(mainMod, 'SHIFT', 'j'), hl.dsp.window.swap({ direction = 'd' }))
hl.bind(u.keys(mainMod, 'SHIFT', 'k'), hl.dsp.window.swap({ direction = 'u' }))
hl.bind(u.keys(mainMod, 'SHIFT', 'l'), hl.dsp.window.swap({ direction = 'r' }))

hl.bind(u.keys(mainMod, 'space'), hl.dsp.window.cycle_next())

hl.bind(u.keys(mainMod, 'ALT', 'h'), hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
hl.bind(u.keys(mainMod, 'ALT', 'j'), hl.dsp.window.resize({ x = 0, y = 20, relative = true }))
hl.bind(u.keys(mainMod, 'ALT', 'k'), hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
hl.bind(u.keys(mainMod, 'ALT', 'l'), hl.dsp.window.resize({ x = 20, y = 0, relative = true }))

hl.bind('PRINT', hl.dsp.exec_cmd('hyprshot -s -m region --clipboard-only'))
hl.bind(
  u.keys('SHIFT', 'PRINT'),
  hl.dsp.exec_cmd(
    'hyprshot -m region --filename "$(date +%s).png" --output-folder "$HOME/data/pictures"'
  )
)

-- Example special workspace (scratchpad)
hl.bind(u.keys(mainMod, 's'), hl.dsp.workspace.toggle_special('magic'))
hl.bind(u.keys(mainMod, 'SHIFT', 's'), hl.dsp.window.move({ workspace = 'special:magic' }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(u.keys(mainMod, 'mouse_down'), hl.dsp.focus({ workspace = 'e+1' }))
hl.bind(u.keys(mainMod, 'mouse_up'), hl.dsp.focus({ workspace = 'e-1' }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(u.keys(mainMod, 'mouse:272'), hl.dsp.window.drag(), { mouse = true })
hl.bind(u.keys(mainMod, 'mouse:273'), hl.dsp.window.resize(), { mouse = true })

hl.bind(
  'XF86AudioRaiseVolume',
  hl.dsp.exec_cmd('media-controller-wrapper v up 5'),
  { locked = true, repeating = true }
)
hl.bind(
  'XF86AudioLowerVolume',
  hl.dsp.exec_cmd('media-controller-wrapper v down 5'),
  { locked = true, repeating = true }
)
hl.bind(
  'XF86AudioMute',
  hl.dsp.exec_cmd('media-controller-wrapper v mute'),
  { locked = true, repeating = true }
)
hl.bind(
  'XF86MonBrightnessUp',
  hl.dsp.exec_cmd('media-controller-wrapper b up 5'),
  { locked = true, repeating = true }
)
hl.bind(
  'XF86MonBrightnessDown',
  hl.dsp.exec_cmd('media-controller-wrapper b down 5'),
  { locked = true, repeating = true }
)
hl.bind(
  u.keys(mainMod, 'ALT', 'm'),
  hl.dsp.exec_cmd('media-controller-wrapper m mute'),
  { repeating = true }
)

hl.bind(u.keys(mainMod, 'e'), hl.dsp.submap('extra'))
hl.define_submap('extra', function()
  hl.bind('escape', hl.dsp.submap('reset'))
  hl.bind('h', function()
    hdr_desktop = not hdr_desktop
    if hdr_desktop then
      external_monitor_setup.hdr_desktop()
    else
      external_monitor_setup.hdr_fullscreen()
    end
    hl.dispatch(hl.dsp.submap('reset'))
  end)
end)

-- WINDOWS

hl.window_rule({
  name = 'suppress-maximize-events',
  match = { class = '.*' },
  suppress_event = 'maximize',
})

hl.window_rule({
  name = 'fix-xwayland-drags',
  match = {
    class = '^$',
    title = '^$',
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

hl.window_rule({ match = { class = 'imv' }, float = true })
hl.window_rule({ match = { class = 'qalculate-gtk' }, opacity = 0.9, float = true })
hl.window_rule({ match = { class = 'discord' }, workspace = '2' })
hl.window_rule({ match = { class = 'slack' }, workspace = '2' })
hl.window_rule({ match = { class = 'Element' }, workspace = '4' })
hl.window_rule({ match = { class = 'Element-Nightly' }, workspace = '4' })
hl.window_rule({ match = { class = 'steam' }, workspace = '5' })
hl.window_rule({ match = { class = 'SDL Application' }, workspace = '5' }) -- Also steam
hl.window_rule({ match = { class = 'Spotify' }, workspace = '6' })
