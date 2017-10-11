-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local contrib = require("vicious.contrib")
local hotkeys_popup = require("awful.hotkeys_popup").widget
--Build this with
--xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu >~/.config/awesome/archmenu.lua
local xdg_menu = require("archmenu")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
	title = "Oops, there were errors during startup!",
	text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, an error happened!",
		text = tostring(err) })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")

local HOME="/home/rob/"

beautiful.init(awful.util.get_xdg_config_home().."awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
--alternative_terminal = "lxterminal"
alternative_terminal = "terminator"
terminal = "qterminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
screen_delta=1

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Makes awesome ignore Num Lock
--awful.key.ignore_modifiers = { "Mod2" }

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.top,
	awful.layout.suit.floating,
	--awful.layout.suit.tile.left,
	--awful.layout.suit.tile.bottom,
	--awful.layout.suit.fair,
	--awful.layout.suit.fair.horizontal,
	--awful.layout.suit.spiral,
	--awful.layout.suit.spiral.dwindle,
	--awful.layout.suit.max,
	--awful.layout.suit.max.fullscreen,
	--awful.layout.suit.magnifier,
	--awful.layout.suit.corner.nw,
	--awful.layout.suit.corner.ne,
	--awful.layout.suit.corner.sw,
	--awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
	local instance = nil

	return function ()
		if instance and instance.wibox.visible then
			instance:hide()
			instance = nil
		else
			instance = awful.menu.clients({ theme = { width = 250 } })
		end
	end
end
-- }}}

mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{"Applications", xdgmenu },
		{ "open terminal", terminal }
	}
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Bob's functions
-- {{{ THIS IS FOR DEBUG PURPOSES:
--function print_r ( t )
--	local print_r_cache={}
--	local function sub_print_r(t,indent)
--		if (print_r_cache[tostring(t)]) then
--			print(indent.."*"..tostring(t))
--		else
--			print_r_cache[tostring(t)]=true
--			if (type(t)=="table") then
--				for pos,val in pairs(t) do
--					if (type(val)=="table") then
--						print(indent.."["..pos.."] => "..tostring(t).." {")
--						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
--						print(indent..string.rep(" ",string.len(pos)+6).."}")
--					elseif (type(val)=="string") then
--						print(indent.."["..pos..'] => "'..val..'"')
--					else
--						print(indent.."["..pos.."] => "..tostring(val))
--					end
--				end
--			else
--				print(indent..tostring(t))
--			end
--		end
--	end
--	if (type(t)=="table") then
--		print(tostring(t).." {")
--		sub_print_r(t,"  ")
--		print("}")
--	else
--		sub_print_r(t,"  ")
--	end
--	print()
--end
--}}}

local function delete_tag()
	local t = awful.screen.focused().selected_tag
	if not t then return end
	t:delete()
end

local function add_named_tag()
	awful.prompt.run {
		prompt       = "New tag name: ",
		textbox      = awful.screen.focused().mypromptbox.widget,
		exe_callback = function(new_name)
			if not new_name or #new_name == 0 then return end
			awful.tag.add(new_name,{screen= awful.screen.focused() }):view_only()
		end
	}
end

local function add_tag()
	awful.tag.add("| |",{screen= awful.screen.focused() }):view_only()
end

local function colorer(orangeT,redT,current,format,invert)
	if not format then
		format = "%s"
	end
	local color ='#3399ff'
	if not invert then
		if current > redT then
			color = '#FF0000'
		else
			if current > orangeT then
				color = '#FFA500'
			end
		end
	else
		if current < redT then
			color = '#FF0000'
		else
			if current < orangeT then
				color = '#FFA500'
			end
		end
	end
	return string.format('<span color="%s">'..format..'</span>', color, current)
end

function metawrap(func)
	local funcTable = {}
	setmetatable(funcTable, { __call = function(_, ...) return func(...) end })
	return funcTable
end

function onlyonmain(wid)
	local wibox = require("wibox")
	local awful = { widget = { only_on_screen = require("awful.widget.only_on_screen") } }

	return {
		{
			widget = wid,
		},
		screen = "primary",
		widget = awful.widget.only_on_screen
	}
end

function scandir(directory, filter)
	local i, t, popen = 0, {}, io.popen
	if not filter then
		filter = function(s) return true end
	end
	print(filter)
	for filename in popen('ls -a "'..directory..'"'):lines() do
		if filter(filename) then
			i = i + 1
			t[i] = filename
		end

	end
	return t
end

wp_index = 1
wp_path = HOME .. "Reinstall/arch/wallpapers/"
wp_files = scandir(wp_path)
math.randomseed( os.time() )
local function randomwp()
	-- get next random index
	wp_index = math.random( 1, #wp_files)

	-- set wallpaper to current index for all screens
	for s = 1, screen.count() do
		gears.wallpaper.maximized(wp_path .. wp_files[wp_index], s, true)
	end
end

-- }}}

-- {{{ Bob's Wibar
--
-- {{{ Rainbow Shrugger
local rainbow = {
	"#FF0000",
	"#FF7F00",
	"#FFFF00",
	"#00FF00",
	"#0000FF",
	"#4B0082",
}

local shrug = {
	"¯",
	"\\",
	"_",
	"(ツ)",
	"_",
	"/",
	"¯",
}

local shrug_KC = {
	"_K",
	"ee",
	"p_",
	"Ca",
	"lm",
	"!_",
}

shrugcounter = 0

local function shrugger()
	label = ' <span background="#808080"><b>'
	for n = 1,6 do
		label =  label .. '<span color="'.. rainbow[(n+shrugcounter)%6+1] ..'">' .. shrug[n] .. '</span>'
		--label =  label .. '<span color="'.. rainbow[(n+shrugcounter)%7+1] ..'">' .. "█" .. '</span>'
	end
	shrugcounter = (shrugcounter+1) % 6
	return label .. "</b></span> "
end
-- }}}

-- {{{ System status widgets
--
--If you want to use powerline
--package.path = package.path .. ';' .. HOME ..'.vim/bundle/powerline/powerline/bindings/awesome/?.lua'
--require('powerline')

batwid = vicious.widgets.bat
powersave = batwid("","BAT0")[1] == "-"
alerted = false
local function mypower()
	batvalues=batwid("","BAT0")
	if batvalues[1] == "-" and batvalues[2] < 7 and not alerted then
		alerted = true
		naughty.notify({ preset = naughty.config.presets.critical,
		title = "Battery state low",
		text = "Time left: "..batvalues[3] })
	end
	local pownow = ""
	if batvalues[1] == "-" then
		if not powersave then
			awful.spawn("powersave ON",false)
			awesome.restart()
		end
		pownow = colorer(8,10,tonumber(batvalues[5])," -%sW")
	else
		if powersave then
			awful.spawn("powersave OFF",false)
			awesome.restart()
		end
		alerted = false
		if batvalues[1] == "+" then
			pownow = '<span color="#009000"> +' .. batvalues[5] .. "W</span>"
		else
			pownow = colorer(8,10,6," "..batvalues[1].. batvalues[5] .. "W")
		end
	end
	return  "│" .. colorer(50,20,batvalues[2],"BAT:%s%% " .. batvalues[3] , true).. pownow .. "│"
end
batwidget = wibox.widget.textbox()
vicious.register(batwidget, metawrap(mypower) , "$1",powersave and 3 or 1)
batwidget = onlyonmain(batwidget)

memwid = vicious.widgets.mem
local function mymem()
	local values = vicious.widgets.mem()
	local label =colorer(65,90,values[1],"MEM:%s%% ")
	label = label .. colorer(60,80,values[5],"SWAP:%s%%")..'│'
	return label
end
memwidget =  wibox.widget.textbox()
memwidget:connect_signal(
"button::press",
function()
	awesome.spawn("tasklist MEM",false)
end
)
vicious.register(memwidget, metawrap(mymem), "$1", powersave and 13 or 1)
memwidget=onlyonmain(memwidget)

cpuwid =vicious.widgets.cpu
local function mycpu()
	local cpulevel = cpuwid()
	local label = ""
	local total = 0
	for n = 2,4 do
		label = label .. colorer(60,80,cpulevel[n],"%02d") .. '|'
		total = total + cpulevel[n]
	end
	total = total + cpulevel[5]
	return colorer(200,320,total,"CPU:%s").. "(" ..label .. colorer(60,80,cpulevel[5],"%02d") ..')' .. '% '
end

cpuwidget = wibox.widget.textbox()
cpuwidget:connect_signal(
"button::press",
function()
	awesome.spawn("tasklist CPU",false)
end
)
vicious.register(cpuwidget, metawrap(mycpu), "$1",powersave and 7 or 1)
cpuwidget=onlyonmain(cpuwidget)

thermwid = vicious.widgets.thermal
local function mytemp()
	if powersave then
		return ""
	end
	local thermal =thermwid("$1","thermal_zone1")[1]
	return colorer(65,75,thermal,"%s°C")..'│'
end
cputempwidget = wibox.widget.textbox()
vicious.register(cputempwidget, metawrap(mytemp), "$1", powersave and 0 or 4)
cputempwidget=onlyonmain(cputempwidget)

hddwid = vicious.widgets.fs
local function myhdd()
	local freespace = hddwid()['{/ avail_gb}']
	return colorer(20,10,tonumber(freespace),'HDD:%sGB ',true)
end
hddwidget = wibox.widget.textbox()
vicious.register(hddwidget, metawrap(myhdd), "HDD:${/ avail_gb}GB ", powersave and 0 or  13)
hddwidget=onlyonmain(hddwidget)

diowid = vicious.widgets.dio
local function mydio()
	if powersave then
		return ""
	end
	local mbps = diowid()['{sda total_mb}']
	return colorer(70,100,tonumber(mbps),'R+W:%sMBps')..'│'
end
diowidget = wibox.widget.textbox()
vicious.register(diowidget, metawrap(mydio), "$1",powersave and 0 or 1)
diowidget=onlyonmain(diowidget)

local function mynet()
	if powersave then
		return ""
	end
	if not netwid then
		netwid = contrib.net
		netwid()
		return "<span color='#FFA500'>Buffering Net...</span>│"
	end
	local values = netwid()
	local internet = values['{total carrier}']
	if tonumber(internet) < 1 then
		return '<span color="#FF0000">Net is down</span>│'
	end
	local up = values['{total up_kb}']
	local down = values['{total down_kb}']
	if tonumber(up) > 1024 then
		up = values['{total up_mb}'] ..'MBps'
	else
		up = up ..'KBps'
	end
	if tonumber(down) > 1024 then
		down = values['{down_mb}'] .. 'MBps'
	else
		down = down .. 'KBps'
	end
	return '<span color="#3399ff">NET:'..up..'↑ '..down .. '↓</span>│'
end
netwidget = wibox.widget.textbox()
vicious.register(netwidget, metawrap(mynet),"",powersave and 0 or 1)
netwidget=onlyonmain(netwidget)

datewidget = wibox.widget.textbox()
datewidget:connect_signal(
"button::press",
function()
	awesome.spawn("calnotify",false)
end
)
dateformat = powersave and "%b%d,%H:%M│" or "%b%d,%H:%M:%S│"
function mydate()
	return os.date(dateformat)
end
vicious.register(datewidget, metawrap(mydate), powersave and 30 or 1)

-- this spawns a 3 processes every time it is called, so it is disabled until I find a better way to do so
--capswid = wibox.widget.textbox()
--local function caps()
--	local f = io.popen("xset -q | grep 'Caps Lock: *on'")
--	local capsstatus = f:read("*all")
--	f:close()
--	--capswid.markup = capsstatus:len() > 0 and '<span color="#FF0000">CAPS IS ON </span>' or '<span color="#008000"></span>'
--	capswid:set_markup(capsstatus)
--	naughty.notify{ text = "Caps!" .. capsstatus }
--end
--vicious.register(capswid, metawrap(caps), 1)

--foowidget = wibox.widget.textbox()
--foowidget:set_markup_silently(powersave and '<span color="#008000">🍂</span>' or '<span color="#FF5000">🔥</span>')
--vicious.register(foowidget, foo, "$1",1)
--foowidget=onlyonmain(foowidget)

-- }}}

-- {{{ Wallpaper rotate
-- setup the timer
wp_timeout  = 300
wp_timer = timer { timeout = wp_timeout }
wp_timer:connect_signal("timeout", function()
	-- stop the timer (we don't need multiple instances running at the same time)
	wp_timer:stop()
	randomwp()
	--restart the timer
	wp_timer.timeout = wp_timeout
	wp_timer:start()
end)
if not powersave then
	-- initial start when rc.lua is first run
	wp_timer:start()
end
-- }}}

--use with echo "echo "aweclientwidget:set_text('foo!')" │ awesome-client
aweclientwidget = wibox.widget.textbox()
--}}}

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
awful.button({ }, 1, function(t) t:view_only() end),
awful.button({ modkey }, 1, function(t)
	if client.focus then
		client.focus:move_to_tag(t)
	end
end),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function(t)
	if client.focus then
		client.focus:toggle_tag(t)
	end
end),
awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
	if c == client.focus then
		c.minimized = true
	else
		-- Without this, the following
		-- :isvisible() makes no sense
		c.minimized = false
		if not c:isvisible() and c.first_tag then
			c.first_tag:view_only()
		end
		-- This will also un-minimize
		-- the client, if needed
		client.focus = c
		c:raise()
	end
end),
awful.button({ }, 3, client_menu_toggle_fn()),
awful.button({ }, 4, function ()
	awful.client.focus.byidx(1)
end),
awful.button({ }, 5, function ()
	awful.client.focus.byidx(-1)
end))

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.layout.inc( 1) end),
	awful.button({ }, 3, function () awful.layout.inc(-1) end),
	awful.button({ }, 4, function () awful.layout.inc( 1) end),
	awful.button({ }, 5, function () awful.layout.inc(-1) end)))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, font ="Monospace 10"})


	-- Add widgets to the wibox
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
		layout = wibox.layout.fixed.horizontal,
		mylauncher,
		s.mytaglist,
		s.mypromptbox,
	},
	s.mytasklist, -- Middle widget
	{ -- Right widgets
	layout = wibox.layout.fixed.horizontal,
	aweclientwidget,
	--powerline_widget,
	batwidget,
	cpuwidget,
	cputempwidget,
	memwidget,
	hddwidget,
	diowidget,
	netwidget,
	datewidget,
	capswid,
	--foowidget,
	wibox.widget.systray(),
	--s.mylayoutbox,
},
}
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
awful.button({ }, 3, function () mymainmenu:toggle() end),
awful.button({ }, 4, awful.tag.viewnext),
awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

--{{{ Author: JP
local function movetonexttag(delta)
	if client.focus then
		local tags = client.focus.screen.tags
		local tag = tags[(client.focus.first_tag.index + delta - 1) % #tags + 1]
		if tag then
			client.focus:move_to_tag(tag)
			tag:view_only()
		end
	end
end
--}}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
awful.key({ modkey,           }, "s",     hotkeys_popup.show_help,{description="show help", group="awesome"}),
awful.key({ modkey,           }, "Left",  awful.tag.viewprev,{description = "view previous", group = "tag"}),
awful.key({ modkey,           }, "Right", awful.tag.viewnext, {description = "view next", group = "tag"}),
awful.key({ modkey,           }, "Escape",awful.tag.history.restore, {description = "go back", group = "tag"}),
awful.key({ modkey,           }, "u",     awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
awful.key({ modkey, "Shift"   }, "space", function () screen_delta=-screen_delta end,{description = "invert screen indexing", group = "screen"}),
awful.key({ modkey, "Shift"   }, "j",     function () awful.client.swap.byidx(  1)    end, {description = "swap with next client by index", group = "client"}),
awful.key({ modkey, "Shift"   }, "k",     function () awful.client.swap.byidx( -1)    end, {description = "swap with previous client by index", group = "client"}),
awful.key({ modkey,           }, "d",     function () awful.screen.focus_relative(screen_delta) end, {description = "focus next", group = "screen"}),
awful.key({ modkey,           }, "a",     function () awful.screen.focus_relative(-screen_delta) end, {description = "focus previous", group = "screen"}),
awful.key({ modkey,           }, "j",     function () awful.client.focus.byidx( 1) end, {description = "focus next by index", group = "client"}),
awful.key({ modkey,           }, "k",     function () awful.client.focus.byidx(-1) end, {description = "focus previous by index", group = "client"}),
awful.key({ modkey, "Control" }, "Right", function() movetonexttag(1) end, {description = "move and switch to tag on the right", group = "client"}),
awful.key({ modkey, "Control" }, "Left",  function() movetonexttag(-1) end, {description = "move and switch to tag on the left", group = "client"}),
awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05) end, {description = "increase master width factor", group = "layout"}),
awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05) end, {description = "decrease master width factor", group = "layout"}),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end, {description = "increase the number of master clients", group = "layout"}),
awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end, {description = "decrease the number of master clients", group = "layout"}),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true) end, {description = "increase the number of columns", group = "layout"}),
awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true) end, {description = "decrease the number of columns", group = "layout"}),
awful.key({ modkey,           }, "space", function () awful.layout.inc( 1) end, {description = "select next", group = "layout"}),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end, {description = "select previous", group = "layout"}),
awful.key({ modkey,           }, ".",     function () awful.spawn("bash -c 'playerctl pause; xscreensaver-command -lock||slock'",false) end, {description = "Locks the screen", group = "system"}),
awful.key({ modkey, "Shift"   }, "c",     function () awesome.spawn("tasklist CPU") end, {description = "Shows the top 5 CPU consuming processes", group = "system"}),
awful.key({ modkey, "Shift"   }, "m",     function () awesome.spawn("tasklist MEM") end, {description = "Shows the top 5 MEMORY consuming processes", group = "system"}),
awful.key({ modkey, "Shift"   }, "Print", function () awful.spawn("screenshot",false)  end,{description = "takes a screenshot", group = "screen"}),
awful.key({                   }, "Print", function () awful.spawn("crop-screenshot",false)  end,{description = "takes a screenshot with selection", group = "screen"}),
awful.key({ modkey            }, "Print", function () awful.spawn("crop-screenshot SAVE",false)  end,{description = "takes a screenshot with selection", group = "screen"}),
awful.key({ modkey, "Shift"   }, "Print", function () awful.spawn("crop-screenshot OCR",false)  end,{description = "takes a screenshot with selection and uses an OCR to read the text inside the image", group = "screen"}),

-- Top row and media managing
awful.key({ modkey,           }, "F1",    function () awful.spawn("chromium") end,{description = "Chromium", group = "system"}),
awful.key({ modkey, "Shift"   }, "F1",    function () awful.spawn("chromium --incognito") end,{description = "Incognito Chromium", group = "system"}),
awful.key({ modkey,           }, "F2",    function () awful.spawn("pcmanfm") end,{description = "File manager", group = "launcher"}),
awful.key({ modkey, "Shift"   }, "F2",    function () awful.spawn("pavucontrol") end,{description = "Volume Manager", group = "launcher"}),
awful.key({ modkey,           }, "F3",    function () awful.spawn("kbd_backlight DOWN", false) end,{description = "Decrease keyboard backlight", group = "system"}),
awful.key({ modkey,           }, "F4",    function () awful.spawn("kbd_backlight UP", false) end,{description = "Increase keyboard backlight", group = "system"}),
awful.key({ modkey,           }, "F5",    function () awful.spawn("xbacklight -5",false) end,{description = "Decrease screen backlight", group = "system"}),
awful.key({ modkey,           }, "F6",    function () awful.spawn("xbacklight +5",false) end,{description = "Increase screen backlight", group = "system"}),
awful.key({ modkey            }, "F8",    function () awful.spawn("bash -c 'killall -9 nm-applet; nm-applet'",false) end,{description = "Decrease screen backlight", group = "system"}),
awful.key({                   }, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -5",false) end,{description = "Decrease screen backlight", group = "system"}),
awful.key({                   }, "XF86MonBrightnessUp", function () awful.spawn("xbacklight +5",false) end,{description = "Increase screen backlight", group = "system"}),
awful.key({                   }, "XF86AudioLowerVolume", function () awful.spawn("volumedown",false) end, {description = "Decrease volume", group = "media"}),
awful.key({                   }, "XF86AudioRaiseVolume", function () awful.spawn("volumeup",false) end,{description = "Increase volume", group = "media"}),
awful.key({                   }, "XF86AudioMute", function () awful.spawn("volumetoggle",false) end,{description = "Mute volume", group = "media"}),
awful.key({                   }, "XF86AudioPlay", function () awful.spawn("playerctl play-pause",false) end,{description = "Play/Pause current player", group = "media"}),
awful.key({                   }, "XF86AudioNext", function () awful.spawn("playerctl next",false)  end,{description = "Next song", group = "media"}),
awful.key({                   }, "XF86AudioPrev", function () awful.spawn("playerctl previous",false)  end,{description = "Previous song", group = "media"}),
awful.key({ modkey            }, "p",     function () awful.spawn("playerctl play-pause",false)  end,{description = "Play/Pause current player", group = "media"}),
awful.key({ modkey            }, "]",     function () awful.spawn("playerctl next",false)  end,{description = "Next song", group = "media"}),
awful.key({ modkey            }, "[",     function () awful.spawn("playerctl previous",false)  end,{description = "Previous song", group = "media"}),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end, {description = "open a terminal", group = "launcher"}),
awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(alternative_terminal) end,{description = "opens an alternative terminal", group = "launcher"}),
awful.key({ modkey, "Control" }, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),

-- More elaborate bindings
awful.key({ modkey,  "Shift"  }, "d",      function()
	if client.focus then
		client.focus:move_to_screen(client.focus.screen.index + screen_delta)
	end
end,
{description = "Move to next screen", group = "client"}),

awful.key({ modkey,  "Shift"  }, "a",      function()
	if client.focus then
		client.focus:move_to_screen(client.focus.screen.index - screen_delta)
	end
end,
{description = "Move to previous screen", group = "client"}),

awful.key({ modkey,           }, "Tab",
function ()
	awful.client.focus.byidx(-1)
	if client.focus then
		client.focus:raise()
	end
end,
{description = "go back", group = "client"}),

awful.key({ modkey, "Shift"  }, "t",
function ()
	awful.prompt.run {
		prompt       = 'Rename tag: ',
		text         = awful.tag.selected().name .. ' ',
		textbox      = mouse.screen.mypromptbox.widget,
		--textbox      = atextbox,
		exe_callback = function(input)
			if not input or #input == 0 then return end
			awful.tag.selected().name = input
		end
	}
end,
{description = "Rename tag",group="tag"}),

awful.key({ modkey, "Shift"   }, "n",
function ()
	local c = awful.client.restore()
	-- Focus restored client
	if c then
		client.focus = c
		c:raise()
	end
end,
{description = "restore minimized", group = "client"}),

--
--TODO this currently does not work
awful.key({ modkey }, "x",
function ()
	awful.prompt.run {
		prompt       = 'Paste snippet: ',
		text         = '',
		textbox      = mouse.screen.mypromptbox.widget,
		exe_callback = function(input)
			if not input or #input == 0 then return end
			awful.spawn('payloads ' .. input)
		end
	}
end,
{description = "Paste snippet",group="tag"}),

-- Prompt
--awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
--{description = "run prompt", group = "launcher"}),

--awful.key({ modkey }, "x",
--function ()
--	awful.prompt.run {
--		prompt       = "Run Lua code: ",
--		textbox      = awful.screen.focused().mypromptbox.widget,
--		exe_callback = awful.util.eval,
--		history_path = awful.util.get_cache_dir() .. "/history_eval"
--	}
--end,
--{description = "lua execute prompt", group = "awesome"}),

-- Menubar
awful.key({ modkey, }, "r", function() menubar.show() end, {description = "show the menubar", group = "launcher"}))

clientkeys = awful.util.table.join(
awful.key({ modkey,  "Shift"}, "f",
function (c)
	c.fullscreen = not c.fullscreen
	c:raise()
end,
{description = "toggle fullscreen", group = "client"}),
--TODO add https://awesomewm.org/apidoc/libraries/awesome.html#unix_signal and add suspend and resume
awful.key({ modkey,"Shift"}, "r",      function (c)
	naughty.notify({ preset = naughty.config.presets.critical,
	fg='#FFFFFF',
	bg='#00AA00',
	title = "Client resumed",
	text = c.name .. "("..c.pid ..")",
	timeout=4})
	awesome.kill(c.pid, awesome.unix_signal["SIGCONT"])
end,
{description = "resume", group = "client"}),

awful.key({ modkey,"Shift"}, "s",      function (c)
	naughty.notify({ preset = naughty.config.presets.critical,
	title = "Client suspended",
	text = c.name .. "("..c.pid ..")",
	timeout=4})
	awesome.kill(c.pid, awesome.unix_signal["SIGSTOP"])
end,
{description = "suspend", group = "client"}),

awful.key({ modkey,}, "q",      function (c) c:kill()                         end,
{description = "close", group = "client"}),

-- The client currently has the input focus, so it cannot be
-- minimized, since minimized clients can't have the focus.
awful.key({ modkey,           }, "n",      function (c) c.minimized = true end , {description = "minimize", group = "client"}),
awful.key({ modkey,           }, "f",      function(c) c.floating = not c.floating end, {description = "toggle floating", group = "client"}),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end, {description = "move to master", group = "client"}),
awful.key({ modkey,           }, "w",      function (c) c:move_to_screen() end, {description = "move to screen", group = "client"}),
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop end, {description = "toggle keep on top", group = "client"}),
awful.key({ modkey,           }, "m",
function (c)
	c.maximized = not c.maximized
	c:raise()
end , {description = "maximize", group = "client"}))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	-- View tag only.
	awful.key({ modkey }, "#" .. i + 9,
	function ()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then
			tag:view_only()
		end
	end,
	{description = "view tag #"..i, group = "tag"}),
	-- Toggle tag display.
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function ()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then
			awful.tag.viewtoggle(tag)
		end
	end,
	{description = "toggle tag #" .. i, group = "tag"}),
	-- Move client to tag.
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end,
	{description = "move focused client to tag #"..i, group = "tag"}),
	-- Toggle tag on focused client.
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:toggle_tag(tag)
			end
		end
	end,
	{description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	properties = { border_width = beautiful.border_width,
	border_color = beautiful.border_normal,
	focus = awful.client.focus.filter,
	raise = true,
	keys = clientkeys,
	buttons = clientbuttons,
	screen = awful.screen.preferred,
	placement = awful.placement.no_overlap+awful.placement.no_offscreen
}
},

-- Floating clients.
{ rule_any = {
	instance = {
		"DTA",  -- Firefox addon DownThemAll.
		"copyq",  -- Includes session name in class.
	},
	class = {
		"Arandr",
		"Gpick",
		"Kruler",
		"MessageWin",  -- kalarm.
		"Sxiv",
		"Wpa_gui",
		"pinentry",
		"veromix",
		"xtightvncviewer"},

		name = {
			"Event Tester",  -- xev.
		},
		role = {
			"AlarmWindow",  -- Thunderbird's calendar.
			--"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
		}
	}, properties = { floating = true }},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = {type = { "normal", "dialog" }
}, properties = { titlebars_enabled = false}
 },

 -- Set Firefox to always map on the tag named "2" on screen 1.
 -- { rule = { class = "Firefox" },
 --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and
		not c.size_hints.user_position
		and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = awful.util.table.join(
	awful.button({ }, 1, function()
		client.focus = c
		c:raise()
		awful.mouse.client.move(c)
	end),
	awful.button({ }, 3, function()
		client.focus = c
		c:raise()
		awful.mouse.client.resize(c)
	end)
	)

	awful.titlebar(c) : setup {
		{ -- Left
		awful.titlebar.widget.iconwidget(c),
		buttons = buttons,
		layout  = wibox.layout.fixed.horizontal
	},
	{ -- Middle
	{ -- Title
	align  = "center",
	widget = awful.titlebar.widget.titlewidget(c)
},
buttons = buttons,
layout  = wibox.layout.flex.horizontal
		  },
		  { -- Right
		  awful.titlebar.widget.floatingbutton (c),
		  awful.titlebar.widget.maximizedbutton(c),
		  awful.titlebar.widget.stickybutton   (c),
		  awful.titlebar.widget.ontopbutton    (c),
		  awful.titlebar.widget.closebutton    (c),
		  layout = wibox.layout.fixed.horizontal()
	  },
	  layout = wibox.layout.align.horizontal
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
		and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Shuffle the wallpaper. If on powersave this will only shuffle here and once
randomwp()
