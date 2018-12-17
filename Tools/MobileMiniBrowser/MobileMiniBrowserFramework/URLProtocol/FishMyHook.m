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
#import "Aspects.h"
#import "NSURLRequest+CYLNSURLProtocolExtension.h"

@implementation NSURLProtocol (XXXX)

+ (NSURLRequest *)fix_canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

@end

@implementation FishMyHook

+ (void)load {
    
//    [self test];
//    [self exchange];
    [self aspectHook];
}

+ (void)aspectHook {
    NSError *err = nil;
    Class NSURLSessionLocal = NSClassFromString(@"__NSURLSessionLocal");
    [NSURLSessionLocal aspect_hookSelector:NSSelectorFromString(@"_protocolClassForTask:") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        NSLog(@"");
    } error:&err];
    
    [NSURLSessionLocal aspect_hookSelector:NSSelectorFromString(@"_createCanonicalRequestForTask:") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        NSLog(@"");
    } error:&err];
    
    [NSURLSessionLocal aspect_hookSelector:NSSelectorFromString(@"_onqueue_canonicalizeTaskAndCreateConnection:") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        
        NSLog(@"");
    } error:&err];
    
    Class __NSCFLocalSessionTask = NSClassFromString(@"__NSCFLocalSessionTask");
    [__NSCFLocalSessionTask aspect_hookSelector:NSSelectorFromString(@"_onqueue_completeInitialization") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"");
    } error:&err];
    
    Class WKCustomProtocol = [NSClassFromString(@"WKCustomProtocol") class];
    [WKCustomProtocol aspect_hookSelector:NSSelectorFromString(@"canInitWithRequest:") withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"");
    } error:&err];
    
}

+ (void)exchange {
    const char *className = @"NSURLRequest".UTF8String;
    Class WKCustomProtocolClass = objc_getClass(className);
    SEL af_startLoading = NSSelectorFromString(@"fix_mutableCopy");
    
    SEL startLoading = NSSelectorFromString(@"mutableCopy");
    
    BOOL add1 = class_addMethod(WKCustomProtocolClass,
                                startLoading,
                                class_getMethodImplementation(WKCustomProtocolClass, startLoading),
                                "@@:");
    
    BOOL add2 = class_addMethod(WKCustomProtocolClass,
                                af_startLoading,
                                class_getMethodImplementation(WKCustomProtocolClass, af_startLoading),
                                "@@:");
    
    NSLog(@"%d,%d", add1, add2);
    
    //    Method orgi = class_getInstanceMethod(WKCustomProtocolClass, startLoading);
    //    Method after = class_getInstanceMethod(WKCustomProtocolClass, af_startLoading);
    Method orgi = class_getClassMethod(WKCustomProtocolClass, startLoading);
    Method after = class_getClassMethod(WKCustomProtocolClass, af_startLoading);
    
    method_exchangeImplementations(orgi, after);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
NSURLRequest * first_startLoading (id sender, SEL cmd, NSURLRequest *req) {
    SEL startLoading = NSSelectorFromString(@"fix_mutableCopy");
    return [sender performSelector:startLoading];
}
#pragma clang diagnostic pop

+ (void)test {
    const char *className = @"_NSURLHTTPProtocol".UTF8String;
    Class WKCustomProtocolClass = objc_getClass(className);
    unsigned int count;
    Method *methods = class_copyMethodList([WKCustomProtocolClass class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        NSLog(@"method_getName:%@",name);
    }
    free(methods);
}

@end
