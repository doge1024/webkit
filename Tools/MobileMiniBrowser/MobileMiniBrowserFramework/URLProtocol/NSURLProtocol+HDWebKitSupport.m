//
//  NSURLProtocol+HDWebKitSupport.m
//  HDWebViewExtension
//
//  Created by lzh on 2018/8/20.
//

#import "NSURLProtocol+HDWebKitSupport.h"
#import <WebKit/WebKit.h>

@implementation NSURLProtocol (HDWebKitSupport)

/**
 * The functions below use some undocumented APIs, which may lead to rejection by Apple.
 */

FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        cls = NSClassFromString([NSString stringWithFormat:@"%@%@%@%@%@", @"W", @"K", @"Browsing", @"Context", @"Controller"]);
        //        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
        if (!cls) {
            NSLog(@"WKWebView (SupportProtocol) has invalid cls or sel");
        }
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

+ (void)wk_registerScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)wk_unregisterScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}


@end
