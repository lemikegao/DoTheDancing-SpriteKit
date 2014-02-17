//
//  DTDSearchingForDeviceScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/20/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDESearchingForControllerScene.h"
#import "DDEMainMenuScene.h"
#import "DDEConnectedToControllerScene.h"

@interface DDESearchingForControllerScene() <MCNearbyServiceBrowserDelegate>

@end

@implementation DDESearchingForControllerScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self _displayBackground];
        [self _displayTopBar];
        [self _displaySearchingForController];
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

#pragma mark - Setup UI
- (void)_displayBackground
{
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-bg"];
    bg.anchorPoint = CGPointMake(0, 1);
    bg.position = CGPointMake(0, self.size.height);
    [self addChild:bg];
}

- (void)_displayTopBar
{
    // Top banner bg
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(self.size.width, 43*self.sizeMultiplier)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32*self.sizeMultiplier;
    titleLabel.text = @"Single Player";
    titleLabel.fontColor = RGB(249, 185, 56);
    titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    titleLabel.position = CGPointMake(self.size.width * 0.5f, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:titleLabel];
    
    // Back button
    SKButton *backButton = [SKButton buttonWithImageNamedNormal:@"back" selected:@"back-highlight"];
    backButton.anchorPoint = CGPointMake(0, 0.5);
    backButton.position = CGPointMake(0, -topBannerBg.size.height * 0.5);
    [backButton setTouchUpInsideTarget:self action:@selector(_pressedBack:)];
    [topBannerBg addChild:backButton];
}

- (void)_displaySearchingForController
{
    // Sprite - Connecting
    SKSpriteNode *connectingSprite = [SKSpriteNode spriteNodeWithImageNamed:@"connecting1"];
    connectingSprite.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.7);
    [self addChild:connectingSprite];
    
    // Animate connecting
    SKAction *connectingAnimation = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"connecting2"], [SKTexture textureWithImageNamed:@"connecting1"]] timePerFrame:0.25];
    [connectingSprite runAction:[SKAction repeatActionForever:connectingAnimation]];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    // Stop browsing
    [[DDGameManager sharedGameManager].browser stopBrowsingForPeers];
    
    [self.view presentScene:[DDEMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

#pragma mark - Networking
- (void)_startSearchingForDevice
{
    NSLog(@"DDESearchingForControllerScene -> Start browsing for peers");
    MCNearbyServiceBrowser *browser = [DDGameManager sharedGameManager].browser;
    browser.delegate = self;
    [browser startBrowsingForPeers];
}

- (void)_peerConnected:(NSNotification *)notification
{
    // Stop browsing
    [[DDGameManager sharedGameManager].browser stopBrowsingForPeers];
    
    [self.view presentScene:[DDEConnectedToControllerScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

#pragma mark - MCNearbyServiceBrowserDelegate methods
// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Found peer! %@", peerID);
    // TODO: Allow multiple peers; currently only single player
    // Send invite to peer
    [browser invitePeer:peerID toSession:[DDGameManager sharedGameManager].sessionManager.session withContext:[kSessionContextType dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
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
