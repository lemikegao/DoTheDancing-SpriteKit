//
//  DTDGameManager.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/22/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DTDTSessionManager.h"
#import "DTDDanceMove.h"
@import AVFoundation;

@interface DTDTGameManager : NSObject

@property (nonatomic) BOOL isMusicOn;
@property (nonatomic) BOOL isSoundEffectsOn;
@property (nonatomic) GameManagerSoundState managerSoundState;
@property (nonatomic, strong) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, strong) NSMutableDictionary *soundEffectsState;

// Individual dance moves practice
@property (nonatomic, strong) DTDDanceMove *individualDanceMove;

// Networking
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) DTDTSessionManager *sessionManager;

+(DTDTGameManager*)sharedGameManager;

// Audio
- (void)playBackgroundMusic:(NSString *)filename;
- (void)pauseBackgroundMusic;
- (void)playSoundEffect:(NSString*)filename;

@end
