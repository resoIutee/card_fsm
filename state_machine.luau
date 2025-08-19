local state_machine = {}
state_machine.__index = state_machine

function state_machine.new(states, map, start_state)
	local self = setmetatable({
		start_state = start_state,
		states = states,
	}, state_machine)

	self.current_state = self.states[start_state]
	self.current_state:enter()

	for signal, method in pairs(map) do
		local connection = signal:Connect(function(...)
			local current_state = self.current_state
			current_state[method](current_state, ...)
		end)
	end

	return self
end

function state_machine:defer_state(state_name, data)
	local new_state = self.states[state_name]

	if not new_state then
		warn("no state found for:", state_name)
		return
	end

	if self.currentState then
		self.currentState:exit()
	end

	task.defer(function()
		new_state:enter(data)
	end)

	self.currentState = new_state
	return
end

return state_machine
