//
//  DDConnectedToExternalScene.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/17/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDConnectedToExternalScene.h"
#import "DDPacketTransitionToScene.h"
#import "DDDanceMoveSelectionScene.h"
#import "DDMultiplayerHostOrJoinScene.h"

#if CONTROLLER
#import "DDMainMenuScene.h"
#else
#import "DDEMainMenuScene.h"
#endif

@implementation DDConnectedToExternalScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self _displayBackground];
        [self _displayTopBar];
        [self _displayConnected];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(_didReceiveData:)
         name:kPeerDidReceiveDataNotification
         object:nil];
    }
    
    return self;
}

#pragma mark - UI setup
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
    titleLabel.text = @"Controller";
#if EXTERNAL
    titleLabel.text = @"External Screen";
#endif
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

- (void)_displayConnected
{
    // Menu - Bg
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227*self.sizeMultiplier, 170*self.sizeMultiplier)];
    menuBg.anchorPoint = CGPointMake(0.5, 1);
    menuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.787);
    [self addChild:menuBg];
    
    // Label - Connected
    SKLabelNode *connectedLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    connectedLabel.fontSize = 24*self.sizeMultiplier;
    connectedLabel.text = @"You're now connected!";
    connectedLabel.fontColor = RGB(56, 56, 56);
    connectedLabel.position = CGPointMake(0, -menuBg.size.height * 0.18);
    [menuBg addChild:connectedLabel];
    
    // Button - Single player
    SKButton *singleButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-single" selected:@"mainmenu-button-single-highlight"];
    singleButton.position = CGPointMake(0, -menuBg.size.height * 0.40);
    [singleButton setTouchUpInsideTarget:self action:@selector(_pressedSingleButton:)];
    [menuBg addChild:singleButton];
    
    // Button - Multiplayer
    SKButton *danceButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-multi" selected:@"mainmenu-button-multi-highlight"];
    danceButton.position = CGPointMake(0, -menuBg.size.height * 0.78);
    [danceButton setTouchUpInsideTarget:self action:@selector(_pressedMultiButton:)];
    [menuBg addChild:danceButton];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    Class mainMenuClass;
#if CONTROLLER
    mainMenuClass = [DDMainMenuScene class];
#else
    mainMenuClass = [DDEMainMenuScene class];
#endif

    [[DDGameManager sharedGameManager].sessionManager.session disconnect];
    
    [self.view presentScene:[mainMenuClass sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

- (void)_pressedSingleButton:(id)sender
{
    if ([DDGameManager sharedGameManager].sessionManager.isConnected == YES)
    {
        NSError *error;
        DDPacketTransitionToScene *packet = [DDPacketTransitionToScene packetWithSceneType:kSceneTypeDanceMoveSelection];
        [[DDGameManager sharedGameManager].sessionManager sendDataToAllPeers:[packet data] withMode:MCSessionSendDataUnreliable error:&error];
    }
    
    // Show dance move selection scene
    [self.view presentScene:[DDDanceMoveSelectionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

- (void)_pressedMultiButton:(id)sender
{
    if ([DDGameManager sharedGameManager].sessionManager.isConnected == YES)
    {
        NSError *error;
        DDPacketTransitionToScene *packet = [DDPacketTransitionToScene packetWithSceneType:kSceneTypeMultiplayerHostOrJoin];
        [[DDGameManager sharedGameManager].sessionManager sendDataToAllPeers:[packet data] withMode:MCSessionSendDataUnreliable error:&error];
    }
    
    // Show multipplayer host or join scene
    [self.view presentScene:[DDMultiplayerHostOrJoinScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

#pragma mark - Networking
- (void)_didReceiveData:(NSNotification *)notification
{
    SceneTypes sceneType = (SceneTypes)[notification.userInfo[@"data"] intValue];
    SKScene *scene;
    switch (sceneType)
    {
        case kSceneTypeDanceMoveSelection:
            scene = [DDDanceMoveSelectionScene sceneWithSize:self.size];
            break;
            
        case kSceneTypeMultiplayerHostOrJoin:
            scene = [DDMultiplayerHostOrJoinScene sceneWithSize:self.size];
            break;
            
        default:
            break;
    }
    
    [self.view presentScene:scene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

@end
