State = {}
State.__index = State

function State.new(name, parent)
	local new = {}
  new.parent = parent

  setmetatable(new, State)
  parent:addState(name, new)
  return new
end

function State:enter() end
function State:leave() end
function State:update(dt) end
function State:draw() end
