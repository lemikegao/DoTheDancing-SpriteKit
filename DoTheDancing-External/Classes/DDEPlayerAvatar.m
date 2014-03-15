//
//  DDEAvatarOrder.m
//  DoTheDancing
//
//  Created by Michael Gao on 3/2/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDEPlayerAvatar.h"

@implementation DDEPlayerAvatar

- (instancetype)initWithAvatar:(SKSpriteNode *)avatar nameBg:(SKSpriteNode *)nameBg player:(DDPlayer *)player peerID:(MCPeerID *)peerID
{
    self = [super init];
    if (self)
    {
        _avatar = avatar;
        _nameBg = nameBg;
        _player = player;
        _peerID = peerID;
    }
    
    return self;
}

@end
