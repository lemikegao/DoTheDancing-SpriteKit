//
//  DTDMainMenuScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/7/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDMainMenuScene.h"

@implementation DTDMainMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size])
    {
        // Background
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-bg"];
        bg.anchorPoint = CGPointMake(0, 1);
        bg.position = CGPointMake(0, self.size.height);
        [self addChild:bg];
        
        // Logo
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-logo1"];
        logo.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.87);
        [self addChild:logo];
        
        // Animate logo
        SKAction *logoAnimation = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"mainmenu-logo2"], [SKTexture textureWithImageNamed:@"mainmenu-logo1"]] timePerFrame:0.25];
        [logo runAction:[SKAction repeatActionForever:logoAnimation]];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    UIImage *tempImage;         // Used to get size for buttons
    
    // Menu - Bg
    UIImageView *mainMenuBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainmenu-cream-box"]];
    mainMenuBg.layer.anchorPoint = CGPointMake(0.5, 1);
    mainMenuBg.layer.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.55);
    [mainMenuBg setUserInteractionEnabled:YES];
    [self.view addSubview:mainMenuBg];
    
    // Menu - Single Player button
    UIButton *mainMenuSingleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempImage = [UIImage imageNamed:@"mainmenu-button-single"];
    [mainMenuSingleButton setImage:tempImage forState:UIControlStateNormal];
    [mainMenuSingleButton setImage:[UIImage imageNamed:@"mainmenu-button-single-highlight"] forState:UIControlStateHighlighted];
    [mainMenuSingleButton setBounds:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height)];
    mainMenuSingleButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
    mainMenuSingleButton.layer.position = CGPointMake(mainMenuBg.frame.size.width * 0.5, mainMenuBg.frame.size.height * 0.25);
    [mainMenuBg addSubview:mainMenuSingleButton];
    
    // Menu - Multiplayer button
    UIButton *mainMenuMultiplayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempImage = [UIImage imageNamed:@"mainmenu-button-multi"];
    [mainMenuMultiplayerButton setImage:tempImage forState:UIControlStateNormal];
    [mainMenuMultiplayerButton setImage:[UIImage imageNamed:@"mainmenu-button-multi-highlight"] forState:UIControlStateHighlighted];
    [mainMenuMultiplayerButton setBounds:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height)];
    mainMenuMultiplayerButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
    mainMenuMultiplayerButton.layer.position = CGPointMake(mainMenuBg.frame.size.width * 0.5, mainMenuBg.frame.size.height * 0.75);
    [mainMenuBg addSubview:mainMenuMultiplayerButton];
}

@end
