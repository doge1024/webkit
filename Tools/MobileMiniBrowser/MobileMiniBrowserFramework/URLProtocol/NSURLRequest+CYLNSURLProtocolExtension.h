//
//  *@项目名称:  MobileMiniBrowser
//  *@文件名称:  NSURLRequest+CYLNSURLProtocolExtension.h
//  *@Date 2018/12/17
//  *@Author lzh 
//  *@Copyright © :  2014-2018 X-Financial Inc.   All rights reserved.
//  *注意：本内容仅限于小赢科技有限责任公内部传阅，禁止外泄以及用于其他的商业目的。
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (CYLNSURLProtocolExtension)

- (NSURLRequest *)cyl_getPostRequestIncludeBody;

@end

NS_ASSUME_NONNULL_END
