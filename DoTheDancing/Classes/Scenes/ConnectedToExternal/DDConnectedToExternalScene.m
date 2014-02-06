//
//  DTDConnectedToIpadScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/25/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDConnectedToExternalScene.h"
#import <CoreMotion/CoreMotion.h>
#import "DDDanceMoveBernie.h"
#import "DDMainMenuScene.h"
#import "DDPacketSendResults.h"

@interface DDConnectedToExternalScene()

@property (nonatomic) BOOL isUpdateActivated;
@property (nonatomic, strong) DDDanceMove *danceMove;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval dt;

// Countdown
@property (nonatomic) CGFloat countdownElapsedTime;
@property (nonatomic) BOOL isCountdownActivated;
@property (nonatomic) NSUInteger currentCountdownNum;

// Dance detection
@property (nonatomic) BOOL isDanceActivated;
@property (nonatomic) CGFloat currentStepElapsedTime;
@property (nonatomic) CGFloat currentIterationElapsedTime;
@property (nonatomic) NSUInteger currentPart;
@property (nonatomic) NSUInteger currentStep;
@property (nonatomic) NSUInteger currentIteration;
@property (nonatomic) CGFloat timeToMoveToNextStep;
@property (nonatomic) BOOL shouldDetectDanceMove;
@property (nonatomic, strong) NSArray *currentDanceStepParts;
@property (nonatomic, strong) NSMutableArray *currentIterationStepsDetected;
@property (nonatomic, strong) NSMutableArray *danceIterationStepsDetected;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation DDConnectedToExternalScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        _isUpdateActivated = NO;
        
        [self _displayPrompt];
        [self _displayBackButton];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(_didReceiveData:)
         name:kPeerDidReceiveDataNotification
         object:nil];
    }
    
    return self;
}

- (void)willMoveFromView:(SKView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.motionManager)
    {
        [self.motionManager stopDeviceMotionUpdates];
    }
    
    [super willMoveFromView:view];
}

#pragma mark - UI setup
- (void)_displayPrompt
{
    SKLabelNode *promptLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    promptLabel.fontSize = 22;
    promptLabel.fontColor = [UIColor blackColor];
    promptLabel.text = @"Follow iPad instructions";
    promptLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.7);
    [self addChild:promptLabel];
}

- (void)_displayBackButton
{
    SKButton *backButton = [SKButton buttonWithImageNamedNormal:@"back" selected:@"back-highlight"];
    backButton.anchorPoint = CGPointMake(0, 1);
    backButton.position = CGPointMake(0, self.size.height);
    [backButton setTouchUpInsideTarget:self action:@selector(_pressedBack:)];
    [self addChild:backButton];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    [[DDGameManager sharedGameManager].sessionManager.session disconnect];
    [self.view presentScene:[DDMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

#pragma mark - Networking
- (void)_didReceiveData:(NSNotification *)notification
{
    DanceMoves danceMoveType = [notification.userInfo[@"data"] intValue];
    switch (danceMoveType) {
        case kDanceMoveBernie: {
            self.danceMove = [[DDDanceMoveBernie alloc] init];
            
            break;
        }
            
        default:
            break;
    }
    
    // Start detection!
    [self _initCountdown];
    [self _initDanceMoveDetection];
}

#pragma mark - Init detection
- (void)_initCountdown
{
    self.isUpdateActivated = YES;
    self.isDanceActivated = NO;
    self.isCountdownActivated = NO;
    self.countdownElapsedTime = 0;
    self.currentCountdownNum = 3;
}

- (void)_initDanceMoveDetection
{
    self.shouldDetectDanceMove = NO;
    self.currentIteration = 1;
    self.currentStep = 1;
    self.currentPart = 1;
    self.currentDanceStepParts = self.danceMove.stepsArray[0];
    self.timeToMoveToNextStep = [self.danceMove.timePerSteps[0] floatValue];
    self.danceIterationStepsDetected = [NSMutableArray arrayWithCapacity:self.danceMove.numIndividualIterations];
    [self _resetCurrentIterationStepsDetected];
    
    // Motion manager
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1.0/60.0f;
    [self.motionManager startDeviceMotionUpdates];
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
            self.shouldDetectDanceMove = YES;
            self.isDanceActivated = YES;
        }];
    }
}

- (void)_countdown
{
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
    NSLog(@"Move on to next iteration");
    self.currentIteration++;
    self.currentStep = 1;
    self.currentPart = 1;
    self.shouldDetectDanceMove = YES;
    self.currentIterationElapsedTime = 0;
    self.currentStepElapsedTime = 0;
    self.timeToMoveToNextStep = [self.danceMove.timePerSteps[0] floatValue];
    self.currentDanceStepParts = self.danceMove.stepsArray[0];
    
    // Save results of current iteration
    [self.danceIterationStepsDetected addObject:self.currentIterationStepsDetected];
    [self _resetCurrentIterationStepsDetected];
}

- (void)_moveOnToNextStep
{
    if (self.currentStep < self.danceMove.numSteps)
    {
        self.currentStep++;
        self.timeToMoveToNextStep = [self.danceMove.timePerSteps[self.currentStep-1] floatValue];
        self.currentDanceStepParts = self.danceMove.stepsArray[self.currentStep-1];
        self.currentPart = 1;
        self.shouldDetectDanceMove = YES;
        self.currentStepElapsedTime = 0;
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

#pragma mark - Results
- (void)_sendResultsToIpad
{
    self.isUpdateActivated = NO;
    
    // Add last step results
    [self.danceIterationStepsDetected addObject:self.currentIterationStepsDetected];
    
    // Create packet with dance step results
    DDPacketSendResults *packet = [DDPacketSendResults packetWithDanceMoveResults:self.danceIterationStepsDetected];
    NSError *error;
    [[DDGameManager sharedGameManager].sessionManager sendDataToAllPeers:[packet data] withMode:MCSessionSendDataUnreliable error:&error];
    
    if (error)
    {
        NSLog(@"DDConnectedToExternalScene -> _sendResultsToIpad ERROR: %@", error.localizedDescription);
    }
}

#pragma mark - Update
- (void)_updateTimers
{
    // Move to next iteration
    if (self.currentIterationElapsedTime >= self.danceMove.timePerIteration)
    {
        self.currentIterationElapsedTime = 0;
        self.currentStepElapsedTime = 0;
        
        // End scene
        if (self.currentIteration == self.danceMove.numIndividualIterations)
        {
            [self _sendResultsToIpad];
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

- (void)update:(NSTimeInterval)currentTime
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
    
    if (self.isUpdateActivated)
    {
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
