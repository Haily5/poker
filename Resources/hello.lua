require "AudioEngine" 

cjson = require "cjson"
require "extern"
require "functions"

require "userInfo"

require "G_node_list"
require "cocoStudioReader"
require "widget_builder"
require "G_E_ui_enum"
require "G_ui_manager"

--ui
require "ui_login"
require "ui_pokerList"
require "ui_createPoker"
require "ui_buildPoker"
require "ui_listLayer"
require "ui_pokerListLayer"
require "ui_decstop"

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    G_UI_Manger.G_Func_showUI("login")
end

xpcall(main, __G__TRACKBACK__)
