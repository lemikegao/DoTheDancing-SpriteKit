//
//  DTDGameManager.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/22/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDGameManager.h"

@interface DTDGameManager()

@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic) AVAudioPlayer *soundEffectPlayer;

@end

@implementation DTDGameManager

static DTDGameManager *_sharedGameManager = nil;   // singleton

+(DTDGameManager*)sharedGameManager
{
    @synchronized([DTDGameManager class])
    {
        if(!_sharedGameManager)
        {
            _sharedGameManager = [[self alloc] init];
        }
        return _sharedGameManager;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized ([DTDGameManager class])
    {
        NSAssert(_sharedGameManager == nil, @"Attempted to allocate a second instance of the Game Manager singleton");
        _sharedGameManager = [super alloc];
        return _sharedGameManager;
    }
    
    return nil;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"Game Manager singleton->init");
        _isMusicOn = YES;
        _isSoundEffectsOn = YES;
        
        // Individual dance moves practice
        _individualDanceMove = nil;
        
        MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:@"iPhone"];
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:peerID discoveryInfo:nil serviceType:kServiceType];
        _sessionManager = [[DTDSessionManager alloc] initWithPeer:peerID];
    }
    
    return self;
}

- (void)playBackgroundMusic:(NSString *)filename
{
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
}

- (void)pauseBackgroundMusic
{
    [self.backgroundMusicPlayer pause];
}

- (void)playSoundEffect:(NSString *)filename
{
    NSError *error;
    NSURL *soundEffectURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    self.soundEffectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundEffectURL error:&error];
    self.soundEffectPlayer.numberOfLoops = 0;
    [self.soundEffectPlayer prepareToPlay];
    [self.soundEffectPlayer play];
}

@end
