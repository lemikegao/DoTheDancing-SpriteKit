//
//  DDPacketHostParty.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/23/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacketHostParty.h"

@implementation DDPacketHostParty

+ (id)packetWithData:(NSData *)data
{
    size_t count;
    DDPlayerColor playerColor = [data rw_int8AtOffset:PACKET_HEADER_SIZE];
    NSString *nickname = [data rw_stringAtOffset:PACKET_HEADER_SIZE+1 bytesRead:&count];
    
    return [[self class] packetWithPlayerColor:playerColor nickname:nickname];
}

+ (id)packetWithPlayerColor:(DDPlayerColor)playerColor nickname:(NSString *)nickname
{
    return [[[self class] alloc] initWithPlayerColor:playerColor nickname:nickname];
}

- (id)initWithPlayerColor:(DDPlayerColor)playerColor nickname:(NSString *)nickname
{
    if ((self = [super initWithType:PacketTypeHostParty]))
    {
        self.playerColor = playerColor;
        self.nickname = nickname;
    }
    
    return self;
}

- (void)addPlayloadToData:(NSMutableData *)data
{
    [data rw_appendInt8:self.playerColor];
    [data rw_appendString:self.nickname];
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [[super dict] mutableCopy];
    [dict setValue:@(self.playerColor) forKey:@"playerColor"];
    [dict setValue:self.nickname forKey:@"nickname"];
    
    return [dict copy];
}

@end
