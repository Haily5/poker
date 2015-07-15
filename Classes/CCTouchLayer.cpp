#include "CCTouchLayer.h"


CCTouchLayer::CCTouchLayer(void)
{
}


CCTouchLayer::~CCTouchLayer(void)
{
	CCLOG("delete CCTouchLayer");
}

bool CCTouchLayer::init(int TouchPriority)
{
	if (!CCLayer::init()) return false;
	m_TouchPriority = TouchPriority;
	return true;
}

CCTouchLayer* CCTouchLayer::create(int TouchPriority)
{
	CCTouchLayer *pRet = new CCTouchLayer();
	if (pRet && pRet -> init(TouchPriority))
	{
		pRet -> autorelease();
	}
	else
	{
		CC_SAFE_DELETE(pRet);
		pRet = NULL;
	}
	return pRet;
}

void CCTouchLayer::onEnter()
{
	CCDirector::sharedDirector() -> getTouchDispatcher() -> addTargetedDelegate(this, m_TouchPriority, true);
}
void CCTouchLayer::onExit()
{
	CCDirector::sharedDirector() -> getTouchDispatcher() -> removeDelegate(this);
}

bool CCTouchLayer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	return true;
}
void CCTouchLayer::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{

}
void CCTouchLayer::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
	
}
void CCTouchLayer::ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent)
{

}

