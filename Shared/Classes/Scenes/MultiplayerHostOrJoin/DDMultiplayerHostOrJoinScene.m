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
#import "DDPacketHostParty.h"

#if CONTROLLER
#import "DDMainMenuScene.h"
#import "DDMultiplayerHostOnExternalScene.h"
#import "DDPlayerAvatarScene.h"
#else
#import "DDEMainMenuScene.h"
#import "DDEWaitingRoomScene.h"
#endif

@interface DDMultiplayerHostOrJoinScene() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SKSpriteNode *hostOrJoinMenuBg;
@property (nonatomic, strong) SKButton *fadeLayer;
@property (nonatomic) BOOL didPressHost;

@end

@implementation DDMultiplayerHostOrJoinScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        _didPressHost = NO;
        
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
    self.didPressHost = YES;
    
    [self _showNicknamePrompt];
}

- (void)_pressedJoinButton:(id)sender
{
    self.didPressHost = NO;
    [self _showNicknamePrompt];
}

- (void)_pressedDanceButton:(id)sender
{
    [self _segueToNextScene];
}

- (void)_pressedOutsideKeyboard:(id)sender
{
    [self _hideNicknamePromptAndShowHostOrJoinMenu];
}

#pragma mark - Nickname
- (void)_showNicknamePrompt
{
    CGFloat menuBgPositionY = self.size.height * 0.74;
#warning TODO - Do not show on external screen. So what then?
    // Hide previous menu immediately & display fade layer
    self.hostOrJoinMenuBg.position = CGPointMake(self.size.width * 0.5, 0);
    self.fadeLayer = [[SKButton alloc] initWithColor:RGBA(0, 0, 0, 0.7) size:self.size];
    [self.fadeLayer setTouchDownTarget:self action:@selector(_pressedOutsideKeyboard:)];
    self.fadeLayer.isEnabled = NO;
    self.fadeLayer.anchorPoint = CGPointMake(0, 0);
    [self addChild:self.fadeLayer];
    
    // Menu bg
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227*self.sizeMultiplier, 144*self.sizeMultiplier)];
    menuBg.anchorPoint = CGPointMake(0.5, 1);
    menuBg.position = CGPointMake(self.size.width * 0.5, 0);
    [self.fadeLayer addChild:menuBg];
    
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
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
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
        self.fadeLayer.isEnabled = YES;
    }];
    
    [menuBg runAction:[SKAction sequence:@[moveAction, showTextFieldAction]]];
}

- (void)_hideNicknamePromptAndShowHostOrJoinMenu
{
    [self.textField resignFirstResponder];
    
    // Remove fade layer and existing menu
    self.textField.hidden = YES;
    [self.fadeLayer removeFromParent];
    
    // Animate old menu back to previous position
    SKAction *moveAction = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.74) duration:0.25];
    [self.hostOrJoinMenuBg runAction:moveAction];
}

#pragma mark - Private methods
- (void)_segueToNextScene
{
#if CONTROLLER
    [self.textField resignFirstResponder];
    [self.textField removeFromSuperview];
    
    // Save nickname
    DDPlayer *player = [DDGameManager sharedGameManager].player;
    player.nickname = self.textField.text;
    
    if (self.didPressHost)
    {
        // Ask if user wants to connect to external screen first
        if ([DDGameManager sharedGameManager].sessionManager.isConnected == NO)
        {
            [self.view presentScene:[DDMultiplayerHostOnExternalScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
        }
        else
        {
            /* Segue external screen to waiting room */
            [DDGameManager sharedGameManager].isHost = YES;
            
            // Randomly select color of player
            DDPlayerColor randomColor = arc4random() % DDPlayerColorCount;
            player.playerColor = randomColor;
            
            // Send packet to external screen
            NSError *error;
            DDPacketHostParty *packet = [DDPacketHostParty packetWithPlayerColor:player.playerColor nickname:player.nickname];
            [[DDGameManager sharedGameManager].sessionManager sendDataToAllPeers:[packet data] withMode:MCSessionSendDataUnreliable error:&error];
            
            // Segue to playerAvatarScene
            [self.view presentScene:[DDPlayerAvatarScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
        }
    }
#endif
}

#pragma mark - UITextFieldDelegate protocol methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self _segueToNextScene];
    
    return YES;
}

#pragma mark - Networking
- (void)_didReceiveData:(NSNotification *)notification
{
    PacketType packetType = (PacketType)[notification.userInfo[@"type"] intValue];
    
    if (packetType == PacketTypeTransitionToScene)
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
    else if (packetType == PacketTypeHostParty)
    {
#if EXTERNAL
        // Store player info in sessionManager
        NSString *peerID = notification.userInfo[@"peerID"];
        DDPlayerColor playerColor = [notification.userInfo[@"playerColor"] intValue];
        NSString *nickname = notification.userInfo[@"nickname"];
        
        DDPlayer *player = [DDPlayer playerWithPlayerColor:playerColor nickname:nickname];
        [[DDGameManager sharedGameManager].sessionManager.connectedPeers setObject:player forKey:peerID];
        
        // Segue to waiting room
        [self.view presentScene:[DDEWaitingRoomScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
#endif
    }
}

@end
