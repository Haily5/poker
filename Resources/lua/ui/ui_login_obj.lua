--[[
	ui_login_obj
	created: haily
]]


ui_obj_list = {

	--登陆按钮
	{obj_name = "loginButton",	t_type = "CCControlButton",			t_data = "loginClicked"},

	--创建标题
	{obj_name = "createTitle",	t_type = "CCSprite"},

	--登录标题
	{obj_name = "loginTitle",	t_type = "CCSprite"},


	--牌谱层
	{obj_name = "paipuLayer",	t_type = "CCLayer"},

	--热门牌谱
	{obj_name = "HOTButton",	t_type = "CCControlButton",			t_data = "hotClicked"},

	--我的牌谱
	{obj_name = "MYButton",		t_type = "CCControlButton",			t_data = "myClicked"},

	--第三方登录层
	{obj_name = "loginLayer",	t_type = "CCLayer"},

	--微信登录
	{obj_name = "weiChatButton",	t_type = "CCControlButton",		t_data = "weichatClicked"},

	--sina登录
	{obj_name = "sinaButton",		t_type = "CCControlButton",		t_data = "sinaClicked"},

	--qq登录
	{obj_name = "qqButton",		t_type = "CCControlButton",		t_data = "qqClicked"}, 

}
G_Node_list.G_Func_Register(ui_obj_list, "login_obj")