//
//  DTDPacket.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/25/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "NSData+Networking.h"

typedef enum
{
    PacketTypeSendResults = 0x64,               // controller to external
    PacketTypeTransitionToScene,                // external <> controller
    PacketTypeShowDanceMoveInstructions,        // external <> controller
    PacketTypeShowNextInstruction,              // external <> controller
    PacketTypeHostParty,                        // controller to external
    PacketTypeJoinParty,                        // controller to external
}
PacketType;

extern const size_t PACKET_HEADER_SIZE;

@interface DDPacket : NSObject

@property (nonatomic) PacketType packetType;

+ (id)packetWithType:(PacketType)packetType;
- (id)initWithType:(PacketType)packetType;

+ (id)packetWithData:(NSData *)data;
- (NSData *)data;
- (NSDictionary *)dict;

@end
