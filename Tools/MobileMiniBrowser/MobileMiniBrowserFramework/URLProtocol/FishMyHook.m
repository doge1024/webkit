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
#import "NSObject+methodSwizzle.h"

@implementation NSURLProtocol (XXXX)

+ (NSURLRequest *)fix_canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

@end

@implementation FishMyHook

+ (void)load {
    
//    [self test];
    [self exchange];
//    [self aspectHook];
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
    
    Class WKCustomProtocolClass = object_getClass(NSClassFromString(@"WKCustomProtocol")); // HDWebURLProtocol
    
    SEL canInitWithRequest = NSSelectorFromString(@"canInitWithRequest:");
    SEL af_canInitWithRequest = NSSelectorFromString(@"fix_canInitWithRequest:");
    
    BOOL add1 = class_addMethod(WKCustomProtocolClass,
                                canInitWithRequest,
                                class_getMethodImplementation(WKCustomProtocolClass, canInitWithRequest),
                                "B@:@");
    
    BOOL add2 = class_addMethod([WKCustomProtocolClass class],
                                af_canInitWithRequest,
                                (IMP)af_canInitWithRequest2,
                                "B@:@");
    
    NSLog(@"%d,%d", add1, add2);
    
    Method orgi = class_getClassMethod(WKCustomProtocolClass, canInitWithRequest);
    Method after = class_getClassMethod(WKCustomProtocolClass, af_canInitWithRequest);
    
    method_exchangeImplementations(orgi, after);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

BOOL af_canInitWithRequest2(id sender, SEL cmd, NSURLRequest *req) {
    SEL canInitWithRequest = NSSelectorFromString(@"fix_canInitWithRequest:");
    return [sender performSelector:canInitWithRequest withObject:req];
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
