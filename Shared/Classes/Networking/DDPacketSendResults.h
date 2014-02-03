//
//  DDPacketSendResults.h
//  DoTheDancing
//
//  Created by Michael Gao on 2/3/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacket.h"

@interface DDPacketSendResults : DDPacket

@property (nonatomic, strong) NSArray *danceMoveResults;

+ (id)packetWithDanceMoveResults:(NSArray*)danceMoveResults;

@end
