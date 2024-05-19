local app = require('umfal')('ore-sorter');
local event = require('event');
local computer = require('computer');

return function(args, ops, context)
  if context.timerId then
    print('Sorting already running');
    return;
  end

  local inputSize = app.routing.inputSize();
  context.currentSlot = 1

  local function timerFunc()
    app.sorter.attemptToMoveItem(context.currentSlot);

    context.currentSlot = (context.currentSlot % inputSize) + 1;
  end

  print('Starting ore sorting...');
  context.timerId = event.timer(0.5, timerFunc, math.huge);
  -- timerFunc();
  print('Sorting started, timerId: '..context.timerId);
end