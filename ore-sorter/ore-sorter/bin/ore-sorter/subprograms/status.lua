local app = require('umfal')('ore-sorter');
local event = require('event');

local pr = function(arg) print(require("serialization").serialize(arg, 99999)) end;

return function(args, ops, context)
  if context.timerId then
    print("Ore sorting running");
  else
    print("Ore sorting stopped");
  end

  pr(app.filterMap.get());
end