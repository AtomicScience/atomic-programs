--[[ UMFAL - Unified Multi-File Applications Loader
     Should be placed in /lib
	 Author - AtomicScience
]]
local filesystem = require("filesystem")
local unicode = require("unicode")

local umfal
-----------------------
-- Metatable functions
-----------------------
local function getBlankUmfalWithMeta()
    local umfal = {}
    umfal.applicationFunctions = {}
    umfal.appCache = {}

    local metatable = {}
    function metatable.__call(self, appID)
        local fetchedApplication = self.appCache[appID]

        if not fetchedApplication then
            error("Application " .. appID .. " was not initialized")
        end

        fetchedApplication.lastLazyModule = {}

        return fetchedApplication, fetchedApplication.lastLazyModule
    end

    setmetatable(umfal, metatable)

    return umfal
end

local function getBlankApplicationWithMeta(appID, path)
    local blankApplication = {}
    blankApplication.id = appID
    blankApplication.path = path

    for methodName, method in pairs(umfal.applicationFunctions) do
        blankApplication[methodName] = method
    end

    local metatable = {}

    metatable.__index = function (application, nodeName)
        local node = application:loadNode({nodeName})

        blankApplication[nodeName] = node

        return node
    end

    setmetatable(blankApplication, metatable)


    return blankApplication
end
-----------------------
-- Library functions
-----------------------
umfal = getBlankUmfalWithMeta()

function umfal.initAppFromAbsolute(appID, path)
    local application = getBlankApplicationWithMeta(appID, path)

    if not umfal.applicationFolderExists(path) then
        error("Failed to find an application " .. appID .. " on path " .. path)
    end

    umfal.appCache[appID] = application

    return application
end

function umfal.initAppFromRelative(appID, levelDelta)
    if appID == nil then
        error("Application ID must be provided")
    end
    levelDelta = levelDelta or 1

    local pathToRunningScript = umfal.getPathToRunningScript()

    local resolvedPath = umfal.resolveRelativePath(pathToRunningScript, levelDelta)

    return umfal.initAppFromAbsolute(appID, resolvedPath)
end

-----------------------
-- File functions
-----------------------
-- Function was copied from MineOS' System library
function umfal.getPathToRunningScript()
    local info
    for runLevel = 0, math.huge do
        info = debug.getinfo(runLevel)
        if info then
            if info.what == "main" then
                return info.source:sub(2, -1)
            end
        else
            error("Failed to get debug info for runlevel " .. runLevel)
        end
    end
end

function umfal.resolveRelativePath(path, levelDelta)
    return umfal.concat(path, string.rep("/..", levelDelta))
end

-----
-- File checking functions
-----
function umfal.applicationFolderExists(path)
    return filesystem.isDirectory(path)
end

-- Three functions below are just a copy from OpenOS's Filesystem API
-- They are brought here because MineOS doesn't have them
local function segments(path)
    local parts = {}
    for part in path:gmatch("[^\\/]+") do
      local current, up = part:find("^%.?%.$")
      if current then
        if up == 2 then
          table.remove(parts)
        end
      else
        table.insert(parts, part)
      end
    end
    return parts
end

function umfal.canonical(path)
    local result = table.concat(segments(path), "/")
    if unicode.sub(path, 1, 1) == "/" then
      return "/" .. result
    else
      return result
    end
end

function umfal.concat(...)
    local set = table.pack(...)
    for index, value in ipairs(set) do
      checkArg(index, value, "string")
    end
    return umfal.canonical(table.concat(set, "/"))
end
-----------------------
-- Application functions
-----------------------

-- Public:
function umfal.applicationFunctions:attemptToLoadModule(parentFolder, moduleName)
    if parentFolder == self then
        parentFolder = self:getEmptyFolder({})
    end

    if not self:nodeIsFolder(parentFolder.node) then
        return nil, "parent node is not valid"
    end

    if moduleName == nil then
        error("Module name was not provided!")
    end

    local pathToModule = self:appendToNode(parentFolder.node, moduleName)

    if not self:nodeIsLuaScript(pathToModule) then
        return nil
    end

    return self:loadNode(pathToModule)
end
-- Private:
function umfal.applicationFunctions:nodeIsFolder(node)
    local pathToNode = self:resolvePathToNodeAsFolder(node)

    return filesystem.isDirectory(pathToNode)
end

function umfal.applicationFunctions:nodeIsLuaScript(node)
    local pathToNode = self:resolvePathToNodeAsModule(node)

    return filesystem.exists(pathToNode) and not filesystem.isDirectory(pathToNode)
end

function umfal.applicationFunctions:nodeIsValid(node)
    local isModule = self:nodeIsLuaScript(node)
    local isFolder = self:nodeIsFolder(node)

    return isModule or isFolder
end

function umfal.applicationFunctions:resolvePathToNodeAsFolder(node)
    local relativePath = self:nodeToRelativePath(node)

    return umfal.concat(self.path, relativePath)
end

function umfal.applicationFunctions:resolvePathToNodeAsModule(node)
    return self:resolvePathToNodeAsFolder(node) .. ".lua"
end

-- {one, two, three} -> "one/two/three"
function umfal.applicationFunctions:nodeToRelativePath(node)
    return table.concat(node, "/")
end

function umfal.applicationFunctions:loadNode(node)
    local loadedNode, reason = self:attemptToLoadNode(node)

    if not loadedNode then
        local nodeName = node[#node]
        error("Failed to load node `" .. nodeName .. "`: " .. reason)
    end

    return loadedNode
end

function umfal.applicationFunctions:attemptToLoadNode(node)
    if not self:nodeIsValid(node) then
        return nil, "file or folder does not exist"
    end

    if self:nodeIsFolder(node) then
        return self:getEmptyFolder(node), nil
    elseif self:nodeIsLuaScript(node) then
        return self:loadModule(node), nil
    end
end

function umfal.applicationFunctions:getEmptyFolder(node)
    local emptyFolder = {}
    emptyFolder.node = node

    local metatable = {}

    function metatable.__index(folder, nodeName)
        local newNode = self:appendToNode(folder.node, nodeName)
        local loadedNode = self:loadNode(newNode)

        emptyFolder[nodeName] = loadedNode

        return loadedNode
    end

    setmetatable(emptyFolder, metatable)

    return emptyFolder
end

function umfal.applicationFunctions:loadModule(node)
    local pathToModule = self:resolvePathToNodeAsModule(node)

    local loadedModuleReturns = dofile(pathToModule)

    if loadedModuleReturns then
        return loadedModuleReturns
    end

    if self:lastLazyModuleContainsSomething() then
        local lastLazyModule = self.lastLazyModule
        self.lastLazyModule = {}
        return lastLazyModule
    end

    local nodeName = node[#node]
    error("Failed to load module `" .. nodeName .. "`: module returned nil and didn't fill a lazy table")
end

function umfal.applicationFunctions:lastLazyModuleContainsSomething()
    for something in pairs(self.lastLazyModule) do
        return true
    end

    return false
end

function umfal.applicationFunctions:appendToNode(node, nodeName)
    local newNode = {}

    for i = 1, #node do
        newNode[i] = node[i]
    end

    table.insert(newNode, nodeName)

    return newNode
end

return umfal