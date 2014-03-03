//
//  DDEAvatarOrder.h
//  DoTheDancing
//
//  Created by Michael Gao on 3/2/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDEAvatarOrder : NSObject

@property (nonatomic) NSUInteger order;
@property (nonatomic, strong) SKSpriteNode *avatar;
@property (nonatomic, strong) DDPlayer *player;

- (instancetype)initWithAvatar:(SKSpriteNode *)avatar player:(DDPlayer *)player order:(NSUInteger)order;

@end
