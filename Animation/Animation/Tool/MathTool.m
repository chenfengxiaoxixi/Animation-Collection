//
//  MathTool.m
//  Animation
//
//  Created by chenfeng on 2018/12/29.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "MathTool.h"

@implementation MathTool

//圆心到点的距离>或<半径
+ (BOOL)point:(CGPoint)point inCircleRect:(CGRect)rect
{
    CGFloat radius = rect.size.width/2.0;
    CGPoint center = CGPointMake(rect.origin.x + radius, rect.origin.y + radius);
    double dx = fabs(point.x - center.x);
    double dy = fabs(point.y - center.y);
    double dis = hypot(dx, dy);
    if (dis <= radius) {
        
        return YES;
    }
    
    return NO;
}

//圆心相同，计算起始点和终止点的弧度
+ (float)radiansToDegreesFromPointX:(CGPoint)start ToPointY:(CGPoint)end ToCenter:(CGPoint)center
{
    
    float rads;
    CGFloat a = (end.x - center.x);
    CGFloat b = (end.y - center.y);
    CGFloat c = (start.x - center.x);
    CGFloat d = (start.y - center.y);
    rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    //    if (start.x < center.x) {
    //        rads = 2*M_PI - rads;
    //    }
    return rads;
}

@end
