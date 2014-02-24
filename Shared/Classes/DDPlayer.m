//
//  DDPlayer.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/23/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPlayer.h"

@implementation DDPlayer

+ (instancetype)playerWithPlayerColor:(DDPlayerColor)playerColor nickname:(NSString *)nickname
{
    return [[[self class] alloc] initWithPlayerColor:playerColor nickname:nickname];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _playerColor = DDPlayerColorNone;
    }
    
    return self;
}

- (instancetype)initWithPlayerColor:(DDPlayerColor)playerColor nickname:(NSString *)nickname
{
    self = [self init];
    if (self)
    {
        _playerColor = playerColor;
        _nickname = nickname;
    }
    
    return self;
}

@end
