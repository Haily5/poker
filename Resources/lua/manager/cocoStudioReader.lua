--[[------------------------------------------]]--
--[[------------------------------------------]]--
--[[--   created:    2013.10.1   13:14      --]]--
--[[--   filename:   cocoStudioReader.lua   --]]--
--[[--   author:     yanhaolee              --]]--
--[[--   purpose:    read cocostudio's json --]]--
--[[------------------------------------------]]--
--[[
  解析json 文件
]]
--JOSN缓存
UIDataBuffer = {
}

function ReaderStudioJson(filename, returnControls)
	if filename == "nillayer" then return CCLayer:create() end

	local function getUIData()
		if not UIDataBuffer[filename] then
			local datas = CCString:createWithContentsOfFile(filename):getCString()
			UIDataBuffer[filename] = cjson.decode(datas)
			print("json read done  " .. filename)
		end

		return UIDataBuffer[filename]
	end

	local tab = getUIData()

	local function isColorLabel(attribute)
		if attribute.classname == "TextArea" and string.match(attribute.name, "colorLabel") == "colorLabel" then
			return true
		else
			return false
		end
	end

	local function setAttribute(parent,parentname,obj,attribute)

		if attribute.classname ~= "Label" then
			obj:setContentSize(CCSizeMake(attribute.width,attribute.height))
		end
		obj:setAnchorPoint(ccp(attribute.anchorPointX,attribute.anchorPointY))

		if parentname == "Button" or parentname == "ImageView" then
			if  parent:getAnchorPoint().x == 0.5 then
				obj:setPositionX(parent:getContentSize().width/2 + attribute.x)
			elseif parent:getAnchorPoint().x == 1 then
				obj:setPositionX(parent:getContentSize().width + attribute.x)
			else
				obj:setPositionX(attribute.x)
			end
			if parent:getAnchorPoint().y == 0.5 then
				obj:setPositionY(parent:getContentSize().height/2 + attribute.y)
			elseif parent:getAnchorPoint().y == 1 then
				obj:setPositionY(parent:getContentSize().height + attribute.y)
			else
				obj:setPositionY(attribute.y)
			end
		elseif isColorLabel(attribute) then                                      --能否设置颜色
			obj:setPosition(ccp(attribute.x - attribute.areaWidth * attribute.anchorPointX,
				attribute.y - attribute.areaHeight * attribute.anchorPointY))
		else
			obj:setPosition(ccp(attribute.x,attribute.y))
		end
		if attribute.rotation ~= 0 then
			obj:setRotation(attribute.rotation)
		end

		obj:setTag(attribute.tag)
		obj:setScaleX(attribute.scaleX)
		obj:setScaleY(attribute.scaleY)
		obj:setZOrder(attribute.ZOrder)
		obj:setVisible(attribute.visible)
	end

	local function creatButton(parent,parentname,attribute,boltext)
		local spritenormal = nil
		local spritepressed = nil
		local spritedisable = nil

		if attribute.normalData.path ~= nil then
			spritenormal = CCScale9Sprite:create(attribute.normalData.path)
		end
		if attribute.pressedData.path ~= nil and type(attribute.pressedData.path) ~= "userdata"then
			spritepressed = CCScale9Sprite:create(attribute.pressedData.path)
			spritepressed:setColor(ccc3(150,150,150))
		end
		if attribute.disabledData.path ~= nil and type(attribute.disabledData.path) ~= "userdata" then
			spritedisable = CCScale9Sprite:create(attribute.disabledData.path)
		end
		local button = CCControlButton:create(spritenormal)
		if spritepressed ~= nil then
			button:setBackgroundSpriteForState(spritepressed,CCControlStateHighlighted)
		end
		if spritedisable ~= nil then
			button:setBackgroundSpriteForState(spritedisable,CCControlStateDisabled)
		end
		button:setPreferredSize(CCSizeMake(attribute.width,attribute.height))
		if attribute.text ~= nil and attribute.text ~= "" then

			-- local spritetitle = CCSprite:create(string.format("%s.png",attribute.text))
			-- button:addChild(spritetitle)
			-- spritetitle:setPosition(attribute.width/2,attribute.height/2)
			-- spritetitle:setTag(1)
			local label = CCLabelTTF:create(attribute.text, attribute.fontName, attribute.fontSize)
			label:setPosition(attribute.width/2,attribute.height/2)
			button:addChild(label)
		end

		button:setZoomOnTouchDown(false)
		return button
	end

	local function creatTextButton(parent,parentname,attribute)
		return creatButton(parent,parentname,attribute,true)
	end

	local function creatLabel(parent,parentname,attribute)
		local label
		if string.match(attribute.name, "colorLabel") == "colorLabel" then
			label = tolua.cast(CCWMEColorLabelTTF:create(attribute.text,attribute.fontName,attribute.fontSize, CCSizeMake(attribute.areaWidth,attribute.areaHeight)), "CCWMEColorLabelTTF")
		else
			label = CCLabelTTF:create(attribute.text,attribute.fontName,attribute.fontSize)
			if attribute.areaWidth and attribute.areaHeight then
				label:setDimensions(CCSizeMake(attribute.areaWidth,attribute.areaHeight))
			end

			if attribute.hAlignment then
				label:setHorizontalAlignment(attribute.hAlignment)
			end

			if attribute.vAlignment then
				label:setVerticalAlignment(attribute.vAlignment)
			end
		end
		return label
	end

	local function creatBMFontLabel(parent,parentname,attribute)
		local label = CCLabelBMFont:create(attribute.text,attribute.fileNameData.path)
		return label
	end

	local function creatTextArea(parent,parentname,attribute)
		local label
		if string.match(attribute.name, "colorLabel") == "colorLabel" then
			label = tolua.cast(CCWMEColorLabelTTF:create(attribute.text,attribute.fontName,attribute.fontSize, CCSizeMake(attribute.areaWidth,attribute.areaHeight)), "CCWMEColorLabelTTF")
		else
			label = CCLabelTTF:create(attribute.text,attribute.fontName,attribute.fontSize)
			if attribute.areaWidth and attribute.areaHeight then
				label:setDimensions(CCSizeMake(attribute.areaWidth,attribute.areaHeight))
			end

			if attribute.hAlignment then
				label:setHorizontalAlignment(attribute.hAlignment)
			end

			if attribute.vAlignment then
				label:setVerticalAlignment(attribute.vAlignment)
			end
		end
		return label
	end

	local function creatAtlasLabel(parent,parentname,attribute)
		local label = CCLabelAtlas:create(attribute.stringValue,attribute.charMapFileData.path,attribute.itemWidth,attribute.itemHeight,48)
		return label
	end

	local function creatSprite(parent,parentname,attribute)
		if attribute.fileNameData.path ~= nil then
			local img =nil
			if attribute.scale9Enable == false then
				img = CCSprite:create(attribute.fileNameData.path)
			else
				img = CCScale9Sprite:create(CCRect(attribute.capInsetsX , attribute.capInsetsY, attribute.capInsetsWidth, attribute.capInsetsHeight),attribute.fileNameData.path)
			end
			if attribute.flipX == true then
				img:setFlipX(true)
			end
			if attribute.flipY == true then
				img:setFlipY(true)
			end
			return img
		end
		return nil
	end

	local function creatInput(parent,parentname,attribute)

		local input = CCEditBox:create(CCSizeMake(attribute.width,attribute.height), CCScale9Sprite:create())
	    input:setFont(attribute.fontName,attribute.fontSize)
	    input:setPlaceHolder(attribute.placeHolder)
	    input:setFontColor(ccc3(attribute.colorR,attribute.colorG,attribute.colorB))
	    if attribute.maxLengthEnable == true then
	    	input:setMaxLength(attribute.maxLength)
		end
		if attribute.passwordEnable == true then
	    	input:setInputFlag(kEditBoxInputFlagPassword)
	    else
	    	input:setInputFlag(kEditBoxInputFlagSensitive)
		end
	    input:setInputMode(kEditBoxInputModeEmailAddr)
	    input:setReturnType(kKeyboardReturnTypeDone)
		return input
	end

	local function creatLoadingBar(parent,parentname,attribute)
		local sprite = CCSprite:create(attribute.textureData.path)
		local progressbar = CCProgressTimer:create(sprite)

	    if attribute.direction == 0 then
	    	progressbar:setMidpoint(ccp(0,0.5))
	    	progressbar:setBarChangeRate(ccp(1, 0))    			--设置进度条的长度和高度开始变化的大小
	    else
	    	progressbar:setMidpoint(ccp(1,0.5))
	    	progressbar:setBarChangeRate(ccp(1, 0))    			--设置进度条的长度和高度开始变化的大小
	    end

	    progressbar:setType(kCCProgressTimerTypeBar)    	--设置进度条为水平
	    progressbar:setPercentage(attribute.percent)  --设置初始百分比的值
	    return progressbar
	end

	local function creatSlider(parent,parentname,attribute)
		local slider = CCControlSlider:create(attribute.barFileNameData.path,attribute.progressBarData.path,attribute.ballNormalData.path)
		slider:setMinimumValue(0)
		slider:setMaximumValue(1)
		slider:setValue(attribute.percent*0.01)
		return slider
	end

	local function createUISlider( parent, parentname, attribute )
		local uiSlider = Slider:create()
		uiSlider:loadBarTexture(attribute.textureData.path)
		uiSlider:setPercent(attribute.percent)
		return uiSlider
	end

	local function creatCheckBox(parent,parentname,attribute)
		local normal = CCSprite:create(attribute.backGroundBoxData.path)
	    local selected = CCSprite:create(attribute.backGroundBoxSelectedData.path)
    	local normallable = CCSprite:create(attribute.frontCrossDisabledData.path)
		local selectlabel = CCSprite:create(attribute.frontCrossData.path)
		local disablelbael = CCSprite:create(attribute.backGroundBoxDisabledData.path)
    	normallable:setTag(1)
    	selectlabel:setTag(2)
		local checkbox = CCControlCheckBox:create(normal,selected,disablelbael ,normallable,selectlabel)
	    if parentname == "Panel" and parent:getTag() ~= 1 then
	    	checkbox:addGroup(parent)
	    end

	    return checkbox
	end

	local function creatScrollView(parent,parentname,attribute)
		local scrollview  = CCMultiColumnTableView:create(CCSizeMake(attribute.width,attribute.height))
		if attribute.direction == 1 then
			scrollview:setVerticalFillOrder(kCCTableViewFillTopDown)
		else
			scrollview:setVerticalFillOrder(kCCTableViewFillBottomUp)
		end
		return scrollview
    -- mBtnView:setMargin(CCSizeMake(0,8))
    -- mBtnView:setCellSize(CCSizeMake(146,50))
    -- mBtnView:setColCount(1)
    -- mBtnView:registerCellCreateScriptHandler(onCellCreated)
    -- mBtnView:initWithCellCount(6)
	end

	local function creatPanel(parent,parentname,attribute)
		local layer = nil
		if attribute.colorType == 1 then
			layer = CCLayerColor:create(ccc4(attribute.bgColorR,attribute.bgColorG,attribute.bgColorB,attribute.bgColorOpacity))
		else
		 	layer = CCNode:create()
		end
		return layer
	end

	--所有元素的集合
	local allChilden = {}

	local function getValues(data)
		local layer = CCLayer:create()
		local node  = CCNode:create()
		node:setTag(1)
		layer:addChild(node)

		local function _creator (parent,parentname,options)
			for k,v in pairs(options) do
				local child = nil
				if v.classname == "Button" then
					child = creatButton(parent,parentname,v.options,false)
				elseif v.classname == "ImageView" then
					child = creatSprite(parent,parentname,v.options)
				elseif v.classname == "Label" then
					child = creatLabel(parent,parentname,v.options)
				elseif v.classname == "LabelBMFont" then
					child =	creatBMFontLabel(parent,parentname,v.options)
				elseif v.classname == "LabelAtlas" then
					child =	creatAtlasLabel(parent,parentname,v.options)
				elseif v.classname == "TextArea" then
					child = creatTextArea(parent,parentname,v.options)
				elseif v.classname == "TextField" then
					child = creatInput(parent,parentname,v.options)
				elseif v.classname == "LoadingBar" then
					child = creatLoadingBar(parent,parentname,v.options)
				elseif v.classname == "CheckBox" then
					child = creatCheckBox(parent,parentname,v.options)
				elseif v.classname == "ScrollView" then
					child = creatScrollView(parent,parentname,v.options)
				elseif v.classname == "TextButton" then
					child = creatTextButton(parent,parentname,v.options)
				elseif v.classname == "Panel" then
					child = creatPanel(parent,parentname,v.options)
				else
					G_log_warning("type not found, the type is:", v.classname)
				end

				--added by taochen
				if returnControls and type(returnControls) == "table" then
					returnControls[v.options.name] = child
				end

				allChilden[v.options.name] = child

				if child ~= nil then
					parent:addChild(child)
					setAttribute(parent,parentname,child,v.options)
					if v.classname ~= "Panel" and
						v.classname ~= "TextButton" and
						v.classname ~= "Button" and
						v.classname ~= "ScrollView" then
							child:setColor(ccc3(v.options.colorR, v.options.colorG, v.options.colorB))
					end
				end
				if table.getn(v.children) ~= 0 then
					_creator(child,v.classname,v.children)
				end
			end
		end
		_creator(node,"Panel",data)
		return layer
	end

	return getValues(tab.widgetTree.children), allChilden
end
