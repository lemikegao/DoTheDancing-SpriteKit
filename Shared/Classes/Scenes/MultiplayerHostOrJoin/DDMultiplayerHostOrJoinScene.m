//
//  DDMultiplayerHostOrJoinScene.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/22/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDMultiplayerHostOrJoinScene.h"
#import "DDPacketTransitionToScene.h"
#import "DDConnectedToExternalScene.h"

#if CONTROLLER
#import "DDMainMenuScene.h"
#import "DDMultiplayerHostOnExternalScene.h"
#else
#import "DDEMainMenuScene.h"
#endif

@implementation DDMultiplayerHostOrJoinScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self _displayBackground];
        [self _displayTopBar];
        [self _displayMenu];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(_didReceiveData:)
         name:kPeerDidReceiveDataNotification
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
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(self.size.width, 43 * self.sizeMultiplier)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32 * self.sizeMultiplier;
    titleLabel.text = @"Multiplayer";
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

- (void)_displayMenu
{
    // Menu - Bg
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227*self.sizeMultiplier, 144*self.sizeMultiplier)];
    menuBg.anchorPoint = CGPointMake(0.5, 1);
    menuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.74);
    [self addChild:menuBg];
    
    // Menu - Host button
    SKButton *hostButton = [SKButton buttonWithImageNamedNormal:@"multiplayer-hostorjoin-button-host" selected:@"multiplayer-hostorjoin-button-host-highlight"];
    hostButton.position = CGPointMake(0, -menuBg.size.height * 0.27);
    [hostButton setTouchUpInsideTarget:self action:@selector(_pressedHostButton:)];
    [menuBg addChild:hostButton];
    
    // Menu - Join button
    SKButton *joinButton = [SKButton buttonWithImageNamedNormal:@"multiplayer-hostorjoin-button-join" selected:@"multiplayer-hostorjoin-button-join-highlight"];
    joinButton.position = CGPointMake(0, -menuBg.size.height * 0.73);
    [joinButton setTouchUpInsideTarget:self action:@selector(_pressedJoinButton:)];
    [menuBg addChild:joinButton];
    
    // Disable join button if connected to another device (like external screen)
    if ([DDGameManager sharedGameManager].sessionManager.isConnected)
    {
        joinButton.isEnabled = NO;
        joinButton.alpha = 0.5;
    }
    else
    {
        joinButton.isEnabled = YES;
        joinButton.alpha = 1.0;
    }
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    // Segue back to ConnectedToExternal screen
    if ([DDGameManager sharedGameManager].sessionManager.isConnected)
    {
        NSError *error;
        DDPacketTransitionToScene *packet = [DDPacketTransitionToScene packetWithSceneType:kSceneTypeConnectedToExternal];
        [[DDGameManager sharedGameManager].sessionManager sendDataToAllPeers:[packet data] withMode:MCSessionSendDataUnreliable error:&error];
        
        [self.view presentScene:[DDConnectedToExternalScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
    }
    else
    {
        Class mainMenuClass;
#if CONTROLLER
        mainMenuClass = [DDMainMenuScene class];
#else
        mainMenuClass = [DDEMainMenuScene class];
#endif
        [self.view presentScene:[mainMenuClass sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
    }
}

- (void)_pressedHostButton:(id)sender
{
#if CONTROLLER
    if ([DDGameManager sharedGameManager].sessionManager.isConnected == NO)
    {
        [self.view presentScene:[DDMultiplayerHostOnExternalScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
    }
#endif
}

- (void)_pressedJoinButton:(id)sender
{
    
}

#pragma mark - Networking
- (void)_didReceiveData:(NSNotification *)notification
{
    SceneTypes sceneType = (SceneTypes)[notification.userInfo[@"data"] intValue];
    SKScene *scene;
    SKTransitionDirection direction = SKTransitionDirectionRight;
    switch (sceneType)
    {
        case kSceneTypeConnectedToExternal:
            scene = [DDConnectedToExternalScene sceneWithSize:self.size];
            
        default:
            break;
    }
    
    [self.view presentScene:scene transition:[SKTransition pushWithDirection:direction duration:0.25]];
}

@end
