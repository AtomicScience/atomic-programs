local app, module = require('umfal')('ore-sorter');

function module.filenameForColor(color)
  return '/etc/cfg/ore-sorter/filters/'..color..'.txt'
end

function module.fileToFilterMap(color, map)
  local file = io.open(module.filenameForColor(color), 'r');

  for line in file:lines() do
    map[line] = color
  end

  file:close()
end

function module.loadFilterMapFromAllFiles()
  local map = {};
  for color, _ in pairs(app.routing.sendTo) do
    if color == 'black' then goto continue end
    module.fileToFilterMap(color, map);
    ::continue::
  end

  return map;
end

function module.filterMapToFile(color, map)
  local file = io.open(module.filenameForColor(color), 'w');

  for item, itemColor in pairs(map) do
    if itemColor == color then
      file:write(item..'\n');
    end
  end

  file:close();
end

function module.saveFilterMapToAllFiles(map)
  app.utils.forEach(app.routing.sendTo, function(_, color)
    if color == 'black' then return end
    module.filterMapToFile(color, map);    
  end)
end