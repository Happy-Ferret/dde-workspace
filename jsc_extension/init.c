
#include "jsextension.h"
#include <JavaScriptCore/JSStringRef.h>
extern JSClassRef get_Desktop_class();
extern JSClassRef get_DBus_class();
extern JSClassRef get_Core_class();

JSGlobalContextRef global_ctx = NULL;

JSGlobalContextRef get_global_context()
{
    return global_ctx;
}
void init_js_extension(JSGlobalContextRef context, struct DDesktopData* data)
{
    global_ctx = context;
    JSObjectRef global_obj = JSContextGetGlobalObject(context);
    JSObjectRef class_Desktop  = JSObjectMake(context, get_Desktop_class(), (void*)data);

    
    JSObjectRef class_DBus = JSObjectMake(context, get_DBus_class(), (void*)data);
    JSStringRef str_DBus = JSStringCreateWithUTF8CString("DBus");
    JSObjectSetProperty(context, class_Desktop, str_DBus, class_DBus,
            kJSClassAttributeNone, NULL);
    JSStringRelease(str_DBus);

    JSObjectRef class_Core = JSObjectMake(context, get_Core_class(), (void*)data);
    JSStringRef str_Core = JSStringCreateWithUTF8CString("Core");
    JSObjectSetProperty(context, class_Desktop, str_Core, class_Core,
            kJSClassAttributeNone, NULL);
    JSStringRelease(str_Core);


    JSStringRef str = JSStringCreateWithUTF8CString("Desktop");
    JSObjectSetProperty(context, global_obj, str, class_Desktop,
            kJSClassAttributeNone, NULL);
    JSStringRelease(str);
}
