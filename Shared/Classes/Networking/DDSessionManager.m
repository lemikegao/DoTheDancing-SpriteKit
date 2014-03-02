//
//  DTDSessionManager.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/24/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDSessionManager.h"
#import "DDPacket.h"

@implementation DDSessionManager

- (instancetype)initWithPeer:(MCPeerID *)peerId
{
    self = [super init];
    if (self != nil)
    {
        _session = [[MCSession alloc] initWithPeer:peerId];
        _session.delegate = self;
        
#if EXTERNAL
        _connectedPlayers = [[NSMutableDictionary alloc] init];
#endif
    }
    
    return self;
}

- (BOOL)isConnected
{
    return (self.session.connectedPeers.count > 0);
}

- (BOOL)sendDataToAllPeers:(NSData *)data withMode:(MCSessionSendDataMode)mode error:(NSError **)error
{
    NSLog(@"DDSessionManager -> sendDataToAllPeers: %@", self.session.connectedPeers);
    return [self.session sendData:data toPeers:self.session.connectedPeers withMode:mode error:error];
}

- (void)disconnect
{
    [self.session disconnect];
    
#if CONTROLLER
    self.externalPeerID = nil;
#endif
    
#if EXTERNAL
    NSLog(@"ALICE MONG 2");
    self.controllerHostPeerID = nil;
    [self.connectedPlayers removeAllObjects];
#endif
}

#pragma mark - MCSessionDelegate methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnected && self.session)
    {
        NSLog(@"DDSessionManager -> peer connected: %@, total connected peer count: %i", peerID, session.connectedPeers.count);
#if CONTROLLER
        self.externalPeerID = peerID;
#endif
        
#if EXTERNAL
        if (self.session.connectedPeers.count == 1)
        {
            NSLog(@"LOKI: CONTROLLER HOST PEER ID IS BEING SET AS %@", peerID);
            self.controllerHostPeerID = peerID;
        }
        
        [self.connectedPlayers setObject:[NSNull null] forKey:peerID];
#endif
        
        // For programmatic discovery, send a notification to the custom advertiser
        // that an invitation was accepted.
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kPeerConnectionAcceptedNotification
             object:nil
             userInfo:nil];
        });
    }
    else if (state == MCSessionStateNotConnected)
    {
        NSLog(@"DDSessionManager -> peer disconnected: %@, total connected peer count: %i", peerID, session.connectedPeers.count);
#if CONTROLLER
        [self disconnect];
#endif
        
#if EXTERNAL
        [self.connectedPlayers removeObjectForKey:peerID];
        NSLog(@"GAO: PEERID: %@ & controller host peer ID: %@", peerID, self.controllerHostPeerID);
        if ([peerID isEqual:self.controllerHostPeerID])
        {
            NSLog(@"ALICE MONG");
            [self disconnect];
        }
#endif
        
        NSLog(@"ALICE MONG 3 ");
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kPeerConnectionDisconnectedNotification
             object:nil
             userInfo:nil];
        });
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"DDSessionManager -> didReceiveData: %@ fromPeer: %@", data, peerID);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kPeerDidReceiveDataNotification
         object:nil
         userInfo:[[DDPacket packetWithData:data] dict]];
    });
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}

@end
