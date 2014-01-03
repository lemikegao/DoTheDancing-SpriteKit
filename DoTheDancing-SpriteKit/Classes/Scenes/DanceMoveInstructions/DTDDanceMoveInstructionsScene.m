//
//  DTDDanceMoveInstructionsScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDDanceMoveInstructionsScene.h"
#import "DTDGameManager.h"
#import "DTDDanceMoveSelectionScene.h"
#import "DTDDanceMoveSeeInActionScene.h"
#import "DTDDanceMoveTryItOutScene.h"
#import "SKMultilineLabel.h"

@interface DTDDanceMoveInstructionsScene()

@property (nonatomic, strong) DTDDanceMove *danceMove;
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

@implementation DTDDanceMoveInstructionsScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = RGB(249, 185, 56);
        _danceMove = [DTDGameManager sharedGameManager].individualDanceMove;
        _currentShownStep = 1;
        
        [self _displayTopBar];
        [self _displayIllustration];
        [self _displayIllustrationButtons];
        [self _displayInstructions];
        [self _displayBottomMenu];
        
        // Play background track
        [[DTDGameManager sharedGameManager] playBackgroundMusic:self.danceMove.trackName];
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
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(320, 43)];
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
    titleLabel.fontSize = 32;
    titleLabel.text = self.danceMove.name;
    titleLabel.fontColor = RGB(249, 185, 56);
    titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    titleLabel.position = CGPointMake(self.size.width * 0.5f, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:titleLabel];
    
    // Instructions label
    SKLabelNode *instructionsLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Italic"];
    instructionsLabel.fontSize = 16.5;
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
    
    if (IS_IPHONE_4)
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
    SKSpriteNode *instructionsBg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(261, 129)];
    instructionsBg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.21);
    [self addChild:instructionsBg];
    
    // Add step decor lines
    SKSpriteNode *line1 = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(52, 1)];
    line1.position = CGPointMake(-instructionsBg.size.width * 0.33, instructionsBg.size.height * 0.35);
    [instructionsBg addChild:line1];
    
    SKSpriteNode *line2 = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(52, 1)];
    line2.position = CGPointMake(instructionsBg.size.width * 0.33, line1.position.y);
    [instructionsBg addChild:line2];
    
    // Current step count label
    self.stepCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    self.stepCountLabel.fontSize = 26;
    self.stepCountLabel.fontColor = RGB(56, 56, 56);
    self.stepCountLabel.text = @"Step 1";
    self.stepCountLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.stepCountLabel.position = CGPointMake(-instructionsBg.size.width * 0.2, line1.position.y * 0.8);
    [instructionsBg addChild:self.stepCountLabel];
    
    // 'out of' label
    SKLabelNode *outOfLabel = [SKLabelNode labelNodeWithFontNamed:@"ACaslonPro-BoldItalic"];
    outOfLabel.fontSize = 10.5;
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
    self.instructionsLabel = [SKMultilineLabel multilineLabelFromStringContainingNewLines:self.danceMove.instructionsForSteps[0] fontName:@"Economica-Regular" fontColor:self.stepCountLabel.fontColor fontSize:20.5 verticalMargin:4 emptyLineHeight:0];
    self.instructionsLabel.position = CGPointMake(0, 0);
    [instructionsBg addChild:self.instructionsLabel];
    
    if (IS_IPHONE_4)
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
    [[DTDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DTDDanceMoveSelectionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

- (void)_pressedLeftButton:(id)sender
{
    [self _showPreviousStep];
}

- (void)_pressedRightButton:(id)sender
{
    [self _showNextStep];
}

- (void)_pressedSeeInAction:(id)sender
{
    [[DTDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DTDDanceMoveSeeInActionScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
}

- (void)_pressedTryItOut:(id)sender
{
    [[DTDGameManager sharedGameManager] pauseBackgroundMusic];
    [self.view presentScene:[DTDDanceMoveTryItOutScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.25]];
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