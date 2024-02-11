local app = require('umfal')('ore-sorter');
local event = require('event');

return function(args, ops, runtimeData)
  if not runtimeData.timerId then
    print('Sorting already stopped');
    return;
  end

  print('Stopping ore sorting...');
  event.cancel(runtimeData.timerId);
  runtimeData.timerId = nil;
  print('Sorting stopped');
end