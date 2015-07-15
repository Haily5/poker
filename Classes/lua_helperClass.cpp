/*
** Lua binding: My
** Generated automatically by tolua++-1.0.92 on 06/28/15 18:26:44.
*/

extern "C" {
#include "tolua_fix.h"
}

#include <map>
#include <string>
#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos-ext.h"

using namespace cocos2d;
using namespace cocos2d::extension;
using namespace CocosDenshion;

#include "CCTouchLayer.h"

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
#ifndef Mtolua_typeid
#define Mtolua_typeid(L,TI,T)
#endif
 tolua_usertype(tolua_S,"CCEvent");
 Mtolua_typeid(tolua_S,typeid(CCEvent), "CCEvent");
 tolua_usertype(tolua_S,"CCTouchLayer");
 Mtolua_typeid(tolua_S,typeid(CCTouchLayer), "CCTouchLayer");
 tolua_usertype(tolua_S,"CCLayer");
 Mtolua_typeid(tolua_S,typeid(CCLayer), "CCLayer");
 tolua_usertype(tolua_S,"CCTouch");
 Mtolua_typeid(tolua_S,typeid(CCTouch), "CCTouch");
}

/* method: init of class  CCTouchLayer */
#ifndef TOLUA_DISABLE_tolua_My_CCTouchLayer_init00
static int tolua_My_CCTouchLayer_init00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCTouchLayer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCTouchLayer* self = (CCTouchLayer*)  tolua_tousertype(tolua_S,1,0);
  int TouchPriority = ((int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'init'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->init(TouchPriority);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'init'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: create of class  CCTouchLayer */
#ifndef TOLUA_DISABLE_tolua_My_CCTouchLayer_create00
static int tolua_My_CCTouchLayer_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCTouchLayer",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  int TouchPriority = ((int)  tolua_tonumber(tolua_S,2,0));
  {
   CCTouchLayer* tolua_ret = (CCTouchLayer*)  CCTouchLayer::create(TouchPriority);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCTouchLayer");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'create'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ccTouchBegan of class  CCTouchLayer */
#ifndef TOLUA_DISABLE_tolua_My_CCTouchLayer_ccTouchBegan00
static int tolua_My_CCTouchLayer_ccTouchBegan00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCTouchLayer",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"CCTouch",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"CCEvent",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCTouchLayer* self = (CCTouchLayer*)  tolua_tousertype(tolua_S,1,0);
  CCTouch* pTouch = ((CCTouch*)  tolua_tousertype(tolua_S,2,0));
  CCEvent* pEvent = ((CCEvent*)  tolua_tousertype(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ccTouchBegan'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->ccTouchBegan(pTouch,pEvent);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ccTouchBegan'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ccTouchMoved of class  CCTouchLayer */
#ifndef TOLUA_DISABLE_tolua_My_CCTouchLayer_ccTouchMoved00
static int tolua_My_CCTouchLayer_ccTouchMoved00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCTouchLayer",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"CCTouch",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"CCEvent",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCTouchLayer* self = (CCTouchLayer*)  tolua_tousertype(tolua_S,1,0);
  CCTouch* pTouch = ((CCTouch*)  tolua_tousertype(tolua_S,2,0));
  CCEvent* pEvent = ((CCEvent*)  tolua_tousertype(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ccTouchMoved'", NULL);
#endif
  {
   self->ccTouchMoved(pTouch,pEvent);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ccTouchMoved'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ccTouchEnded of class  CCTouchLayer */
#ifndef TOLUA_DISABLE_tolua_My_CCTouchLayer_ccTouchEnded00
static int tolua_My_CCTouchLayer_ccTouchEnded00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCTouchLayer",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"CCTouch",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"CCEvent",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCTouchLayer* self = (CCTouchLayer*)  tolua_tousertype(tolua_S,1,0);
  CCTouch* pTouch = ((CCTouch*)  tolua_tousertype(tolua_S,2,0));
  CCEvent* pEvent = ((CCEvent*)  tolua_tousertype(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ccTouchEnded'", NULL);
#endif
  {
   self->ccTouchEnded(pTouch,pEvent);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ccTouchEnded'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: ccTouchCancelled of class  CCTouchLayer */
#ifndef TOLUA_DISABLE_tolua_My_CCTouchLayer_ccTouchCancelled00
static int tolua_My_CCTouchLayer_ccTouchCancelled00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCTouchLayer",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"CCTouch",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,3,"CCEvent",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCTouchLayer* self = (CCTouchLayer*)  tolua_tousertype(tolua_S,1,0);
  CCTouch* pTouch = ((CCTouch*)  tolua_tousertype(tolua_S,2,0));
  CCEvent* pEvent = ((CCEvent*)  tolua_tousertype(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'ccTouchCancelled'", NULL);
#endif
  {
   self->ccTouchCancelled(pTouch,pEvent);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'ccTouchCancelled'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_My_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"CCTouchLayer","CCTouchLayer","CCLayer",NULL);
  tolua_beginmodule(tolua_S,"CCTouchLayer");
   tolua_function(tolua_S,"init",tolua_My_CCTouchLayer_init00);
   tolua_function(tolua_S,"create",tolua_My_CCTouchLayer_create00);
   tolua_function(tolua_S,"ccTouchBegan",tolua_My_CCTouchLayer_ccTouchBegan00);
   tolua_function(tolua_S,"ccTouchMoved",tolua_My_CCTouchLayer_ccTouchMoved00);
   tolua_function(tolua_S,"ccTouchEnded",tolua_My_CCTouchLayer_ccTouchEnded00);
   tolua_function(tolua_S,"ccTouchCancelled",tolua_My_CCTouchLayer_ccTouchCancelled00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_My (lua_State* tolua_S) {
 return tolua_My_open(tolua_S);
};
#endif