local widget = require("widget")
local dialogue = require("dialogue")

local newDialogue = dialogue:new()
local script = newDialogue:addScript()
script:addBranch("main")
script:add("Hello world!")
script:add({ message = "How are you today?", menu = {"I'm OK", "Not too good"}, branchTo = {"main", "unwell"} })
script:add({ message = "I'm glad to hear it", branchTo = "ending" })
script:addBranch("unwell")
script:add("I'm sorry to hear that")
script:add("I hope you get better soon.")
script:add({ message = "On a nicer subject... How's the weather today?", menu = {"It's Raining", "It's Sunny", "It's Freezing"}, branchTo = {"unwell", "sunny", "freezing"} })
script:add({ message = "Rain is really annoying, ain't it :/", branchTo = "ending" })
script:addBranch("sunny")
script:add({ message = "I love sunny days!", branchTo = "ending" })
script:addBranch("freezing")
script:add({ message = "Freezing days are so fresh!", branchTo = "ending" })
script:addBranch("ending")
script:add("I've got to go, have a nice day!")
script:setBranch("main")

local textObj = display.newText({
	text = "",
	fontSize = 18,
	align = "center"
})
textObj.x = display.contentCenterX
textObj.y = display.contentCenterY

local function advanceScript()
	local nextLine = script:next()

	if (nextLine ~= nil) then
		textObj.text = nextLine.message

		if (nextLine.menu) then
			textObj.text = textObj.text .. "\n\n" .. table.concat(nextLine.menu, "\n")
		end
	else
		textObj.text = "<Script finished>"
	end

	return true
end

local resetButton = widget.newButton({
	label = "Reset Script",
	fontSize = 24,
	width = 100,
	height = 40,
	onPress = function(event)
		textObj.text = ""
		script:reset()
		advanceScript()
	end
})
resetButton.x = 180
resetButton.y = 40

local function onKeyEvent(event)
	local keyName = event.keyName
	local phase = event.phase

	--print(keyName)

	if (phase == "up") then
		if (keyName:lower() == "enter") then
			advanceScript()
		end

		if (script.pauseForInput) then
			if (keyName:lower() == "numpad1") then
				script:select(1)
				advanceScript()
			elseif (keyName:lower() == "numpad2") then
				script:select(2)
				advanceScript()
			elseif (keyName:lower() == "numpad3") then
				script:select(3)
				advanceScript()
			elseif (keyName:lower() == "numpad4") then
				script:select(4)
				advanceScript()
			elseif (keyName:lower() == "numpad5") then
				script:select(5)
				advanceScript()
			end
		end
	end

	return true
end

Runtime:addEventListener("key", onKeyEvent)
advanceScript()
