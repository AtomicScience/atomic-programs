local app, module = require('umfal')('ore-sorter');

function module.attemptToMoveItem(slot)
  local name = app.routing.inputItemNameAt(slot);

  if not name then
    return;
  end

  local targetColor = app.filterMap.get()[name];

  if not targetColor then
    targetColor = 'black'
  end

  print(targetColor);

  local hasFreeSlot = app.routing.hasFreeSlot[targetColor]();

  if hasFreeSlot then
    app.routing.sendTo[targetColor](slot, 27);
  end
end