local app  = require('umfal')('ore-sorter');
local term = require('term');
local cli  = app.utils.cli;
local tr   = app.items.transposers;

return function(args, ops, runtimeData)
  term.clear();
  cli.printBanner('ORE-SORTER SETUP WIZARD');
  print('This program will take you through all');
  print('the steps necessary to set up the');
  print('ore sorting system');
  print('')
  print('Press Enter to proceed to the first');
  print('step of the setup, or press Q and then');
  print('Enter to quit the wizard');

  if not cli.getConfirmationOrExit('Proceed?', true) then
    cli.fancyExit(false);
    return;
  end
  -- Step 1;
  local allTransposers = tr.getAllTransposers();

  term.clear();
  cli.printBanner('STEP 1: MAPPING THE SETUP');
  print('At this step, an internal "map" will be');
  print('created to allow the system to route');
  print('items between inventories');
  print('');
  print('Computer has ' .. #allTransposers .. ' transposer(s) connected');
  print('');
  print('To continue, put a single item in the first slot');
  print('of the input buffer, proceed when done');

  if not cli.getConfirmationOrExit('Proceed?', true) then
    cli.fancyExit(false);
    return;
  end
end