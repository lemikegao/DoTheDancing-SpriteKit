//
//  DDDanceMoveInstructionsScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DDDanceMoveInstructionsScene.h"
#import "DDDanceMoveSelectionScene.h"
#import "DDDanceMoveSeeInActionScene.h"
#import "DDDanceMoveTryItOutScene.h"
#import "SKMultilineLabel.h"
#import "DDPacketTransitionToScene.h"
#import "DDPacketShowNextInstruction.h"

@interface DDDanceMoveInstructionsScene()

@property (nonatomic, strong) DDDanceMove *danceMove;
@property (nonatomic) NSUInteger currentShownStep;

// Sprite management
@property (nonatomic, strong) SKSpriteNode *illustration;
@property (nonatomic, strong) SKButton *leftArrowButton;
@property (nonatomic, strong) SKButton *rightArrowButton;
@property (nonatomic, strong) SKLabelNode *stepCountLabel;
@property (nonatomic, strong) SKMultilineLabel *instructionsLabel;

// Swipe gesture recognizer
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRightRecognizer;

@end

@implementation DDDanceMoveInstructionsScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        _danceMove = [DDGameManager sharedGameManager].individualDanceMove;
        _currentShownStep = 1;
        
        [self _displayTopBar];
        [self _displayIllustration];
        [self _displayIllustrationButtons];
        [self _displayInstructions];
        [self _displayBottomMenu];
        
        // Play background track
        [[DDGameManager sharedGameManager] playBackgroundMusic:self.danceMove.trackName];
        
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
    // Remove gesture recognizers
    [self.view removeGestureRecognizer:self.swipeLeftRecognizer];
    [self.view removeGestureRecognizer:self.swipeRightRecognizer];
    self.swipeLeftRecognizer = nil;
    self.swipeRightRecognizer = nil;
    
    [super willMoveFromView:view];
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    // Setup gesture recognizers for instruction swipe
    self.swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_showNextStep)];
    self.swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeLeftRecognizer];
    
    self.swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_showPreviousStep)];
    self.swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.swipeRightRecognizer];
}

#pragma mark - UI setup

- (void)_displayTopBar
{
    // Top bar bg
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(self.size.width, 43 * self.sizeMultiplier)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Back button
    SKButton *backButton = [SKButton buttonWithImageNamedNormal:@"back" selected:@"back-highlight"];
    backButton.anchorPoint = CGPointMake(0, 0.5);
    backButton.position = CGPointMake(0, -topBannerBg.size.height * 0.5);
    [backButton setTouchUpInsideTarget:self action:@selector(_pressedBack:)];
    [topBannerBg addChild:backButton];
    
    // Title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32 * self.sizeMultiplier;
    titleLabel.text = self.danceMove.name;
    titleLabel.fontColor = RGB(249, 185, 56);
    titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    titleLabel.position = CGPointMake(self.size.width * 0.5f, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:titleLabel];
    
    // Instructions label
    SKLabelNode *instructionsLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Italic"];
    instructionsLabel.fontSize = 16.5 * self.sizeMultiplier;
    instructionsLabel.text = @"INSTRUCTIONS";
    instructionsLabel.fontColor = RGB(249, 185, 56);
    instructionsLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    instructionsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    instructionsLabel.position = CGPointMake(topBannerBg.size.width * 0.97, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:instructionsLabel];
}

- (void)_displayIllustration
{
    // Initial image: step 1, part 1
    NSArray *step1Illustrations = self.danceMove.illustrationsForSteps[0];
    self.illustration = [SKSpriteNode spriteNodeWithImageNamed:step1Illustrations[0]];
    self.illustration.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.63);
    
    if (IS_IPHONE_4 || IS_IPAD)
    {
        self.illustration.scale = 0.75;
    }
    
    [self addChild:self.illustration];
    
    [self _animateIllustration];
}

- (void)_displayIllustrationButtons
{
    // Only add arrows if there are more than 1 step
    if (self.danceMove.numSteps > 1)
    {
        // Left arrow button
        self.leftArrowButton = [SKButton buttonWithImageNamedNormal:@"instructions-arrow" selected:nil];
        self.leftArrowButton.zRotation = DegreesToRadians(180);
        self.leftArrowButton.alpha = 0.4;
        self.leftArrowButton.isEnabled = NO;
        self.leftArrowButton.position = CGPointMake(self.size.width * 0.1, self.illustration.position.y);
        [self.leftArrowButton setTouchDownTarget:self action:@selector(_pressedLeftButton:)];
        [self addChild:self.leftArrowButton];
        
        // Right arrow button
        self.rightArrowButton = [SKButton buttonWithImageNamedNormal:@"instructions-arrow" selected:nil];
        self.rightArrowButton.position = CGPointMake(self.size.width * 0.9, self.illustration.position.y);
        [self.rightArrowButton setTouchDownTarget:self action:@selector(_pressedRightButton:)];
        [self addChild:self.rightArrowButton];
    }
}

- (void)_displayInstructions
{
    // Instructions bg
    SKSpriteNode *instructionsBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(261 * self.sizeMultiplier, 129 * self.sizeMultiplier)];
    instructionsBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.21);
    [self addChild:instructionsBg];
    
    // Add step decor lines
    SKSpriteNode *line1 = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(52 * self.sizeMultiplier, 1 * self.sizeMultiplier)];
    line1.position = CGPointMake(-instructionsBg.size.width * 0.33, instructionsBg.size.height * 0.35);
    [instructionsBg addChild:line1];
    
    SKSpriteNode *line2 = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:line1.size];
    line2.position = CGPointMake(instructionsBg.size.width * 0.33, line1.position.y);
    [instructionsBg addChild:line2];
    
    // Current step count label
    self.stepCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    self.stepCountLabel.fontSize = 26 * self.sizeMultiplier;
    self.stepCountLabel.fontColor = RGB(56, 56, 56);
    self.stepCountLabel.text = @"Step 1";
    self.stepCountLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.stepCountLabel.position = CGPointMake(-instructionsBg.size.width * 0.2, line1.position.y * 0.8);
    [instructionsBg addChild:self.stepCountLabel];
    
    // 'out of' label
    SKLabelNode *outOfLabel = [SKLabelNode labelNodeWithFontNamed:@"ACaslonPro-BoldItalic"];
    outOfLabel.fontSize = 10.5 * self.sizeMultiplier;
    outOfLabel.fontColor = self.stepCountLabel.fontColor;
    outOfLabel.text = @"out of";
    outOfLabel.position = CGPointMake(instructionsBg.size.width * 0.085, line1.position.y);
    outOfLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    [instructionsBg addChild:outOfLabel];
    
    // Total step count label
    SKLabelNode *totalCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    totalCountLabel.fontSize = self.stepCountLabel.fontSize;
    totalCountLabel.fontColor = self.stepCountLabel.fontColor;
    totalCountLabel.text = @(self.danceMove.numSteps).stringValue;
    totalCountLabel.position = CGPointMake(instructionsBg.size.width * 0.17, self.stepCountLabel.position.y);
    [instructionsBg addChild:totalCountLabel];
    
    // Instructions
    self.instructionsLabel = [SKMultilineLabel multilineLabelFromStringContainingNewLines:self.danceMove.instructionsForSteps[0] fontName:@"Economica-Regular" fontColor:self.stepCountLabel.fontColor fontSize:20.5*self.sizeMultiplier verticalMargin:4 emptyLineHeight:0];
    self.instructionsLabel.position = CGPointMake(0, 0);
    [instructionsBg addChild:self.instructionsLabel];
    
    if (IS_IPHONE_4 || IS_IPAD)
    {
        instructionsBg.yScale = 0.95;
        instructionsBg.position = CGPointMake(instructionsBg.position.x, self.size.height * 0.23);
    }
}

- (void)_displayBottomMenu
{
    // 'See in action' button
    SKButton *seeInActionButton = [SKButton buttonWithImageNamedNormal:@"instructions-button-action" selected:@"instructions-button-action-highlight"];
    seeInActionButton.anchorPoint = CGPointMake(1, 0);
    seeInActionButton.position = CGPointMake(self.size.width * 0.57, self.size.height * 0.02);
    [seeInActionButton setTouchUpInsideTarget:self action:@selector(_pressedSeeInAction:)];
    [self addChild:seeInActionButton];
    
    // 'Try it out!' button
    SKButton *tryItOutButton = [SKButton buttonWithImageNamedNormal:@"instructions-button-try" selected:@"instructions-button-try-highlight"];
    tryItOutButton.anchorPoint = CGPointMake(0, 0);
    tryItOutButton.position = CGPointMake(self.size.width * 0.53, seeInActionButton.position.y);
    [tryItOutButton setTouchUpInsideTarget:self action:@selector(_pressedTryItOut:)];
    [self addChild:tryItOutButton];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    [[DDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DDDanceMoveSelectionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
    
    [self _sendPacketWithSceneType:kSceneTypeDanceMoveSelection];
}

- (void)_pressedLeftButton:(id)sender
{
    [self _showPreviousStep];
    [self _sendNextInstruction:NO];
}

- (void)_pressedRightButton:(id)sender
{
    [self _showNextStep];
    [self _sendNextInstruction:YES];
}

- (void)_pressedSeeInAction:(id)sender
{
    [[DDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DDDanceMoveSeeInActionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
    
    [self _sendPacketWithSceneType:kSceneTypeDanceMoveSeeInAction];
}

- (void)_pressedTryItOut:(id)sender
{
    [[DDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DDDanceMoveTryItOutScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
    
    [self _sendPacketWithSceneType:kSceneTypeDanceMoveTryItOut];
}

#pragma mark - Networking
- (void)_didReceiveData:(NSNotification *)notification
{
    PacketType packetType = (PacketType)[notification.userInfo[@"type"] intValue];
    
    if (packetType == PacketTypeTransitionToScene)
    {
        SceneTypes sceneType = (SceneTypes)[notification.userInfo[@"data"] intValue];
        SKScene *scene;
        SKTransitionDirection direction = SKTransitionDirectionLeft;
        switch (sceneType)
        {
            case kSceneTypeDanceMoveSelection:
                scene = [DDDanceMoveSelectionScene sceneWithSize:self.size];
                direction = SKTransitionDirectionRight;
                break;
                
            case kSceneTypeDanceMoveSeeInAction:
                scene = [DDDanceMoveSeeInActionScene sceneWithSize:self.size];
                break;
                
            case kSceneTypeDanceMoveTryItOut:
                scene = [DDDanceMoveTryItOutScene sceneWithSize:self.size];
                break;
                
            default:
                break;
        }
        
        [self.view presentScene:scene transition:[SKTransition pushWithDirection:direction duration:0.25]];
    }
    else if (packetType == PacketTypeShowNextInstruction)
    {
        BOOL shouldShowNextInstruction = [notification.userInfo[@"data"] boolValue];
        if (shouldShowNextInstruction == YES)
        {
            [self _showNextStep];
        }
        else
        {
            [self _showPreviousStep];
        }
    }
}

- (void)_sendPacketWithSceneType:(SceneTypes)sceneType
{
    if ([DDGameManager sharedGameManager].sessionManager.isConnected == YES)
    {
        NSError *error;
        DDPacketTransitionToScene *packet = [DDPacketTransitionToScene packetWithSceneType:sceneType];
        [[DDGameManager sharedGameManager].sessionManager sendDataToAllPeers:[packet data] withMode:MCSessionSendDataUnreliable error:&error];
    }
}

- (void)_sendNextInstruction:(BOOL)shouldShowNextInstruction
{
    if ([DDGameManager sharedGameManager].sessionManager.isConnected == YES)
    {
        NSError *error;
        DDPacketShowNextInstruction *packet = [DDPacketShowNextInstruction packetWithNextInstruction:shouldShowNextInstruction];
        [[DDGameManager sharedGameManager].sessionManager sendDataToAllPeers:[packet data] withMode:MCSessionSendDataUnreliable error:&error];
    }
}

#pragma mark - Private methods
- (void)_showPreviousStep
{
    // Enabled only if current step > 1
    if (self.currentShownStep > 1)
    {
        self.currentShownStep--;
        self.rightArrowButton.alpha = 1;
        
        if (self.currentShownStep == 1)
        {
            self.leftArrowButton.alpha = 0.4;
            self.leftArrowButton.isEnabled = NO;
        }
        
        self.rightArrowButton.isEnabled = YES;
        [self _updateInstructionsForNewStep];
    }
}

- (void)_showNextStep
{
    if (self.currentShownStep < self.danceMove.numSteps)
    {
        self.currentShownStep++;
        self.leftArrowButton.alpha = 1;
        
        if (self.currentShownStep == self.danceMove.numSteps) {
            self.rightArrowButton.alpha = 0.4;
            self.rightArrowButton.isEnabled = NO;
        }
        
        self.leftArrowButton.isEnabled = YES;
        [self _updateInstructionsForNewStep];
    }
}

- (void)_updateInstructionsForNewStep
{
    // Stop any animations
    [self.illustration removeAllActions];
    
    /* Update illustration */
    // Check for animation
    [self _animateIllustration];
    
    // update step count
    self.stepCountLabel.text = [NSString stringWithFormat:@"Step %i", self.currentShownStep];
    
    // update instructions
    self.instructionsLabel.text = self.danceMove.instructionsForSteps[self.currentShownStep - 1];
}

- (void)_animateIllustration
{
    NSArray *currentIllustrations = self.danceMove.illustrationsForSteps[self.currentShownStep-1];
    if (currentIllustrations.count > 1)
    {
        // Animations!
        NSMutableArray *textures = [[NSMutableArray alloc] initWithCapacity:currentIllustrations.count];
        [currentIllustrations enumerateObjectsUsingBlock:^(NSString *textureFilename, NSUInteger idx, BOOL *stop) {
            textures[idx] = [SKTexture textureWithImageNamed:currentIllustrations[idx]];
        }];
        SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:[self.danceMove.delayForIllustrationAnimations[self.currentShownStep-1] floatValue] resize:NO restore:YES];
        [self.illustration runAction:[SKAction repeatActionForever:animation]];
    }
    else
    {
        // Static illustraton
        self.illustration.texture = [SKTexture textureWithImageNamed:currentIllustrations[0]];
    }
}

@end
