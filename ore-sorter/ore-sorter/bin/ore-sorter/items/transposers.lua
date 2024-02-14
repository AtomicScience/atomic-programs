local app, transposers = require('umfal')('ore-sorter');
local component = require('component');
local sides = require('sides');

transposers.sides = {
  sides.bottom,
  sides.top,
  sides.north,
  sides.south,
  sides.west,
  sides.east
}

function transposers.getAllTransposers()
  local list = {}

  for address, _ in component.list('transposer') do
    table.insert(list, component.proxy(address))
  end
  
  return list;
end