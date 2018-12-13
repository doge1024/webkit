//
//  NSURLProtocol+HDWebKitSupport.h
//  HDWebViewExtension
//
//  Created by lzh on 2018/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLProtocol (HDWebKitSupport)

+ (void)wk_registerScheme:(NSString *)scheme;

+ (void)wk_unregisterScheme:(NSString *)scheme;

@end

NS_ASSUME_NONNULL_END
