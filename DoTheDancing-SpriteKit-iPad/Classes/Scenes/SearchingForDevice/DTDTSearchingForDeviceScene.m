//
//  DTDSearchingForDeviceScene.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 1/20/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DTDTSearchingForDeviceScene.h"
#import "DTDTMainMenuScene.h"

@implementation DTDTSearchingForDeviceScene

- (id)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self)
    {
        self.backgroundColor = RGB(249, 185, 56);
        
        [self _displaySearchingMessage];
        [self _displayBackButton];
        [self _startSearchingForDevice];
    }
    return self;
}

#pragma mark - Setup UI

- (void)_displaySearchingMessage
{
    SKLabelNode *searchingLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    searchingLabel.fontSize = 50;
    searchingLabel.fontColor = [UIColor blackColor];
    searchingLabel.text = @"Searching for device...";
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
    [self.view presentScene:[DTDTMainMenuScene sceneWithSize:self.size] transition:[SKTransition pushWithDirection:SKTransitionDirectionRight duration:0.25]];
}

#pragma mark - Connection
- (void)_startSearchingForDevice
{
    
}

@end
