//
//  DDDanceMoveTryItOutScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/24/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DDDanceMoveTryItOutScene.h"
#import "DDDanceMoveResultsScene.h"
#import "TCProgressTimerNode.h"
#include <CoreMotion/CoreMotion.h>

@interface DDDanceMoveTryItOutScene()

@property (nonatomic, strong) DDDanceMove *danceMove;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) BOOL isSceneOver;

// Sprite management
@property (nonatomic, strong) SKLabelNode *movesCompletedCountLabel;
@property (nonatomic, strong) SKSpriteNode *illustration;
@property (nonatomic, strong) SKLabelNode *countdownLabel;
@property (nonatomic, strong) SKLabelNode *stepCountLabel;
@property (nonatomic, strong) TCProgressTimerNode *stepTimer;

// Countdown
@property (nonatomic) CGFloat countdownElapsedTime;
@property (nonatomic) BOOL isCountdownActivated;
@property (nonatomic) NSUInteger currentCountdownNum;

// Illustration management
@property (nonatomic) BOOL isDanceActivated;
@property (nonatomic) CGFloat currentStepElapsedTime;
@property (nonatomic) CGFloat currentIterationElapsedTime;
@property (nonatomic) NSUInteger currentPart;
@property (nonatomic) NSUInteger currentStep;
@property (nonatomic) NSUInteger currentIteration;
@property (nonatomic) CGFloat timeToMoveToNextStep;

// Dance detection
@property (nonatomic) BOOL shouldDetectDanceMove;
@property (nonatomic, strong) NSArray *currentDanceStepParts;
@property (nonatomic, strong) NSMutableArray *currentIterationStepsDetected;
@property (nonatomic, strong) NSMutableArray *danceIterationStepsDetected;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation DDDanceMoveTryItOutScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        _danceMove = [DDGameManager sharedGameManager].individualDanceMove;
        _isSceneOver = NO;
        
        // Initialize motion detection
        [self _initCountdown];
        [self _initDanceMoveDetection];
        
        // Set up UI
        [self _displayTopBar];
        [self _displayMovesCompletedBar];
        [self _displayIllustration];
        [self _addStepLabelAndTimer];
        
        // Play background track
        [[DDGameManager sharedGameManager] playBackgroundMusic:self.danceMove.trackName];
    }
    
    return self;
}

- (void)_initCountdown
{
    _isDanceActivated = NO;
    _isCountdownActivated = NO;
    _countdownElapsedTime = 0;
    self.currentCountdownNum = 3;
}

- (void)_initDanceMoveDetection
{
    _shouldDetectDanceMove = NO;
    _currentIteration = 1;
    _currentStep = 1;
    _currentPart = 1;
    _currentDanceStepParts = self.danceMove.stepsArray[0];
    _timeToMoveToNextStep = [self.danceMove.timePerSteps[0] floatValue];
    _danceIterationStepsDetected = [NSMutableArray arrayWithCapacity:self.danceMove.numIndividualIterations];
    [self _resetCurrentIterationStepsDetected];
    
    // Motion manager
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 1.0/60.0f;
    [_motionManager startDeviceMotionUpdates];
}

#pragma mark - Exit scene
- (void)willMoveFromView:(SKView *)view
{
    [self.motionManager stopDeviceMotionUpdates];
    
    [super willMoveFromView:view];
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
    instructionsLabel.text = @"DANCE MODE";
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
    self.countdownLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    self.countdownLabel.fontSize = 63*self.sizeMultiplier;
    self.countdownLabel.fontColor = RGB(56, 56, 56);
    self.countdownLabel.position = self.illustration.position;
    self.countdownLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.countdownLabel.text = @"Ready?";
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
            self.shouldDetectDanceMove = YES;
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

#pragma mark - Dance move detection
- (void)_resetCurrentIterationStepsDetected
{
    self.currentIterationStepsDetected = [NSMutableArray arrayWithCapacity:self.danceMove.numSteps];
    for (NSUInteger i=0; i < self.danceMove.numSteps; i++)
    {
        self.currentIterationStepsDetected[i] = @(NO);
    }
}

- (void)_detectDancePart
{
    CGFloat yaw = (RadiansToDegrees(self.motionManager.deviceMotion.attitude.yaw));
    CGFloat pitch = (RadiansToDegrees(self.motionManager.deviceMotion.attitude.pitch));
    CGFloat roll = (RadiansToDegrees(self.motionManager.deviceMotion.attitude.roll));
    CMAcceleration totalAcceleration = self.motionManager.deviceMotion.userAcceleration;
    
    if (self.shouldDetectDanceMove)
    {
        DDMotionRequirements *currentPartMotionRequirements = self.currentDanceStepParts[self.currentPart-1];
        if ((yaw > currentPartMotionRequirements.yawMin) &&
            (yaw < currentPartMotionRequirements.yawMax) &&
            (pitch > currentPartMotionRequirements.pitchMin) &&
            (pitch < currentPartMotionRequirements.pitchMax) &&
            (roll > currentPartMotionRequirements.rollMin) &&
            (roll < currentPartMotionRequirements.rollMax) &&
            (totalAcceleration.x > currentPartMotionRequirements.accelerationXMin) &&
            (totalAcceleration.x < currentPartMotionRequirements.accelerationXMax) &&
            (totalAcceleration.y > currentPartMotionRequirements.accelerationYMin) &&
            (totalAcceleration.y < currentPartMotionRequirements.accelerationYMax) &&
            (totalAcceleration.z > currentPartMotionRequirements.accelerationZMin) &&
            (totalAcceleration.z < currentPartMotionRequirements.accelerationZMax)) {
            NSLog(@"iteration: %i, step: %i, part: %i detected", self.currentIteration, self.currentStep, self.currentPart);
            
            [self _moveOnToNextPart];
        }
    }
}

- (void)_moveOnToNextIteration
{
    self.currentIteration++;
    self.currentStep = 1;
    self.currentPart = 1;
    self.shouldDetectDanceMove = YES;
    [self _updateIterationCountWithNum:self.currentIteration-1];
    self.stepCountLabel.text = @"Step 1";
    self.currentIterationElapsedTime = 0;
    self.currentStepElapsedTime = 0;
    self.timeToMoveToNextStep = [self.danceMove.timePerSteps[0] floatValue];
    self.currentDanceStepParts = self.danceMove.stepsArray[0];
    
    // Save results of current iteration
    [self.danceIterationStepsDetected addObject:self.currentIterationStepsDetected];
    [self _resetCurrentIterationStepsDetected];
    
    [self _updateIllustrations];
}

- (void)_moveOnToNextStep
{
    if (self.currentStep < self.danceMove.numSteps)
    {
        self.currentStep++;
        self.timeToMoveToNextStep = [self.danceMove.timePerSteps[self.currentStep-1] floatValue];
        self.stepCountLabel.text = [NSString stringWithFormat:@"Step %i", self.currentStep];
        self.currentDanceStepParts = self.danceMove.stepsArray[self.currentStep-1];
        self.currentPart = 1;
        self.shouldDetectDanceMove = YES;
        self.currentStepElapsedTime = 0;
        
        [self _updateIllustrations];
    }
}

- (void)_moveOnToNextPart
{
    if (self.currentPart == self.currentDanceStepParts.count)
    {
        // Step detected!
        self.shouldDetectDanceMove = NO;
        NSLog(@"Iteration: %i, Step: %i Successfully Detected!", self.currentIteration, self.currentStep);
        self.currentIterationStepsDetected[self.currentStep-1] = @(YES);
    }
    else
    {
        // Move on to next part
        self.currentPart++;
    }
}

#pragma mark - Private methods
- (void)_segueToResults
{
    // Terminate scene
    self.isSceneOver = YES;
    
    // Add last step results
    [self.danceIterationStepsDetected addObject:self.currentIterationStepsDetected];
    [self _updateIterationCountWithNum:self.currentIteration];
    
    // Segue to results scene
    [[DDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DDDanceMoveResultsScene sceneWithSize:self.size results:self.danceIterationStepsDetected] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

#pragma mark - Update
- (void)_updateIllustrations
{
    // Stop any animations
    [self.illustration removeAllActions];
    
    // Play step SFX
    if (self.currentStep == 1)
    {
        [[DDGameManager sharedGameManager] playSoundEffect:kStep1_SFX];
    }
    else if (self.currentStep == 2)
    {
        [[DDGameManager sharedGameManager] playSoundEffect:kStep2_SFX];
    }
    
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
            [self _segueToResults];
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
            [self _detectDancePart];
        }
        else if (self.isCountdownActivated == NO)
        {
            _countdownElapsedTime = _countdownElapsedTime + _dt;
            [self _checkToStartCountdown];
        }
    }
}

@end
