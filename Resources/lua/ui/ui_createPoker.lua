--[[
    ui_createPoker
    牌谱列表
	created:haily
]]
require "ui_createPoker_obj"
local all_node
local priority


local function buttonClicked( index )
	if all_node["poker" .. index ]:getChildByTag(10) then all_node["poker" .. index ]:removeChildByTag(10, true) end
		local function ChangePoker(value)
			pokerData.publicPoker[index] = value
			local p = UserInfo:createPokerUI(pokerData.publicPoker[index])
			all_node["poker" .. index ]:addChild(p)
			p:setTag(10)
		end
	G_UI_Manger.G_Func_showUI("pokerListLayer",ChangePoker ,pokerData.publicPoker[index])
end

local button_clicked_list = {
	retrunClicked = function ()
		G_UI_Manger.GFN_CloseUI()
	end,
	addUserClicked = function ()
		if #pokerData.usersInfo == 9 then
			return
		end
		local name = string.format("玩家%02d", #pokerData.usersInfo + 1)
		local pokers = {}
		local jetton = 0
		local sbStr = cloneNamesArray[1]
		local sb = namesIndex[sbStr]
		table.remove(cloneNamesArray, 1)
		local user = {
			["name"] = name,
			["pokers"] = pokers,
			["jetton"] = jetton,
			["sb"] = sb,
			["user"] = user,
		}
		table.insert(pokerData.usersInfo, user)
		all_node.scrollListLayer:initWithCellCount(#pokerData.usersInfo)
		if #pokerData.usersInfo > 2 then
			all_node.scrollListLayer:setContentOffset(ccp (0, 0))
		end


	end,
	pokerEditor1 = function (touchType, button)
		buttonClicked(1)
	end,
	pokerEditor2 = function (touchType, button)
		buttonClicked(2)
	end,
	pokerEditor3 = function (touchType, button)
		buttonClicked(3)
	end,
	pokerEditor4 = function (touchType, button)
		buttonClicked(4)
	end,
	pokerEditor5 = function (touchType, button)
		buttonClicked(5)
	end,
	nextButtonClicked = function ()
		local pokerName = all_node.txtName:getText()
		if not pokerName or string.len(pokerName) == 0 then
			print("名字不能为空")
			return
		end
		local pokerLevel = all_node.txtLevel:getText()
		if not pokerLevel or string.len(pokerLevel) == 0 or not tonumber(pokerLevel) then
			print("盲数不能为空")
			return
		end	
		pokerData.pokerInfo.name = pokerName
		pokerData.pokerInfo.level = pokerLevel
		pokerData.pokerInfo.pokerId = UserInfo:getUserId() .. "_" .. os.time()
		pokerData.pokerInfo.hotLevel = 0

		--对玩家顺序排序
		local cloneUsersInfo = pokerData.usersInfo
		table.sort(cloneUsersInfo, function ( p1, p2 )
			return p1.sb < p2.sb
		end)
		pokerData.usersInfo = cloneUsersInfo

		-- dump(pokerData, "pokerData", 5)

		G_UI_Manger.G_Func_showUI("buildPoker")
	end,
}

local function onCellCreated( state, pSender )
	local prop = {}
	local function drawCell( cell )
		cell:removeAllChildrenWithCleanup(true)
		local index = cell:getIdx() + 1

		local cellLayer, childen = ReaderStudioJson("createCell.json")

		local user = pokerData.usersInfo[index]
		--玩家名字 lblName
		local lblName = childen.lblName
		lblName = tolua.cast(lblName, "CCLabelTTF")
		lblName:setString(user.name)

		local add1 = childen.add1
		add1 = tolua.cast(add1, "CCSprite")

		

		--底牌1按钮 poker1
		local poker1 = childen.poker1
		poker1 = tolua.cast(poker1, "CCControlButton")
		poker1:setTouchPriority(priority)

		local function updateAdd1()
			if poker1:getChildByTag(10) then poker1:removeChildByTag(10, true) end
			if user.pokers[1] then
				local p1 = UserInfo:createPokerUI(user.pokers[1])
				poker1:addChild(p1)
				p1:setTag(10)
				add1:setVisible(false)
			else
				add1:setVisible(true)
			end
		end
		updateAdd1()
		local function poker1Clicked()
			local function ChangePoker(value)
				user.pokers[1] = value
				updateAdd1()
			end
			G_UI_Manger.G_Func_showUI("pokerListLayer",ChangePoker ,user.pokers[1])
		end
		poker1:addHandleOfControlEvent(poker1Clicked, CCControlEventTouchUpInside)
		

		local add2 = childen.add2
		add2 = tolua.cast(add2, "CCSprite")

		
		--底牌2按钮 poker2
		local poker2 = childen.poker2
		poker2 = tolua.cast(poker2, "CCControlButton")
		poker2:setTouchPriority(priority)
		

		local function updateAdd2()
			if poker2:getChildByTag(10) then poker2:removeChildByTag(10, true) end
			if user.pokers[2] then
				local p2 = UserInfo:createPokerUI(user.pokers[2])
				poker2:addChild(p2)
				p2:setTag(10)
				add2:setVisible(false)
			else
				add2:setVisible(true)
			end
		end
		updateAdd2()

		local function poker2Clicked()
			local function ChangePoker(value)
				user.pokers[2] = value
				updateAdd2()
			end
			G_UI_Manger.G_Func_showUI("pokerListLayer",ChangePoker ,user.pokers[2])
		end
		poker2:addHandleOfControlEvent(poker2Clicked, CCControlEventTouchUpInside)

		--筹码数量 txtChouma
		local function boxHandler(EventName, eSender)
			local e = tolua.cast(eSender, "CCEditBox")
			if EventName == "began" then
				print(e:getText())
			elseif EventName == "ended" then
				print(e:getText())
				if e:getText() and tonumber(e:getText()) then
					user.jetton = e:getText()
				end
			elseif EventName == "return" then
				print(e:getText())
			elseif EventName == "changed" then
				print(e:getText())
			end
		end
		local txtChouma = childen.txtChouma
		txtChouma = tolua.cast(txtChouma, "CCEditBox")
		txtChouma:registerScriptEditBoxHandler(boxHandler)
		if user.jetton and tonumber(user.jetton) ~= 0 then
			txtChouma:setText(user.jetton)
		end

		local function finishChoumaClicked()
			if txtChouma:getText() and tonumber(txtChouma:getText()) then
				user.jetton = txtChouma:getText()
			end
		end
		local finishChoumaButton = childen.finishChoumaButton
		finishChoumaButton = tolua.cast(finishChoumaButton, "CCControlButton")
		finishChoumaButton:setTouchPriority(priority)
		finishChoumaButton:addHandleOfControlEvent(finishChoumaClicked, CCControlEventTouchUpInside)

		--sb文字 SBlabel
		local SBlabel = childen.SBlabel
		SBlabel = tolua.cast(SBlabel, "CCLabelTTF")
		dump(user, "user")
		SBlabel:setString(namesArray[user.sb])
		--sb bb转换按钮 exchangeButton
		local exchangeButton = childen.exchangeButton
		
		local function listCallback(cellIndex)
			local sbStr = cloneNamesArray[cellIndex]
			print(sbStr, "sbStr", cellIndex)
			user.sb = namesIndex[sbStr]
			table.remove(cloneNamesArray, cellIndex)
			SBlabel:setString(namesArray[user.sb])
		end
		local function exchangeButtonClicked()
			local sbStr = namesArray[user.sb]
			table.insert(cloneNamesArray, sbStr)
			G_UI_Manger.G_Func_showUI("listLayer", cloneNamesArray, exchangeButton:getPosition(), listCallback)
		end
		exchangeButton = tolua.cast(exchangeButton, "CCControlButton")
		exchangeButton:setTouchPriority(priority)
		exchangeButton:addHandleOfControlEvent(exchangeButtonClicked, CCControlEventTouchUpInside)

		--删除玩家按钮 deleteUser
		local function deleteUserClicked()
			print("删除玩家")
			table.remove(pokerData.usersInfo, index)
			local containerPos = all_node.scrollListLayer:getContentOffset()
			all_node.scrollListLayer:initWithCellCount(#pokerData.usersInfo)
			all_node.scrollListLayer:setContentOffset(containerPos)

		end
		local deleteUser = childen.deleteUser
		deleteUser = tolua.cast(deleteUser, "CCControlButton")
		deleteUser:setTouchPriority(priority)
		deleteUser:addHandleOfControlEvent(deleteUserClicked, CCControlEventTouchUpInside)

		cell:addChild(cellLayer)
    end
	local pCellbag = tolua.cast(pSender, "CCMultiColumnTableViewCell")
	drawCell(pCellbag)
end

local function on_init(_layer, _data1, _data2, _data3, _priority, _childen)

	all_node = GFN_Widget_Builder(_layer,"createPoker_obj",nil,button_clicked_list, _priority, _childen)
	priority = _priority
	all_node.scrollListLayer:setCellSize(CCSizeMake(576, 150))
	all_node.scrollListLayer:setColCount(1)
	all_node.scrollListLayer:registerCellCreateScriptHandler(onCellCreated)
	all_node.scrollListLayer:initWithCellCount(#pokerData.usersInfo)

end

local function on_close()

end

local function on_key_anroid_click()

end

local ui_data = {
	json = "createPoker.json",
	ui_name = "createPoker",
	ui_type = G_Type_ui.layer,
	init_func = on_init,
	close_func = on_close,
	key_android_click = on_key_anroid_click,
}
G_UI_Manger.G_Func_addResiger(ui_data, "createPoker")
