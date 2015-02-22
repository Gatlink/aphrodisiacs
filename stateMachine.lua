StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new()
	local new = {}
	new.states = {}
	new.currentState = nil

	setmetatable(new, StateMachine)
	return new
end

function StateMachine:addState(stateName, state)
  self.states[stateName] = state
end

function StateMachine:update(dt)
	self.states[self.currentState]:update(dt)
end

function StateMachine:draw()
	self.states[self.currentState]:draw()
end

function StateMachine:setState(newState)
	if self.currentState ~= nil then
		self.states[self.currentState]:leave()
	end

	self.currentState = newState
	self.states[self.currentState]:enter()
end
