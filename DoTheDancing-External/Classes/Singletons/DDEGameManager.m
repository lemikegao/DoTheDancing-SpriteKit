//
//  DDGameManager.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/22/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDEGameManager.h"

@interface DDEGameManager()

@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic) AVAudioPlayer *soundEffectPlayer;

@end

@implementation DDEGameManager

static DDEGameManager *_sharedGameManager = nil;   // singleton

+(DDEGameManager*)sharedGameManager
{
    @synchronized([DDEGameManager class])
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
    @synchronized ([DDEGameManager class])
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
        
        // individual dance moves practice
        _individualDanceMove = nil;
        
        MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:@"iPad"];
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:peerID serviceType:kServiceType];
        _sessionManager = [[DDESessionManager alloc] initWithPeer:peerID];
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
