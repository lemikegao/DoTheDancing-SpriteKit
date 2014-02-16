//
//  DDConnectToExternalScene.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/16/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDConnectToExternalScene.h"
#import "DDMainMenuScene.h"
#import "DDDanceMoveSelectionScene.h"
#import "DDSearchingForExternalScene.h"

@implementation DDConnectToExternalScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self _displayBackground];
        [self _displayTopBar];
        [self _displayMenu];
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
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(self.size.width, 43)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32;
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

- (void)_displayMenu
{
    // Label - Connect
#warning - Update font and fontColor
    SKLabelNode *connectLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    connectLabel.fontSize = 28;
    connectLabel.text = @"Connect to external screen?";
    connectLabel.fontColor = [UIColor blackColor];
    connectLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.8);
    [self addChild:connectLabel];
    
    // Menu - Bg
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227, 165)];
    menuBg.anchorPoint = CGPointMake(0.5, 1);
    menuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.74);
    [self addChild:menuBg];
    
    // Menu - Yes button
    SKButton *singleButton = [SKButton buttonWithImageNamedNormal:@"button-yes" selected:@"button-yes-highlight"];
    singleButton.position = CGPointMake(0, -menuBg.size.height * 0.25);
    [singleButton setTouchUpInsideTarget:self action:@selector(_pressedYesButton:)];
    [menuBg addChild:singleButton];
    
    // Menu - No button
    SKButton *multiButton = [SKButton buttonWithImageNamedNormal:@"button-no" selected:@"button-no-highlight"];
    multiButton.position = CGPointMake(0, -menuBg.size.height * 0.75);
    [multiButton setTouchUpInsideTarget:self action:@selector(_pressedNoButton:)];
    [menuBg addChild:multiButton];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    [self.view presentScene:[DDMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

- (void)_pressedYesButton:(id)sender
{
    [self.view presentScene:[DDSearchingForExternalScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

- (void)_pressedNoButton:(id)sender
{
    [self.view presentScene:[DDDanceMoveSelectionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

@end
