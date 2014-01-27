//
//  DDMotionRequirements.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMotionRequirements : NSObject

@property (nonatomic) CGFloat yawMin;
@property (nonatomic) CGFloat yawMax;
@property (nonatomic) CGFloat pitchMin;
@property (nonatomic) CGFloat pitchMax;
@property (nonatomic) CGFloat rollMin;
@property (nonatomic) CGFloat rollMax;
@property (nonatomic) CGFloat accelerationXMin;
@property (nonatomic) CGFloat accelerationXMax;
@property (nonatomic) CGFloat accelerationYMin;
@property (nonatomic) CGFloat accelerationYMax;
@property (nonatomic) CGFloat accelerationZMin;
@property (nonatomic) CGFloat accelerationZMax;

@end
