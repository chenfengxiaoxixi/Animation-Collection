//
//  SectorChartView.m
//  Animation
//
//  Created by cf on 2018/12/31.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "SectorChartView.h"

//扇形对象
@interface Sector : NSObject

@property (nonatomic, assign) CGFloat animationTime;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation Sector

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end


@interface SectorChartView ()<CAAnimationDelegate>
{
    NSInteger index;
    NSMutableArray *sectorArray;
    //半径
    CGFloat radius;
}

@end

@implementation SectorChartView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        sectorArray = [[NSMutableArray alloc] init];
        index = 1;
        radius = frame.size.width/2;//半径
        
    }
    return self;
}

#pragma mark - method

- (void)setDataSource:(id<SectorChartDataSource>)dataSource
{
    _dataSource = dataSource;
    
    NSArray *dataSourceArray = [self.dataSource getSectorChartDataSource];

    //计算总数据
    NSNumber *sum = [dataSourceArray valueForKeyPath:@"@sum.floatValue"];
    //开始角
    CGFloat startRadian = -M_PI/2;
    //结束角
    CGFloat endRadian = startRadian;
    //动画执行总时间
    CGFloat totalAnimationTime = 1.5;
    //中心点
    CGPoint center = CGPointMake(radius, radius);
    
    for (int i = 0; i < dataSourceArray.count; i++) {
        
        CGFloat radio = [dataSourceArray[i] floatValue]/[sum floatValue];
        //转动弧度
        CGFloat rotationalRadian = 2*M_PI * radio;
        //每个扇形动画的执行时间
        CGFloat animationTime = totalAnimationTime * radio;
        
        //下一个扇形的开始角为上一个扇形的结束角
        if (i > 0) {
            startRadian = endRadian;
        }
        
        endRadian = startRadian + rotationalRadian;
        
        //创建扇形，注意这里的radius还要除以2,和下面设置lineWidth为radius有关
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:radius/2 startAngle:startRadian endAngle:endRadian clockwise:YES];
        
        CAShapeLayer *sectorLayer = [[CAShapeLayer alloc] init];
        sectorLayer.name = [NSString stringWithFormat:@"sector_%d",i];
        sectorLayer.frame = CGRectMake(0, 0, radius * 2, radius * 2);
        sectorLayer.path = path.CGPath;//设置path
        sectorLayer.strokeColor = randomColor.CGColor;//边框颜色
        sectorLayer.fillColor = kClearColor.CGColor;//内部填充颜色
        sectorLayer.lineWidth = radius;//这里为了实现扇形动画，lineWidth设置为radius，实际UIBezierPath圆内半径为radius/2，可以想象成，圆边框内外各占一半，组合成的lineWidth
        [self.layer addSublayer:sectorLayer];
        
        //每个扇形对象
        Sector *sector = [[Sector alloc] init];
        //起始角度为-90度，整体加上90度是为了和计算出的触点夹角统一起始角度
        sector.startAngle = (180/M_PI) * startRadian + 90;//弧度转角度，可能会好理解些
        sector.endAngle = (180/M_PI) * endRadian + 90;
        sector.shapeLayer = sectorLayer;
        sector.animationTime = animationTime;
        
        [sectorArray addObject:sector];
        //NSLog(@"start = %f,end = %f",radian.startRadian,radian.endRadian);
        
        //动画为依次执行，先执行第一个
        if (i == 0) {
            //要想同时执行可以把AnimationDelegate里的动画放到for循环里面
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
            animation.delegate = self;
            animation.values = @[@0.0,@1.0];
            animation.duration = animationTime;
            //    animation.repeatCount = MAXFLOAT;
            //    animation.autoreverses = YES;
            //    animation.calculationMode = kCAAnimationCubic;
            //animation.fillMode = kCAFillModeForwards;
            
            [animation setValue:@"sectorLayer" forKey:@"AnimationKey"];
            [sectorLayer addAnimation:animation forKey:@"sector"];
        }
        else
        {   //剩下需要动画的layer先隐藏
            sectorLayer.hidden = YES;
        }
    }
}

//点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //先判断是否在园内
    if ([MathTool point:point inCircleRect:self.bounds]) {
        //再判断是否在扇形内
        [self calculatedPointInWhichRegion:point];
    }
}

//计算触点在哪个扇形
- (void)calculatedPointInWhichRegion:(CGPoint)point
{
    //起始边到触点的弧度
    CGFloat radian = [MathTool radiansToDegreesFromPointX:CGPointMake(radius, 0) ToPointY:point ToCenter:CGPointMake(radius, radius)];
    //弧长
    CGFloat l = radian * radius;
    //夹角
    CGFloat n = (180 * l)/(M_PI * radius);
    
    //如果endPoint在坐标轴第三象限
    if ((point.x >= 0 && point.x <= radius) &&
        (point.y >= radius && point.y <= radius*2)) {
        n = 360 - n;
    }
    //如果endPoint在坐标轴第四象限
    else if ((point.x >= 0 && point.x <= radius) &&
             (point.y >= 0 && point.y <= radius))
    {
        n = 360 - n;
    }
    
    //NSLog(@"n = %f",n);
    //判断触点边位于哪个扇形,触点就在哪个扇形
    for (int i = 0; i < sectorArray.count; i++) {
        Sector *sector = sectorArray[i];
        
        if (sector.startAngle <= n && n <= sector.endAngle) {
            
            sector.isSelected = !sector.isSelected;

            NSLog(@"name = %@",sector.shapeLayer.name);
            if ([self.delegate respondsToSelector:@selector(sectorChart:didSelectedWithIndex:)]) {
                 [self.delegate sectorChart:self didSelectedWithIndex:i];
            }
            //扇形点击动画
            [self sectorAnimation:sector];
            
        }
    }
}

- (void)sectorAnimation:(Sector *)sector
{
    if (sector.isSelected) {
        CATransform3D t = CATransform3DIdentity;
        t.m34 = -1/1000;
        
        [UIView animateWithDuration:0.25f animations:^{
            
            sector.shapeLayer.transform = CATransform3DTranslate(t, 5, -3, 10);
        }];
    }
    else
    {
        sector.shapeLayer.transform = CATransform3DIdentity;
    }
    
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{   //上一个扇形动画结束，再执行下一个
    if (flag) {
        if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"sectorLayer"]) {
            
            if (index < sectorArray.count) {
                
                Sector *sector = sectorArray[index];
                
                CAShapeLayer *sectorLayer = sector.shapeLayer;
                sectorLayer.hidden = NO;
                CGFloat animationTime = sector.animationTime;
                
                CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
                animation.delegate = self;
                animation.values = @[@0.0,@1.0];
                animation.duration = animationTime;
                //添加layer对象
                [self.layer addSublayer:sectorLayer];
                [animation setValue:@"sectorLayer" forKey:@"AnimationKey"];
                [sectorLayer addAnimation:animation forKey:@"sector"];
                
                index++;
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
