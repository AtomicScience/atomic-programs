local app, module = require('umfal')('ore-sorter');

local component = require("component");
local sides = require('sides');

local lTr = app.components.lTr;
local mTr = app.components.mTr;
local tTr = app.components.tTr;
local sTr = app.components.sTr;

module.sendTo = {
  ['red'] = function(sourceSlot, sinkSlot)
    lTr.transferItem(sides.bottom, sides.west, 64, sourceSlot, sinkSlot);
  end,

  ['yellow'] = function(sourceSlot, sinkSlot)
    lTr.transferItem(sides.bottom, sides.north, 64, sourceSlot, sinkSlot);
  end,

  ['blue'] = function(sourceSlot, sinkSlot)
    lTr.transferItem(sides.bottom, sides.east, 64, sourceSlot, sinkSlot);
  end,

  ['orange'] = function(sourceSlot, sinkSlot)
    lTr.transferItem(sides.bottom, sides.top, 64, sourceSlot, 1);
    mTr.transferItem(sides.bottom, sides.west, 64, 1, sinkSlot);
  end,

  ['gray'] = function(sourceSlot, sinkSlot)
    lTr.transferItem(sides.bottom, sides.top, 64, sourceSlot, 1);
    mTr.transferItem(sides.bottom, sides.north, 64, 1, sinkSlot);
  end,

  ['pink'] = function(sourceSlot, sinkSlot)
    lTr.transferItem(sides.bottom, sides.top, 64, sourceSlot, 1);
    mTr.transferItem(sides.bottom, sides.east, 64, 1, sinkSlot);
  end,

  ['white'] = function(sourceSlot, sinkSlot)
    lTr.transferItem(sides.bottom, sides.top, 64, sourceSlot, 1);
    mTr.transferItem(sides.bottom, sides.top, 64, 1, 1);
    tTr.transferItem(sides.bottom, sides.west, 64, 1, sinkSlot);
  end,

  ['black'] = function(sourceSlot, sinkSlot)
    lTr.transferItem(sides.bottom, sides.top, 64, sourceSlot, 1);
    mTr.transferItem(sides.bottom, sides.top, 64, 1, 1);
    tTr.transferItem(sides.bottom, sides.east, 64, 1, sinkSlot);
  end,
}

module.hasFreeSlot = {
  ['red'] = function()
    return not lTr.getStackInSlot(sides.west, 27);
  end,

  ['yellow'] = function()
    return not lTr.getStackInSlot(sides.north, 27);
  end,

  ['blue'] = function()
    return not lTr.getStackInSlot(sides.east, 27);
  end,

  ['orange'] = function()
    return not mTr.getStackInSlot(sides.west, 27);
  end,

  ['gray'] = function()
    return not mTr.getStackInSlot(sides.north, 27);
  end,

  ['pink'] = function()
    return not mTr.getStackInSlot(sides.east, 27);
  end,

  ['white'] = function()
    return not tTr.getStackInSlot(sides.west, 27);
  end,

  ['black'] = function()
    return not tTr.getStackInSlot(sides.east, 27);
  end,
}

function module.inputItemNameAt(slot)
  local stack = lTr.getStackInSlot(sides.bottom, slot);

  if not stack then
    return nil;
  else
    return stack.label;
  end
end

function module.inputSize()
  return lTr.getInventorySize(sides.bottom);
end

-- Lazy module doesn't work for some reason
return module