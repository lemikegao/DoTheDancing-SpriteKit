//
//  DDPacketShowDanceMoveInstructions.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/9/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacketShowDanceMoveInstructions.h"

@implementation DDPacketShowDanceMoveInstructions

+ (id)packetWithData:(NSData *)data
{
    DanceMoves danceMoveType = [data rw_int8AtOffset:PACKET_HEADER_SIZE];
    
	return [[self class] packetWithDanceMoveType:danceMoveType];
}

+ (id)packetWithDanceMoveType:(DanceMoves)danceMoveType
{
	return [[[self class] alloc] initWithDanceMoveType:danceMoveType];
}

- (id)initWithDanceMoveType:(DanceMoves)danceMoveType
{
	if ((self = [super initWithType:PacketTypeShowDanceMoveInstructions]))
	{
		self.danceMoveType = danceMoveType;
	}
	return self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
    [data rw_appendInt8:self.danceMoveType];
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [[super dict] mutableCopy];
    [dict setValue:@(self.danceMoveType) forKey:@"data"];
    
    return [dict copy];
}

@end
