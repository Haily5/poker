#pragma once
#include "cocos2d.h"

USING_NS_CC;
class CCTouchLayer :
	public CCLayer
{
public:
	CCTouchLayer(void);
	virtual ~CCTouchLayer(void);

	bool init(int TouchPriority);
	static CCTouchLayer* create(int TouchPriority);

	virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
    virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
    virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
    virtual void ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent);

	virtual void onEnter();
	virtual void onExit();

private:
	int m_TouchPriority;
};

