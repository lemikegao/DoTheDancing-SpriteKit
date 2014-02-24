//
//  DDPlayer.h
//  DoTheDancing
//
//  Created by Michael Gao on 2/23/14.
//  Copyright (c) 2014 Chin and Cheeks LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDPlayer : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic) DDPlayerColor playerColor;

+ (instancetype)playerWithPlayerColor:(DDPlayerColor)playerColor nickname:(NSString *)nickname;
- (instancetype)initWithPlayerColor:(DDPlayerColor)playerColor nickname:(NSString *)nickname;

@end
