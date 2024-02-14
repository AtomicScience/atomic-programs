local app, cli = require('umfal')('ore-sorter');
local term = require('term');
local text = require('text');
local computer = require('computer');

function cli.getConfirmation(question, defaultToYes)
  local input = cli.inquire(question, defaultToYes and 'Y' or 'y', 'n');

  if input == '' and defaultToYes then
    return true;
  elseif input == 'y' or input == 'Y' then
    return true
  else
    return false
  end
end

function cli.getConfirmationOrExit(question, defaultToYes)
  term.setCursor(1, 16);

  while true do
    local input = cli.inquire(question, defaultToYes and 'Y' or 'y', 'q');

    term.clearLine();
    if input == '' and defaultToYes then
      cli.positiveBeep();
      return true;
    elseif input == 'y' or input == 'Y' then
      cli.positiveBeep();
      return true;
    elseif input == 'q' then
      cli.negativeBeep();
      return false;
    end

    cli.negativeBeep();
  end
end

function cli.inquire(question, positiveOption, negativeOption)
  local options = table.concat({positiveOption, negativeOption}, '/');
  io.write(string.format('%s (%s): ', question, options));

  -- sub removes a /n at the end
  local input = term.read({dobreak=false}):sub(1, -2);

  return input
end

function cli.fancyExit(actuallyExit)
  print('Exiting...');
  os.sleep(0.5);
  term.clear();
  if actuallyExit then os.exit(); end
end

function cli.printBanner(message)
  local messageWithBorders = '|| ' .. message .. ' ||';
  -- We always assume we have a tier 1 monitor
  local whitespacesNeeded = math.floor((50 - #messageWithBorders) / 2);
  local paddedMessage = text.padLeft(messageWithBorders, #messageWithBorders + whitespacesNeeded);
  print('')
  print(paddedMessage)
  print('')
end

function cli.negativeBeep()
  computer.beep(600, 0.3);
end

function cli.positiveBeep()
  computer.beep(1400, 0.1);
end

function cli.shiftCursorBy(byCol, byRow)
  local col, row = term.getCursor();
  term.setCursor(col + byCol, row + byRow);
end