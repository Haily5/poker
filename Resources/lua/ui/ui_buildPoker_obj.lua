 --[[
	ui_buildPoker_obj
	created: haily
]]


ui_obj_list = {

	--返回按钮
	{obj_name = "returnButton",	t_type = "CCControlButton",			t_data = "retrunClicked"},

	--滚动层
	{obj_name = "scroPerFlop",	t_type = "CCMultiColumnTableView"},
	{obj_name = "scroFlop",		t_type = "CCMultiColumnTableView"},
	{obj_name = "scrolTurn",	t_type = "CCMultiColumnTableView"},
	{obj_name = "scroRiver",	t_type = "CCMultiColumnTableView"},

	--完成
	{obj_name = "doneButton",	t_type = "CCControlButton",		t_data = "doneClicked"},
}
G_Node_list.G_Func_Register(ui_obj_list, "buildPoker_obj")