//
//  *@项目名称:  MobileMiniBrowser
//  *@文件名称:  NSURLRequest+CYLNSURLProtocolExtension.m
//  *@Date 2018/12/17
//  *@Author lzh 
//  *@Copyright © :  2014-2018 X-Financial Inc.   All rights reserved.
//  *注意：本内容仅限于小赢科技有限责任公内部传阅，禁止外泄以及用于其他的商业目的。
//

#import "NSURLRequest+CYLNSURLProtocolExtension.h"

@implementation NSURLRequest (CYLNSURLProtocolExtension)

- (NSURLRequest *)cyl_getPostRequestIncludeBody {
    return [[self cyl_getMutablePostRequestIncludeBody] copy];
}

- (NSMutableURLRequest *)cyl_getMutablePostRequestIncludeBody {
    NSMutableURLRequest *req = (NSMutableURLRequest *)self;
    if (![self isKindOfClass:[NSMutableURLRequest class]]) {
        req = [self mutableCopy];
    }

    if ([self.HTTPMethod isEqualToString:@"POST"]) {
        if (!self.HTTPBody) {
            NSInteger maxLength = 1024;
            uint8_t d[maxLength];
            NSInputStream *stream = self.HTTPBodyStream;
            NSMutableData *data = [[NSMutableData alloc] init];
            [stream open];
            BOOL endOfStreamReached = NO;
            //不能用 [stream hasBytesAvailable]) 判断，处理图片文件的时候这里的[stream hasBytesAvailable]会始终返回YES，导致在while里面死循环。
            while (!endOfStreamReached) {
                NSInteger bytesRead = [stream read:d maxLength:maxLength];
                if (bytesRead == 0) { //文件读取到最后
                    endOfStreamReached = YES;
                } else if (bytesRead == -1) { //文件读取错误
                    endOfStreamReached = YES;
                } else if (stream.streamError == nil) {
                    [data appendBytes:(void *)d length:bytesRead];
                }
            }
            req.HTTPBody = [data copy];
            [stream close];
        }
        
    }
    return req;
}

@end
