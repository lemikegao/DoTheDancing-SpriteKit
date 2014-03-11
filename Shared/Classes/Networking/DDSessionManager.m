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
        NSLog(@"DDSessionManager -> peer connected: %@, total connected peer count: %lu", peerID, (unsigned long)session.connectedPeers.count);
#if CONTROLLER
        if ([peerID.displayName isEqualToString:@"External"] && self.externalPeerID == nil)
        {
            self.externalPeerID = peerID;
            
            // Only send notification if controller connects to external screen (not another controller)
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kPeerConnectionAcceptedNotification
                 object:nil
                 userInfo:nil];
            });
        }
#endif
        
#if EXTERNAL
        if (self.controllerHostPeerID == nil)
        {
            self.controllerHostPeerID = peerID;
        }
        
        [self.connectedPlayers setObject:[NSNull null] forKey:peerID];
        
        // Send notification if a new controller connects
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kPeerConnectionAcceptedNotification
             object:nil
             userInfo:nil];
        });
#endif
    }
    else if (state == MCSessionStateNotConnected)
    {
        NSLog(@"DDSessionManager -> peer disconnected: %@, total connected peer count: %lu", peerID, (unsigned long)session.connectedPeers.count);
#if CONTROLLER
        // Disconnect controller if external display disconnected
        if ([peerID isEqual:self.externalPeerID])
        {
            [self disconnect];
            
            // Only send notification if external screen disconnects
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kPeerConnectionDisconnectedNotification
                 object:nil
                 userInfo:nil];
            });
        }
#endif
        
#if EXTERNAL
        [self.connectedPlayers removeObjectForKey:peerID];
        if ([peerID isEqual:self.controllerHostPeerID])
        {
            [self disconnect];
        }
        
        // Send notification if any controller disconnects
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kPeerConnectionDisconnectedNotification
             object:nil
             userInfo:@{@"peerID": peerID}];
        });
#endif
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSMutableDictionary *dict = [[[DDPacket packetWithData:data] dict] mutableCopy];
    dict[@"peerID"] = peerID;
    
    NSLog(@"DDSessionManager -> didReceiveData: %@ fromPeer: %@", data, peerID);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kPeerDidReceiveDataNotification
         object:nil
         userInfo:[dict copy]];
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
