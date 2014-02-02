//
//  DDDanceMoveSeeInActionScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/23/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DDDanceMoveSeeInActionScene.h"
#import "DDDanceMoveInstructionsScene.h"
#import "DDDanceMoveTryItOutScene.h"
#import "SKMultilineLabel.h"
#import "TCProgressTimerNode.h"

@interface DDDanceMoveSeeInActionScene()

@property (nonatomic, strong) DDDanceMove *danceMove;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) BOOL isSceneOver;

// Sprite management
@property (nonatomic, strong) SKLabelNode *movesCompletedCountLabel;
@property (nonatomic, strong) SKSpriteNode *illustration;
@property (nonatomic, strong) SKMultilineLabel *countdownLabel;
@property (nonatomic, strong) SKLabelNode *stepCountLabel;
@property (nonatomic, strong) TCProgressTimerNode *stepTimer;
@property (nonatomic, strong) NSArray *hiddenMenuItems;

// Countdown
@property (nonatomic) CGFloat countdownElapsedTime;
@property (nonatomic) BOOL isCountdownActivated;
@property (nonatomic) NSUInteger currentCountdownNum;

// Illustration management
@property (nonatomic) BOOL isDanceActivated;
@property (nonatomic) CGFloat currentStepElapsedTime;
@property (nonatomic) CGFloat currentIterationElapsedTime;
@property (nonatomic) NSUInteger currentStep;
@property (nonatomic) NSUInteger currentIteration;
@property (nonatomic) CGFloat timeToMoveToNextStep;

@end

@implementation DDDanceMoveSeeInActionScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        // Init properties
        _danceMove = [DDGameManager sharedGameManager].individualDanceMove;
        _countdownElapsedTime = 0;
        _isCountdownActivated = NO;
        _currentCountdownNum = 3;
        _isDanceActivated = NO;
        _currentStepElapsedTime = 0;
        _currentIterationElapsedTime = 0;
        _currentStep = 1;
        _currentIteration = 1;
        _timeToMoveToNextStep = [self.danceMove.timePerSteps[0] floatValue];
        _isSceneOver = NO;
        
        // Set up UI
        [self _displayTopBar];
        [self _displayMovesCompletedBar];
        [self _displayIllustration];
        [self _addStepLabelAndTimer];
        [self _addMenu];
        
        // Play background music
        [[DDGameManager sharedGameManager] playBackgroundMusic:self.danceMove.trackName];
    }
    
    return self;
}

#pragma mark - UI setup
- (void)_displayTopBar
{
    // Top bar bg
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(self.size.width, 43*self.sizeMultiplier)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Dance move name
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32*self.sizeMultiplier;
    titleLabel.text = self.danceMove.name;
    titleLabel.fontColor = RGB(249, 185, 56);
    titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    titleLabel.position = CGPointMake(self.size.width * 0.5f, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:titleLabel];
    
    // 'IN ACTION' label
    SKLabelNode *instructionsLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Italic"];
    instructionsLabel.fontSize = 16.5*self.sizeMultiplier;
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
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(261*self.sizeMultiplier, 34*self.sizeMultiplier)];
    if (IS_IPHONE_4 || IS_IPAD)
    {
        bg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.85);
    } else {
        bg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.87);
    }
    [self addChild:bg];
    
    // Moves completed label
    SKLabelNode *movesCompletedLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    movesCompletedLabel.fontSize = 20*self.sizeMultiplier;
    movesCompletedLabel.fontColor = RGB(56, 56, 56);
    movesCompletedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    movesCompletedLabel.position = CGPointMake(-bg.size.width * 0.43, -bg.size.height * 0.25);
    movesCompletedLabel.text = @"Moves Completed:";
    [bg addChild:movesCompletedLabel];
    
    // Moves completed count label
    self.movesCompletedCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    self.movesCompletedCountLabel.fontSize = 31*self.sizeMultiplier;
    self.movesCompletedCountLabel.fontColor = RGB(204, 133, 18);
    self.movesCompletedCountLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.movesCompletedCountLabel.position = CGPointMake(bg.size.width * 0.1, 0);
    self.movesCompletedCountLabel.text = @"0";
    [bg addChild:self.movesCompletedCountLabel];
    
    // 'out of' label
    SKLabelNode *outOfLabel = [SKLabelNode labelNodeWithFontNamed:@"ACaslonPro-BoldItalic"];
    outOfLabel.fontSize = 19*self.sizeMultiplier;
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
    if (IS_IPHONE_4 || IS_IPAD)
    {
        self.illustration.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.45);
    }
    else
    {
        self.illustration.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    }
    [self addChild:self.illustration];
    
    // Display 'Ready?' label
    self.countdownLabel = [SKMultilineLabel multilineLabelFromStringContainingNewLines:@"Watch &\nLearn" fontName:@"Economica-Bold" fontColor:RGB(56, 56, 56) fontSize:51*self.sizeMultiplier verticalMargin:4 emptyLineHeight:0];
    self.countdownLabel.position = self.illustration.position;
    [self addChild:self.countdownLabel];
}

- (void)_addStepLabelAndTimer
{
    // Add invisible step count label
    self.stepCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    self.stepCountLabel.fontSize = 31*self.sizeMultiplier;
    self.stepCountLabel.fontColor = RGB(56, 56, 56);
    self.stepCountLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    if (IS_IPHONE_4 || IS_IPAD)
    {
        self.stepCountLabel.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.03);
    }
    else
    {
        self.stepCountLabel.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.12);
    }
    self.stepCountLabel.text = @"Step 1";
    self.stepCountLabel.hidden = YES;
    [self addChild:self.stepCountLabel];
    
    // Add invisible step timer
    self.stepTimer = [[TCProgressTimerNode alloc] initWithForegroundImageNamed:@"inaction-timer" backgroundImageNamed:Nil accessoryImageNamed:nil];
    self.stepTimer.position = CGPointMake(self.size.width * 0.62, self.stepCountLabel.position.y * 1.15);
    [self.stepTimer setProgress:0.999f];
    if (IS_IPHONE_4 || IS_IPAD)
    {
        self.stepTimer.scale = 0.7;
        self.stepTimer.position = CGPointMake(self.size.width * 0.6, self.stepCountLabel.position.y * 1.75);
    }
    self.stepTimer.hidden = YES;
    [self addChild:self.stepTimer];
}

- (void)_addMenu
{
    // 'TRY IT OUT!' button
    SKButton *tryItOutButton = [SKButton buttonWithImageNamedNormal:@"inaction-button-try" selected:@"inaction-button-try-highlight"];
    tryItOutButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.72);
    tryItOutButton.hidden = YES;
    [tryItOutButton setTouchUpInsideTarget:self action:@selector(_pressedTryItOut:)];
    [self addChild:tryItOutButton];
    
    // 'WATCH AGAIN' button
    SKButton *watchAgainButton = [SKButton buttonWithImageNamedNormal:@"inaction-button-watchagain" selected:@"inaction-button-watchagain-highlight"];
    watchAgainButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.58);
    watchAgainButton.hidden = YES;
    [watchAgainButton setTouchUpInsideTarget:self action:@selector(_pressedWatchAgain:)];
    [self addChild:watchAgainButton];
    
    // 'INSTRUCTIONS' button
    SKButton *instructionsButton = [SKButton buttonWithImageNamedNormal:@"inaction-button-instructions" selected:@"inaction-button-instructions-highlight"];
    instructionsButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.44);
    instructionsButton.hidden = YES;
    [instructionsButton setTouchUpInsideTarget:self action:@selector(_pressedInstructions:)];
    [self addChild:instructionsButton];
    
    self.hiddenMenuItems = @[tryItOutButton, watchAgainButton, instructionsButton];
}

#pragma mark - Countdown methods
- (void)_checkToStartCountdown
{
    if (self.isCountdownActivated == NO && self.countdownElapsedTime >= self.danceMove.timeToStartCountdown)
    {
        self.isCountdownActivated = YES;
        // Start countdown
        SKAction *wait = [SKAction waitForDuration:self.danceMove.delayForCountdown];
        SKAction *updateCountdown = [SKAction runBlock:^{
            [self _countdown];
        }];
        [self runAction:[SKAction repeatAction:[SKAction sequence:@[updateCountdown, wait]] count:3] completion:^{
            [self.countdownLabel removeFromParent];
            self.isDanceActivated = YES;
            self.stepCountLabel.hidden = NO;
            self.stepTimer.hidden = NO;
            [self _updateIllustrations];
        }];
    }
}

- (void)_countdown
{
    self.countdownLabel.text = @(self.currentCountdownNum).stringValue;
    self.currentCountdownNum--;
}

#pragma mark - Button actions
- (void)_pressedTryItOut:(id)sender
{
    [[DDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DDDanceMoveTryItOutScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

- (void)_pressedWatchAgain:(id)sender
{
    [[DDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DDDanceMoveSeeInActionScene sceneWithSize:self.size]];
}

- (void)_pressedInstructions:(id)sender
{
    [[DDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DDDanceMoveInstructionsScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

#pragma mark - Private methods
- (void)_moveOnToNextStep
{
    if (self.currentStep < self.danceMove.numSteps)
    {
        self.currentStep++;
        self.timeToMoveToNextStep = [self.danceMove.timePerSteps[self.currentStep-1] floatValue];
        self.stepCountLabel.text = [NSString stringWithFormat:@"Step %i", self.currentStep];
        self.currentStepElapsedTime = 0;
        
        [self _updateIllustrations];
    }
}

- (void)_moveOnToNextIteration
{
    self.currentIteration++;
    self.currentStep = 1;
    [self _updateIterationCountWithNum:self.currentIteration-1];
    self.stepCountLabel.text = @"Step 1";
    self.currentIterationElapsedTime = 0;
    self.currentStepElapsedTime = 0;
    self.timeToMoveToNextStep = [self.danceMove.timePerSteps[0] floatValue];
    
    [self _updateIllustrations];
}

- (void)_endScene
{
    [self _updateIterationCountWithNum:self.currentIteration];
    _isSceneOver = YES;
    
    // Remove illustration, step label, and step timer
    [self.illustration removeFromParent];
    [self.stepCountLabel removeFromParent];
    [self.stepTimer removeFromParent];
    
    // Display menu
    [self.hiddenMenuItems enumerateObjectsUsingBlock:^(SKButton *button, NSUInteger idx, BOOL *stop) {
        button.hidden = NO;
    }];
}

#pragma mark - Update

- (void)_updateIllustrations
{
    // Stop any animations
    [self.illustration removeAllActions];
    
    /* Update illustration */
    // Check for animation
    NSArray *currentIllustrations = self.danceMove.illustrationsForSteps[self.currentStep-1];
    if (currentIllustrations.count > 1)
    {
        // Animations!
        NSMutableArray *textures = [[NSMutableArray alloc] initWithCapacity:currentIllustrations.count];
        [currentIllustrations enumerateObjectsUsingBlock:^(NSString *textureFilename, NSUInteger idx, BOOL *stop) {
            textures[idx] = [SKTexture textureWithImageNamed:currentIllustrations[idx]];
        }];
        SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:[self.danceMove.delayForIllustrationAnimations[self.currentStep-1] floatValue] resize:YES restore:YES];
        [self.illustration runAction:[SKAction repeatActionForever:animation]];
    }
    else
    {
        // Static illustraton
        self.illustration.texture = [SKTexture textureWithImageNamed:currentIllustrations[0]];
        self.illustration.size = self.illustration.texture.size;
    }
}

- (void)_updateTimers
{
    // Update timer for current iteration
    [self.stepTimer setProgress:1.0f - (self.currentStepElapsedTime/self.timeToMoveToNextStep)];
    
    // Move to next iteration
    if (self.currentIterationElapsedTime >= self.danceMove.timePerIteration)
    {
        self.currentIterationElapsedTime = 0;
        self.currentStepElapsedTime = 0;
        // End scene
        if (self.currentIteration == self.danceMove.numIndividualIterations)
        {
            [self _endScene];
        }
        else
        {
            // Move on to next iteration
            [self _moveOnToNextIteration];
        }
    }
    else if (self.currentStepElapsedTime >= self.timeToMoveToNextStep)
    {
        // Move on to next step of current iteration
        self.currentStepElapsedTime = 0;
        [self _moveOnToNextStep];
    }
}

- (void)_updateIterationCountWithNum:(NSUInteger)num
{
    self.movesCompletedCountLabel.text = [NSString stringWithFormat:@"%i", num];
    
    // Enlarge and shrink animation
    self.movesCompletedCountLabel.scale = 2.5;
    [self.movesCompletedCountLabel runAction:[SKAction scaleTo:1.0 duration:0.2]];
}

- (void)update:(NSTimeInterval)currentTime
{
    if (_isSceneOver == NO)
    {
        // Keep track of deltaTime
        if (_lastUpdateTime)
        {
            _dt = currentTime - _lastUpdateTime;
        }
        else
        {
            _dt = 0;
        }
        _lastUpdateTime = currentTime;
        
        // Update dance timer & illustrations
        if (self.isDanceActivated == YES)
        {
            self.currentStepElapsedTime = self.currentStepElapsedTime + _dt;
            self.currentIterationElapsedTime = self.currentIterationElapsedTime + _dt;
            [self _updateTimers];
        }
        else if (self.isCountdownActivated == NO)
        {
            _countdownElapsedTime = _countdownElapsedTime + _dt;
            [self _checkToStartCountdown];
        }
    }
}

@end
