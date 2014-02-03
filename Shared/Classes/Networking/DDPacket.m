//
//  DTDPacket.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/25/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacket.h"
#import "DDPacketStartDanceMoveDance.h"
#import "DDPacketSendResults.h"

const size_t PACKET_HEADER_SIZE = 10;

@implementation DDPacket

+ (id)packetWithType:(PacketType)packetType
{
	return [[[self class] alloc] initWithType:packetType];
}

- (id)initWithType:(PacketType)packetType
{
	if ((self = [super init]))
	{
		self.packetType = packetType;
	}
	return self;
}

+ (id)packetWithData:(NSData *)data
{
	if ([data length] < PACKET_HEADER_SIZE)
	{
		NSLog(@"Error: Packet too small");
		return nil;
	}
    
	if ([data rw_int32AtOffset:0] != 'DTD!')
	{
		NSLog(@"Error: Packet has invalid header");
		return nil;
	}
    
//	int packetNumber = [data rw_int32AtOffset:4];
	PacketType packetType = [data rw_int16AtOffset:8];
    
	DDPacket *packet;
    
	switch (packetType)
	{
        case PacketTypeStartDanceMoveDance:
            packet = [DDPacketStartDanceMoveDance packetWithData:data];
            break;
            
        case PacketTypeSendResults:
            packet = [DDPacketSendResults packetWithData:data];
            break;
            
		default:
			NSLog(@"Error: Packet has invalid type");
			return nil;
	}
    
	return packet;
}

- (NSData *)data
{
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
	[data rw_appendInt32:'DTD!'];   // 0x534E4150
	[data rw_appendInt32:0];
	[data rw_appendInt16:self.packetType];
    
    [self addPayloadToData:data];
	return data;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

- (void)addPayloadToData:(NSMutableData *)data
{
	// base class does nothing
}

- (NSDictionary *)dict
{
    // Override data in subclass
    NSDictionary *dict = @{@"type": @(self.packetType),
                           @"data":[NSNull null]};
    
    return dict;
}

@end
