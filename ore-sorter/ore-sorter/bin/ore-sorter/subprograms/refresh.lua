local app = require('umfal')('ore-sorter');

return function(args, ops, context)
  app.filterMap.refreshFromFiles();
  print('Filters refreshed from files');
end