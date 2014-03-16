//
//  DDGameManager.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DDSessionManager.h"
#import "DDDanceMove.h"
#import "DDPlayer.h"
@import AVFoundation;

@interface DDGameManager : NSObject

@property (nonatomic) BOOL isMusicOn;
@property (nonatomic) BOOL isSoundEffectsOn;
@property (nonatomic, strong) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, strong) NSMutableDictionary *soundEffectsState;

// Individual dance moves practice
@property (nonatomic, strong) DDDanceMove *individualDanceMove;

// Networking
@property (nonatomic, strong, readonly) MCPeerID *peerID;
@property (nonatomic, strong, readonly) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong, readonly) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong, readonly) DDSessionManager *sessionManager;

// Multiplayer
@property (nonatomic, strong) DDPlayer *player;
@property (nonatomic) BOOL isHost;

+(DDGameManager*)sharedGameManager;
- (void)setUpSession;

// Audio
- (void)playBackgroundMusic:(NSString *)filename;
- (void)pauseBackgroundMusic;
- (void)playSoundEffect:(NSString*)filename;

@end
