//
//  DTDDanceMoveResultsScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/24/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDDanceMoveResultsScene.h"
#import "DTDGameManager.h"
#import "DTDDanceMoveSelectionScene.h"
#import "DTDDanceMoveInstructionsScene.h"

@interface DTDDanceMoveResultsScene()

@property (nonatomic, strong) DTDDanceMove *danceMove;
@property (nonatomic, strong) NSArray *results;

// Sprite management
@property (nonatomic, strong) NSMutableArray *moveResultsArray;
@property (nonatomic, strong) NSMutableArray *stepResultsArray;
@property (nonatomic) NSUInteger lastClickedIndex;
@property (nonatomic) BOOL isResultExpanded;

@end

@implementation DTDDanceMoveResultsScene

+ (instancetype)sceneWithSize:(CGSize)size results:(NSArray *)results
{
    return [[self alloc] initWithSize:size results:results];
}

- (instancetype)initWithSize:(CGSize)size results:(NSArray *)results
{
    self = [self initWithSize:size];
    if (self)
    {
        self.backgroundColor = RGB(249, 185, 56);
        _results = results;
        _danceMove = [DTDGameManager sharedGameManager].individualDanceMove;
        
        [self _displayTopBar];
        [self _displayResults];
        [self _displayMenu];
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
    instructionsLabel.text = @"RESULTS";
    instructionsLabel.fontColor = RGB(249, 185, 56);
    instructionsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    instructionsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    instructionsLabel.position = CGPointMake(topBannerBg.size.width * 0.97, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:instructionsLabel];
}

- (void)_displayResults
{
    self.lastClickedIndex = self.danceMove.numIndividualIterations;
    self.isResultExpanded = NO;
    self.moveResultsArray = [NSMutableArray arrayWithCapacity:self.danceMove.numIndividualIterations];
    self.stepResultsArray = [NSMutableArray arrayWithCapacity:self.danceMove.numIndividualIterations];
    
    CGFloat positionY = self.size.height * 0.68;
    NSArray *currentIterationResults;
    BOOL isIterationCorrect;
    NSUInteger numIterationsCorrect = 0;
    
    // Set up results per iteration
    for (NSUInteger i=0; i<self.results.count; i++)
    {
        // Add results bg
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(215, 55)];
        bg.position = CGPointMake(self.size.width * 0.45, positionY);
        [self addChild:bg];
        
        // Add move label
        SKLabelNode *moveLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
        moveLabel.fontSize = 32;
        moveLabel.fontColor = RGB(56, 56, 56);
        moveLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        moveLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        moveLabel.position = CGPointMake(-bg.size.width * 0.43, 0);
        moveLabel.text = [NSString stringWithFormat:@"Move %i", i+1];
        [bg addChild:moveLabel];
        
        // Add result
        SKSpriteNode *result;
        currentIterationResults = self.results[i];
        isIterationCorrect = YES;
        for (NSNumber *stepResult in currentIterationResults)
        {
            if (stepResult.boolValue == NO)
            {
                isIterationCorrect = NO;
                break;
            }
        }
        
        if (isIterationCorrect)
        {
            numIterationsCorrect++;
            result = [SKSpriteNode spriteNodeWithImageNamed:@"results-correct"];
            result.color = RGB(154, 140, 41);
        }
        else
        {
            result = [SKSpriteNode spriteNodeWithImageNamed:@"results-incorrect"];
            result.color = RGB(153, 64, 32);
        }
        result.colorBlendFactor = 1.0;
        result.position = CGPointMake(bg.size.width * 0.3, 0);
        [bg addChild:result];
        
        // Update positionY
        positionY = positionY - bg.size.height * 1.2;
    }
    
    // Add message
    NSString *messageFile;
    if (numIterationsCorrect == self.danceMove.numIndividualIterations)
    {
        messageFile = @"results-nice-moves.png";
    }
    else if (numIterationsCorrect == (self.danceMove.numIndividualIterations - 1))
    {
        messageFile = @"results-so-close.png";
    }
    else
    {
        messageFile = @"results-do-better.png";
    }
    
    SKSpriteNode *messageSprite = [SKSpriteNode spriteNodeWithImageNamed:messageFile];
    messageSprite.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.83);
    if (IS_IPHONE_4)
    {
        [messageSprite setScale:0.8];
    }
    [self addChild:messageSprite];
}

- (void)_displayMenu {
    SKButton *mainMenuButton = [SKButton buttonWithImageNamedNormal:@"results-button-mainmenu" selected:@"results-button-mainmenu-highlight"];
    mainMenuButton.anchorPoint = CGPointMake(1, 0);
    mainMenuButton.position = CGPointMake(self.size.width * 0.545, self.size.height * 0.05);
    [mainMenuButton setTouchUpInsideTarget:self action:@selector(_pressedMainMenu:)];
    [self addChild:mainMenuButton];
    
    SKButton *tryAgainButton = [SKButton buttonWithImageNamedNormal:@"results-button-tryagain" selected:@"results-button-tryagain-highlight"];
    tryAgainButton.anchorPoint = CGPointMake(0, 0);
    tryAgainButton.position = CGPointMake(self.size.width * 0.52, mainMenuButton.position.y);
    [tryAgainButton setTouchUpInsideTarget:self action:@selector(_pressedTryAgain:)];
    [self addChild:tryAgainButton];
}

#pragma mark - Button actions
- (void)_pressedMainMenu:(id)sender
{
    [self.view presentScene:[DTDDanceMoveSelectionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

- (void)_pressedTryAgain:(id)sender
{
    [self.view presentScene:[DTDDanceMoveInstructionsScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

@end
