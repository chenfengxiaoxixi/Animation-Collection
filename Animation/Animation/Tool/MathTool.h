//
//  MathTool.h
//  Animation
//
//  Created by chenfeng on 2018/12/29.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MathTool : NSObject

//圆心到点的距离>或<半径
+ (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect;
//圆心相同，计算起始点和终止点的弧度
+ (float)radiansToDegreesFromPointX:(CGPoint)start ToPointY:(CGPoint)end ToCenter:(CGPoint)center;

@end


