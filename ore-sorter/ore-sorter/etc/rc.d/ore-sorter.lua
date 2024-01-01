local app = require('umfal').initAppFromAbsolute('ore-sorter', '/bin/ore-sorter');

local shell = require('shell');
local event = require('event');

local runtimeData = {}

function start(...)
  local args, ops = shell.parse(...);  

  app.subprograms.start(args, ops, runtimeData);
end

function status(...)
  local args, ops = shell.parse(...)

  app.subprograms.status(args, ops, runtimeData);
end

function stop(...)
  local args, ops = shell.parse(...)

  app.subprograms.stop(args, ops, runtimeData);
end

function scan(...)
  local args, ops = shell.parse(...)

  app.subprograms.scan(args, ops, runtimeData);
end