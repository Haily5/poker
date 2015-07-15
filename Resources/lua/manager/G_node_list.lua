--[[
	the global obj register and get obj
	created: haily
]]

G_Node_list = {}

local node_list = {}

--[[ 注册方法
	_obj:注册对象
	_key:唯一key值
]]

function G_Node_list.G_Func_Register( _obj, _key )
	-- G_log_info("node Register :", _key, _obj)

	if _obj ~= nil and _key ~= nil then
		if node_list[_key] ~= nil then
			print("the key:" .. _key .. " already exists!")
			node_list[_key] = nil
		end
		node_list[_key] = _obj
	else
		error("_obj or _key is nil")
	end
end

--[[寻找对象方法
	_key:key值
]]

function G_Node_list.G_Func_GetObj( _key )
	--G_log_info("get obj ", _key)
	return node_list[_key]
end