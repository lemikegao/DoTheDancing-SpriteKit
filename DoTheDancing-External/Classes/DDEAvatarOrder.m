//
//  DDEAvatarOrder.m
//  DoTheDancing
//
//  Created by Michael Gao on 3/2/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDEAvatarOrder.h"

@implementation DDEAvatarOrder

- (instancetype)initWithAvatar:(SKSpriteNode *)avatar player:(DDPlayer *)player order:(NSUInteger)order
{
    self = [super init];
    if (self)
    {
        _avatar = avatar;
        _player = player;
        _order = order;
    }
    
    return self;
}

@end
