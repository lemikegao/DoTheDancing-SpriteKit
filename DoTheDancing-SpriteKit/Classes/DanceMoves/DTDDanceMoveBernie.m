//
//  DTDDanceMoveBernie.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDDanceMoveBernie.h"

@implementation DTDDanceMoveBernie

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.danceMoveType = kDanceMoveBernie;
        self.name = kDanceMoveBernieName;
        self.trackName = @"the_bernie.caf";
        
        [self _setUpMotionRequirements];
        
        self.numIndividualIterations = 3;
        self.timePerIteration = 5.2;
        self.timePerSteps = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.9], [NSNumber numberWithFloat:3.3], nil];
        
        [self _setUpIllustrations];
        [self _setUpInstructions];
        
        self.timeToStartCountdown = 2.45;       // actual countdown start time - delayForCountdown
        self.delayForCountdown = 0.69;
    }
    
    return self;
}

-(void)_setUpMotionRequirements
{
    self.numSteps = 2;
    
    /* step 1 breakdown - 1 part */
    // part 1
    DTDMotionRequirements *step1_1 = [[DTDMotionRequirements alloc] init];
    step1_1.pitchMin = -80;
    step1_1.pitchMax = -20;
    
    /* step 2 breakdown - 4 parts */
    // part 1
    DTDMotionRequirements *step2_1 = [[DTDMotionRequirements alloc] init];
    step2_1.pitchMin = -80;
    step2_1.pitchMax = -20;
    step2_1.accelerationZMin = 0.3;
    
    // part 2
    DTDMotionRequirements *step2_2 = [[DTDMotionRequirements alloc] init];
    step2_2.pitchMin = -80;
    step2_2.pitchMax = -20;
    step2_2.accelerationZMax = -0.3;
    
    // part 3
    DTDMotionRequirements *step2_3 = [[DTDMotionRequirements alloc] init];
    step2_3.pitchMin = -80;
    step2_3.pitchMax = -20;
    step2_3.accelerationZMin = 0.3;
    
    // part 4
    DTDMotionRequirements *step2_4 = [[DTDMotionRequirements alloc] init];
    step2_4.pitchMin = -80;
    step2_4.pitchMax = -20;
    step2_4.accelerationZMax = -0.3;
    
    NSArray *step1Array = [NSArray arrayWithObject:step1_1];
    NSArray *step2Array = [NSArray arrayWithObjects:step2_1, step2_2, step2_3, step2_4, nil];
    
    self.stepsArray = [NSArray arrayWithObjects:step1Array, step2Array, nil];
}

-(void)_setUpIllustrations
{
    NSArray *step1Illustrations = [NSArray arrayWithObject:@"instructions-bernie2"];
    NSArray *step2Illustrations = [NSArray arrayWithObjects:@"instructions-bernie1", @"instructions-bernie2", @"instructions-bernie3", @"instructions-bernie2", nil];
    
    self.illustrationsForSteps = [NSArray arrayWithObjects:step1Illustrations, step2Illustrations, nil];
    
    // set up delay for animations
    self.delayForIllustrationAnimations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.165], nil];
}

-(void)_setUpInstructions
{
    NSString *step1 = @"Drop arms & hold your head back\nlike a nosebleed coming through.";
    NSString *step2 = @"Twist your arms like curly fries.";
    
    self.instructionsForSteps = [NSArray arrayWithObjects:step1, step2, nil];
}


@end
