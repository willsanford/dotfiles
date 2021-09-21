-- Widget and layout library
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Widget Imports
-- local battery_widget = require("widgets.battery_widget")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local net_widgets = require("net_widgets")
net_wireless = net_widgets.wireless({interface="wlp0s20f3",
                                     onclick = "alacritty -e sudo wifi-menu",
                                     popup_position = "bottom_right"})
-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
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
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        style = {
            shape = gears.shape.rounded_bar,
            fg_focus = "#e04614"
        },
        -- layout   = {
        --     spacing = 5,
        --     spacing_widget = {
        --         color  = '#dddddd',
        --         shape  = gears.shape.rounded_rect,
        --         widget = wibox.widget.separator,
        --     },
        --     layout  = wibox.layout.fixed.horizontal
        -- },
    }


	s.mytasklist = awful.widget.tasklist {
	    screen   = s,
	    filter   = awful.widget.tasklist.filter.currenttags,
	    buttons  = tasklist_buttons,
	    style    = {
		shape_border_width = 1,
		shape_border_color = '#777777',
		shape  = gears.shape.rounded_bar,
	    },
	    layout   = {
		spacing = 10,
		spacing_widget = {
		    {
			forced_width = 5,
			shape        = gears.shape.circle,
			widget       = wibox.widget.separator
		    },
		    valign = 'center',
		    halign = 'center',
		    widget = wibox.container.place,
		},
		layout  = wibox.layout.flex.horizontal
	    },
	    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
	    -- not a widget instance.
	    widget_template = {
		{
		    {
			{
			    {
				id     = 'icon_role',
				widget = wibox.widget.imagebox,
			    },
			    margins = 2,
			    widget  = wibox.container.margin,
			},
			{
			    id     = 'text_role',
			    widget = wibox.widget.textbox,
			},
			layout = wibox.layout.fixed.horizontal,
		    },
		    left  = 10,
		    right = 10,
		    widget = wibox.container.margin
		},
		id     = 'background_role',
		widget = wibox.container.background,
	    },
	}


    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height=30, opacity=1, bg="#1d1d1d" })
    local separator = wibox.widget.textbox("  ")
    local large_separator = wibox.widget.textbox("      ")
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
	    separator,
	    s.mytaglist,
	    separator,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
	   
            large_separator,
            wibox.widget.systray(),
            
            large_separator,
            net_wireless,

            large_separator,
            volume_widget{ 
                widget_type = 'icon_and_text'
            },
            
            large_separator,
            battery_widget{
                show_current_level = true
            },

            large_separator,
            mytextclock,

            large_separator,
                logout_menu_widget(),
        },
    }
end)
