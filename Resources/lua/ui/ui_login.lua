--[[
    ui_login
    登录界面
	created:haily
]]
require "ui_login_obj"
local all_node

local function showLoginLayer()
	if UserInfo:getUserId() then
		all_node.paipuLayer:setVisible(true)
		all_node.loginLayer:setVisible(false)
		all_node.createTitle:setVisible(true)
		all_node.loginTitle:setVisible(false)
	else
		all_node.paipuLayer:setVisible(false)
		all_node.loginLayer:setVisible(false)
		all_node.createTitle:setVisible(false)
		all_node.loginTitle:setVisible(true)
	end
end

local button_clicked_list = {
	loginClicked = function ()
		if UserInfo:getUserId() then
			print("创建牌谱")
			UserInfo:resetPokerPool()
			G_UI_Manger.G_Func_showUI("createPoker")
		else
			print("登录")
			all_node.loginLayer:setVisible(true)
		end
	end,
	hotClicked = function ()
		print("热门牌谱")
		G_UI_Manger.G_Func_showUI("pokerList", 1)
	end,
	myClicked = function ()
		print("我的牌谱")
		G_UI_Manger.G_Func_showUI("pokerList", 2)
	end,

	weichatClicked = function ()
		print("微信登录")
		local time = os.time();
		UserInfo:setUserId(time)
		showLoginLayer()
	end,
	sinaClicked = function ()
		print("微博登录")
		local time = os.time();
		UserInfo:setUserId(time)
		showLoginLayer()
	end,
	qqClicked = function ()
		print("qq登录")
		local time = os.time();
		UserInfo:setUserId(time)
		showLoginLayer()
	end,
}

local function on_init(_layer, _data1, _data2, _data3, _priority, _childen)

	all_node = GFN_Widget_Builder(_layer,"login_obj",nil,button_clicked_list, _priority, _childen)
	
	showLoginLayer();
	UserInfo:initMyPokerList()
	
end

local function on_close()

end

local function on_key_anroid_click()

end

local ui_data = {
	json = "login.json",
	ui_name = "login",
	ui_type = G_Type_ui.scene,
	init_func = on_init,
	close_func = on_close,
	key_android_click = on_key_anroid_click,
	ui_pulic = true
}
G_UI_Manger.G_Func_addResiger(ui_data, "login")
