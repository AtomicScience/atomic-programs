local app, module = require('umfal')('ore-sorter');
local term = require('term');
local cli  = app.utils.cli;

module.showStep = function()
  cli.clear();
  cli.printBanner('ORE-SORTER SETUP WIZARD');
  print('This program will take you through all');
  print('the steps necessary to set up the system');
  print('')
  print('Press Enter to proceed to the first');
  print('step of the setup, or press Q and then');
  print('Enter to quit the wizard');
  print('')
  print('Need help? Feel free to ask for help in');
  print('#opencomputers-help at the GTNH Discord');
  print('Found a bug? Please, file the issue at');
  print('the project\'s GitHub repo!');

  if not cli.getConfirmationOrExit('Proceed?', true) then
    cli.fancyExit();
    return false;
  end

  return true
end