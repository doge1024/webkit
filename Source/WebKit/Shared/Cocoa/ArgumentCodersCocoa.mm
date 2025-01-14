/*
 * Copyright (C) 2018 Apple Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "config.h"
#import "ArgumentCodersCocoa.h"

#if PLATFORM(COCOA)

#import "ArgumentCodersCF.h"
#import <pal/spi/cocoa/NSKeyedArchiverSPI.h>

namespace IPC {

void encodeObject(Encoder& encoder, id <NSSecureCoding> object)
{
    auto archiver = secureArchiver();
    [archiver encodeObject:object forKey:NSKeyedArchiveRootObjectKey];
    [archiver finishEncoding];

    IPC::encode(encoder, (__bridge CFDataRef)[archiver encodedData]);
}

std::optional<RetainPtr<id <NSSecureCoding>>> decodeObject(Decoder& decoder, NSArray<Class> *allowedClasses)
{
    RetainPtr<CFDataRef> data;
    if (!decode(decoder, data))
        return std::nullopt;

    auto unarchiver = secureUnarchiverFromData((__bridge NSData *)data.get());
    @try {
        id result = [unarchiver decodeObjectOfClasses:[NSSet setWithArray:allowedClasses] forKey:NSKeyedArchiveRootObjectKey];
        ASSERT(!result || [result conformsToProtocol:@protocol(NSSecureCoding)]);
        return { result };
    } @catch (NSException *exception) {
        LOG_ERROR("Failed to decode object of classes %@: %@", allowedClasses, exception);
        return std::nullopt;
    } @finally {
        [unarchiver finishDecoding];
    }
}

} // namespace IPC

#endif // PLATFORM(COCOA)
