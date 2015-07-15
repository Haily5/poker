--[[------------------------------------------]]--
--[[--   created:    2014.7.16   13:14      --]]--
--[[--   filename:   widget_builder.lua     --]]--
--[[--   author:     yanhaolee              --]]--
--[[--   purpose:    转换cocostudio json    --]]--
--[[------------------------------------------]]--

--解析lable是字符串
local function find_widget_data(_user_data,_key,_index)
	local now_item = nil
	-- print("_user_data[_key] = ",_user_data[_key])
	if type(_key) == "string" then                                                    --判断类型是否为字符串
		now_item =  _user_data[_key]
	elseif type(_key) == "table" then                                                 --判断类型是否为table
		now_item = find_widget_data(_user_data[_key[_index]],_key[_index+1],_index+1) --递归
	end
	return now_item                                                                   --返回按钮的类型
end

--[[
参数1  _base_node  ： 整个界面的父节点
参数2  _ui_config_obj_key : Ui配置文件名 (key)
参数3  _user_data :label 显示的相关数据table
参数4  _call_back_list : 按钮回调 table
参数5  _priority 界面事件优先级 没有就空
]]
function GFN_Widget_Builder(_base_node,_ui_config_obj_key,_user_data,_call_back_list,_priority, _childen)
	local obj_list = {}                                            --对象链表
	local obj = G_Node_list.G_Func_GetObj(_ui_config_obj_key)                       --根据键获取到对象
	dump(_ui_config_obj_key)
	for i,v in ipairs(obj) do                                      --遍历整个对象

		local item = nil

		if _childen ~= nil then
			item = tolua.cast(_childen[v.obj_name], v.t_type)
		end

		if item == nil then                                                           --如果对象为空
			print ("item is nil, key = " .. v.obj_name .. "  type =" .. v.t_type)     --输出对象和类型
			error("item NULL")
			break
		end

		if v.t_type == "CCControlButton" then                                         --判断对象是否为CCControlButton
			if _call_back_list ~= nil then                                            --判断事件列表
				if _call_back_list[v.t_data] ~= nil then                              --判断按钮是否有回调
					print(_call_back_list[v.t_data])
					item:addHandleOfControlEvent(_call_back_list[v.t_data] ,CCControlEventTouchUpInside)
				else
					print (" button  touch func is nil", v.obj_name, v.t_data, _call_back_list[v.t_data])
					dump(_call_back_list, "_call_back_list")
				end
			end
			if _priority ~= nil then                                                                           --判断事件的优先级是否为空
				item:setTouchPriority(_priority-1)                                                             --优先级减1
			end
		elseif v.t_type == "CCLabelFT" then                                                                   --判断按钮类是否为CCLabelFT
			if _user_data ~= nil then                                                                          --判断table数据是否为空
				local n_data = find_widget_data(_user_data,v.t_data,1)                                         --字符串
				if n_data ~= nil then                                                                          --查看字符串是否为空
					item:setString(tostring(n_data))                                                           --给按钮设置字符串
				end
			end
		elseif v.t_type == "CCLabelBMFont" then                                                                   --判断按钮类是否为CCLabelFT
			if _user_data ~= nil then                                                                          --判断table数据是否为空
				local n_data = find_widget_data(_user_data,v.t_data,1)                                         --字符串
				if n_data ~= nil then                                                                          --查看字符串是否为空
					item:setString(tostring(n_data))                                                           --给按钮设置字符串
				end
			else
				item:setString("")
			end
		elseif v.t_type == "CCControlCheckBox" then                                                            --判断类型是否为CCControlCheckBox
			if _call_back_list ~= nil then                                                                     --判断事件列表是否为空
				if _call_back_list[v.t_data] ~= nil then                                                       --判断是不是有回调
					item:addHandleOfControlEvent(_call_back_list[v.t_data],CCControlEventTouchUpInside)        --添加事件
				end
			end
			if _priority ~= nil then                                                                           --查看是否有优先级
				item:setTouchPriority(_priority-1)                                                             --优先级减1
			end
			item:setSelected(v.exdata or false)                                                                --没有选项择不选中
		elseif v.t_type == "CCLabelAtlas" then                                                                 --查看是否为CCLabelAtlas
			if _user_data ~= nil then                                                                          --查看table是否有数据
				local n_data = find_widget_data(_user_data,v.t_data,1)                                         --字符串
				if v.exdata == true then                                                                       --查看是否带符号
					item:setString(tostring(n_data))                                                           --给按钮设置值
				else
					if n_data ~= nil then                                                                          --判断table的字符串是否为空
						if n_data > 0 then
							item:setString(";"..tostring(n_data))                                                  --给CCLabelAtlas设置带符号字符串
						elseif n_data < 0 then
							item:setString(":"..tostring(-n_data))                                                 --给CCLabelAtlas设置带符号字符串
						else
							item:setString(tostring(n_data))                                                       --给CCLabelAtlas设置字符串
						end
					end
				end
		 	end
		elseif v.t_type == "CCSprite" then                                                                     --判断是否为CCSprite
			if _user_data ~= nil and v.t_data ~= nil then                                                      --判断table和回调是否为空
				local n_data = find_widget_data(_user_data,v.t_data,1)                                         --获取table的字符串
				local newsprite = CCSpriteFrame:create(n_data,CCRectMake(0,0,item:getContentSize().width,item:getContentSize().height))   --实例化一个精灵
				item:setDisplayFrame(newsprite)                                                                                                                         --
			end
		elseif v.t_type == "CCMultiColumnTableView" then                                                       --判断类型是否为CCMultiColumnTableView
			if _call_back_list[v.t_data] ~= nil then                                                           --查看事件是否为空
				item:registerCellCreateScriptHandler(_call_back_list[v.t_data])                                --给CCMultiColumnTableView添加事件
			end
			if _priority ~= nil then
				item:setTouchPriority(_priority-1)                                                             --设置优先级减1
			end
			if v.exdata ~= nil then                                                                            --查看数字是否为空
				item:setColCount(v.exdata)                                                                     --设置行
			end
		elseif v.t_type == "CCControlSlider" then                                                              --判断类型是否为CCControlSlider
			if _call_back_list ~= nil then                                                                     --查看事件列表为空
				if _call_back_list[v.t_data] ~= nil then                                                       --查看事件是否为空
					item:addHandleOfControlEvent(_call_back_list[v.t_data],CCControlEventValueChanged)         --添加事件
				end
			end
			if _priority ~= nil then                                                                           --查看优先级是否为空
				item:setTouchPriority(_priority-1)                                                             --查看优先级减1
			end
		elseif v.t_type == "CCNode" then                                                                       --判断类型是否为节点
			if v.t_data ~= nil then                                                                            --判断回调是否为空
				item:setVisible(v.t_data )                                                                     --隐藏节点
			end
		elseif v.t_type == "CCEditBox" then                                                                    --判断类型是否是CCEditBox
			if _priority ~= nil then                                                                           --如果优先级不为空
				item:setTouchPriority(_priority-1)                                                             --将优先级设置为优先级减1
			end
		end
		obj_list[v.obj_name] = item                                                                            --将遍历的对象加入table
	end
	return obj_list                                                                                            --返回对象的链表
end




