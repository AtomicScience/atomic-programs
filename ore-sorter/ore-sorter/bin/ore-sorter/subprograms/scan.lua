local app = require('umfal')('ore-sorter');

return function(args, ops, context)
  if not args[1] then
    print('ERROR: Provide a color')
    return;
  end

  local color = args[1];

  if not app.routing.sendTo[color] then
    print('ERROR: Unknown color');
    return;
  end

  if not app.scanner.isOutputEmpty() then
    print('ERROR: Scanner`s output buffer must be empty');
    return;
  end

  local inputItems = app.scanner.scanInput();

  if #inputItems == 0 then
    print('ERROR: No items in the input buffer');
    return;
  end

  print("Scanned items:")
  app.utils.forEach(inputItems, function(v) print('- '..v) end)
  print('Total amount of '..#inputItems..' will be recorded to the '..color:upper()..' channel.');
  io.write('Confirm writing (y/n): ');

  local input = io.read();

  if input ~= 'y' then
    print('Aborting');
    return;
  end

  print('Scanning...');

  app.scanner.scanMoveAndWriteToFilterMap(color);

  print('Success')
end