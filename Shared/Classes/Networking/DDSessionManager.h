//
//  DTDSessionManager.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/24/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

@interface DDSessionManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, copy, readonly) NSMutableArray *peerIDs;
@property (nonatomic, assign) BOOL isConnected;

- (instancetype)initWithPeer:(MCPeerID *)peerId;
- (BOOL)sendDataToAllPeers:(NSData *)data withMode:(MCSessionSendDataMode)mode error:(NSError **)error;

@end
