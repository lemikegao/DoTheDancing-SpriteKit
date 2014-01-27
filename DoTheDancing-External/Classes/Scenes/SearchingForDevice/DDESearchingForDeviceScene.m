//
//  DTDSearchingForDeviceScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/20/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDESearchingForDeviceScene.h"
#import "DDEMainMenuScene.h"
#import "DDEConnectedToDeviceScene.h"

@interface DDESearchingForDeviceScene() <MCNearbyServiceBrowserDelegate>

@end

@implementation DDESearchingForDeviceScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = RGB(249, 185, 56);
        
        [self _displaySearchingMessage];
        [self _displayBackButton];
        [self _startSearchingForDevice];
        
        // Register for notifications when connected to advertiser
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(_peerConnected:)
         name:kPeerConnectionAcceptedNotification
         object:nil];
    }
    return self;
}

- (void)willMoveFromView:(SKView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup UI

- (void)_displaySearchingMessage
{
    SKLabelNode *searchingLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    searchingLabel.fontSize = 50;
    searchingLabel.fontColor = [UIColor blackColor];
    searchingLabel.text = @"Searching for device...";
    searchingLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    [self addChild:searchingLabel];
}

- (void)_displayBackButton
{
    SKButton *backButton = [SKButton buttonWithImageNamedNormal:@"back" selected:@"back-highlight"];
    backButton.anchorPoint = CGPointMake(0, 1);
    backButton.position = CGPointMake(0, self.size.height);
    [backButton setTouchUpInsideTarget:self action:@selector(_pressedBack:)];
    [self addChild:backButton];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    // Stop browsing
    [[DDEGameManager sharedGameManager].browser stopBrowsingForPeers];
    
    [self.view presentScene:[DDEMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

#pragma mark - Networking
- (void)_startSearchingForDevice
{
    MCNearbyServiceBrowser *browser = [DDEGameManager sharedGameManager].browser;
    browser.delegate = self;
    [browser startBrowsingForPeers];
}

- (void)_peerConnected:(NSNotification *)notification
{
    // Stop browsing
    [[DDEGameManager sharedGameManager].browser stopBrowsingForPeers];
    
    [self.view presentScene:[DDEConnectedToDeviceScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

#pragma mark - MCNearbyServiceBrowserDelegate methods
// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Found peer! %@", peerID);
    // TODO: Allow multiple peers; currently only single player
    // Send invite to peer
    [browser invitePeer:peerID toSession:[DDEGameManager sharedGameManager].sessionManager.session withContext:[kSessionContextType dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    // TODO: Required
}

// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    // TODO: Optional
    NSLog(@"Error browsing: %@", error.localizedDescription);
}

@end
