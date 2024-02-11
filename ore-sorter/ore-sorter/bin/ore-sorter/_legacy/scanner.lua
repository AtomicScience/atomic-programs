local app, module = require('umfal')('ore-sorter');

local sides = require('sides')

function module.scanInput()
  return app.inventory.scanInventory(app.components.sTr, sides.top);
end

function module.scanAndMoveToOutput()
  local input = module.scanInput();

  app.utils.forEach(input, function(_, slot)
    app.components.sTr.transferItem(sides.top, sides.bottom, 64, slot, slot)
  end)

  return input;
end

function module.isOutputEmpty()
  return #app.inventory.scanInventory(app.components.sTr, sides.bottom) == 0;
end

function module.writeItemsToFilterMap(items, color)
  local map = app.filterMap.get();

  app.utils.forEach(items, function(item)
    map[item] = color;
  end)
  
  app.fileMethods.saveFilterMapToAllFiles(map)
end

function module.scanMoveAndWriteToFilterMap(color)
  local input = module.scanAndMoveToOutput();

  module.writeItemsToFilterMap(app.utils.values(input), color);

  app.filterMap.refreshFromFiles();
end