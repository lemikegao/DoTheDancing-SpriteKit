//
//  DDPlayerAvatarScene.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/23/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPlayerAvatarScene.h"
#import "UIColor+PlayerColor.h"

@implementation DDPlayerAvatarScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self _displayBackground];
        [self _displayTopBar];
        [self _displayAvatar];
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
    titleLabel.text = [DDGameManager sharedGameManager].player.nickname;
    titleLabel.fontColor = RGB(249, 185, 56);
    titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    titleLabel.position = CGPointMake(self.size.width * 0.5f, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:titleLabel];
}

- (void)_displayAvatar
{
    SKSpriteNode *avatar = [SKSpriteNode spriteNodeWithImageNamed:@"playeravatar-avatar"];
    avatar.color = [UIColor colorWithPlayerColor:[DDGameManager sharedGameManager].player.playerColor];
    avatar.colorBlendFactor = 0.5;
    avatar.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.59);
    [self addChild:avatar];
    
    // Scale for iPhone4
    if (IS_IPHONE_4)
    {
        [avatar setScale:0.75];
    }
}

- (void)_displayMenu
{
    // Menu - Bg
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227, 130)];
    menuBg.anchorPoint = CGPointMake(0.5, 0);
    menuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.03);
    [self addChild:menuBg];
    
    if ([DDGameManager sharedGameManager].isHost)
    {
        // Button - Start the Party!
        SKButton *startButton = [SKButton buttonWithImageNamedNormal:@"playeravatar-button-start" selected:@"playeravatar-button-start-highlight"];
        startButton.anchorPoint = CGPointMake(0.5, 1);
        startButton.position = CGPointMake(0, menuBg.size.height * 0.93);
        [startButton setTouchUpInsideTarget:self action:@selector(_pressedStartButton:)];
        [menuBg addChild:startButton];
    }
    else
    {
        menuBg.size = CGSizeMake(menuBg.size.width, 100);
        
        // Label - Leave party?
        SKLabelNode *leavePartyLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
        leavePartyLabel.fontColor = RGB(56, 56, 56);
        leavePartyLabel.text = @"Want to leave the party?";
        leavePartyLabel.fontSize = 22;
        leavePartyLabel.position = CGPointMake(0, menuBg.size.height * 0.72);
        [menuBg addChild:leavePartyLabel];
    }
    
    // Button - Disconnect
    SKButton *disconnectButton = [SKButton buttonWithImageNamedNormal:@"playeravatar-button-disconnect" selected:@"playeravatar-button-disconnect-highlight"];
    disconnectButton.anchorPoint = CGPointMake(0.5, 0);
    disconnectButton.position = CGPointMake(0, menuBg.size.height * 0.07);
    [disconnectButton setTouchUpInsideTarget:self action:@selector(_pressedDisconnectButton:)];
    [menuBg addChild:disconnectButton];
}

#pragma mark - Button actions
- (void)_pressedStartButton:(id)sender
{
    
}

- (void)_pressedDisconnectButton:(id)sender
{
    
}

#pragma mark - Networking
- (void)_didReceiveData:(NSNotification *)notification
{
    
}

@end
