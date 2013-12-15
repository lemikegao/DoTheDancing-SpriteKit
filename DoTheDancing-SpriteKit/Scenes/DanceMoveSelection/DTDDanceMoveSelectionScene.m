//
//  DTDDanceMoveSelectionScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/14/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDDanceMoveSelectionScene.h"

@implementation DTDDanceMoveSelectionScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:249/255.0 green:185/255.0 blue:56/255.0 alpha:1.0];
        
        [self _displayTopBar];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
}

#pragma mark - Setup UI
- (void)_displayTopBar
{
    // Top banner bg
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0] size:CGSizeMake(320, 43)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Title label
    
//    CCLabelBMFont *selectDanceLabel = [CCLabelBMFont labelWithString:@"Select Dance" fntFile:@"economica-bold_64.fnt"];
//    selectDanceLabel.color = ccc3(249, 185, 56);
//    selectDanceLabel.position = ccp(self.screenSize.width * 0.5, topBannerBg.contentSize.height * 0.5);
//    [topBannerBg addChild:selectDanceLabel];
}

@end
