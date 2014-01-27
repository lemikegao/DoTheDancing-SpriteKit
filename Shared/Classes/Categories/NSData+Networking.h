//
//  NSData+Networking.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/25/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

@interface NSData (Networking)

- (int)rw_int32AtOffset:(size_t)offset;
- (short)rw_int16AtOffset:(size_t)offset;
- (char)rw_int8AtOffset:(size_t)offset;
- (NSString *)rw_stringAtOffset:(size_t)offset bytesRead:(size_t *)amount;

@end

@interface NSMutableData (Networking)

- (void)rw_appendInt32:(int)value;
- (void)rw_appendInt16:(short)value;
- (void)rw_appendInt8:(char)value;
- (void)rw_appendString:(NSString *)string;

@end