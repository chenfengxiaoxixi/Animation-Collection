//
//  MathTool.h
//  Animation
//
//  Created by chenfeng on 2018/12/29.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathTool : NSObject

+ (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect;

+ (float)radiansToDegreesFromPointX:(CGPoint)start ToPointY:(CGPoint)end ToCenter:(CGPoint)center;

@end


