//
//  DDTransitionToScene.h
//  DoTheDancing
//
//  Created by Michael Gao on 2/8/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacket.h"

@interface DDPacketTransitionToScene : DDPacket

@property (nonatomic) SceneTypes sceneType;

+(id)packetWithSceneType:(SceneTypes)sceneType;

@end
