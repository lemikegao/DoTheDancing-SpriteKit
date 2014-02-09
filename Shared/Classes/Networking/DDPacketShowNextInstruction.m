//
//  DDPacketShowNextInstruction.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/9/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacketShowNextInstruction.h"

@implementation DDPacketShowNextInstruction

+ (id)packetWithData:(NSData *)data
{
    int shouldShowNextInstruction = [data rw_int8AtOffset:PACKET_HEADER_SIZE];
    
	return [[self class] packetWithNextInstruction:@(shouldShowNextInstruction).boolValue];
}

+ (id)packetWithNextInstruction:(BOOL)shouldShowNextInstruction
{
	return [[[self class] alloc] initWithNextInstruction:shouldShowNextInstruction];
}

- (id)initWithNextInstruction:(BOOL)shouldShowNextInstruction
{
	if ((self = [super initWithType:PacketTypeShowNextInstruction]))
	{
		self.shouldShowNextInstruction = shouldShowNextInstruction;
	}
	return self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
    [data rw_appendInt8:@(self.shouldShowNextInstruction).intValue];
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [[super dict] mutableCopy];
    [dict setValue:@(self.shouldShowNextInstruction) forKey:@"data"];
    
    return [dict copy];
}

@end
