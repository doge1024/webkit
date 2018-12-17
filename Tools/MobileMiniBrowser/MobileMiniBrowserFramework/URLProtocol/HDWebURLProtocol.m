//
//  HDWebURLProtocol.m
//  HDWebViewExtension
//
//  Created by lzh on 2018/8/20.
//

#import "HDWebURLProtocol.h"
#import "NSURLProtocol+HDWebKitSupport.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>

@implementation HDWebURLProtocol

+ (void)registerClass {
    [NSURLProtocol registerClass:[HDWebURLProtocol class]];
    [HDWebURLProtocol wk_registerScheme:@"http"];
    [HDWebURLProtocol wk_registerScheme:@"https"];
}


#pragma mark - override
+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    NSURLRequest *request = task.currentRequest;
    return [self canInitWithRequest:request];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    
}

- (void)stopLoading {
}

@end
