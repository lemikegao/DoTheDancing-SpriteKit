//
//  DDPacketHostParty.h
//  DoTheDancing
//
//  Created by Michael Gao on 2/23/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDPacket.h"

@interface DDPacketHostParty : DDPacket

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic) DDPlayerColor playerColor;

+(id)packetWithPlayerColor:(DDPlayerColor)playerColor nickname:(NSString *)nickname;

@end
