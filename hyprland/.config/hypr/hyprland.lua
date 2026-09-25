-- #######################################################################################
-- HYPRLAND CONFIG (Lua, Hyprland >= 0.55)
-- API reference: /usr/share/hypr/stubs/hl.meta.lua and https://wiki.hypr.land/Configuring/
--
-- Hyprland puts ~/.config/hypr/?.lua and ~/.config/hypr/?/init.lua on package.path,
-- so require("core") loads core/init.lua and require("modules.laptop") loads
-- modules/laptop.lua.
--
--   core/     shared by every machine
--   modules/  opt-in features; each returns { setup = function(opts) }
--   host.lua  per machine, from the host stow package (framework/, cosmo/):
--             monitors + the modules that machine wants
-- #######################################################################################

require("core")

-- A machine without a host stow package just gets core. Errors *inside* host.lua
-- don't raise here: Hyprland's require reports them as config errors instead.
pcall(require, "host")
