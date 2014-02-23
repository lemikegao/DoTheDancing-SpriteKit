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

@interface DDMultiplayerHostOrJoinScene() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SKSpriteNode *hostOrJoinMenuBg;

@end

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
    self.hostOrJoinMenuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227*self.sizeMultiplier, 144*self.sizeMultiplier)];
    self.hostOrJoinMenuBg.anchorPoint = CGPointMake(0.5, 1);
    self.hostOrJoinMenuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.74);
    [self addChild:self.hostOrJoinMenuBg];
    
    // Menu - Host button
    SKButton *hostButton = [SKButton buttonWithImageNamedNormal:@"multiplayer-hostorjoin-button-host" selected:@"multiplayer-hostorjoin-button-host-highlight"];
    hostButton.position = CGPointMake(0, -self.hostOrJoinMenuBg.size.height * 0.27);
    [hostButton setTouchUpInsideTarget:self action:@selector(_pressedHostButton:)];
    [self.hostOrJoinMenuBg addChild:hostButton];
    
    // Menu - Join button
    SKButton *joinButton = [SKButton buttonWithImageNamedNormal:@"multiplayer-hostorjoin-button-join" selected:@"multiplayer-hostorjoin-button-join-highlight"];
    joinButton.position = CGPointMake(0, -self.hostOrJoinMenuBg.size.height * 0.73);
    [joinButton setTouchUpInsideTarget:self action:@selector(_pressedJoinButton:)];
    [self.hostOrJoinMenuBg addChild:joinButton];
    
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
    // Remove UITextField
    [self.textField removeFromSuperview];
    
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
    [self _showNicknamePrompt];
}

- (void)_pressedDanceButton:(id)sender
{
    
}

#pragma mark - Nickname
- (void)_showNicknamePrompt
{
    CGFloat menuBgPositionY = self.size.height * 0.74;
#warning TODO - Do not show on external screen. So what then?
    // Hide previous menu immediately & display fade layer
    self.hostOrJoinMenuBg.hidden = YES;
    SKSpriteNode *fadeLayer = [SKSpriteNode spriteNodeWithColor:RGBA(0, 0, 0, 0.5) size:self.size];
    fadeLayer.anchorPoint = CGPointMake(0, 0);
    [self addChild:fadeLayer];
    
    // Menu bg
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227*self.sizeMultiplier, 144*self.sizeMultiplier)];
    menuBg.anchorPoint = CGPointMake(0.5, 1);
    menuBg.position = CGPointMake(self.size.width * 0.5, 0);
    [fadeLayer addChild:menuBg];
    
    // Label - Dancer name?
    SKLabelNode *nameLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    nameLabel.fontSize = 20;
    nameLabel.text = @"What's your dancer name?";
    nameLabel.fontColor = RGB(56, 56, 56);
    nameLabel.position = CGPointMake(0, -menuBg.size.height * 0.15);
    [menuBg addChild:nameLabel];
    
    // Sprite - Fake UITextField for SpriteKit
    SKSpriteNode *fakeTextField = [SKSpriteNode spriteNodeWithColor:RGB(255, 251, 231) size:CGSizeMake(menuBg.size.width * 0.84, 32)];
    fakeTextField.position = CGPointMake(0, -menuBg.size.height * 0.32);
    [menuBg addChild:fakeTextField];
    
    // UITextField
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(menuBg.position.x - menuBg.size.width * 0.42 , self.size.height - (menuBgPositionY - menuBg.size.height * 0.21), menuBg.size.width * 0.84, 32)];
    self.textField.backgroundColor = RGB(255, 251, 231);
    self.textField.textColor = RGB(219, 133, 20);
    self.textField.font = [UIFont fontWithName:@"Economica-Bold" size:18];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    // Add padding on left side
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    paddingView.backgroundColor = self.textField.backgroundColor;
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.hidden = YES;
    [self.view addSubview:self.textField];
    
    // Button - Let's Dance!
    SKButton *danceButton = [SKButton buttonWithImageNamedNormal:@"multiplayer-hostorjoin-button-lets-dance" selected:@"multiplayer-hostorjoin-button-lets-dance-highlight"];
    danceButton.position = CGPointMake(0, -menuBg.size.height * 0.73);
    [danceButton setTouchUpInsideTarget:self action:@selector(_pressedDanceButton:)];
    [menuBg addChild:danceButton];
    
    // Animations! Move new menu up to previous menu position and focus on textfield
    SKAction *moveAction = [SKAction moveTo:CGPointMake(self.size.width * 0.5, menuBgPositionY) duration:0.25];
    SKAction *showTextFieldAction = [SKAction runBlock:^{
        self.textField.hidden = NO;
        [self.textField becomeFirstResponder];
    }];
    
    [menuBg runAction:[SKAction sequence:@[moveAction, showTextFieldAction]]];
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
