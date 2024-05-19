local app  = require('umfal')('ore-sorter');
local term = require('term');
local cli  = app.utils.cli;
local tr   = app.items.transposers;
local steps = app.subprograms.wizard.steps;

local function showStep1(allTransposers)
  cli.clear();
  cli.printBanner('STEP 1: MAPPING THE SETUP');
  print('At this step, an internal "map" will be');
  print('created to allow the system to route');
  print('items between inventories');
  print('');
  print('Computer has ' .. #allTransposers .. ' transposer(s) connected');
  print('');
  print('To continue, put a single item in the first slot');
  print('of the input buffer, proceed when done');
  print('')
  print('Other connected inventories should be EMPTY')
end

local function showStep1TooManyItemsError()
  cli.clear();
  cli.printBanner('ERROR: TOO MANY ITEMS');
  print('One of the connected inventories has');
  print('too many items in it');
  print('');
  print('Remove all the items except for one');
  print('in the input buffer, then proceed');
end

local function showStep1TooManyInventories()
  cli.clear();
  cli.printBanner('ERROR: TOO MANY INVENTORIES');
  print('There are more than one inventory');
  print('with items');
  print('');
  print('Remove all the items except for one');
  print('in the input buffer, then proceed');
end

return function(args, ops, context)
  local shouldContinue;
  
  shouldContinue = steps.intro.showStep();
  if not shouldContinue then return end;
  -- Step 1;
  local completedStep1 = false;
  local allTransposers = tr.getAllTransposers();

  repeat 
    showStep1(allTransposers);

    ::confirmation::
    if not cli.getConfirmationOrExit('Proceed?', true) then
      cli.fancyExit(false);
      return;
    end

    local foundTransposer = nil;
    local foundSide       = nil;

    for i, transposer in pairs(allTransposers) do
      print('Searching for items in transposer #' .. i);

      for j, side in pairs(tr.sides) do
        io.write('#' .. i .. ' - Checking side ' .. j .. '...    ');

        local itemsIterator = transposer.getAllStacks(side);

        local foundItems = 0;

        if not itemsIterator then
          print('No inventory');
        else
          local slot = 1;
          io.write('Slot #')
          for item in itemsIterator do
            os.sleep(0.05);
            io.write((slot < 10 and '0' or '') .. slot);
            slot = slot + 1;
            cli.shiftCursorBy(-2, 0);
            if item.label then
              foundItems = foundItems + 1;
            end
          end

          cli.shiftCursorBy(-6, 0);

          if foundItems == 0 then
            print('Empty inventory');
          elseif foundItems > 1 then
            showStep1TooManyItemsError();
            goto confirmation;
          elseif foundItems == 1 then
            if foundI or foundJ then
              showStep1TooManyInventories();
              goto confirmation;
            else
              print('Candidate found!');
              foundTransposer = transposer;
              foundSide = side;
            end
          end
        end
      end
    end
  until completedStep1;
end