//
//  DTDDanceMoveSelectionScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/14/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDDanceMoveSelectionScene.h"
#import "DTDMainMenuScene.h"

@implementation DTDDanceMoveSelectionScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = RGB(249, 185, 56);
        
        [self _displayTopBar];
        [self _displayDanceMoves];
    }
    return self;
}

#pragma mark - Setup UI
- (void)_displayTopBar
{
    // Top banner bg
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(320, 43)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32;
    titleLabel.text = @"Select Dance";
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

- (void)_displayDanceMoves
{
    // Bernie
    SKButton *bernieButton = [[SKButton alloc] initWithColor:RGB(249, 228, 172) size:CGSizeMake(261, 129)];
    bernieButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.76);
    [self addChild:bernieButton];
    
    // Peter Griffin
    SKButton *peterGriffinButton = [bernieButton copy];
    peterGriffinButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.51);
    [self addChild:peterGriffinButton];
    
    // Cat Daddy
    SKButton *catDaddyButton = [bernieButton copy];
    catDaddyButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.26);
    [self addChild:catDaddyButton];
    
    
    // Temporarily disable dance moves that are not yet implemented
    peterGriffinButton.alpha = 0.4f;
    catDaddyButton.alpha = 0.4f;
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    [self.view presentScene:[DTDMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

@end
