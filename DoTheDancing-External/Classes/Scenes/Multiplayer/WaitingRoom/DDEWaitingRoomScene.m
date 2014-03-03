//
//  DDEWaitingRoomScene.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/23/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDEWaitingRoomScene.h"
#import "DDEMainMenuScene.h"
#import "UIColor+PlayerColor.h"
#import "DDEAvatarOrder.h"

@interface DDEWaitingRoomScene() <MCNearbyServiceBrowserDelegate>

@property (nonatomic) NSUInteger currentAvatarOrder;
@property (nonatomic, strong) NSMutableDictionary *avatars;     // Key: PeerID; Value: DDEAvatarOrder

@end

@implementation DDEWaitingRoomScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        _currentAvatarOrder = 0;
        _avatars = [[NSMutableDictionary alloc] init];
        
        [self _displayBackground];
        [self _displayTopBar];
        [self _displayWaitingPrompt];
        [self _displayHostAvatar];
        [self _startSearchingForControllers];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(_didReceiveData:)
         name:kPeerDidReceiveDataNotification
         object:nil];
    }
    return self;
}

#pragma mark - Setup UI
- (void)_displayBackground
{
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"mainmenu-bg"];
    bg.anchorPoint = CGPointMake(0, 1);
    bg.position = CGPointMake(0, self.size.height);
    [self addChild:bg];
}

- (void)_displayTopBar
{
    // Top banner bg
    SKSpriteNode *topBannerBg = [SKSpriteNode spriteNodeWithColor:RGB(56, 56, 56) size:CGSizeMake(self.size.width, 43 * self.sizeMultiplier)];
    topBannerBg.anchorPoint = CGPointMake(0, 1);
    topBannerBg.position = CGPointMake(0, self.size.height);
    [self addChild:topBannerBg];
    
    // Title label
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    titleLabel.fontSize = 32 * self.sizeMultiplier;
    titleLabel.text = @"Waiting Room";
    titleLabel.fontColor = RGB(249, 185, 56);
    titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    titleLabel.position = CGPointMake(self.size.width * 0.5f, -topBannerBg.size.height * 0.5);
    [topBannerBg addChild:titleLabel];
    
    // Back button
    SKButton *backButton = [SKButton buttonWithImageNamedNormal:@"back" selected:@"back-highlight"];
    backButton.anchorPoint = CGPointMake(0, 0.5);
    backButton.position = CGPointMake(0, -topBannerBg.size.height * 0.5);
    [backButton setTouchUpInsideTarget:self action:@selector(_pressedBack:)];
    [topBannerBg addChild:backButton];
}

- (void)_displayWaitingPrompt
{
    // Background
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithColor:RGB(249, 228, 172) size:CGSizeMake(310*self.sizeMultiplier, 100*self.sizeMultiplier)];
    bg.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75);
    [self addChild:bg];
    
    // Text
    SKLabelNode *waitingLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    waitingLabel.fontSize = 24 * self.sizeMultiplier;
    waitingLabel.text = @"Waiting for other dancers...";
    waitingLabel.fontColor = RGB(56, 56, 56);
    waitingLabel.position = CGPointMake(0, bg.size.height * 0.2);
    [bg addChild:waitingLabel];
    
    SKSpriteNode *dots = [SKSpriteNode spriteNodeWithImageNamed:@"waitingroom-loader1"];
    dots.position = CGPointMake(0, 0);
    [bg addChild:dots];
    
    // Waiting animation (dots)
    NSMutableArray *textures = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSUInteger i=1; i<5; i++)
    {
        [textures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"waitingroom-loader%lu", (unsigned long)i]]];
    }
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.75 resize:NO restore:YES];
    [dots runAction:[SKAction repeatActionForever:animation]];
}

- (void)_displayHostAvatar
{
    DDPlayer *hostPlayer = [DDGameManager sharedGameManager].sessionManager.connectedPlayers[[DDGameManager sharedGameManager].sessionManager.controllerHostPeerID];
    [self _addNewAvatarForPlayer:hostPlayer forPeerID:[DDGameManager sharedGameManager].sessionManager.controllerHostPeerID];
}

- (void)_startSearchingForControllers
{
    NSLog(@"DDEWaitingRoomScene -> Start browsing for peers");
    MCNearbyServiceBrowser *browser = [DDGameManager sharedGameManager].browser;
    browser.delegate = self;
    [browser startBrowsingForPeers];
}

#pragma mark -
#pragma Avatar handling
- (void)_saveAvatar:(SKSpriteNode *)avatar andPlayer:(DDPlayer *)player forPeerID:(MCPeerID *)peerID
{
    DDEAvatarOrder *avatarOrder = [[DDEAvatarOrder alloc] initWithAvatar:avatar player:player order:self.currentAvatarOrder];
    self.currentAvatarOrder++;
    
    [self.avatars setObject:avatarOrder forKey:peerID];
}

- (void)_addNewAvatarForPlayer:(DDPlayer *)player forPeerID:(MCPeerID *)peerID
{
    SKSpriteNode *avatar = [SKSpriteNode spriteNodeWithImageNamed:@"waitingroom-avatar"];
    avatar.position = CGPointMake(self.size.width * 0.2 + avatar.size.width * 1.5 * self.avatars.count, self.size.height * 0.35);
    [self addChild:avatar];
    
    // Set to correct color
    avatar.color = [UIColor colorWithPlayerColor:player.playerColor];
    avatar.colorBlendFactor = 0.5;
    
    // Save host avatar
    [self _saveAvatar:avatar andPlayer:player forPeerID:peerID];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    // Stop browsing
    [[DDGameManager sharedGameManager].browser stopBrowsingForPeers];
    
    // Disconnect session and segue to main menu
    [[DDGameManager sharedGameManager].sessionManager disconnect];
    [self.view presentScene:[DDEMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

#pragma mark - Networking
- (void)_didReceiveData:(NSNotification *)notification
{
    // TODO: Stop browsing for peers once the host starts the party!
    
    // Save new player
    MCPeerID *peerID = notification.userInfo[@"peerID"];
    DDPlayerColor playerColor = [notification.userInfo[@"playerColor"] intValue];
    NSString *nickname = notification.userInfo[@"nickname"];
    
    DDPlayer *player = [DDPlayer playerWithPlayerColor:playerColor nickname:nickname];
    [[DDGameManager sharedGameManager].sessionManager.connectedPlayers setObject:player forKey:peerID];
    
    // Create new avatar
    [self _addNewAvatarForPlayer:player forPeerID:peerID];
}

#pragma mark - MCNearbyServiceBrowserDelegate methods
// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"DDEWaitingRoomScene -> Found peer! %@. Inviting peer to connect", peerID);
    // TODO: Allow multiple peers; currently only single player
    // Send invite to peer
    [browser invitePeer:peerID toSession:[DDGameManager sharedGameManager].sessionManager.session withContext:[kSessionContextType dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
}

// A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    // TODO: Required
}

// Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    // TODO: Optional
    NSLog(@"DDEWaitingRoomScene -> Error browsing: %@", error.localizedDescription);
}

@end
