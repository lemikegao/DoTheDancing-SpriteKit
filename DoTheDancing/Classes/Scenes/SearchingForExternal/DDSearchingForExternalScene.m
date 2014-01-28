//
//  DTDSearchingForIpadScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/24/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDSearchingForExternalScene.h"
#import "DDMainMenuScene.h"

@interface DDSearchingForExternalScene() <MCNearbyServiceAdvertiserDelegate>

@end

@implementation DDSearchingForExternalScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = RGB(249, 185, 56);
        
        [self _displaySearchingForIpad];
        [self _displayBackButton];
        [self _startSearchingForIpad];
        
        // Register for notifications when connected to browser
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(_peerConnected:)
         name:kPeerConnectionAcceptedNotification
         object:nil];
    }
    return self;
}

- (void)willMoveFromView:(SKView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup UI
- (void)_displaySearchingForIpad
{
    SKLabelNode *searchingLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    searchingLabel.fontSize = 28;
    searchingLabel.fontColor = [UIColor blackColor];
    searchingLabel.text = @"Searching for iPad...";
    searchingLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    [self addChild:searchingLabel];
}

- (void)_displayBackButton
{
    SKButton *backButton = [SKButton buttonWithImageNamedNormal:@"back" selected:@"back-highlight"];
    backButton.anchorPoint = CGPointMake(0, 1);
    backButton.position = CGPointMake(0, self.size.height);
    [backButton setTouchUpInsideTarget:self action:@selector(_pressedBack:)];
    [self addChild:backButton];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    // Stop advertising
    [[DDGameManager sharedGameManager].advertiser stopAdvertisingPeer];
    
    [self.view presentScene:[DDMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

#pragma mark - Networking
- (void)_startSearchingForIpad
{
    MCNearbyServiceAdvertiser *advertiser = [DDGameManager sharedGameManager].advertiser;
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
}

- (void)_peerConnected:(NSNotification *)notification
{
    // Stop advertising
    [[DDGameManager sharedGameManager].advertiser stopAdvertisingPeer];
    
    // TODO: Segue to connected to ipad scene
    
}

#pragma mark - MCNearbyServiceAdvertiserDelegate methods
// Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    if ([[NSString stringWithUTF8String:[context bytes]] isEqualToString:kSessionContextType])
    {
        // Accept the invitation immediately for single player mode
        invitationHandler(YES, [DDGameManager sharedGameManager].sessionManager.session);
        
        NSLog(@"Accepted invitation from peer: %@", peerID);
    }
}

// Advertising did not start due to an error
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    // Optional
}

@end
