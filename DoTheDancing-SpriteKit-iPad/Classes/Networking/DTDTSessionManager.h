//
//  DTDTSessionManager.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/23/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTDTSessionManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;

- (instancetype)initWithPeer:(MCPeerID *)peerId;

@end
