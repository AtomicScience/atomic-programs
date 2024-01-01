local app, module = require('umfal')('ore-sorter');

function module.scanInventory(tr, side)
  local names = {}

  local i = 1;
  for stack in tr.getAllStacks(side) do
    if stack.label then
      names[i] = stack.label;
    end
    i = i + 1;
  end

  return names;
end

function module.freeSlots(scanResult)
  local freeSlots = {};

  for i = 1, 27 do
    if not scanResult[i] then
      table.insert(freeSlots, i);
    end
  end

  return freeSlots;
end

function module.getAnyItem(scanResult)
  for slot, name in pairs(scanResult) do
    return slot, name
  end

  return nil
end