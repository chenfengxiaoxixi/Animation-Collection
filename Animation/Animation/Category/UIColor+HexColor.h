//
//  UIColor+HexColor.h
//  Animation
//
//  Created by cf on 2018/12/23.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

//根据颜色值获取颜色
+ (UIColor *)colorOfHex:(int)value;

@end
