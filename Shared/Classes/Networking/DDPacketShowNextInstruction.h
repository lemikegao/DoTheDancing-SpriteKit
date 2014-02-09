//
//  DDPacketShowNextInstruction.h
//  DoTheDancing
//
//  Created by Michael Gao on 2/9/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacket.h"

@interface DDPacketShowNextInstruction : DDPacket

@property (nonatomic) BOOL shouldShowNextInstruction;

+(id)packetWithNextInstruction:(BOOL)shouldShowNextInstruction;

@end
