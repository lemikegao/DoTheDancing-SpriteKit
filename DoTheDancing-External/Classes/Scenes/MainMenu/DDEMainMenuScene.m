//
//  DTDMainMenuScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/20/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDEMainMenuScene.h"
#import "DDESearchingForControllerScene.h"

@implementation DDEMainMenuScene

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
    SKSpriteNode *menuBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(560, 150)];
    menuBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.6);
    [self addChild:menuBg];

    // Button - Connect to Controller
    SKButton *controllerButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-connect" selected:@"mainmenu-button-connect-highlight"];
    controllerButton.position = CGPointMake(0, 0);
    [controllerButton setTouchUpInsideTarget:self action:@selector(_pressedConnectToControllerButton:)];
    [menuBg addChild:controllerButton];

}

#pragma mark - Button actions
- (void)_pressedConnectToControllerButton:(id)sender
{
    [self.view presentScene:[DDESearchingForControllerScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

- (void)_pressedSingleButton:(id)sender
{
    
}

- (void)_pressedMultiplayerButton:(id)sender
{
    
}

@end
