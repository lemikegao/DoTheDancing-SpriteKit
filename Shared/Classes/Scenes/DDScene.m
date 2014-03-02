//
//  DDScene.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/2/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDScene.h"

#if CONTROLLER
#import "DDMainMenuScene.h"
#endif

#if EXTERNAL
#import "DDEMainMenuScene.h"
#endif


@interface DDScene()

@property (nonatomic) NSUInteger sizeMultiplier;

@end

@implementation DDScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        // Set up yellow background color for all scenes
        self.backgroundColor = RGB(249, 185, 56);
        _sizeMultiplier = IS_IPAD ? 2 : 1;
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(peerDisconnected:)
         name:kPeerConnectionDisconnectedNotification
         object:nil];
    }
    
    return self;
}

- (void)peerDisconnected:(NSNotification *)notification
{
#if CONTROLLER
    // If external screen disconnected, then controller should return to main menu
        [self.view presentScene:[DDMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
#endif
    
#if EXTERNAL
    NSLog(@"Peer disconnected. Controller host peer ID: %@", [DDGameManager sharedGameManager].sessionManager.controllerHostPeerID);
    // If host controller disconnected, then external should return to main menu
    if ([DDGameManager sharedGameManager].sessionManager.controllerHostPeerID == nil)
    {
        //Segue to main menu
        [self.view presentScene:[DDEMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
    }
#endif
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
