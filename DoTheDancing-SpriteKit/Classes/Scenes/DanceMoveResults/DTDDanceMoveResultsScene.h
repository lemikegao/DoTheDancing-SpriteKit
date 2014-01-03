//
//  DTDDanceMoveResultsScene.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/24/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DTDDanceMoveResultsScene : SKScene

+ (instancetype)sceneWithSize:(CGSize)size results:(NSArray *)results;
- (instancetype)initWithSize:(CGSize)size results:(NSArray *)results;

@end