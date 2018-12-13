//
//  HDWebURLProtocol.h
//  HDWebViewExtension
//
//  Created by lzh on 2018/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDWebURLProtocol : NSURLProtocol

/**
 需要在较早时机调用此方法，开启对url的拦截
 */
+ (void)registerClass;

@end

NS_ASSUME_NONNULL_END
