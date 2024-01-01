local app = require('umfal')('ore-sorter');
local event = require('event');
local computer = require('computer');

return function(args, ops, runtimeData)
  if runtimeData.timerId then
    print('Sorting already running');
    return;
  end

  local inputSize = app.routing.inputSize();
  runtimeData.currentSlot = 1

  local function timerFunc()
    app.sorter.attemptToMoveItem(runtimeData.currentSlot);

    runtimeData.currentSlot = (runtimeData.currentSlot % inputSize) + 1;
  end

  print('Starting ore sorting...');
  runtimeData.timerId = event.timer(2, timerFunc, math.huge);
  -- timerFunc();
  print('Sorting started, timerId: '..runtimeData.timerId);
end