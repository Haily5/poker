--[[
	ui_pokerList_obj
	created: haily
]]


ui_obj_list = {

	--返回按钮
	{obj_name = "returnButton",	t_type = "CCControlButton",			t_data = "retrunClicked"},

	--热门标题
	{obj_name = "remen",		t_type = "CCSprite"},

	--牌谱列表
	{obj_name = "scroList",		t_type = "CCMultiColumnTableView" },

}
G_Node_list.G_Func_Register(ui_obj_list, "pokerList_obj")