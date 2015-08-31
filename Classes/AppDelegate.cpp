#include "cocos2d.h"
#include "CCEGLView.h"
#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "Lua_extensions_CCB.h"

#include "lua_helperClass.h"

#include "cocos-ext.h"

#include "lua_extensions.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif

using namespace CocosDenshion;

USING_NS_CC;

USING_NS_CC_EXT;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());

    // turn on display FPS
    pDirector->setDisplayStats(false);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);

	CCEGLView::sharedOpenGLView() -> setDesignResolutionSize(576, 1024, kResolutionExactFit);

	CCFileUtils::sharedFileUtils() -> addSearchPath("cocostudio");
	CCFileUtils::sharedFileUtils() -> addSearchPath("cocostudio/Resources");
	CCFileUtils::sharedFileUtils() -> addSearchPath("poker");

    // register lua engine
    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
    
	CCLuaStack *pStack = pEngine->getLuaStack();
	
	pStack -> addSearchPath("lua");
	pStack -> addSearchPath("lua/manager");
	pStack -> addSearchPath("lua/ui");
	pStack -> addSearchPath("lua/data");
    lua_State *tolua_s = pStack->getLuaState();
	luaopen_lua_extensions(tolua_s);
	//tolua_extensions_ccb_open(tolua_s);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    pStack = pEngine->getLuaStack();
    tolua_s = pStack->getLuaState();
    tolua_web_socket_open(tolua_s);
	tolua_s = pStack ->getLuaState();
	tolua_My_open(tolua_s);
#endif
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_BLACKBERRY)
    CCFileUtils::sharedFileUtils()->addSearchPath("script");
#endif

    std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("hello.lua");
    pEngine->executeScriptFile(path.c_str());

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();

    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();

    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
