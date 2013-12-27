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
@property (nonatomic, strong) NSMutableArray *expandButtons;

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
        _expandButtons = [[NSMutableArray alloc] initWithCapacity:self.danceMove.numIndividualIterations];
        
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
        
        // Add + button
        SKButton *expandResultsButton = [SKButton buttonWithImageNamedNormal:@"results-plus" selected:@"results-plus-highlight"];
        expandResultsButton.name = @(i).stringValue;
        [expandResultsButton setTouchUpInsideTarget:self action:@selector(_pressedExpandResults:)];
        expandResultsButton.position = CGPointMake(self.size.width * 0.87, bg.position.y);
        [self addChild:expandResultsButton];
        self.expandButtons[i] = expandResultsButton;
        
        // Add detailed step results
        SKSpriteNode *detailedResultsBg = [SKSpriteNode spriteNodeWithColor:RGBA(249, 228, 172, 0.4) size:bg.size];
        detailedResultsBg.position = CGPointMake(bg.position.x, bg.position.y - bg.size.height);
        detailedResultsBg.hidden = YES;
        [self addChild:detailedResultsBg];
        
        // Add 'Steps' label
        SKLabelNode *stepsLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
        stepsLabel.fontSize = 18;
        stepsLabel.fontColor = RGB(56, 56, 56);
        stepsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        stepsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        stepsLabel.text = @"Steps";
        stepsLabel.position = CGPointMake(-detailedResultsBg.size.width * 0.43, detailedResultsBg.size.height * 0.15);
        [detailedResultsBg addChild:stepsLabel];
        
        // Add detailed results circles
        for (NSUInteger j=0; j<currentIterationResults.count; j++)
        {
            SKSpriteNode *dot = [SKSpriteNode spriteNodeWithImageNamed:@"results-dot"];
            dot.color = [currentIterationResults[j] boolValue] == YES ? RGB(154, 140, 41) : RGB(153, 64, 32);
            dot.colorBlendFactor = 1;
            dot.position = CGPointMake(-detailedResultsBg.size.width * 0.4 + j*detailedResultsBg.size.width * 0.15, -detailedResultsBg.size.height * 0.20);
            [detailedResultsBg addChild:dot];
        }
        
        // Add result views to array
        self.moveResultsArray[i] = bg;
        self.stepResultsArray[i] = detailedResultsBg;
        
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

- (void)_pressedExpandResults:(id)sender
{
    SKSpriteNode *tempSteps;
    SKSpriteNode *tempMove;
    SKButton *tempButton;
    SKButton *tempSender = (SKButton *)sender;
    NSUInteger senderIndex = tempSender.name.integerValue;
    
    // Nothing is currently expanded
    if (self.isResultExpanded == NO)
    {
        [self _showDetailedResultsFromSender:sender];
    }
    else
    {
        // Switch previous clicked button to +
        tempButton = self.expandButtons[self.lastClickedIndex];
        tempButton.normalTexture = [SKTexture textureWithImageNamed:@"results-plus"];
        tempButton.selectedTexture = [SKTexture textureWithImageNamed:@"results-plus-highlight"];
        
        // Hide expanded results
        tempSteps = self.stepResultsArray[self.lastClickedIndex];
        tempSteps.hidden = YES;
        
        // Move results up
        for (NSUInteger i=self.lastClickedIndex+1; i<self.danceMove.numIndividualIterations; i++)
        {
            tempMove = self.moveResultsArray[i];
            tempMove.position = CGPointMake(tempMove.position.x, tempMove.position.y + tempMove.size.height);
            tempButton = self.expandButtons[i];
            tempButton.position = CGPointMake(tempButton.position.x, tempMove.position.y);
        }
        
        // If clicking previously expanded result, only move appropriate results up and don't show any steps
        if (self.lastClickedIndex == senderIndex)
        {
            self.isResultExpanded = NO;
        }
        else
        {
            // Else, move results down and show detailed steps
            [self _showDetailedResultsFromSender:sender];
        }
    }
}

- (void)_showDetailedResultsFromSender:(id)sender
{
    SKSpriteNode *tempSteps;
    SKSpriteNode *tempMove;
    SKButton *tempButton;
    SKButton *tempSender = (SKButton *)sender;
    NSUInteger senderIndex = tempSender.name.integerValue;
    
    // Switch button to minus
    tempSender.normalTexture = [SKTexture textureWithImageNamed:@"results-minus"];
    tempSender.selectedTexture = [SKTexture textureWithImageNamed:@"results-minus-highlight"];
    
    // Move appropriate results down
    for (NSUInteger i=senderIndex+1; i<self.danceMove.numIndividualIterations; i++)
    {
        tempMove = self.moveResultsArray[i];
        tempMove.position = CGPointMake(tempMove.position.x, tempMove.position.y - tempMove.size.height);
        tempButton = self.expandButtons[i];
        tempButton.position = CGPointMake(tempButton.position.x, tempMove.position.y);
    }
    
    // Show detailed results
    tempSteps = self.stepResultsArray[senderIndex];
    tempSteps.hidden = NO;
    
    self.isResultExpanded = YES;
    self.lastClickedIndex = senderIndex;
}

@end
