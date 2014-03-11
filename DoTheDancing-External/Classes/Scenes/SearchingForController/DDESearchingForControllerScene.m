//
//  DTDSearchingForDeviceScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/20/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDESearchingForControllerScene.h"
#import "DDEMainMenuScene.h"
#import "DDConnectedToExternalScene.h"

@interface DDESearchingForControllerScene() <MCNearbyServiceAdvertiserDelegate>

@end

@implementation DDESearchingForControllerScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self _displayBackground];
        [self _displayTopBar];
        [self _displayConnectingToController];
        [self _startAdvertisingToDevice];
        
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
    titleLabel.text = @"External Screen";
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

- (void)_displayConnectingToController
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
    // Stop advertising
    [[DDGameManager sharedGameManager].advertiser stopAdvertisingPeer];
    
    [self.view presentScene:[DDEMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

#pragma mark - Networking
- (void)_startAdvertisingToDevice
{
    NSLog(@"DDEWaitingRoomScene -> Start advertising to controllers");
    MCNearbyServiceAdvertiser *advertiser = [DDGameManager sharedGameManager].advertiser;
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
}

- (void)_peerConnected:(NSNotification *)notification
{
    // Stop advertising
    [[DDGameManager sharedGameManager].advertiser stopAdvertisingPeer];
    
    [self.view presentScene:[DDConnectedToExternalScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

#pragma mark - MCNearbyServiceAdvertiserDelegate methods
// Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    NSLog(@"DDSearchingForExternalScene -> didReceiveInvitationFromPeer: %@", peerID);
    if ([[NSString stringWithUTF8String:[context bytes]] isEqualToString:kSessionContextType])
    {
        // Accept the invitation immediately for single player mode
        invitationHandler(YES, [DDGameManager sharedGameManager].sessionManager.session);
        
        NSLog(@"Accepted invitation from peer: %@", peerID);
    }
}

// Advertising did not start due to an error
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    // Optional
    NSLog(@"DDSearchingForExternalScene -> didNotStartAdvertisingPeer error: %@", error);
}

@end
