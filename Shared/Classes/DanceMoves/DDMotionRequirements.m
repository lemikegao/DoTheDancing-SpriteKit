//
//  DDMotionRequirements.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DDMotionRequirements.h"

@implementation DDMotionRequirements

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.yawMin = kYawMin;
        self.yawMax = kYawMax;
        self.pitchMin = kPitchMin;
        self.pitchMax = kPitchMax;
        self.rollMin = kRollMin;
        self.rollMax = kRollMax;
        self.accelerationXMin = kAccelerationXMin;
        self.accelerationXMax = kAccelerationXMax;
        self.accelerationYMin = kAccelerationYMin;
        self.accelerationYMax = kAccelerationYMax;
        self.accelerationZMin = kAccelerationZMin;
        self.accelerationZMax = kAccelerationZMax;
    }
    
    return self;
}

@end
