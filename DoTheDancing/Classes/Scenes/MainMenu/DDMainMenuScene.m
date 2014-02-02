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
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(227, 165)];
    menuBg.anchorPoint = CGPointMake(0.5, 1);
    menuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.74);
    [self addChild:menuBg];
    
    // Menu - Single Player button
    SKButton *singleButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-single" selected:@"mainmenu-button-single-highlight"];
    singleButton.position = CGPointMake(0, -menuBg.size.height * 0.25);
    [singleButton setTouchUpInsideTarget:self action:@selector(_pressedSingleButton:)];
    [menuBg addChild:singleButton];
    
    // Menu - Multiplayer button
    SKButton *multiButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-multi" selected:@"mainmenu-button-multi-highlight"];
    multiButton.position = CGPointMake(0, -menuBg.size.height * 0.75);
    [multiButton setTouchUpInsideTarget:self action:@selector(_pressedMultiplayerButton:)];
    [menuBg addChild:multiButton];
    
    
    
    // Temp menu
    SKButton *connectToIpadButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-single" selected:@"mainmenu-button-single-highlight"];
    connectToIpadButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.15);
    [connectToIpadButton setTouchUpInsideTarget:self action:@selector(_pressedConnectToIpadButton:)];
    [self addChild:connectToIpadButton];
}

#pragma mark - Button actions
- (void)_pressedSingleButton:(id)sender
{
    // Present scene
    [self.view presentScene:[DDDanceMoveSelectionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

- (void)_pressedMultiplayerButton:(id)sender
{
    
}

- (void)_pressedConnectToIpadButton:(id)sender
{
    [self.view presentScene:[DDSearchingForExternalScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

@end