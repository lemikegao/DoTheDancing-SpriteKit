//
//  DDScene.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/2/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "DDScene.h"

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
    }
    
    return self;
}

#pragma mark - Exit scene
- (void)willMoveFromView:(SKView *)view
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super willMoveFromView:view];
}

@end
