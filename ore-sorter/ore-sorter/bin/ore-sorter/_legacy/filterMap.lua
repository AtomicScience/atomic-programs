local app, module = require('umfal')('ore-sorter');

local filterMap;

function module.get()
  return filterMap;
end

function module.set(newFilterMap)
  filterMap = newFilterMap;
end

function module.refreshFromFiles()
  filterMap = app.fileMethods.loadFilterMapFromAllFiles();
end

module.refreshFromFiles();
-- For some reason, calling module.refresh() breaks lazy module,
-- we have to return it explicitly, I'm too lazy to troubleshoot that
return module;