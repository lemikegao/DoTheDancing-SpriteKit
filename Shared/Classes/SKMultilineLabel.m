//
//  SKMultilineLabel.m
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/23/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#import "SKMultilineLabel.h"

@implementation SKMultilineLabel

+(instancetype)multilineLabelFromStringContainingNewLines:(NSString *)text fontName:(NSString *)fontname fontColor:(SKColor *)fontColor fontSize:(const CGFloat)fontSize verticalMargin:(const CGFloat)verticalMargin emptyLineHeight:(const CGFloat)emptyLineHeight
{
    return [[self alloc] initWithStringContainingNewLines:text fontName:fontname fontColor:fontColor fontSize:fontSize verticalMargin:verticalMargin emptyLineHeight:emptyLineHeight];
}

- (instancetype)initWithStringContainingNewLines:(NSString *)text fontName:(NSString *)fontName fontColor:(SKColor *)fontColor fontSize:(const CGFloat)fontSize verticalMargin:(const CGFloat)verticalMargin emptyLineHeight:(const CGFloat)emptyLineHeight
{
    self = [super init];
    if (self)
    {
        _text = text;
        _fontName = fontName;
        _fontColor = fontColor;
        _fontSize = fontSize;
        _verticalMargin = verticalMargin;
        _emptyLineHeight = emptyLineHeight;
        
        [self _updateText];
    }
    
    return self;
}

#pragma mark - Setters
- (void)setText:(NSString *)newText
{
    _text = newText;
    
    [self _updateText];
}

#pragma mark - Private methods
- (void)_updateText
{
    // Remove all previous labels
    [self removeAllChildren];
    
    NSArray *strings = [self.text componentsSeparatedByString:@"\n"];
    
    CGFloat totalheight = 0;
    CGFloat maxwidth = 0;
    
    NSMutableArray* labels = [NSMutableArray array];
    for (NSUInteger i = 0; i < strings.count; i++) {
        NSString* str = [strings objectAtIndex:i];
        const BOOL ISEMPTYLINE = [str isEqualToString:@""];
        
        if (!ISEMPTYLINE)
        {
            SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:self.fontName];
            label.text = str;
            label.fontColor = self.fontColor;
            label.fontSize = self.fontSize;
            
            const CGSize SIZEOFLABEL = [label calculateAccumulatedFrame].size;
            if (SIZEOFLABEL.width > maxwidth)
                maxwidth = SIZEOFLABEL.width;
            totalheight += SIZEOFLABEL.height;
            [labels addObject:label];
        }
        else
        {
            totalheight += self.emptyLineHeight;
            [labels addObject:[NSNull null]];
        }
        if (i + 1 < strings.count)
            totalheight += self.verticalMargin;
    }
    self.size = CGSizeMake(maxwidth, totalheight);
    
    CGFloat y = self.size.height * 0.5;
    const CGFloat x = 0;
    for (NSUInteger i = 0; i < strings.count; i++)
    {
        id obj = [labels objectAtIndex:i];
        if ([obj isKindOfClass:SKLabelNode.class])
        {
            SKLabelNode* label = obj;
            label.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
            label.position = CGPointMake(x, y);
            [self addChild:label];
            const CGSize SIZEOFLABEL = [label calculateAccumulatedFrame].size;
            y -= SIZEOFLABEL.height;
        }
        else {
            y -= self.emptyLineHeight;
        }
        if (i + 1 < labels.count)
            y -= self.verticalMargin;
    }

}

@end
