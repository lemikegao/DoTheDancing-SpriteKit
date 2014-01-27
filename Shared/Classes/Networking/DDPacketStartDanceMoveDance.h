//
//  DTDPacketStartDanceMoveDance.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/25/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacket.h"

@interface DDPacketStartDanceMoveDance : DDPacket

@property (nonatomic) DanceMoves danceMoveType;

+(id)packetWithDanceMoveType:(DanceMoves)danceMoveType;

@end
