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
        _peerIDs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BOOL)sendDataToAllPeers:(NSData *)data withMode:(MCSessionSendDataMode)mode error:(NSError **)error
{
    return [self.session sendData:data toPeers:self.peerIDs withMode:mode error:error];
}

#pragma mark - MCSessionDelegate methods
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnected && self.session) {
        [self.peerIDs addObject:peerID];
        
        // For programmatic discovery, send a notification to the custom advertiser
        // that an invitation was accepted.
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kPeerConnectionAcceptedNotification
         object:nil
         userInfo:nil];
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"DDSessionManager -> didReceiveData: %@ fromPeer: %@", data, peerID);
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kPeerDidReceiveDataNotification
     object:nil
     userInfo:[[DDPacket packetWithData:data] dict]];
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
