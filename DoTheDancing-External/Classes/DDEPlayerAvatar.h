//
//  DDEAvatarOrder.h
//  DoTheDancing
//
//  Created by Michael Gao on 3/2/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDEPlayerAvatar : NSObject

@property (nonatomic, strong) SKSpriteNode *avatar;
@property (nonatomic, strong) SKSpriteNode *nameBg;
@property (nonatomic, strong) DDPlayer *player;
@property (nonatomic, strong) MCPeerID *peerID;

- (instancetype)initWithAvatar:(SKSpriteNode *)avatar nameBg:(SKSpriteNode *)nameBg player:(DDPlayer *)player peerID:(MCPeerID *)peerID;

@end
