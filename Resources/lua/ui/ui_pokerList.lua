--[[
    ui_pokerList
    牌谱列表
	created:haily
]]
require "ui_pokerList_obj"
local all_node
local priority
local own
local data
local button_clicked_list = {
	retrunClicked = function ()
		G_UI_Manger.GFN_CloseUI()
	end
}

local function onCellCreated( state, pSender )
	local prop = {}
	local function drawCell( cell )
		cell:removeAllChildrenWithCleanup(true)
		local index = cell:getIdx() + 1

		local jsonFile
		if own then
			jsonFile = "listCell.json"
		else
			jsonFile = "listCellHOT.json"
		end

		local cellLayer, childen = ReaderStudioJson(jsonFile)
		--头像 headImg
		--按钮 cellButton
		--名称 name
		--级别 level
		--时间 createTime
		--热门度 hotLevel

		local poker = data[index]

		local function setLabelView(name, strKey)
			local label = childen[name]
			label = tolua.cast(label, "CCLabelTTF")
			local strValue = poker.pokerInfo[strKey] or ""
			if strKey == "time" then
				local date = os.date("*t", tonumber(strValue))
				strValue = string.format("%d-%d-%d %02d:%02d:%02d",date.year, date.month, date.day, date.hour, date.min, date.sec)
			end
			label:setString(strValue)
		end
		setLabelView("name", "name")
		setLabelView("level", "level")
		setLabelView("createTime", "time")
		setLabelView("hotLevel", "name")

		
		local level

		local function showPokerDeskstop()
			print("显示牌局" .. index)
			G_UI_Manger.G_Func_showUI("decstop", poker)
		end
		local cellButton = childen.cellButton
		cellButton = tolua.cast(cellButton ,"CCControlButton")
		cellButton:setTouchPriority(priority)
		cellButton:addHandleOfControlEvent(showPokerDeskstop ,CCControlEventTouchUpInside)

		if own then
			local function deleteButtonClicked()
				print("删除牌谱:", index)
				UserInfo:deletePoker( index )
				table.remove(data, index)
				all_node.scroList:initWithCellCount(#data)
			end
			local delButton = childen.delButton
			delButton = tolua.cast(delButton, "CCControlButton")
			delButton:setTouchPriority(priority)
			delButton:addHandleOfControlEvent(deleteButtonClicked, CCControlEventTouchUpInside)
		end

		cell:addChild(cellLayer)
    end
	local pCellbag = tolua.cast(pSender, "CCMultiColumnTableViewCell")
	drawCell(pCellbag)
end

local function on_init(_layer, _data1, _data2, _data3, _priority, _childen)

	all_node = GFN_Widget_Builder(_layer,"pokerList_obj",nil,button_clicked_list, _priority, _childen)
	priority = _priority
	all_node.scroList:setCellSize(CCSizeMake(576, 100))
	all_node.scroList:setColCount(1)
	all_node.scroList:registerCellCreateScriptHandler(onCellCreated)

	

	if _data1 == 1 then
		print("热门牌谱")
		own = false
		print("联网后， 使用联网数据")
		data = UserInfo:getMyPokerList()
		all_node.scroList:initWithCellCount(#data)
	else
		print("我的牌谱")
		own = true
		data = UserInfo:getMyPokerList()
		all_node.remen:setVisible(false)
		all_node.scroList:initWithCellCount(#data)
	end

end

local function on_close()

end

local function on_key_anroid_click()

end

local ui_data = {
	json = "pokerList.json",
	ui_name = "pokerList",
	ui_type = G_Type_ui.layer,
	init_func = on_init,
	close_func = on_close,
	key_android_click = on_key_anroid_click,
}
G_UI_Manger.G_Func_addResiger(ui_data, "pokerList")
