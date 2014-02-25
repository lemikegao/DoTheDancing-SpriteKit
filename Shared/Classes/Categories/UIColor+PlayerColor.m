//
//  UIColor+PlayerColor.m
//  DoTheDancing
//
//  Created by Michael Gao on 2/25/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import "UIColor+PlayerColor.h"

@implementation UIColor (PlayerColor)

+ (UIColor *)colorWithPlayerColor:(DDPlayerColor)playerColor
{
    switch (playerColor)
    {
        case DDPlayerColorBlue:
            return [UIColor blueColor];
        
        case DDPlayerColorBrown:
            return [UIColor brownColor];
            
        case DDPlayerColorCyan:
            return [UIColor cyanColor];
            
        case DDPlayerColorDarkGray:
            return [UIColor darkGrayColor];
            
        case DDPlayerColorGray:
            return [UIColor grayColor];
            
        case DDPlayerColorGreen:
            return [UIColor greenColor];
            
        case DDPlayerColorLightGray:
            return [UIColor lightGrayColor];
            
        case DDPlayerColorMagenta:
            return [UIColor magentaColor];
            
        case DDPlayerColorOrange:
            return [UIColor orangeColor];
            
        case DDPlayerColorPurple:
            return [UIColor purpleColor];
            
        case DDPlayerColorRed:
            return [UIColor redColor];
            
        case DDPlayerColorYellow:
            return [UIColor yellowColor];
            
        default:
            return [UIColor clearColor];
    }
}

@end
