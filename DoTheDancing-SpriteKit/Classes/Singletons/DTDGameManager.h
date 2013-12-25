//
//  DTDGameManager.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTDDanceMove.h"
@import AVFoundation;

@interface DTDGameManager : NSObject

@property (nonatomic) BOOL isMusicOn;
@property (nonatomic) BOOL isSoundEffectsOn;
@property (nonatomic) GameManagerSoundState managerSoundState;
@property (nonatomic, strong) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, strong) NSMutableDictionary *soundEffectsState;

// Individual dance moves practice
@property (nonatomic, strong) DTDDanceMove *individualDanceMove;

// Multiplayer
//@property (nonatomic) BOOL isMultiplayer;
//@property (nonatomic) BOOL isHost;
//@property (nonatomic, strong) MatchmakingClient *client;
//@property (nonatomic, strong) MatchmakingServer *server;

+(DTDGameManager*)sharedGameManager;

// Audio
- (void)playBackgroundMusic:(NSString *)filename;
- (void)pauseBackgroundMusic;
- (void)playSoundEffect:(NSString*)filename;

@end
