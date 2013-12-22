//
//  DTDConstants.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/15/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#ifndef DoTheDancing_SpriteKit_DTDConstants_h
#define DoTheDancing_SpriteKit_DTDConstants_h

#define RGBA(r,g,b,a)				[SKColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)					RGBA(r, g, b, 1.0f)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)

#endif
