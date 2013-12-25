//
//  DTDDanceMoveSelectionScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/14/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDDanceMoveSelectionScene.h"
#import "DTDGameManager.h"
#import "DTDMainMenuScene.h"
#import "DTDDanceMoveInstructionsScene.h"
#import "DTDDanceMoveBernie.h"

@implementation DTDDanceMoveSelectionScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = RGB(249, 185, 56);
        
        [self _displayTopBar];
        [self _displayDanceMoves];
        [self _displayBottomPageControls];
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
    bernieButton.name = [@(kDanceMoveBernie) stringValue];
    [bernieButton setTouchUpInsideTarget:self action:@selector(_showDanceInstructions:)];
    [self addChild:bernieButton];
    
    SKLabelNode *bernieLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    bernieLabel.fontColor = RGB(56, 56, 56);
    bernieLabel.fontSize = 31;
    bernieLabel.text = @"Bernie";
    bernieLabel.position = CGPointMake(0, bernieButton.size.height * 0.23f);
    [bernieButton addChild:bernieLabel];
    
    SKSpriteNode *bernieImage = [SKSpriteNode spriteNodeWithImageNamed:@"select-dance-bernie"];
    bernieImage.position = CGPointMake(0, -bernieButton.size.height * 0.16f);
    [bernieButton addChild:bernieImage];
    
    // Peter Griffin
    SKButton *peterGriffinButton = [[SKButton alloc] initWithColor:RGB(249, 228, 172) size:CGSizeMake(261, 129)];
    peterGriffinButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.51);
    [self addChild:peterGriffinButton];
    
    SKLabelNode *peterGriffinLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    peterGriffinLabel.fontColor = RGB(56, 56, 56);
    peterGriffinLabel.fontSize = 31;
    peterGriffinLabel.text = @"Peter Griffin";
    peterGriffinLabel.position = CGPointMake(0, peterGriffinButton.size.height * 0.23f);
    [peterGriffinButton addChild:peterGriffinLabel];
    
    SKSpriteNode *peterGriffinImage = [SKSpriteNode spriteNodeWithImageNamed:@"select-dance-soon"];
    peterGriffinImage.position = CGPointMake(0, -peterGriffinButton.size.height * 0.10f);
    [peterGriffinButton addChild:peterGriffinImage];
    
    // Cat Daddy
    SKButton *catDaddyButton = [[SKButton alloc] initWithColor:RGB(249, 228, 172) size:CGSizeMake(261, 129)];
    catDaddyButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.26);
    [self addChild:catDaddyButton];
    
    SKLabelNode *catDaddyLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    catDaddyLabel.fontColor = RGB(56, 56, 56);
    catDaddyLabel.fontSize = 31;
    catDaddyLabel.text = @"Peter Griffin";
    catDaddyLabel.position = CGPointMake(0, catDaddyButton.size.height * 0.23);
    [catDaddyButton addChild:catDaddyLabel];
    
    SKSpriteNode *catDaddyImage = [SKSpriteNode spriteNodeWithImageNamed:@"select-dance-soon"];
    catDaddyImage.position = CGPointMake(0, -catDaddyButton.size.height * 0.1);
    [catDaddyButton addChild:catDaddyImage];
    
    // Scale down buttons for smaller devices
    if (IS_IPHONE_4)
    {
        CGFloat newScale = 0.87;
        [bernieButton setScale:newScale];
        [peterGriffinButton setScale:newScale];
        [catDaddyButton setScale:newScale];
    }
    
    // Temporarily disable dance moves that are not yet implemented
    peterGriffinButton.alpha = 0.4;
    catDaddyButton.alpha = 0.4;
    peterGriffinButton.isEnabled = NO;
    catDaddyButton.isEnabled = NO;
}

- (void)_displayBottomPageControls
{
    // Menu buttons
    SKButton *previousButton = [SKButton buttonWithImageNamedNormal:@"select-dance-button-prev" selected:@"select-dance-button-prev-highlight"];
    previousButton.position = CGPointMake(self.size.width * 0.185, self.size.height * 0.08);
    [self addChild:previousButton];
    
    SKButton *nextButton = [SKButton buttonWithImageNamedNormal:@"select-dance-button-next" selected:@"select-dance-button-next-highlight"];
    nextButton.position = CGPointMake(self.size.width * 0.815, self.size.height * 0.08);
    [self addChild:nextButton];
    
    // Temporarily disable menu buttons
    previousButton.alpha = 0.4;
    nextButton.alpha = 0.4;
    previousButton.isEnabled = NO;
    nextButton.isEnabled = NO;
    
    // Page info
    SKLabelNode *currentPageLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    currentPageLabel.fontColor = RGB(56, 56, 56);
    currentPageLabel.fontSize = 31;
    currentPageLabel.text = @"1";
    currentPageLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    currentPageLabel.position = CGPointMake(self.size.width * 0.39, self.size.height * 0.08);
    [self addChild:currentPageLabel];
    
    SKLabelNode *outOfLabel = [SKLabelNode labelNodeWithFontNamed:@"ACaslonPro-BoldItalic"];
    outOfLabel.fontColor = currentPageLabel.fontColor;
    outOfLabel.fontSize = 19;
    outOfLabel.text = @"out of";
    outOfLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    outOfLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.08);
    [self addChild:outOfLabel];
    
    SKLabelNode *totalPageLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    totalPageLabel.fontColor = currentPageLabel.fontColor;
    totalPageLabel.fontSize = 31;
    totalPageLabel.text = @"1";
    totalPageLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    totalPageLabel.position = CGPointMake(self.size.width * 0.61, self.size.height * 0.08);
    [self addChild:totalPageLabel];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    [self.view presentScene:[DTDMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

- (void)_showDanceInstructions:(id)sender
{
    DanceMoves danceMoveType = [[(SKButton *)sender name] intValue];
    
    if (danceMoveType != kDanceMoveNone)
    {
        DTDDanceMove *danceMove;
        switch (danceMoveType)
        {
            case kDanceMoveBernie:
                danceMove = [[DTDDanceMoveBernie alloc] init];
                break;
                
            default:
                NSLog(@"DTDDanceMoveSelectionScene->_showDanceInstructions: INVALID DANCE MOVE!");
                return;
        }
        
        DTDGameManager *gm = [DTDGameManager sharedGameManager];
        gm.individualDanceMove = danceMove;
        
        // Transition to instructions cene
        [self.view presentScene:[DTDDanceMoveInstructionsScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
    }
}

@end
