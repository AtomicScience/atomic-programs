local app = require('umfal').initAppFromAbsolute('ore-sorter', '/bin/ore-sorter');

local shell = require('shell');
local event = require('event');
local gpu   = require('component').gpu;

local context = {}

-- When turned on: 
-- 1) Resets rc.d's cache after every rerun
-- 2) Paints the area outside of Tier 1 screen size with white
--    (Allows to use a Tier 3 screen while developing)
context.isInDevMode = true;

if context.isInDevMode then
  -- Clearing offscreen area with white...
  gpu.setBackground(0xFFFFFF);
  gpu.fill(51, 1, 1000, 1000, ' ');
  gpu.fill(1, 17, 1000, 1000, ' ');
  -- ...and screen area with black
  gpu.setBackground(0x000000);
  gpu.fill(1, 1, 50, 16, ' ');
end

function start(...)
  local args, ops = shell.parse(...);

  app.subprograms.start(args, ops, context);
end

function status(...)
  local args, ops = shell.parse(...)

  app.subprograms.status(args, ops, context);
end

function stop(...)
  local args, ops = shell.parse(...)

  app.subprograms.stop(args, ops, context);
end

function scan(...)
  local args, ops = shell.parse(...)

  app.subprograms.scan(args, ops, context);
end

function wizard(...)
  local args, ops = shell.parse(...)

  app.subprograms.wizard.wizard(args, ops, context);
end

event.timer(0, function ()
  if context.isInDevMode then
    require('rc').unload('ore-sorter');
  end
end)