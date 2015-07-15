--[[
    ui_buildPoker
    完成牌谱
	created:haily
]]
require "ui_buildPoker_obj"
local all_node
local priority
local button_clicked_list = {
	retrunClicked = function ()
		G_UI_Manger.GFN_CloseUI()
	end,

	doneClicked = function ()
		print("牌谱完成")
		
		pokerData.pokerInfo.time = os.time()
		-- dump(pokerData, "pokerData", 5)
		UserInfo:addPoker(pokerData)
	 	G_UI_Manger.GFN_ReturnUI("login")
	 	G_UI_Manger.G_Func_showUI("pokerList", 2)
	end
}

local costValue = 0

local index1 = 1
local index2 = 1
local index3 = 1

local index4 = 1

local function getLastAction(index, group)

	local steps = pokerData.steps[group]
	if not steps then return nil end

	local action = nil
	for i=1, #steps do
		local stepInfo = steps[#steps - i + 1]
		if stepInfo.index == index then
			return stepInfo.action
		end
	end
	return getLastAction(index, actionName[group].back)
end

local sbArray = {}

local function getNoPassPlayer(group, index)

	local sbIndex
	for i,v in ipairs(sbArray) do
		if v == index then
			sbIndex = i
		end
	end

	for i= 1, #sbArray do
		local idx = sbIndex + i
		if idx > #sbArray then idx = idx - #sbArray end
		local player = pokerData.usersInfo[idx]
		local lastAction = getLastAction(player.sb, group)
		if lastAction ~= "fold" then return player end
	end
end

local function getPlayerByIndex(index)
	for ___,playerInfo in pairs(pokerData.usersInfo) do
		if playerInfo.sb == index then return playerInfo end
	end
end

local function scroPerFlop_onCellCreated( state, pSender )
	local scrollView = tolua.cast(pSender, "")
	local function drawCell( cell )
		cell:removeAllChildrenWithCleanup(true)
		local index = cell:getIdx() + 1
		local stepInfo = pokerData["steps"]["scroPerFlop"][index]
		if not stepInfo then
			--新建按钮
			local spritenormal = CCScale9Sprite:create("tianjiadongzuo.png")
			local spritepressed = CCScale9Sprite:create("tianjiadongzuo.png")
			spritepressed:setColor(ccc3(150,150,150))
			local spritedisable = CCScale9Sprite:create("tianjiadongzuo.png")

			local button = CCControlButton:create(spritenormal)
			button:setBackgroundSpriteForState(spritepressed,CCControlStateHighlighted)
			button:setBackgroundSpriteForState(spritedisable,CCControlStateDisabled)

			button:setPreferredSize(CCSizeMake(100, 21))
			button:setPosition(ccp(288, 15))
			button:setTouchPriority(priority)
			local function addButtonClicked()
				--获取最后一个人的操作
				local stepInfo = {}
				if #pokerData.steps.scroPerFlop == 0 then
					--大盲操作
					stepInfo["index"] = 3
					stepInfo["action"] = "call"
					stepInfo["jetton"] = pokerData.pokerInfo.level
					costValue = pokerData.pokerInfo.level
				else
					--其他操作
					local lastStepInfo = pokerData.steps.scroPerFlop[#pokerData.steps.scroPerFlop]
					local nextPlayer = getNoPassPlayer("scroPerFlop", lastStepInfo.index)
					if not nextPlayer or nextPlayer.sb == lastStepInfo.index then return end
					
					local jetton = costValue

					stepInfo["jetton"] = jetton
					stepInfo["index"] = nextPlayer.sb
					stepInfo["action"] = "call"

					index1 = index1 + 1
				end
				
				table.insert(pokerData.steps.scroPerFlop, stepInfo)

				local count = #pokerData.steps.scroPerFlop + 1
				all_node.scroPerFlop:initWithCellCount(count)
				if count > 2 then
					all_node.scroPerFlop:setContentOffset(ccp (0, 0))
				end
				
			end
			button:addHandleOfControlEvent(addButtonClicked, CCControlEventTouchUpInside)

			cell:addChild(button)
			return
		end
		dump(stepInfo, "stepInfo")
		local cellLayer, childen = ReaderStudioJson("buildCell.json")
		--动作名称 actionLabel
		local actionLabel = childen.actionLabel
		actionLabel = tolua.cast(actionLabel, "CCLabelTTF")
		actionLabel:setString(string.format("动作%02d",index))

		--玩家名称 userName
		local userName = childen.userName
		userName = tolua.cast(userName, "CCLabelTTF")

		userName:setString(getPlayerByIndex(stepInfo.index).name)

		local raise = childen.raise
		raise = tolua.cast(raise, "CCEditBox")

		--fold checkfold 放弃继续牌局的机会
		local function foldClicked()
			print("选择fold")
			stepInfo.action = "fold"
			stepInfo["jetton"] = 0
			raise:setText("raise")

		end
		local checkfold = childen.checkfold
		checkfold = tolua.cast(checkfold, "CCControlCheckBox")
		checkfold:setTouchPriority(priority)
		checkfold:addHandleOfControlEvent(foldClicked, CCControlEventTouchUpInside)

		--check checkcheck 在无人下注的情况下选择把决定“让”给下一位
		local function checkClicked()
			print("选择check")
			stepInfo.action = "check"

			stepInfo["jetton"] = 0
			raise:setText("raise")
		end
		local checkcheck = childen.checkcheck
		checkcheck = tolua.cast(checkcheck, "CCControlCheckBox")
		checkcheck:setTouchPriority(priority)
		checkcheck:addHandleOfControlEvent(checkClicked, CCControlEventTouchUpInside)

		--call checkcall 跟随众人押上同等的注额
		local function callClicked()
			print("选择call")
			stepInfo.action = "call"
			raise:setText("raise")
			stepInfo["jetton"] = costValue
		end
		local checkcall = childen.checkcall
		checkcall = tolua.cast(checkcall, "CCControlCheckBox")
		checkcall:setTouchPriority(priority)
		checkcall:addHandleOfControlEvent(callClicked, CCControlEventTouchUpInside)

		--raise raise 把现有的注金抬高

		--保存
		local function saveButtonClicked()
			if raise:getText() and tonumber(raise:getText()) then
				costValue = tonumber(raise:getText())
				if stepInfo.action ~= "raise" then
					childen["check" .. stepInfo.action]:setSelected(false)
				end

				stepInfo.action = "raise"
				stepInfo["jetton"] = jetton

			end
		end

		local function boxHandler(EventName, eSender)
			local e = tolua.cast(eSender, "CCEditBox")
			if EventName == "began" then
				print(e:getText())
			elseif EventName == "ended" then
				print(e:getText())
				if e:getText() and tonumber(e:getText()) then
					saveButtonClicked()
				end
			elseif EventName == "return" then
				print(e:getText())
			elseif EventName == "changed" then
				print(e:getText())
			end
		end
		raise:setTouchPriority(priority)
		raise:registerScriptEditBoxHandler(boxHandler);

		if stepInfo.action ~= "raise" then
			childen["check" .. stepInfo.action]:setSelected(true)
		else
			raise:setText(stepInfo.jetton)
		end

		checkfold:setEnabled(index1 == index)
		checkcheck:setEnabled(index1 == index)
		checkcall:setEnabled(index1 == index)
		raise:setEnabled(index1 == index)
		local saveButton = childen.saveButton
		saveButton = tolua.cast(saveButton, "CCControlButton")
		saveButton:setTouchPriority(priority)
		saveButton:addHandleOfControlEvent(saveButtonClicked, CCControlEventTouchUpInside)
		cell:addChild(cellLayer)
    end
	local pCellbag = tolua.cast(pSender, "CCMultiColumnTableViewCell")
	drawCell(pCellbag)
end

local function scroFlop_onCellCreated( state, pSender )
	local scrollView = tolua.cast(pSender, "")
	local function drawCell( cell )
		cell:removeAllChildrenWithCleanup(true)
		local index = cell:getIdx() + 1
		local stepInfo = pokerData["steps"]["scroFlop"][index]
		if not stepInfo then
			--新建按钮
			local spritenormal = CCScale9Sprite:create("tianjiadongzuo.png")
			local spritepressed = CCScale9Sprite:create("tianjiadongzuo.png")
			spritepressed:setColor(ccc3(150,150,150))
			local spritedisable = CCScale9Sprite:create("tianjiadongzuo.png")

			local button = CCControlButton:create(spritenormal)
			button:setBackgroundSpriteForState(spritepressed,CCControlStateHighlighted)
			button:setBackgroundSpriteForState(spritedisable,CCControlStateDisabled)

			button:setPreferredSize(CCSizeMake(100, 21))
			button:setPosition(ccp(288, 15))
			button:setTouchPriority(priority)
			local function addButtonClicked()
				--获取最后一个人的操作
				stepInfo = {}
				if #pokerData.steps.scroFlop == 0 then
					local nextPlayer = getNoPassPlayer("scroFlop", 1)
					if not nextPlayer then return end
					stepInfo["index"] = nextPlayer.sb
					stepInfo["action"] = "call"
					stepInfo["jetton"] = 0
					costValue = 0
					
				else
					--其他操作
					local lastStepInfo = pokerData.steps.scroFlop[#pokerData.steps.scroFlop]
					local nextPlayer = getNoPassPlayer("scroFlop" ,lastStepInfo.index)
					if not nextPlayer or nextPlayer.sb == lastStepInfo.index then return end

					stepInfo["jetton"] = costValue
					stepInfo["index"] = nextPlayer.sb
					stepInfo["action"] = "call"

					index2 = index2 + 1
				end

				table.insert(pokerData.steps.scroFlop, stepInfo)

				local count = #pokerData.steps.scroFlop

				all_node.scroFlop:initWithCellCount(count + 1)
				if count > 2 then
					all_node.scroFlop:setContentOffset(ccp (0, 0))
				end
				
			end
			button:addHandleOfControlEvent(addButtonClicked, CCControlEventTouchUpInside)

			cell:addChild(button)
			return
		end


		local cellLayer, childen = ReaderStudioJson("buildCell.json")
		--动作名称 actionLabel
		local actionLabel = childen.actionLabel
		actionLabel = tolua.cast(actionLabel, "CCLabelTTF")
		actionLabel:setString(string.format("动作%02d",index))

		--玩家名称 userName
		local userName = childen.userName
		userName = tolua.cast(userName, "CCLabelTTF")
		userName:setString(getPlayerByIndex(stepInfo.index).name)

		local raise = childen.raise
		raise = tolua.cast(raise, "CCEditBox")

		--fold checkfold 放弃继续牌局的机会
		local function foldClicked()
			print("选择fold")
			stepInfo.action = "fold"
			stepInfo["jetton"] = 0
			raise:setText("raise")
		end
		local checkfold = childen.checkfold
		checkfold = tolua.cast(checkfold, "CCControlCheckBox")
		checkfold:setTouchPriority(priority)
		checkfold:addHandleOfControlEvent(foldClicked, CCControlEventTouchUpInside)

		--check checkcheck 在无人下注的情况下选择把决定“让”给下一位
		local function checkClicked()
			print("选择check")
			stepInfo.action = "check"
			stepInfo["jetton"] = 0
			raise:setText("raise")
		end
		local checkcheck = childen.checkcheck
		checkcheck = tolua.cast(checkcheck, "CCControlCheckBox")
		checkcheck:setTouchPriority(priority)
		checkcheck:addHandleOfControlEvent(checkClicked, CCControlEventTouchUpInside)

		--call checkcall 跟随众人押上同等的注额
		local function callClicked()
			print("选择call")
			stepInfo.action = "call"
			raise:setText("raise")
			stepInfo["jetton"] = costValue
		end
		local checkcall = childen.checkcall
		checkcall = tolua.cast(checkcall, "CCControlCheckBox")
		checkcall:setTouchPriority(priority)
		checkcall:addHandleOfControlEvent(callClicked, CCControlEventTouchUpInside)

		--raise raise 把现有的注金抬高

		--保存
		local function saveButtonClicked()
			if raise:getText() and tonumber(raise:getText()) then
				costValue = tonumber(raise:getText())
				if stepInfo.action ~= "raise" then
					childen["check" .. stepInfo.action]:setSelected(false)
				end
				stepInfo.action = "raise"
				
				stepInfo["jetton"] = costValue

			end
		end

		local function boxHandler(EventName, eSender)
			local e = tolua.cast(eSender, "CCEditBox")
			if EventName == "began" then
				print(e:getText())
			elseif EventName == "ended" then
				print(e:getText())
				if e:getText() and tonumber(e:getText()) then
					saveButtonClicked()
				end
			elseif EventName == "return" then
				print(e:getText())
			elseif EventName == "changed" then
				print(e:getText())
			end
		end
		raise:setTouchPriority(priority)
		raise:registerScriptEditBoxHandler(boxHandler);
		if stepInfo.action ~= "raise" then
			childen["check" .. stepInfo.action]:setSelected(true)
		else
			raise:setText(stepInfo.jetton)
		end

		checkfold:setEnabled(index2 == index )
		checkcheck:setEnabled(index2 == index)
		checkcall:setEnabled(index2 == index)
		raise:setEnabled(index2 == index)
		local saveButton = childen.saveButton
		saveButton = tolua.cast(saveButton, "CCControlButton")
		saveButton:setTouchPriority(priority)
		saveButton:addHandleOfControlEvent(saveButtonClicked, CCControlEventTouchUpInside)
		cell:addChild(cellLayer)
    end
	local pCellbag = tolua.cast(pSender, "CCMultiColumnTableViewCell")
	drawCell(pCellbag)
end

local function scrolTurn_onCellCreated( state, pSender )
	local scrollView = tolua.cast(pSender, "")
	local function drawCell( cell )
		cell:removeAllChildrenWithCleanup(true)
		local index = cell:getIdx() + 1
		local stepInfo = pokerData["steps"]["scrolTurn"][index]
		if not stepInfo then
			--新建按钮
			local spritenormal = CCScale9Sprite:create("tianjiadongzuo.png")
			local spritepressed = CCScale9Sprite:create("tianjiadongzuo.png")
			spritepressed:setColor(ccc3(150,150,150))
			local spritedisable = CCScale9Sprite:create("tianjiadongzuo.png")

			local button = CCControlButton:create(spritenormal)
			button:setBackgroundSpriteForState(spritepressed,CCControlStateHighlighted)
			button:setBackgroundSpriteForState(spritedisable,CCControlStateDisabled)

			button:setPreferredSize(CCSizeMake(100, 21))
			button:setPosition(ccp(288, 15))
			button:setTouchPriority(priority)
			local function addButtonClicked()
				--获取最后一个人的操作
				local stepInfo = {}
				if #pokerData.steps.scrolTurn == 0 then
					--大盲操作

					local nextPlayer = getNoPassPlayer("scrolTurn" , 1)
					if not nextPlayer then return end

					stepInfo["action"] = "call"
					stepInfo["jetton"] = 0
					stepInfo["index"] = nextPlayer.sb
					costValue = 0
				else
					--其他操作
					local lastStepInfo = pokerData.steps.scrolTurn[#pokerData.steps.scrolTurn]
					local nextPlayer = getNoPassPlayer("scrolTurn" ,lastStepInfo.index)
					if not nextPlayer or nextPlayer.sb == lastStepInfo.index then return end
					stepInfo["jetton"] = costValue
					stepInfo["index"] = nextPlayer.sb
					stepInfo["action"] = "call"
					index3 = index3 + 1
				end

				table.insert(pokerData.steps.scrolTurn, stepInfo)

				local count = #pokerData.steps.scrolTurn + 1

				all_node.scrolTurn:initWithCellCount(count)
				if count > 2 then
					all_node.scrolTurn:setContentOffset(ccp (0, 0))
				end
				
			end
			button:addHandleOfControlEvent(addButtonClicked, CCControlEventTouchUpInside)

			cell:addChild(button)
			return
		end

		local cellLayer, childen = ReaderStudioJson("buildCell.json")
		--动作名称 actionLabel
		local actionLabel = childen.actionLabel
		actionLabel = tolua.cast(actionLabel, "CCLabelTTF")
		actionLabel:setString(string.format("动作%02d",index))

		--玩家名称 userName
		local userName = childen.userName
		userName = tolua.cast(userName, "CCLabelTTF")
		userName:setString(getPlayerByIndex(stepInfo.index).name)

		local raise = childen.raise
		raise = tolua.cast(raise, "CCEditBox")

		--fold checkfold 放弃继续牌局的机会
		local function foldClicked()
			stepInfo.action = "fold"
			stepInfo["jetton"] = 0
			raise:setText("raise")
		end
		local checkfold = childen.checkfold
		checkfold = tolua.cast(checkfold, "CCControlCheckBox")
		checkfold:setTouchPriority(priority)
		checkfold:addHandleOfControlEvent(foldClicked, CCControlEventTouchUpInside)

		--check checkcheck 在无人下注的情况下选择把决定“让”给下一位
		local function checkClicked()
			stepInfo.action = "check"
			stepInfo["jetton"] = 0
			raise:setText("raise")
		end
		local checkcheck = childen.checkcheck
		checkcheck = tolua.cast(checkcheck, "CCControlCheckBox")
		checkcheck:setTouchPriority(priority)
		checkcheck:addHandleOfControlEvent(checkClicked, CCControlEventTouchUpInside)

		--call checkcall 跟随众人押上同等的注额
		local function callClicked()
			stepInfo.action = "call"			
			raise:setText("raise")
			stepInfo["jetton"] = costValue
		end
		local checkcall = childen.checkcall
		checkcall = tolua.cast(checkcall, "CCControlCheckBox")
		checkcall:setTouchPriority(priority)
		checkcall:addHandleOfControlEvent(callClicked, CCControlEventTouchUpInside)

		--raise raise 把现有的注金抬高

		--保存
		local function saveButtonClicked()
			if raise:getText() and tonumber(raise:getText()) then
				costValue = tonumber(raise:getText())
				if stepInfo.action ~= "raise" then
					childen["check" .. stepInfo.action]:setSelected(false)
				end

				stepInfo.action = "raise"
				stepInfo["jetton"] = costValue
			end
		end

		local function boxHandler(EventName, eSender)
			local e = tolua.cast(eSender, "CCEditBox")
			if EventName == "began" then
				print(e:getText())
			elseif EventName == "ended" then
				print(e:getText())
				if e:getText() and tonumber(e:getText()) then
					saveButtonClicked()
				end
			elseif EventName == "return" then
				print(e:getText())
			elseif EventName == "changed" then
				print(e:getText())
			end
		end
		raise:setTouchPriority(priority)
		raise:registerScriptEditBoxHandler(boxHandler);

		if stepInfo.action ~= "raise" then
			childen["check" .. stepInfo.action]:setSelected(true)
		else
			raise:setText(stepInfo.jetton)
		end

		checkfold:setEnabled(index3 == index)
		checkcheck:setEnabled(index3 == index)
		checkcall:setEnabled(index3 == index)
		raise:setEnabled(index3 == index)
		local saveButton = childen.saveButton
		saveButton = tolua.cast(saveButton, "CCControlButton")
		saveButton:setTouchPriority(priority)
		saveButton:addHandleOfControlEvent(saveButtonClicked, CCControlEventTouchUpInside)
		cell:addChild(cellLayer)
    end
	local pCellbag = tolua.cast(pSender, "CCMultiColumnTableViewCell")
	drawCell(pCellbag)
end

local function scroRiver_onCellCreated( state, pSender )
	local scrollView = tolua.cast(pSender, "")
	local function drawCell( cell )
		cell:removeAllChildrenWithCleanup(true)
		local index = cell:getIdx() + 1
		local stepInfo = pokerData["steps"]["scroRiver"][index]
		if not stepInfo then
			--新建按钮
			local spritenormal = CCScale9Sprite:create("tianjiadongzuo.png")
			local spritepressed = CCScale9Sprite:create("tianjiadongzuo.png")
			spritepressed:setColor(ccc3(150,150,150))
			local spritedisable = CCScale9Sprite:create("tianjiadongzuo.png")

			local button = CCControlButton:create(spritenormal)
			button:setBackgroundSpriteForState(spritepressed,CCControlStateHighlighted)
			button:setBackgroundSpriteForState(spritedisable,CCControlStateDisabled)

			button:setPreferredSize(CCSizeMake(100, 21))
			button:setPosition(ccp(288, 15))
			button:setTouchPriority(priority)
			local function addButtonClicked()
				--获取最后一个人的操作
				local stepInfo = {}
				if #pokerData.steps.scroRiver == 0 then
					--大盲操作
					local nextPlayer = getNoPassPlayer("scroRiver" , 1)
					if not nextPlayer then return end

					stepInfo["index"] = nextPlayer.sb
					stepInfo["action"] = "call"
					stepInfo["jetton"] = 0
					costValue = 0
				else
					--其他操作
					local lastStepInfo = pokerData.steps.scroRiver[#pokerData.steps.scroRiver]
					local nextPlayer = getNoPassPlayer("scroPerFlop", lastStepInfo.index)
					if not nextPlayer or nextPlayer.sb == lastStepInfo.index then return end

					stepInfo["jetton"] = costValue
					stepInfo["index"] = nextPlayer.sb
					stepInfo["action"] = "call"
					index4 = index4 + 1
				end

				table.insert(pokerData.steps.scroRiver, stepInfo)

				local count = #pokerData.steps.scroRiver + 1
				all_node.scroRiver:initWithCellCount(count)
				if count > 2 then
					all_node.scroRiver:setContentOffset(ccp (0, 0))
				end
				
			end
			button:addHandleOfControlEvent(addButtonClicked, CCControlEventTouchUpInside)

			cell:addChild(button)
			return
		end

		local cellLayer, childen = ReaderStudioJson("buildCell.json")
		--动作名称 actionLabel
		local actionLabel = childen.actionLabel
		actionLabel = tolua.cast(actionLabel, "CCLabelTTF")
		actionLabel:setString(string.format("动作%02d",index))

		--玩家名称 userName
		local userName = childen.userName
		userName = tolua.cast(userName, "CCLabelTTF")
		userName:setString(getPlayerByIndex(stepInfo.index).name)

		local raise = childen.raise
		raise = tolua.cast(raise, "CCEditBox")

		--fold checkfold 放弃继续牌局的机会
		local function foldClicked()
			stepInfo.action = "fold"
			stepInfo["jetton"] = 0
			raise:setText("raise")
		end
		local checkfold = childen.checkfold
		checkfold = tolua.cast(checkfold, "CCControlCheckBox")
		checkfold:setTouchPriority(priority)
		checkfold:addHandleOfControlEvent(foldClicked, CCControlEventTouchUpInside)

		--check checkcheck 在无人下注的情况下选择把决定“让”给下一位
		local function checkClicked()
			stepInfo.action = "check"
			stepInfo["jetton"] = 0
			raise:setText("raise")
		end
		local checkcheck = childen.checkcheck
		checkcheck = tolua.cast(checkcheck, "CCControlCheckBox")
		checkcheck:setTouchPriority(priority)
		checkcheck:addHandleOfControlEvent(checkClicked, CCControlEventTouchUpInside)

		--call checkcall 跟随众人押上同等的注额
		local function callClicked()
			stepInfo.action = "call"			
			raise:setText("raise")
			stepInfo["jetton"] = costValue
		end
		local checkcall = childen.checkcall
		checkcall = tolua.cast(checkcall, "CCControlCheckBox")
		checkcall:setTouchPriority(priority)
		checkcall:addHandleOfControlEvent(callClicked, CCControlEventTouchUpInside)

		--raise raise 把现有的注金抬高

		--保存
		local function saveButtonClicked()
			if raise:getText() and tonumber(raise:getText()) then
				costValue = tonumber(raise:getText())
				if stepInfo.action ~= "raise" then
					childen["check" .. stepInfo.action]:setSelected(false)
				end

				stepInfo.action = "raise"
				stepInfo["jetton"] = costValue

			end
		end

		local function boxHandler(EventName, eSender)
			local e = tolua.cast(eSender, "CCEditBox")
			if EventName == "began" then
				print(e:getText())
			elseif EventName == "ended" then
				print(e:getText())
				if e:getText() and tonumber(e:getText()) then
					saveButtonClicked()
				end
			elseif EventName == "return" then
				print(e:getText())
			elseif EventName == "changed" then
				print(e:getText())
			end
		end
		raise:setTouchPriority(priority)
		raise:registerScriptEditBoxHandler(boxHandler);

		if stepInfo.action ~= "raise" then
			childen["check" .. stepInfo.action]:setSelected(true)
		else
			raise:setText(stepInfo.jetton)
		end

		checkfold:setEnabled(index4 == index)
		checkcheck:setEnabled(index4 == index)
		checkcall:setEnabled(index4 == index)
		raise:setEnabled(index4 == index)
		local saveButton = childen.saveButton
		saveButton = tolua.cast(saveButton, "CCControlButton")
		saveButton:setTouchPriority(priority)
		saveButton:addHandleOfControlEvent(saveButtonClicked, CCControlEventTouchUpInside)
		cell:addChild(cellLayer)
    end
	local pCellbag = tolua.cast(pSender, "CCMultiColumnTableViewCell")
	drawCell(pCellbag)
end

local function on_init(_layer, _data1, _data2, _data3, _priority, _childen)

	all_node = GFN_Widget_Builder(_layer,"buildPoker_obj",nil,button_clicked_list, _priority, _childen)
	priority = _priority
	index1 = 1
	index2 = 1
	index3 = 1
	index4 = 1

	sbArray = {}
	for ___, playerInfo in pairs(pokerData.usersInfo) do
		table.insert(sbArray, playerInfo.sb)
	end
	--[[
		scroPerFlop
		scroFlop
		scrolTurn
		scroRiver
	]]
	local function initScroll(createFunction, name)
		all_node[name]:setCellSize(CCSizeMake(576, 35))
		all_node[name]:setColCount(1)
		all_node[name]:registerCellCreateScriptHandler(createFunction)
		all_node[name]:initWithCellCount(#pokerData["steps"][name] + 1)
	end

	initScroll(scroPerFlop_onCellCreated, "scroPerFlop")
	initScroll(scroFlop_onCellCreated, "scroFlop")
	initScroll(scrolTurn_onCellCreated	, "scrolTurn")
	initScroll(scroRiver_onCellCreated ,"scroRiver")
	
end

local function on_close()

end

local function on_key_anroid_click()

end

local ui_data = {
	json = "buildPoker.json",
	ui_name = "buildPoker",
	ui_type = G_Type_ui.layer,
	init_func = on_init,
	close_func = on_close,
	key_android_click = on_key_anroid_click,
}
G_UI_Manger.G_Func_addResiger(ui_data, "buildPoker")
