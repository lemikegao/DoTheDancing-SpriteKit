//
//  DTDDanceMoveSeeInActionScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/23/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDDanceMoveSeeInActionScene.h"
#import "DTDGameManager.h"
#import "DTDDanceMove.h"
#import "SKMultilineLabel.h"

@interface DTDDanceMoveSeeInActionScene()

@property (nonatomic, strong) DTDDanceMove *danceMove;

// Sprite management
@property (nonatomic, strong) SKLabelNode *movesCompletedCountLabel;
@property (nonatomic, strong) SKSpriteNode *illustration;
@property (nonatomic, strong) SKMultilineLabel *countdownLabel;

@end

@implementation DTDDanceMoveSeeInActionScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = RGB(249, 185, 56);
        _danceMove = [DTDGameManager sharedGameManager].individualDanceMove;
        
        [self _displayTopBar];
        [self _displayMovesCompletedBar];
        [self _displayIllustration];
    }
    
    return self;
}

#pragma mark - UI setup
- (void)_displayTopBar
{
    // Top bar bg
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(320, 43)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Dance move name
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32;
    titleLabel.text = self.danceMove.name;
    titleLabel.fontColor = RGB(249, 185, 56);
    titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    titleLabel.position = CGPointMake(self.size.width * 0.5f, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:titleLabel];
    
    // 'IN ACTION' label
    SKLabelNode *instructionsLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Italic"];
    instructionsLabel.fontSize = 16.5;
    instructionsLabel.text = @"IN ACTION";
    instructionsLabel.fontColor = RGB(249, 185, 56);
    instructionsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    instructionsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    instructionsLabel.position = CGPointMake(topBannerBg.size.width * 0.97, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:instructionsLabel];
}

- (void)_displayMovesCompletedBar
{
    // Moves completed bg
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(261, 34)];
    if (IS_IPHONE_4)
    {
        bg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.85);
    } else {
        bg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.87);
    }
    [self addChild:bg];
    
    // Moves completed label
    SKLabelNode *movesCompletedLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    movesCompletedLabel.fontSize = 20;
    movesCompletedLabel.fontColor = RGB(56, 56, 56);
    movesCompletedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    movesCompletedLabel.position = CGPointMake(-bg.size.width * 0.43, -bg.size.height * 0.25);
    movesCompletedLabel.text = @"Moves Completed:";
    [bg addChild:movesCompletedLabel];
    
    // Moves completed count label
    self.movesCompletedCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    self.movesCompletedCountLabel.fontSize = 31;
    self.movesCompletedCountLabel.fontColor = RGB(204, 133, 18);
    self.movesCompletedCountLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.movesCompletedCountLabel.position = CGPointMake(bg.size.width * 0.1, 0);
    self.movesCompletedCountLabel.text = @"0";
    [bg addChild:self.movesCompletedCountLabel];
    
    // 'out of' label
    SKLabelNode *outOfLabel = [SKLabelNode labelNodeWithFontNamed:@"ACaslonPro-BoldItalic"];
    outOfLabel.fontSize = 19;
    outOfLabel.fontColor = self.movesCompletedCountLabel.fontColor;
    outOfLabel.position = CGPointMake(bg.size.width * 0.25, -bg.size.height * 0.2);
    outOfLabel.text = @"out of";
    [bg addChild:outOfLabel];
    
    // Total moves label
    SKLabelNode *totalMovesLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    totalMovesLabel.fontSize = self.movesCompletedCountLabel.fontSize;
    totalMovesLabel.fontColor = self.movesCompletedCountLabel.fontColor;
    totalMovesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    totalMovesLabel.position = CGPointMake(bg.size.width * 0.39, self.movesCompletedCountLabel.position.y);
    totalMovesLabel.text = @(self.danceMove.numIndividualIterations).stringValue;
    [bg addChild:totalMovesLabel];
}

- (void)_displayIllustration
{
    // Init illustration with instruction sign
    self.illustration = [SKSpriteNode spriteNodeWithImageNamed:@"countdown-illustration"];
    if (IS_IPHONE_4)
    {
        self.illustration.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.45);
    }
    else
    {
        self.illustration.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    }
    [self addChild:self.illustration];
    
    // Display 'Ready?' label
    self.countdownLabel = [SKMultilineLabel multilineLabelFromStringContainingNewLines:@"Watch &\nLearn" fontName:@"Economica-Bold" fontColor:RGB(56, 56, 56) fontSize:51 verticalMargin:4 emptyLineHeight:0];
    self.countdownLabel.position = self.illustration.position;
    [self addChild:self.countdownLabel];
}

@end
