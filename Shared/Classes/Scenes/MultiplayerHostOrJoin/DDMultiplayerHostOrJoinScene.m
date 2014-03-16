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
#import "DDSearchingForExternalScene.h"
#else
#import "DDEMainMenuScene.h"
#import "DDEWaitingRoomScene.h"
#endif

@interface DDMultiplayerHostOrJoinScene() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SKSpriteNode *hostOrJoinMenuBg;
@property (nonatomic, strong) SKButton *fadeLayer;
@property (nonatomic) BOOL didPressHost;

// Nickname
@property (nonatomic) CGFloat menuBgPositionY;
@property (nonatomic, strong) SKSpriteNode *nicknameBg;
@property (nonatomic, strong) SKLabelNode *maxCharacterErrorLabel;

@end

@implementation DDMultiplayerHostOrJoinScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        _menuBgPositionY = self.size.height * 0.74;
        _didPressHost = NO;
        
        [self _displayBackground];
        [self _displayTopBar];
        [self _displayMenu];
        [self _initNicknamePrompt];
        
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
    _hostOrJoinMenuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227*self.sizeMultiplier, 144*self.sizeMultiplier)];
    _hostOrJoinMenuBg.anchorPoint = CGPointMake(0.5, 1);
    _hostOrJoinMenuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.74);
    [self addChild:_hostOrJoinMenuBg];
    
    // Menu - Host button
    SKButton *hostButton = [SKButton buttonWithImageNamedNormal:@"multiplayer-hostorjoin-button-host" selected:@"multiplayer-hostorjoin-button-host-highlight"];
    hostButton.position = CGPointMake(0, -_hostOrJoinMenuBg.size.height * 0.27);
    [hostButton setTouchUpInsideTarget:self action:@selector(_pressedHostButton:)];
    [_hostOrJoinMenuBg addChild:hostButton];
    
    // Menu - Join button
    SKButton *joinButton = [SKButton buttonWithImageNamedNormal:@"multiplayer-hostorjoin-button-join" selected:@"multiplayer-hostorjoin-button-join-highlight"];
    joinButton.position = CGPointMake(0, -_hostOrJoinMenuBg.size.height * 0.73);
    [joinButton setTouchUpInsideTarget:self action:@selector(_pressedJoinButton:)];
    [_hostOrJoinMenuBg addChild:joinButton];
    
    // Disable join button if connected to another device (like external screen)
    if ([DDGameManager sharedGameManager].sessionManager.isConnected)
    {
        [joinButton disableButton];
    }
    else
    {
        [joinButton enableButton];
    }
}

- (void)_initNicknamePrompt
{
    // Fade layer
    _fadeLayer = [[SKButton alloc] initWithColor:RGBA(0, 0, 0, 0.7) size:self.size];
    [_fadeLayer setTouchDownTarget:self action:@selector(_pressedOutsideKeyboard:)];
    _fadeLayer.anchorPoint = CGPointMake(0, 0);
    _fadeLayer.position = CGPointMake(0, -self.size.height);        // Initialized off screen so button is not blocking user interaction
    [self addChild:_fadeLayer];
    
    // Max character error
    _maxCharacterErrorLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    _maxCharacterErrorLabel.text = @"Name must be 1-4 characters!";
#warning - TODO: Update font color
    _maxCharacterErrorLabel.fontColor = [UIColor redColor];
    _maxCharacterErrorLabel.fontSize = 22;
    _maxCharacterErrorLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.82);
    _maxCharacterErrorLabel.alpha = 0;
    [_fadeLayer addChild:_maxCharacterErrorLabel];
    
    // Nickname bg
    _nicknameBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227*self.sizeMultiplier, 144*self.sizeMultiplier)];
    _nicknameBg.anchorPoint = CGPointMake(0.5, 1);
    _nicknameBg.position = CGPointMake(self.size.width * 0.5, 0);
    [_fadeLayer addChild:_nicknameBg];
    
    // Label - Dancer name?
    SKLabelNode *nameLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    nameLabel.fontSize = 20;
    nameLabel.text = @"What's your dancer name?";
    nameLabel.fontColor = RGB(56, 56, 56);
    nameLabel.position = CGPointMake(0, -_nicknameBg.size.height * 0.15);
    [_nicknameBg addChild:nameLabel];
    
    // Sprite - Fake UITextField for SpriteKit
    SKSpriteNode *fakeTextField = [SKSpriteNode spriteNodeWithColor:RGB(255, 251, 231) size:CGSizeMake(_nicknameBg.size.width * 0.84, 32)];
    fakeTextField.position = CGPointMake(0, -_nicknameBg.size.height * 0.32);
    [_nicknameBg addChild:fakeTextField];
    
    // Button - Let's Dance!
    SKButton *danceButton = [SKButton buttonWithImageNamedNormal:@"multiplayer-hostorjoin-button-lets-dance" selected:@"multiplayer-hostorjoin-button-lets-dance-highlight"];
    danceButton.position = CGPointMake(0, -_nicknameBg.size.height * 0.73);
    [danceButton setTouchUpInsideTarget:self action:@selector(_pressedDanceButton:)];
    [_nicknameBg addChild:danceButton];
}

- (void)didMoveToView:(SKView *)view
{
    // UITextField
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.nicknameBg.position.x - self.nicknameBg.size.width * 0.42 , self.size.height - (self.menuBgPositionY - self.nicknameBg.size.height * 0.21), self.nicknameBg.size.width * 0.84, 32)];
    self.textField.backgroundColor = RGB(255, 251, 231);
    self.textField.textColor = RGB(219, 133, 20);
    self.textField.font = [UIFont fontWithName:@"Economica-Bold" size:18];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.textField.placeholder = @"4 characters max";
    self.textField.delegate = self;
    
    // Add padding on left side
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    paddingView.backgroundColor = self.textField.backgroundColor;
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.hidden = YES;
    [self.view addSubview:self.textField];
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
    if (self.textField.text.length == 0)
    {
        [self _showMaxCharacterErrorLabel];
        
    }
    else
    {
        [self _segueToNextScene];
    }
}

- (void)_pressedOutsideKeyboard:(id)sender
{
    [self _hideNicknamePromptAndShowHostOrJoinMenu];
}

#pragma mark - Nickname
- (void)_showNicknamePrompt
{
#warning TODO - Do not show on external screen. So what then?
    // Hide previous menu immediately & display fade layer
    self.hostOrJoinMenuBg.position = CGPointMake(self.size.width * 0.5, 0);
    
    // Show fade layer
    self.fadeLayer.isEnabled = NO;
    self.fadeLayer.position = CGPointZero;
    
    // Animations! Move new menu up to previous menu position and focus on textfield
    SKAction *moveAction = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.menuBgPositionY) duration:0.25];
    SKAction *showTextFieldAction = [SKAction runBlock:^{
        self.textField.hidden = NO;
        self.fadeLayer.isEnabled = YES;
    }];
    
    // TODO: Fix delay of keyboard appearing on first time
    [self.textField becomeFirstResponder];
    [self.nicknameBg runAction:[SKAction sequence:@[moveAction, showTextFieldAction]]];
}

- (void)_hideNicknamePromptAndShowHostOrJoinMenu
{
    [self.textField resignFirstResponder];
    
    // Remove fade layer and existing menu
    self.textField.hidden = YES;
    self.textField.text = @"";
    self.fadeLayer.position = CGPointMake(0, -self.size.height);
    
    // Reset nickname bg to hidden position
    self.nicknameBg.position = CGPointMake(self.size.width * 0.5, 0);
    
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
    // Randomly select color of player
    DDPlayerColor randomColor = arc4random() % DDPlayerColorCount;
    player.playerColor = randomColor;
    
    
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
            
            // Send packet to external screen
            NSError *error;
            DDPacketHostParty *packet = [DDPacketHostParty packetWithPlayerColor:player.playerColor nickname:player.nickname];
            [[DDGameManager sharedGameManager].sessionManager sendDataToAllPeers:[packet data] withMode:MCSessionSendDataUnreliable error:&error];
            
            // Segue to playerAvatarScene
            [self.view presentScene:[DDPlayerAvatarScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
        }
    }
    else
    {
        // Join party!
        [DDGameManager sharedGameManager].isHost = NO;
        
        [self.view presentScene:[[DDSearchingForExternalScene alloc] initWithSize:self.size isJoiningParty:YES] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
    }
#endif
}

- (void)_showMaxCharacterErrorLabel
{
    [self.maxCharacterErrorLabel removeAllActions];
    self.maxCharacterErrorLabel.alpha = 1;
    
    // Fade out
    SKAction *fadeOutLabel = [SKAction sequence:@[[SKAction waitForDuration:3], [SKAction fadeOutWithDuration:0.5]]];
    [self.maxCharacterErrorLabel runAction:fadeOutLabel];
}

#pragma mark - UITextFieldDelegate protocol methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        [self _showMaxCharacterErrorLabel];
        
        return NO;
    }
    
    [self _segueToNextScene];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Display error message if textField will contain over 4 letters
    if (range.location >= 4)
    {
        [self _showMaxCharacterErrorLabel];
        
        return NO;
    }
    
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
        MCPeerID *peerID = notification.userInfo[@"peerID"];
        DDPlayerColor playerColor = [notification.userInfo[@"playerColor"] intValue];
        NSString *nickname = notification.userInfo[@"nickname"];
        
        DDPlayer *player = [DDPlayer playerWithPlayerColor:playerColor nickname:nickname];
        [[DDGameManager sharedGameManager].sessionManager.connectedPlayers setObject:player forKey:peerID];
        
        // Segue to waiting room
        [self.view presentScene:[DDEWaitingRoomScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
#endif
    }
}

@end
