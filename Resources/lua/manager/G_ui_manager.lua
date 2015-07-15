--[[ the ui mananger	Author: haily
]]


--[[
	local ui_data = {
		json = "login_main.json",
		ui_name = "login",
		ui_type = G_Type_ui.scene,
		ui_pulic = true,
		init_func = on_init,
		close_func = on_close,
		key_android_click = on_key_anroid_click,
		update_func = {
			key = func
		}
	}
]]
G_UI_Manger = {}

local scene_list = {} --显示的ui数组

local layer_obj_list = {} --显示的ui数据table数组

local showui = {}	--当前显示的ui

--[[ 注册UI
	_obj:ui对象 (实际上是一个table)
]]
function G_UI_Manger.G_Func_addResiger( _obj, _key )
	--G_log_info("G_Func_addResiger:",_key)
	G_Node_list.G_Func_Register(_obj, _key)
end

--[[ android key

]]
local function on_android_key(_state)
	if _state == "backClicked" then
		local now_ui = layer_obj_list[#layer_obj_list]
		if now_ui ~= nil and now_ui.key_android_click ~= nil then
			now_ui.key_android_click()
		end
	end
end

--[[ 显示UI
	_ui_name:唯一key值
	_data1:传入的参数1
	_data2:传入的参数2
	_data3:传入的参数3
]]
function G_UI_Manger.G_Func_showUI( _ui_name, _data1, _data2, _data3)
	print("show UI :", _ui_name)
	local ui_data = G_Node_list.G_Func_GetObj(_ui_name)

	--记录参数
	if ui_data.ui_pulic then
		--公共数据每次都清空
		ui_data._data1 = nil
		ui_data._data2 = nil
		ui_data._data3 = nil
	end

	if _data1 then ui_data._data1 = _data1 end
	if _data2 then ui_data._data2 = _data2 end
	if _data3 then ui_data._data3 = _data3 end

	if ui_data == nil then G_log_error(_ui_name ," ui obj is nil") return end


	local json = ui_data.json
	if json ~= nil then
		local curTouchPriority = 0

		if ui_data.ui_type == G_Type_ui.scene then

			if #layer_obj_list ~= 0 then
				local last_ui_data =  layer_obj_list[#layer_obj_list]
				last_ui_data.close_func()
			end

			curTouchPriority = -30 - #layer_obj_list*10
			local sc = CCScene:create()
			local _layer, childen = ReaderStudioJson(json)

			sc:addChild(_layer)
			_layer:setPosition(0,0)

			--android key
			_layer:setKeypadEnabled(true)
			dump(ui_data)
			if ui_data.key_android_click ~= nil then
				_layer:registerScriptKeypadHandler(ui_data.key_android_click)
			end

			if #scene_list ~= 0 then

				CCDirector:sharedDirector():replaceScene(sc)

			else
				CCDirector:sharedDirector():runWithScene(sc)
			end
			if not ui_data.show then
				table.insert(scene_list, sc)
				table.insert(layer_obj_list, ui_data)
			end
			showui = {}
			table.insert(showui, ui_data)
			ui_data.init_func(_layer:getChildByTag(1), ui_data._data1, ui_data._data2, ui_data._data3, curTouchPriority, childen)

		elseif ui_data.ui_type == G_Type_ui.layer then

			curTouchPriority = -30 - #layer_obj_list*10
			local sc = CCScene:create()
			local _layer, childen = ReaderStudioJson(json)

			sc:addChild(_layer)

			_layer:setKeypadEnabled(true)
			if ui_data.key_android_click ~= nil then
				_layer:registerScriptKeypadHandler(ui_data.key_android_click)
			end

			CCDirector:sharedDirector():pushScene(sc)

			if not ui_data.show then
				table.insert(scene_list, sc)
				table.insert(layer_obj_list, ui_data)
			end
			table.insert(showui, ui_data)
			ui_data.init_func(_layer:getChildByTag(1), ui_data._data1, ui_data._data2, ui_data._data3, curTouchPriority, childen)
		elseif ui_data.ui_type == G_Type_ui.dialog then

			curTouchPriority = -40 - #layer_obj_list*20
			local _dialog, childen = ReaderStudioJson(json)

			local sc = CCDirector:sharedDirector():getRunningScene()

			local blackLayer = CCLayerColor:create(ccc4(0, 0 , 0, 120))
			_dialog:addChild(blackLayer, - 1)
			blackLayer:setPosition(ccp (0, 0))

			local touchLayer = CCTouchLayer:create(curTouchPriority)
			blackLayer:addChild(touchLayer)
			sc:addChild(_dialog)

			--设置可触摸区域，点击其他区域关闭界面
			childen.dialogControl = {}
			if childen["dialog_size"] then
				childen.dialogControl[#childen.dialogControl + 1] = childen["dialog_size"]
			end

			local function onTouch(eventType, x, y)
				print(eventType, "eventType")
				if eventType == "began" then
					if #childen.dialogControl > 0 then
						local touchOutside = true
						for k, v in pairs(childen.dialogControl) do
							local parent = v:getParent()
							local cpNode = parent:convertToNodeSpace(ccp(x, y))
							local cpx, cpy = v:getPosition()
							if v:boundingBox():containsPoint(cpNode) then
								touchOutside = false
							end
						end

						if touchOutside then
							G_UI_Manger.GFN_CloseUI()
						end
					end
				elseif eventType == "move" then

				elseif eventType == "end" then

				end
			end
			touchLayer:registerScriptTouchHandler(onTouch)


			if not ui_data.show then
				table.insert(scene_list, _dialog)
				table.insert(layer_obj_list, ui_data)
			end

			table.insert(showui, ui_data)
			ui_data.init_func(_dialog:getChildByTag(1), ui_data._data1, ui_data._data2, ui_data._data3, curTouchPriority, childen)
		elseif ui_data.ui_type == G_Type_ui.tips then

		else

		end
		ui_data.show = true
	end

end
--[[
	获取当前正在运行的ui name
]]
function G_UI_Manger.GFN_Get_Now_UI_Name()

	if #layer_obj_list == 0 then error("no ui show!") return end
	return layer_obj_list[#layer_obj_list].ui_name
end

--[[推送更新信息
	key:推送的key
	value:推送的值， 可以不填写，接收数据从全局变量获得
]]
function G_UI_Manger.GFN_PushUpdate(key, value)
	G_log_info("push key:", key)
	for _,last_ui_data in ipairs(showui) do
		if last_ui_data.update_func ~= nil then
			for _, update in ipairs(last_ui_data.update_func) do
				if update.key_name == key then
					if update.up_function ~= nil then
						update.up_function(value)
					else
						G_log_error("can not find update function , key:", key, " ui name is", last_ui_data.ui_name)
					end
				end

			end

		end
	end
end

--关闭当前正在显示的UI

function G_UI_Manger.GFN_CloseUI()
	local last_ui_data = layer_obj_list[#layer_obj_list]

	if #layer_obj_list == 1 then  error("then scence can not close") return end

	if last_ui_data.ui_type == G_Type_ui.layer then
		last_ui_data.show = false
		last_ui_data.close_func()
		table.remove(layer_obj_list, #layer_obj_list)
		table.remove(scene_list, #scene_list)

		CCDirector:sharedDirector():popScene()

	elseif last_ui_data.ui_type == G_Type_ui.dialog then
		last_ui_data.show = false
		last_ui_data.close_func()
		local dialog = scene_list[#scene_list]
		dialog:removeFromParentAndCleanup(true)
		table.remove(layer_obj_list, #layer_obj_list)
		table.remove(scene_list, #scene_list)
		table.remove(showui, #showui)

	else
		last_ui_data.show = false
		last_ui_data.close_func()
		table.remove(layer_obj_list, #layer_obj_list)
		table.remove(scene_list, #scene_list)
		table.remove(showui, #showui)

	 	G_UI_Manger.G_Func_showUI(layer_obj_list[#layer_obj_list].ui_name)
	end
end

--回退到某个界面
function G_UI_Manger.GFN_ReturnUI(_ui_name)

	local function removeObj(tab)
		local last_ui_data = tab[#tab]
		if last_ui_data.ui_name ~= _ui_name then
			last_ui_data.show = false
			table.remove(layer_obj_list, #layer_obj_list)
			table.remove(scene_list, #scene_list)
			removeObj(layer_obj_list)
		else
			last_ui_data.show = false
		end
	end
	removeObj(layer_obj_list)

	G_UI_Manger.G_Func_showUI(_ui_name)
end