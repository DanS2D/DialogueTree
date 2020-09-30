
local M = {
	script = {}
}
M.__index = M

function M:new(providerName)
	local object = {}
	setmetatable(object, self)

	return object
end

function M:addScript()
	local script = {
		currentPos = 0,
		currentBranch = "main",
		characterName = "none",
		selectedOption = nil,
		pauseForInput = false,
		selection = nil,
		branch = {},
	}

	function script:addBranch(key)
		if (self.branch[key] ~= nil) then
			error(("The branch %s already exists!"):format(key))
		end

		self.branch[key] = {}
		self.currentBranch = key
	end

	function script:setBranch(key)
		self.currentBranch = key
	end

	function script:add(options)
		local message = type(options) == "string" and options or options.message
		local menu = type(options) == "table" and options.menu
		local branchTo = type(options) == "table" and options.branchTo

		self.branch[self.currentBranch][#self.branch[self.currentBranch] + 1] = {
			message = message,
			menu = menu,
			branchTo = branchTo
		}

		print(#self.branch[self.currentBranch], "branch:", self.currentBranch)
	end

	function script:characterName(name)
		self.characterName = name
	end

	function script:select(optionNumber)
		if (optionNumber > #self.branch[self.currentBranch][self.currentPos].menu) then
			return
		end

		local currentBranch = self.currentBranch
		self.selection = optionNumber

		if (type(self.branch[self.currentBranch][self.currentPos].branchTo) == "table") then
			self.currentBranch = self.branch[self.currentBranch][self.currentPos].branchTo[self.selection]
		else
			self.currentBranch = self.branch[self.currentBranch][self.currentPos].branchTo
		end

		print("select: branchTo is:", self.currentBranch, "current branch is:", currentBranch)

		if (self.currentBranch ~= currentBranch) then
			print("switching branch")
			self.currentPos = 0
		end

		self.pauseForInput = false
		self.selectedInput = true
	end

	function script:next()
		if (self.pauseForInput) then
			return self.branch[self.currentBranch][self.currentPos]
		end

		if (self.currentPos < #self.branch[self.currentBranch]) then
			local nextBranch = self.currentPos > 0 and self.branch[self.currentBranch][self.currentPos + 1] or nil

			if (nextBranch ~= nil and nextBranch.menu) then
				self.pauseForInput = true
			end

			self.currentPos = self.currentPos + 1

			print(("branch: %s, current pos: %s, num of items: %s, message: %s"):format(self.currentBranch, self.currentPos, #self.branch[self.currentBranch], self.branch[self.currentBranch][self.currentPos].message))

			return self.branch[self.currentBranch][self.currentPos]
		else
			print("END OF BRANCH", self.currentBranch)
			if (self.branch[self.currentBranch][self.currentPos].branchTo) then
				print("message should branch")
				self.currentBranch = self.branch[self.currentBranch][self.currentPos].branchTo
				self.currentPos = 1
				print("setting branch to:", self.currentBranch)

				return self.branch[self.currentBranch][self.currentPos]
			end
		end

		return nil
	end

	function script:reset()
		self.currentPos = 0
		self.currentBranch = "main"
		self.selectedOption = nil
		self.pauseForInput = false
		self.selection = nil
	end

	self.script[#self.script + 1] = script

	return self.script[#self.script]
end

return M
