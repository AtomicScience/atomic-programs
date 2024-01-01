local app = require('umfal')('ore-sorter');
local event = require('event');

return function(args, ops, runtimeData)
  if not runtimeData.timerId then
    print('Sorting already stopped');
    -- TODO: Remove
    require('rc').unload('ore-sorter');
    return;
  end

  print('Stopping ore sorting...');
  event.cancel(runtimeData.timerId);
  runtimeData.timerId = nil;
  print('Sorting stopped');

  -- TODO: Remove
  require('rc').unload('ore-sorter');
end