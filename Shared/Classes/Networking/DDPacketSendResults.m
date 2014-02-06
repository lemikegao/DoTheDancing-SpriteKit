//
//  DDPacketSendResults.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/3/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacketSendResults.h"

@implementation DDPacketSendResults

+ (id)packetWithData:(NSData *)data
{
    size_t offset = PACKET_HEADER_SIZE;
    
    int numIterations = [data rw_int8AtOffset:offset];
    offset += 1;
    
    int numSteps = [data rw_int8AtOffset:offset];
    offset += 1;
    
    NSMutableArray *danceMoveResults = [[NSMutableArray alloc] initWithCapacity:numIterations];
    NSMutableArray *danceStepResults;
    
    for (int i=0; i<numIterations; i++) {
        danceStepResults = [[NSMutableArray alloc] initWithCapacity:numSteps];
        
        for (int j=0; j<numSteps; j++) {
            BOOL result = [data rw_int8AtOffset:offset];
            if (result > 0) {
                danceStepResults[j] = @(YES);
            } else {
                danceStepResults[j] = @(NO);
            }
            
            offset += 1;
        }
        
        danceMoveResults[i] = danceStepResults;
    }
    
	return [[self class] packetWithDanceMoveResults:[danceMoveResults copy]];
}

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

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [[super dict] mutableCopy];
    [dict setValue:self.danceMoveResults forKey:@"data"];
    
    return [dict copy];
}

@end
