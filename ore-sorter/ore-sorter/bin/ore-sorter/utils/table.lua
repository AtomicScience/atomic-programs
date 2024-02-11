local module = {};

function module.values(tbl)
  local values = {};
  for _, v in pairs(tbl) do
    table.insert(values, v);
  end
  return values;
end

function module.keys(tbl)
  local keys = {};
  for k,_v in pairs(tbl) do
    table.insert(keys, k);
  end
  return keys;
end

function module.forEach(tbl, callback)
  for k, v in pairs(tbl) do
    callback(v, k);
  end
end

function module.map(tbl, callback)
  local newTable = {}

  for k, v in pairs(tbl) do
    newTable[k] = callback(v, k);
  end

  return newTable;
end

return module;