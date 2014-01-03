//
//  SKMultilineLabel.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/23/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKMultilineLabel : SKSpriteNode

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) SKColor *fontColor;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat verticalMargin;
@property (nonatomic) CGFloat emptyLineHeight;

+(instancetype)multilineLabelFromStringContainingNewLines:(NSString *)text fontName:(NSString *)fontname fontColor:(SKColor *)fontColor fontSize:(const CGFloat)fontSize verticalMargin:(const CGFloat)verticalMargin emptyLineHeight:(const CGFloat)emptyLineHeight;
- (instancetype)initWithStringContainingNewLines:(NSString *)text fontName:(NSString *)fontName fontColor:(SKColor *)fontColor fontSize:(const CGFloat)fontSize verticalMargin:(const CGFloat)verticalMargin emptyLineHeight:(const CGFloat)emptyLineHeight;

@end
