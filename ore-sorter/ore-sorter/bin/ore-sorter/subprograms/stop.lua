local app = require('umfal')('ore-sorter');
local event = require('event');

return function(args, ops, context)
  if not context.timerId then
    print('Sorting already stopped');
    return;
  end

  print('Stopping ore sorting...');
  event.cancel(context.timerId);
  context.timerId = nil;
  print('Sorting stopped');
end