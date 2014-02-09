//
//  DDTransitionToScene.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/8/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacketTransitionToScene.h"

@implementation DDPacketTransitionToScene

+ (id)packetWithData:(NSData *)data
{
    SceneTypes sceneType = [data rw_int8AtOffset:PACKET_HEADER_SIZE];
    
	return [[self class] packetWithSceneType:sceneType];
}

+ (id)packetWithSceneType:(SceneTypes)sceneType
{
	return [[[self class] alloc] initWithSceneType:sceneType];
}

- (id)initWithSceneType:(SceneTypes)sceneType
{
	if ((self = [super initWithType:PacketTypeTransitionToScene]))
	{
		self.sceneType = sceneType;
	}
	return self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
    [data rw_appendInt8:self.sceneType];
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [[super dict] mutableCopy];
    [dict setValue:@(self.sceneType) forKey:@"data"];
    
    return [dict copy];
}

@end
