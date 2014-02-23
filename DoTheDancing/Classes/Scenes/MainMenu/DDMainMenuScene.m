//
//  DTDMainMenuScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/7/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DDMainMenuScene.h"
#import "DDDanceMoveSelectionScene.h"
#import "DDSearchingForExternalScene.h"
#import "DDMultiplayerHostOrJoinScene.h"

@implementation DDMainMenuScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        [self _displayBackground];
        [self _displayLogo];
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

- (void)_displayLogo
{
    // Logo
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-logo1"];
    logo.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.87);
    [self addChild:logo];
    
    // Animate logo
    SKAction *logoAnimation = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"mainmenu-logo2"], [SKTexture textureWithImageNamed:@"mainmenu-logo1"]] timePerFrame:0.25];
    [logo runAction:[SKAction repeatActionForever:logoAnimation]];
}

- (void)_displayMenu
{
    // Menu - Bg
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227, 265)];
    menuBg.anchorPoint = CGPointMake(0.5, 1);
    menuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.74);
    [self addChild:menuBg];
    
    // Button - Single Player
    SKButton *singleButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-single" selected:@"mainmenu-button-single-highlight"];
    singleButton.position = CGPointMake(0, -menuBg.size.height * 0.15);
    [singleButton setTouchUpInsideTarget:self action:@selector(_pressedSingleButton:)];
    [menuBg addChild:singleButton];
    
    // Button - Multiplayer
    SKButton *multiButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-multi" selected:@"mainmenu-button-multi-highlight"];
    multiButton.position = CGPointMake(0, -menuBg.size.height * 0.40);
    [multiButton setTouchUpInsideTarget:self action:@selector(_pressedMultiplayerButton:)];
    [menuBg addChild:multiButton];
    
    // - or -
    SKSpriteNode *line1 = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(menuBg.size.width * 0.25, 1)];
    line1.anchorPoint = CGPointMake(0, 0.5);
    line1.position = CGPointMake(-menuBg.size.width * 0.35, -menuBg.size.height * 0.62);
    [menuBg addChild:line1];
    
    SKLabelNode *orLabel = [SKLabelNode labelNodeWithFontNamed:@"ACaslonPro-BoldItalic"];
    orLabel.fontColor = RGB(56, 56, 56);
    orLabel.text = @"or";
    orLabel.fontSize = 28;
    orLabel.position = CGPointMake(0, line1.position.y);
    orLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [menuBg addChild:orLabel];
    
    SKSpriteNode *line2 = [SKSpriteNode spriteNodeWithColor:line1.color size:line1.size];
    line2.anchorPoint = CGPointMake(1, 0.5);
    line2.position = CGPointMake(menuBg.size.width * 0.35, line1.position.y);
    [menuBg addChild:line2];
    
    // Button - Connect to external screen
    SKButton *externalButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-external" selected:@"mainmenu-button-external-highlight"];
    externalButton.anchorPoint = CGPointMake(0.5, 0);
    externalButton.position = CGPointMake(0, -menuBg.size.height * 0.95);
    [externalButton setTouchUpInsideTarget:self action:@selector(_pressedConnectToExternalButton:)];
    [menuBg addChild:externalButton];
}

#pragma mark - Button actions
- (void)_pressedSingleButton:(id)sender
{
    [self.view presentScene:[DDDanceMoveSelectionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

- (void)_pressedMultiplayerButton:(id)sender
{
    [self.view presentScene:[DDMultiplayerHostOrJoinScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

- (void)_pressedConnectToExternalButton:(id)sender
{
    [self.view presentScene:[DDSearchingForExternalScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

@end
