//
//  DDGameManager.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/22/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DDESessionManager.h"
#import "DDDanceMove.h"
@import AVFoundation;

@interface DDEGameManager : NSObject

@property (nonatomic) BOOL isMusicOn;
@property (nonatomic) BOOL isSoundEffectsOn;
@property (nonatomic) GameManagerSoundState managerSoundState;
@property (nonatomic, strong) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, strong) NSMutableDictionary *soundEffectsState;

// Individual dance moves practice
@property (nonatomic, strong) DDDanceMove *individualDanceMove;

// Networking
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) DDESessionManager *sessionManager;

+(DDEGameManager*)sharedGameManager;

// Audio
- (void)playBackgroundMusic:(NSString *)filename;
- (void)pauseBackgroundMusic;
- (void)playSoundEffect:(NSString*)filename;

@end
