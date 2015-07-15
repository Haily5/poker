--[[
    ui_pokerListLayer
   	透明层，选择牌的层
	created:haily
]]
require "ui_pokerListLayer_obj"
local all_node
local priority
local callback
local defalutPoker
local button_clicked_list = {

}

local function onCellCreated( state, pSender )
	local prop = {}
	local function drawCell( cell )
		cell:removeAllChildrenWithCleanup(true)
		local index = cell:getIdx() + 1

		local pokerValue = UserInfo:getPokerPool()[index]
		local pokerUi = UserInfo:createPoker(pokerValue)

		local function ButtonClicked()
			if callback then
				callback(pokerValue)
				print(pokerValue)
				UserInfo:selectPoker(pokerValue)
				G_UI_Manger.GFN_CloseUI()
			end
		end

		local button  = UserInfo:createPoker(pokerValue, ButtonClicked)
		button:setTouchPriority(priority)
		button:setPosition(ccp(48, 64))
		cell:addChild(button)

    end
	local pCellbag = tolua.cast(pSender, "CCMultiColumnTableViewCell")
	drawCell(pCellbag)
end

local function on_init(_layer, _clallback, _defalutPoker, _data3, _priority, _childen)
	all_node = GFN_Widget_Builder(_layer,"pokerListLayer_obj",nil,button_clicked_list, _priority, _childen)

	priority = _priority
	callback = _clallback

	print(_defalutPoker, "_defalutPoker")

	all_node.pokerList:setCellSize(CCSizeMake(96, 128))
	all_node.pokerList:setColCount(6)
	all_node.pokerList:registerCellCreateScriptHandler(onCellCreated)
	all_node.pokerList:initWithCellCount(#UserInfo:getPokerPool(_defalutPoker))

end

local function on_close()

end

local function on_key_anroid_click()

end

local ui_data = {
	json = "pokerListLayer.json",
	ui_name = "pokerListLayer",
	ui_type = G_Type_ui.dialog,
	init_func = on_init,
	close_func = on_close,
	key_android_click = on_key_anroid_click,
}
G_UI_Manger.G_Func_addResiger(ui_data, "pokerListLayer")
