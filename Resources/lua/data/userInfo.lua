UserInfo = {}

actionName = 
{
	["scroPerFlop"] = {["next"] = "scroFlop"},
	["scroFlop"] = {["next"] = "scrolTurn", ["back"] = "scroPerFlop"},
	["scrolTurn"] = {["next"] = "scroRiver", ["back"] = "scroFlop"},
	["scroRiver"] = {["back"] = "scrolTurn"},
}

--我的牌谱
local userPokerList = {}

--获取用户ID	
function UserInfo:getUserId()
	local userId = CCUserDefault:sharedUserDefault():getStringForKey("userId")
	if string.len(userId) ~= 0 then
		return userId
	end
end

--设置用户ID
function UserInfo:setUserId(userId)
	if userId then
		CCUserDefault:sharedUserDefault():setStringForKey("userId", userId)
	else
		CCUserDefault:sharedUserDefault():setStringForKey("userId", "")
	end
end

--[[
	--黑桃 1 - 13
	--梅桃 14 - 26
	--红花 27 - 39
	--方块 40 - 52
]]

--牌型数据
pokerData = nil

local pokerPool = {}

--重置牌
function UserInfo:resetPokerPool()
	pokerPool = {}
	for i=1,52 do
		table.insert(pokerPool, i)
	end

	pokerData = {
		["pokerInfo"] = {},
		["usersInfo"] = {},
		["publicPoker"] = {},
		["steps"] = {},
	}
	pokerData["steps"]["scroPerFlop"] = {}
	pokerData["steps"]["scroFlop"] = {}
	pokerData["steps"]["scrolTurn"] = {}
	pokerData["steps"]["scroRiver"] = {}
	cloneNamesArray = clone(namesArray)
end

--选择牌
function UserInfo:selectPoker(selectPoker )
	if #pokerPool == 0 then UserInfo:resetPokerPool() end

	for i,poker in ipairs(pokerPool) do
		if poker == selectPoker then
			table.remove(pokerPool, i)
			i = i + 1
		end
	end

end

--获得剩余牌
function UserInfo:getPokerPool(defualtPoker)
	if #pokerPool == 0 then UserInfo:resetPokerPool() end
	if defualtPoker then
		table.insert(pokerPool, defualtPoker)
		table.sort(pokerPool)
	end
	return pokerPool
end

--生成牌UI
function UserInfo:createPokerUI( value )
	local pokerColor = "paiBg" .. math.floor( (value - 1) / 13) .. ".png"
	local poker = CCSprite:create(pokerColor)
	local number = "n"
	if value < 27 then
		number = "nn"
	end
	local numValue = CCSprite:create(number ..  (value - 1) % 13 + 1 .. ".png")
	poker:addChild(numValue)
	numValue:setPosition(ccp (15, 75))
	poker:setPosition(ccp(35, 47))
	return poker
end

--生成牌UI按钮
function UserInfo:createPoker(value, callback)
	local pokerColor = "paiBg" .. math.floor( (value - 1) / 13) .. ".png"
	local spritenormal = CCScale9Sprite:create(pokerColor)
	local spritepressed = CCScale9Sprite:create(pokerColor)
	spritepressed:setColor(ccc3(150,150,150))
	local spritedisable = CCScale9Sprite:create(pokerColor)

	local button = CCControlButton:create(spritenormal)
	button:setBackgroundSpriteForState(spritepressed,CCControlStateHighlighted)
	button:setBackgroundSpriteForState(spritedisable,CCControlStateDisabled)
	button:setPreferredSize(CCSizeMake(70, 94))
	if callback then
		button:addHandleOfControlEvent(callback, CCControlEventTouchUpInside)
	end
	button:setTag(value)

	local number = "n"
	if value < 27 then
		number = "nn"
	end
	local numValue = CCSprite:create(number ..  (value - 1) % 13 + 1 .. ".png")
	button:addChild(numValue)
	numValue:setPosition(ccp (15, 75))

	return button
end

--[[
	一次牌数据
	table{
		pokerInfo = {
			name = "牌局名称",
			level= "最大盲数值",
			pokerId = userid_time,
			time = "创建时间",
			hotLevel = "热门度",
		},
		usersInfo = {
			[
				name = "玩家01",
				index = 1,
				pokers = [
					1 , 2
				],
				jetton = "筹码数量",
				sb = 0,
			],
			......
		},
		publicPoker = {
			flop = [3, 4, 5],
			turn = 6,
			river = 7,
		},
		steps = [
			scroPerFlop = [
				{
					index = 1,
					action = "fold"	,
					jetton = 100 消耗数量
				},
				{
					index = 2,
					action = "call"	,
					jetton = 200 消耗数量
				},
			],
			scroFlop =[
				{
					index = 2,
					action = "call"	,
					jetton = 200 消耗数量
				},
			],
		],
	}
]]
local function getFilePath()
	local filePath = CCFileUtils:sharedFileUtils():getWritablePath()
	filePath = string.format("%s/pokerList", filePath)
	print("filePath:", filePath) 
	return filePath
end
local function getMyPokerListString()
	local filePath = getFilePath()
	local pokerString = io.readfile(filePath)
	print("pokerString:", pokerString)
	return pokerString
end

local function savePoker()
	local filePath = getFilePath()
	if #userPokerList > 0 then
		local pokerString = cjson.encode(userPokerList)
		
		io.writefile(filePath, pokerString)
	else
		io.writefile(filePath, "")
	end
end

function UserInfo:initMyPokerList()
	local pokerString = getMyPokerListString()
	if pokerString and string.len(pokerString) > 0 then
		userPokerList = cjson.decode(pokerString)
	end
end

function UserInfo:addPoker(poker)
	table.insert(userPokerList, poker)
	savePoker()
end

function UserInfo:deletePoker( index )
	table.remove(userPokerList, index)
	savePoker()
end
function UserInfo:getMyPokerList()
	return userPokerList
end

--总共9个玩家
namesArray = {"SB", "BB", "UTG", "UTG+1", "UTG+2", "MP1", "MP2", "CO", "D"}
namesIndex = {
	["SB"] = 1, 
	["BB"] = 2, 
	["UTG"] = 3, 
	["UTG+1"] = 4, 
	["UTG+2"] = 5, 
	["MP1"] = 6, 
	["MP2"] = 7, 
	["CO"] = 8, 
	["D"] = 9,
}
cloneNamesArray = nil
