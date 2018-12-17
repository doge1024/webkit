//
//  *@项目名称:  xywallet
//  *@文件名称:  FishMyHook.m
//  *@Date 2018/12/13
//  *@Author lzh 
//  *@Copyright © :  2014-2018 X-Financial Inc.   All rights reserved.
//  *注意：本内容仅限于小赢科技有限责任公内部传阅，禁止外泄以及用于其他的商业目的。
//

#import "FishMyHook.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>

@implementation FishMyHook

+ (void)load {
    const char *className = @"HDWebURLProtocol".UTF8String;
    Class WKCustomProtocolClass = objc_getClass(className);
    SEL af_startLoading = NSSelectorFromString(@"fix_startLoading");
    
    SEL startLoading = NSSelectorFromString(@"startLoading");
    
    BOOL add1 = class_addMethod(WKCustomProtocolClass,
                                startLoading,
                                class_getMethodImplementation(WKCustomProtocolClass, startLoading),
                                "v@:");
    
    BOOL add2 = class_addMethod(WKCustomProtocolClass,
                                af_startLoading,
                                (IMP)first_startLoading,
                                "v@:");
    
    NSLog(@"%d,%d", add1, add2);
    
    Method orgi = class_getClassMethod(WKCustomProtocolClass, startLoading);
    Method after = class_getClassMethod(WKCustomProtocolClass, af_startLoading);
    method_exchangeImplementations(orgi, after);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
void first_startLoading (id sender, SEL cmd) {
    SEL startLoading = NSSelectorFromString(@"fix_startLoading");
    [sender performSelector:startLoading];
}
#pragma clang diagnostic pop

@end
