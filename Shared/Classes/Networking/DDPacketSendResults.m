//
//  DDPacketSendResults.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/3/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacketSendResults.h"

@implementation DDPacketSendResults

+ (id)packetWithDanceMoveResults:(NSArray*)danceMoveResults
{
    return [[[self class] alloc] initWithDanceMoveResults:danceMoveResults];
}

- (id)initWithDanceMoveResults:(NSArray*)danceMoveResults {
    self = [super initWithType:PacketTypeSendResults];
    if (self)
    {
        self.danceMoveResults = danceMoveResults;
    }
    
    return self;
}

- (void)addPayloadToData:(NSMutableData*)data
{
    // Add num iterations
    [data rw_appendInt8:self.danceMoveResults.count];
    
    // Add num steps
    NSArray *steps = self.danceMoveResults[0];
    [data rw_appendInt8:steps.count];
    
    for (NSArray *currentIterationResults in self.danceMoveResults) {
        for (NSNumber *currentStepResult in currentIterationResults) {
            if ([currentStepResult boolValue] == YES) {
                [data rw_appendInt8:1];
            } else {
                [data rw_appendInt8:0];
            }
        }
    }
}

@end
