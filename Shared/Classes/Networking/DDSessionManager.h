//
//  DTDSessionManager.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/24/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

@interface DDSessionManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, assign) BOOL isConnected;

#if CONTROLLER
@property (nonatomic, strong) MCPeerID *externalPeerID;         // Controller's only connected peer should be the external screen (for now, until we allow non-external screen support)
#endif

#if EXTERNAL
@property (nonatomic, strong) MCPeerID *controllerHostPeerID;
@property (nonatomic, copy, readonly) NSMutableDictionary *connectedPlayers;
#endif

- (instancetype)initWithPeer:(MCPeerID *)peerId;
- (BOOL)sendDataToAllPeers:(NSData *)data withMode:(MCSessionSendDataMode)mode error:(NSError **)error;
- (void)disconnect;         // Disconnects session and resets networking properties

@end
