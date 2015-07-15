--[[
	ui_createPoker_obj
	created: haily
]]


ui_obj_list = {

	--返回按钮
	{obj_name = "returnButton",	t_type = "CCControlButton",			t_data = "retrunClicked"},

	--名字输入框
	{obj_name = "txtName",		t_type = "CCEditBox"},

	--盲数输入值
	{obj_name = "txtLevel",		t_type = "CCEditBox"},

	--滚动层
	{obj_name = "scrollListLayer",	t_type = "CCMultiColumnTableView"},

	--添加玩家
	{obj_name = "addUserButton",	t_type = "CCControlButton",		t_data = "addUserClicked"},

	--公共牌1
	{obj_name = "poker1",		t_type = "CCControlButton",			t_data = "pokerEditor1"},
	{obj_name = "poker2",		t_type = "CCControlButton",			t_data = "pokerEditor2"},
	{obj_name = "poker3",		t_type = "CCControlButton",			t_data = "pokerEditor3"},
	{obj_name = "poker4",		t_type = "CCControlButton",			t_data = "pokerEditor4"},
	{obj_name = "poker5",		t_type = "CCControlButton",			t_data = "pokerEditor5"},

	--下一步
	{obj_name = "nextButton",	t_type = "CCControlButton",			t_data = "nextButtonClicked"}
}
G_Node_list.G_Func_Register(ui_obj_list, "createPoker_obj")