//
//  DDDanceMoveSelectionScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/14/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DDDanceMoveSelectionScene.h"
#import "DDDanceMoveInstructionsScene.h"
#import "DDDanceMoveBernie.h"

#if CONTROLLER
#import "DDMainMenuScene.h"
#else
#import "DDEMainMenuScene.h"
#endif

@implementation DDDanceMoveSelectionScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
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
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(self.size.width, 43 * self.sizeMultiplier)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32 * self.sizeMultiplier;
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
    SKButton *bernieButton = [[SKButton alloc] initWithColor:RGB(249, 228, 172) size:CGSizeMake(261 * self.sizeMultiplier, 129 * self.sizeMultiplier)];
    bernieButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.76);
    bernieButton.name = [@(kDanceMoveBernie) stringValue];
    [bernieButton setTouchUpInsideTarget:self action:@selector(_showDanceInstructions:)];
    [self addChild:bernieButton];
    
    SKLabelNode *bernieLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    bernieLabel.fontColor = RGB(56, 56, 56);
    bernieLabel.fontSize = 31 * self.sizeMultiplier;
    bernieLabel.text = @"Bernie";
    bernieLabel.position = CGPointMake(0, bernieButton.size.height * 0.23f);
    [bernieButton addChild:bernieLabel];
    
    SKSpriteNode *bernieImage = [SKSpriteNode spriteNodeWithImageNamed:@"select-dance-bernie"];
    bernieImage.position = CGPointMake(0, -bernieButton.size.height * 0.16f);
    [bernieButton addChild:bernieImage];
    
    // Peter Griffin
    SKButton *peterGriffinButton = [[SKButton alloc] initWithColor:RGB(249, 228, 172) size:CGSizeMake(bernieButton.size.width, bernieButton.size.height)];
    peterGriffinButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.51);
    [self addChild:peterGriffinButton];
    
    SKLabelNode *peterGriffinLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    peterGriffinLabel.fontColor = RGB(56, 56, 56);
    peterGriffinLabel.fontSize = bernieLabel.fontSize;
    peterGriffinLabel.text = @"Peter Griffin";
    peterGriffinLabel.position = CGPointMake(0, peterGriffinButton.size.height * 0.23f);
    [peterGriffinButton addChild:peterGriffinLabel];
    
    SKSpriteNode *peterGriffinImage = [SKSpriteNode spriteNodeWithImageNamed:@"select-dance-soon"];
    peterGriffinImage.position = CGPointMake(0, -peterGriffinButton.size.height * 0.10f);
    [peterGriffinButton addChild:peterGriffinImage];
    
    // Cat Daddy
    SKButton *catDaddyButton = [[SKButton alloc] initWithColor:RGB(249, 228, 172) size:CGSizeMake(bernieButton.size.width, bernieButton.size.height)];
    catDaddyButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.26);
    [self addChild:catDaddyButton];
    
    SKLabelNode *catDaddyLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    catDaddyLabel.fontColor = RGB(56, 56, 56);
    catDaddyLabel.fontSize = bernieLabel.fontSize;
    catDaddyLabel.text = @"Peter Griffin";
    catDaddyLabel.position = CGPointMake(0, catDaddyButton.size.height * 0.23);
    [catDaddyButton addChild:catDaddyLabel];
    
    SKSpriteNode *catDaddyImage = [SKSpriteNode spriteNodeWithImageNamed:@"select-dance-soon"];
    catDaddyImage.position = CGPointMake(0, -catDaddyButton.size.height * 0.1);
    [catDaddyButton addChild:catDaddyImage];
    
    if (IS_IPHONE_4 || IS_IPAD)
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
    currentPageLabel.fontSize = 31 * self.sizeMultiplier;
    currentPageLabel.text = @"1";
    currentPageLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    currentPageLabel.position = CGPointMake(self.size.width * 0.39, self.size.height * 0.08);
    [self addChild:currentPageLabel];
    
    SKLabelNode *outOfLabel = [SKLabelNode labelNodeWithFontNamed:@"ACaslonPro-BoldItalic"];
    outOfLabel.fontColor = currentPageLabel.fontColor;
    outOfLabel.fontSize = 19 * self.sizeMultiplier;
    outOfLabel.text = @"out of";
    outOfLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    outOfLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.08);
    [self addChild:outOfLabel];
    
    SKLabelNode *totalPageLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    totalPageLabel.fontColor = currentPageLabel.fontColor;
    totalPageLabel.fontSize = currentPageLabel.fontSize;
    totalPageLabel.text = @"1";
    totalPageLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    totalPageLabel.position = CGPointMake(self.size.width * 0.61, self.size.height * 0.08);
    [self addChild:totalPageLabel];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    Class mainMenuClass;
#if CONTROLLER
    mainMenuClass = [DDMainMenuScene class];
#else
    mainMenuClass = [DDEMainMenuScene class];
#endif
    [self.view presentScene:[mainMenuClass sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

- (void)_showDanceInstructions:(id)sender
{
    DanceMoves danceMoveType = [[(SKButton *)sender name] intValue];
    
    if (danceMoveType != kDanceMoveNone)
    {
        DDDanceMove *danceMove;
        switch (danceMoveType)
        {
            case kDanceMoveBernie:
                danceMove = [[DDDanceMoveBernie alloc] init];
                break;
                
            default:
                NSLog(@"DDDanceMoveSelectionScene->_showDanceInstructions: INVALID DANCE MOVE!");
                return;
        }
        
        DDGameManager *gm = [DDGameManager sharedGameManager];
        gm.individualDanceMove = danceMove;
        
        // Transition to instructions cene
        [self.view presentScene:[DDDanceMoveInstructionsScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
    }
}

@end
