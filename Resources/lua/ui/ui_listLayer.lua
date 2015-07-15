--[[
    ui_listLayer
   	透明层，生成某个坐标点的touch按钮
	created:haily
]]
require "ui_listLayer_obj"
local all_node
local button_clicked_list = {
}

local function on_init(_layer, dataList, startPoint, callback, _priority, _childen)
	all_node = GFN_Widget_Builder(_layer,"listLayer_obj",nil,button_clicked_list, _priority, _childen)
	local function buttonClicked( TouchEvent, button )
		G_UI_Manger.GFN_CloseUI()
		callback(button:getTag())
	end

	for __, data in pairs(dataList) do
		local button = CCControlButton:create(data, "verdana", 40)
		_layer:addChild(button)
		button:setTouchPriority(_priority)
		button:addHandleOfControlEvent(buttonClicked, CCControlEventTouchUpInside)
		button:setTag(__)
		button:setPosition(ccp (288, 900 - __ * 80 + 20))
	end
end

local function on_close()

end

local function on_key_anroid_click()

end

local ui_data = {
	json = "listLayer.json",
	ui_name = "listLayer",
	ui_type = G_Type_ui.dialog,
	init_func = on_init,
	close_func = on_close,
	key_android_click = on_key_anroid_click,
}
G_UI_Manger.G_Func_addResiger(ui_data, "listLayer")
