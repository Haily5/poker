--[[
	ui_decstop_obj
	created: haily
]]


ui_obj_list = {
	--返回键
	{obj_name = "returnButton",		t_type = "CCControlButton",		t_data = "returnButtonClicked"},

	--分享
	{obj_name = "shareButton",		t_type = "CCControlButton",		t_data = "shareButtonClicked"},

	--上一步
	{obj_name = "backButton",		t_type = "CCControlButton",		t_data = "backButtonClicked"},

	--下一步
	{obj_name = "nextButton",		t_type = "CCControlButton",		t_data = "nextButtonClicked"},

	--牌谱名称
	{obj_name = "pokerName",		t_type = "CCLabelTTF"},

	--9个位置
	{obj_name = "player1",			t_type = "CCLayer"},
	{obj_name = "player2",			t_type = "CCLayer"},
	{obj_name = "player3",			t_type = "CCLayer"},

	{obj_name = "player4",			t_type = "CCLayer"},
	{obj_name = "player5",			t_type = "CCLayer"},
	{obj_name = "player6",			t_type = "CCLayer"},

	{obj_name = "player7",			t_type = "CCLayer"},
	{obj_name = "player8",			t_type = "CCLayer"},
	{obj_name = "player9",			t_type = "CCLayer"},

	--公共牌层
	{obj_name = "public1",			t_type = "CCLayer"},
	{obj_name = "public2",			t_type = "CCLayer"},

	--桌面层
	{obj_name = "decstopLayer",		t_type = "CCLayer"},

	--pool
	{obj_name = "PoolValue", 		t_type = "CCLabelTTF"},
}
G_Node_list.G_Func_Register(ui_obj_list, "decstop_obj")