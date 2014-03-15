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
#import "DDEPlayerAvatar.h"

@interface DDEWaitingRoomScene() <MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) NSMutableArray *avatars;

@end

@implementation DDEWaitingRoomScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        _avatars = [[NSMutableArray alloc] initWithCapacity:4];
        
        [self _displayBackground];
        [self _displayTopBar];
        [self _displayWaitingPrompt];
        [self _displayHostAvatar];
        [self _startAdvertisingToControllers];
        
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

- (void)_startAdvertisingToControllers
{
    NSLog(@"DDEWaitingRoomScene -> Start advertising to controllers");
    MCNearbyServiceAdvertiser *advertiser = [DDGameManager sharedGameManager].advertiser;
    advertiser.delegate = self;
    [advertiser startAdvertisingPeer];
}

#pragma mark -
#pragma Avatar handling
- (void)_addNewAvatarForPlayer:(DDPlayer *)player forPeerID:(MCPeerID *)peerID
{
    // Avatar
    SKSpriteNode *avatar = [SKSpriteNode spriteNodeWithImageNamed:@"waitingroom-avatar"];
    // Set to correct color
    avatar.color = [UIColor colorWithPlayerColor:player.playerColor];
    avatar.colorBlendFactor = 0.5;
    
    // Player name
    SKSpriteNode *nameBg = [SKSpriteNode spriteNodeWithImageNamed:@"waitingroom-namebg"];
    
    SKLabelNode *nameLabel = [SKLabelNode labelNodeWithFontNamed:@"Economica-Bold"];
    nameLabel.fontSize = 32;
    nameLabel.fontColor = RGB(249, 228, 172);
    nameLabel.text = player.nickname;
    nameLabel.position = CGPointMake(0, -nameBg.size.height * 0.08);
    [nameBg addChild:nameLabel];
    
    // Find first empty slot in array for new player. If no empty slots, add to end of the line!
    DDEPlayerAvatar *pa = [[DDEPlayerAvatar alloc] initWithAvatar:avatar nameBg:nameBg player:player peerID:peerID];
    
    // Add host
    if (self.avatars.count == 0)
    {
        [self.avatars addObject:pa];
        [self _displayAvatarAndNameForPlayer:pa AtIndex:0];
    }
    else
    {
        [self.avatars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // If empty slot exists, place avatar there
            if ([obj isEqual:[NSNull null]])
            {
                self.avatars[idx] = pa;
                [self _displayAvatarAndNameForPlayer:pa AtIndex:idx];
                *stop = YES;
            }
            // If no empty slots in array, add to the end
            else if (idx == (self.avatars.count-1))
            {
                [self.avatars addObject:pa];
                [self _displayAvatarAndNameForPlayer:pa AtIndex:idx+1];
                *stop = YES;
            }
        }];
    }
}

- (void)_displayAvatarAndNameForPlayer:(DDEPlayerAvatar *)pa AtIndex:(NSUInteger)idx
{
    SKSpriteNode *avatar = pa.avatar;
    SKSpriteNode *nameBg = pa.nameBg;
    
    // Avatar
    avatar.position = CGPointMake(self.size.width * 0.2 + avatar.size.width * 1.5 * idx, self.size.height * 0.35);
    avatar.alpha = 0;
    [self addChild:avatar];
    
    // Player name
    nameBg.position = CGPointMake(avatar.position.x, avatar.position.y + avatar.size.height*0.75);
    nameBg.alpha = 0;
    [self addChild:nameBg];
    
    // Fade in newly added avatar
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.3];
    [avatar runAction:fadeIn];
    [nameBg runAction:fadeIn];
}

- (void)_removeAvatarForPeerID:(MCPeerID *)peerID
{
    NSUInteger playerIndex = [self.avatars indexOfObjectPassingTest:^BOOL(DDEPlayerAvatar *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.peerID isEqual:peerID])
        {
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
    
    DDEPlayerAvatar *pa = self.avatars[playerIndex];
    // Replace player with an empty slot
    self.avatars[playerIndex] = [NSNull null];
    
    // Fade out and then remove avatar sprite + name sprite & label
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];
    [pa.avatar runAction:fadeOut completion:^{
        [pa.avatar removeFromParent];
    }];
    
    [pa.nameBg runAction:fadeOut completion:^{
        [pa.nameBg removeFromParent];
    }];
}

#pragma mark - Button actions
- (void)_pressedBack:(id)sender
{
    // Stop advertising
    [[DDGameManager sharedGameManager].advertiser stopAdvertisingPeer];
    
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

- (void)peerDisconnected:(NSNotification *)notification
{
    [super peerDisconnected:notification];
    
    // If host controller was not disconnected, remove player from waiting room
    if ([DDGameManager sharedGameManager].sessionManager.controllerHostPeerID != nil)
    {
        MCPeerID *peerID = notification.userInfo[@"peerID"];
        [self _removeAvatarForPeerID:peerID];
    }
}

#pragma mark - MCNearbyServiceAdvertiserDelegate methods
// Incoming invitation request.  Call the invitationHandler block with YES and a valid session to connect the inviting peer to the session.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    NSLog(@"DDSearchingForExternalScene -> didReceiveInvitationFromPeer: %@", peerID);
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
    NSLog(@"DDSearchingForExternalScene -> didNotStartAdvertisingPeer error: %@", error);
}

@end
