//
//  DDEConnectedToDeviceScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/23/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDEConnectedToControllerScene.h"

@implementation DDEConnectedToControllerScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = RGB(249, 185, 56);
        
        [self _displayConnectedLabel];
        [self _displayPlayButton];
    }
    return self;
}

#pragma mark - UI setup
- (void)_displayConnectedLabel
{
    SKLabelNode *connectedLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    connectedLabel.fontSize = 28;
    connectedLabel.text = @"Connected!";
    connectedLabel.fontColor = [UIColor blackColor];
    connectedLabel.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.9);
    [self addChild:connectedLabel];
}

- (void)_displayPlayButton
{
    // Temporary play button
    SKButton *playButton = [SKButton buttonWithImageNamedNormal:@"mainmenu-button-single" selected:@"mainmenu-button-single-highlight"];
    playButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    [playButton setTouchUpInsideTarget:self action:@selector(_pressedPlayButton:)];
    [self addChild:playButton];
}

#pragma mark - Button actions
- (void)_pressedPlayButton:(id)sender
{
    
}

@end
