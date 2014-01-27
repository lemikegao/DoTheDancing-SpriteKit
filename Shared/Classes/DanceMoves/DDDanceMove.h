//
//  DDDanceMove.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMotionRequirements.h"

@interface DDDanceMove : NSObject

@property (nonatomic) DanceMoves danceMoveType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *trackName;
@property (nonatomic) NSInteger numSteps;
@property (nonatomic, strong) NSArray *stepsArray;
@property (nonatomic) NSInteger numIndividualIterations;
@property (nonatomic) CGFloat timePerIteration;
@property (nonatomic) NSArray *timePerSteps;
@property (nonatomic, strong) NSArray *illustrationsForSteps;
@property (nonatomic, strong) NSArray *delayForIllustrationAnimations;
@property (nonatomic, strong) NSArray *instructionsForSteps;
@property (nonatomic) CGFloat timeToStartCountdown;
@property (nonatomic) CGFloat delayForCountdown;

@end
