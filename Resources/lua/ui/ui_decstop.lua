--[[
    ui_decstop
   	牌桌
	created:haily
]]
require "ui_decstop_obj"
local all_node
local data
local tableChouma = {}
local actionStep = 1
local stepname = nil
local stepArray = {}
local actionArray = {}

local cloneUserInfo = {}

local costLabel
local costNode
local bPoint

local poolValue

local function getPoint(index, value)
	local p
	value = value or 0
	print("index", index)
	local xx = all_node["player" .. index]:getPositionX()
	local yy = all_node["player" .. index]:getPositionY()

	if index == 1 then
		p = ccp(xx + 50, yy + 123 + value)
	elseif index == 2 then
		p = ccp(xx + 129 + value, yy + 47)
	elseif index == 3 then
		p = ccp(xx + 129 + value, yy + 47)
	elseif index == 4 then
		p = ccp(xx + 129 + value, yy + 47)
	elseif index == 5 then
		p = ccp(xx + 129 / 2 + value / 2, yy - 29 - value / 2)
	elseif index == 6 then
		p = ccp(xx - 29 - value / 2, yy - 29 - value / 2)
	elseif index == 7 then
		p = ccp(xx - 29 - value, yy + 47)
	elseif index == 8 then
		p = ccp(xx - 29 - value, yy + 47)
	elseif index == 9 then
		p = ccp(xx - 29 - value, yy + 47)
	end
	return p
end

local function formatChouma(chouma)
	local s = ""
	local count = math.ceil(string.len(tostring(chouma)) / 3)
	for i=1,count do
		local num = math.pow(1000, count - i)
		print(num)
		if string.len(s) == 0 then
			s = math.floor(chouma / num)
		else
			s = s .. "," .. string.format("%03d", math.floor(chouma / num))
		end
		chouma = chouma % num
	end
	return s
end

local function updateNextAction()
	local steps = data["steps"]
	local group = steps[stepname]
	local stepInfo = group[actionStep]
	if stepInfo then
		dump(stepInfo, "stepInfo")
		dump(actionArray, "actionArray")
		local actionName = actionArray[stepInfo.index]
		actionName = tolua.cast(actionName, "CCLabelTTF")
		actionName:setString(stepInfo.action or "ALL IN")

		local jetton = stepInfo.jetton
		local label = tableChouma[stepInfo.index]
		label = tolua.cast(label, "CCLabelTTF")
		cloneUserInfo[stepInfo.index] = cloneUserInfo[stepInfo.index] - jetton
		local cloneJetton = cloneUserInfo[stepInfo.index]
		if cloneJetton <= 0 then
			actionName:setString("ALL IN")
			local v = cloneJetton + jetton
			if v > 0 then poolValue = poolValue + v end
			cloneJetton = 0
		else
			poolValue = poolValue + jetton
		end
		all_node.PoolValue:setString(poolValue)
		label:setString(formatChouma(cloneJetton))

		costNode:setPosition(getPoint(stepInfo.index, 40))
		costLabel:setString(formatChouma(jetton))

		actionStep = actionStep + 1
	else
		stepname = actionName[stepname].next
		if stepname then
			print("下一步")
			actionStep = 1
			updateNextAction()
		else
			stepname = "scroRiver"
			print("牌局结束")
		end
		
	end
end

local function updateBackAction()
	local steps = data["steps"]
	local group = steps[stepname]
	actionStep = actionStep - 1

	if actionStep > 0 then
		local stepInfo = group[actionStep]

		local actionName = actionArray[stepInfo.index]
		actionName = tolua.cast(actionName, "CCLabelTTF")
		actionName:setString(stepInfo.action)
		
		local jetton = stepInfo.jetton
		local label = tableChouma[stepInfo.index]
		label = tolua.cast(label, "CCLabelTTF")
		cloneUserInfo[stepInfo.index] = cloneUserInfo[stepInfo.index] + jetton
		
		local cloneJetton = cloneUserInfo[stepInfo.index]
		if cloneJetton <= 0 then
			actionName:setString("ALL IN")
			local v = cloneJetton + jetton
			if v > 0 then poolValue = poolValue - v end
			cloneJetton = 0
		else 
			poolValue = poolValue - jetton
		end
		all_node.PoolValue:setString(poolValue)
		label:setString(formatChouma(cloneJetton))

		costNode:setPosition(getPoint(stepInfo.index, 40))
		costLabel:setString(formatChouma(jetton))
	else
		stepname = actionName[stepname].back
		if stepname then
			print("上一步")
			actionStep = #steps[stepname] + 1
			updateBackAction()
		else
			actionStep = 1
			stepname = "scroPerFlop"
			costNode:setPosition(getPoint(1, 40))
			costLabel:setString("0")
			print("牌局第一步")
			for __, l in pairs(actionArray) do
				tolua.cast(l, "CCLabelTTF")
				l:setString("action")
			end
		end
		
	end
end

local button_clicked_list = {
	returnButtonClicked = function ()
		G_UI_Manger.GFN_CloseUI()
	end,
	shareButtonClicked = function ()

	end,
	backButtonClicked = function ()
		updateBackAction()
	end,
	nextButtonClicked = function ()
		updateNextAction()
	end,
}


local function on_init(_layer, _data, startPoint, callback, _priority, _childen)
	all_node = GFN_Widget_Builder(_layer,"decstop_obj",nil,button_clicked_list, _priority, _childen)
	data = _data
	dump(data, "data ", 4)
	all_node.pokerName:setString(data.pokerInfo.name)
	all_node.PoolValue:setString(0)
	poolValue = 0

	--每个人筹码显示的
	tableChouma = {}
	stepArray = {}
	cloneUserInfo = {}
	actionArray = {}
	local usersInfo = clone(data.usersInfo)

	for ___,	info in pairs(usersInfo) do
		local jetton = info.jetton
		local index = info.sb
		cloneUserInfo[index] = tonumber(jetton)
		local pokers = info.pokers

		local pokerValue1 = pokers[1]
		if pokerValue1 then
			local poker1 = UserInfo:createPokerUI( pokerValue1 )
			poker1:setAnchorPoint(ccp(0, 0))
			all_node["player" .. index]:addChild(poker1)
			poker1:setPosition(ccp (0, 0))
		end

		local pokerValue2 = pokers[2]
		if pokerValue2 then
			local poker2 = UserInfo:createPokerUI( pokerValue2 )
			poker2:setAnchorPoint(ccp(0, 0))
			all_node["player" .. index]:addChild(poker2)
			poker2:setPosition(ccp (40, 0))
		end

		local jetton = info.jetton
		jetton = formatChouma(jetton)

		local label = CCLabelTTF:create(jetton, "verdana", 18)
		all_node["player" .. index]:addChild(label)
		label:setAnchorPoint(ccp (0.5, 0))
		label:setPosition( ccp (50, 95))
		tableChouma[index] = label

		local actionName = CCLabelTTF:create("action", "verdana", 18)
		all_node["player" .. index]:addChild(actionName)
		actionName:setAnchorPoint(ccp (0.5, 0))
		actionName:setPosition( ccp (50, 115))
		actionArray[index] = actionName
		
	end

	dump(cloneUserInfo, "cloneUserInfo")

	local publicPoker = data.publicPoker
	for i=1,3 do
		local pokerValue = publicPoker[i]
		if pokerValue then
			local poker = UserInfo:createPokerUI( pokerValue )
			poker:setAnchorPoint(ccp(0, 0))
			all_node.public1:addChild(poker)
			poker:setPosition(ccp (25 * (i - 1), 0))
		end
	end

	for i=4,5 do
		local pokerValue = publicPoker[i]
		if pokerValue then
			local poker = UserInfo:createPokerUI( pokerValue )
			poker:setAnchorPoint(ccp(0, 0))
			all_node.public2:addChild(poker)
			poker:setPosition(ccp (25 * (i - 4), 0))
		end
	end

	actionStep = 1
	stepname = "scroPerFlop"

	--确定庄家位置
	local steps = data["steps"]
	local group = steps[stepname]

	local zhuangjia = 1

	local shaizi = CCSprite:create("Resources/shaizi.png")
	all_node.decstopLayer:addChild(shaizi, 3)
	local p = getPoint(zhuangjia, 10)
	p.x = p.x - 50
	shaizi:setPosition(p)

	costNode = CCSprite:create("Resources/playIcon.png");
	all_node.decstopLayer:addChild(costNode, 3)
	costNode:setPosition(getPoint(zhuangjia, 40))

	costLabel = CCLabelTTF:create("0", "verdana", 18)
	costNode:addChild(costLabel)
	costLabel:setAnchorPoint(ccp (0, 0))
	costLabel:setPosition(ccp (30, 0))


end

local function on_close()

end

local function on_key_anroid_click()

end

local ui_data = {
	json = "decstop.json",
	ui_name = "decstop",
	ui_type = G_Type_ui.layer,
	init_func = on_init,
	close_func = on_close,
	key_android_click = on_key_anroid_click,
}
G_UI_Manger.G_Func_addResiger(ui_data, "decstop")
