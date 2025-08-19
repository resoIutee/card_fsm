function card.new(board, card_data, initial_container)
	local self = setmetatable({
		model = resources:WaitForChild("card"):Clone(),
		index = nil,
		board = board,
		container = nil,
	}, card)
	
	local events = {
		[self.model.click_detector.MouseHoverEnter] = "mouse_hover_enter",
		[self.model.click_detector.MouseHoverLeave] = "mouse_hover_leave",
		[uis.InputBegan] = "input_began",
		[uis.InputEnded] = "input_ended",
		[uis.InputChanged] = "input_changed",
	}
	
	self.model.click_detector.MouseHoverEnter:Connect(function()
		self.hovering = true
	end)
	
	self.model.click_detector.MouseHoverLeave:Connect(function()
		self.hovering = false
	end)
	
	self.state_machine = state_machine.new(states, events, initial_state)
	
	self.model.Parent = workspace
	self.state_machine:defer_state("hand_idle", {index = 2, total = 5})
	
	return self
end
