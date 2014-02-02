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

@interface DDConnectedToExternalScene()

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
        [self _displayPrompt];
        [self _displayBackButton];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(_didReceiveData:)
         name:kPeerConnectionAcceptedNotification
         object:nil];
    }
    
    return self;
}

- (void)willMoveFromView:(SKView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
}

@end
