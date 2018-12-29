//
//  SectorChartController.m
//  Animation
//
//  Created by chenfeng on 2018/12/28.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "SectorChartController.h"
//半径
CGFloat radius = 80;

//扇形对象
@interface Sector : NSObject

@property (nonatomic, assign) CGFloat animationTime;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

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

@interface SectorChartController ()<CAAnimationDelegate>
{
    UIImageView *bgImage;
    UIView *drawLayerView;
    NSInteger index;
    NSMutableArray *sectorArray;
}

@end

@implementation SectorChartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    sectorArray = [[NSMutableArray alloc] init];
    index = 1;
    [self buildUI];
}

- (void)buildUI
{
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    bgImage.image = [UIImage imageNamed:@"chart_bg"];
    [self.view addSubview:bgImage];
    
    drawLayerView = [[UIView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - radius, Main_Screen_Height/2 - radius, radius * 2, radius * 2)];
    [self.view addSubview:drawLayerView];
    
    //按100正圆来算
    [self creatSectorWithArray:@[@(20),@(20),@(20),@(20),@(20)]];
}

#pragma mark - method

- (void)creatSectorWithArray:(NSArray *)dataSource
{
    //绘制扇形
    //开始角
    CGFloat startAngle = -M_PI/2;
    //结束角
    CGFloat endAngle = startAngle;
    //动画执行总时间
    CGFloat totalAnimationTime = 2;
    //中心点
    CGPoint center = CGPointMake(radius, radius);
    
    for (int i = 0; i < dataSource.count; i++) {
        
        CGFloat radio = [dataSource[i] floatValue]/100.f;
        //转动弧度
        CGFloat rotationalRadian = 2*M_PI * radio;
        //每个扇形动画的执行时间
        CGFloat animationTime = totalAnimationTime * radio;
        
        //下一个扇形的开始角为上一个扇形的结束角
        if (i > 0) {
            startAngle = endAngle;
        }
        
        endAngle = startAngle + rotationalRadian;

        //创建扇形，注意这里的radius还要除以2,和下面设置lineWidth为radius有关
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:center radius:radius/2 startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        CAShapeLayer *sectorLayer = [[CAShapeLayer alloc] init];
        sectorLayer.name = [NSString stringWithFormat:@"sector_%d",i];
        sectorLayer.frame = CGRectMake(0, 0, radius * 2, radius * 2);
        sectorLayer.path = path.CGPath;//设置path
        sectorLayer.strokeColor = randomColor.CGColor;//边框颜色
        sectorLayer.fillColor = kClearColor.CGColor;//内部填充颜色
        sectorLayer.lineWidth = radius;//这里为了实现扇形动画，lineWidth设置为radius，实际圆半径为radius/2，可以想象成，圆边框内外各占一半lineWidth
        [drawLayerView.layer addSublayer:sectorLayer];
        
        //每个扇形对象
        Sector *sector = [[Sector alloc] init];
        //起始角度为-90度，整体加上90度是为了和计算出的触点夹角统一起始角度
        sector.startAngle = (180/M_PI) * startAngle + 90;
        sector.endAngle = (180/M_PI) * endAngle + 90;
        sector.shapeLayer = sectorLayer;
        sector.animationTime = animationTime;

        [sectorArray addObject:sector];
        //NSLog(@"start = %f,end = %f",radian.startRadian,radian.endRadian);
    
        if (i == 0) {
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:drawLayerView];
    
    //先判断是否在园内
    if ([MathTool point:point inCircleRect:drawLayerView.bounds]) {
        
        [self calculatedPointInWhichRegion:point];
    }
    
//
//    //NSLog(@"pointX = %f,pointY = %f,",point.x,point.y);
//
//    for (int i = 0; i < bezierPathArray.count; i++) {
//        UIBezierPath *path = bezierPathArray[i];
//        if (CGPathContainsPoint(path.CGPath, NULL, point, NO)) {
//
//            CAShapeLayer *layer = layerArray[i];
//
//            NSLog(@"name = %@",layer.name);
//
//        }
//
//    }
   
//
//    NSLog(@"layer = %@",layer);
//
//    CATransform3D t = CATransform3DIdentity;
//    t.m34 = 0.004;
//    [layer setTransform:t];
//    layer.zPosition = 100;
//
//    [UIView animateWithDuration:0.25f animations:^{
//        layer.transform = CATransform3DRotate(t, 7/90.0 * M_PI_2, 1, 0, 0);
//
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.25f animations:^{
//            layer.transform = CATransform3DTranslate(t, 0, -50, -50);
//        }];
//    }];
    
    
//    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
//    //[self notifyDelegateOfSelectionChangeFrom:_selectedSliceIndex to:selectedIndex];
//    [self touchesCancelled:touches withEvent:event];
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
    
    for (Sector *sector in sectorArray) {
        
        if (sector.startAngle <= n && n <= sector.endAngle) {
            NSLog(@"name = %@",sector.shapeLayer.name);
        }
    }
}

- (NSInteger)getCurrentSelectedOnTouch:(CGPoint)point
{
    __block NSUInteger selectedIndex = -1;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CALayer *layer = [self.view.layer hitTest:point];
    
    layer.transform = CATransform3DMakeRotation(M_PI/6, 0, 1, 0);
    
    CATransform3D rotate = CATransform3DMakeRotation(M_PI/6, 0, 1, 0);
    
   // layer.transform = CATransform3DPerspect(rotate, CGPointMake(0, 0), 200);

    
//    CALayer *parentLayer = [_pieView layer];
//    NSArray *pieLayers = [parentLayer sublayers];
    
//    [pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
////        SliceLayer *pieLayer = (SliceLayer *)obj;
////        CGPathRef path = [pieLayer path];
//
//        if (CGPathContainsPoint(path, &transform, point, 0)) {
////            [pieLayer setLineWidth:_selectedSliceStroke];
////            [pieLayer setStrokeColor:[UIColor whiteColor].CGColor];
////            [pieLayer setLineJoin:kCALineJoinBevel];
////            [pieLayer setZPosition:MAXFLOAT];
////            selectedIndex = idx;
//        } else {
////            [pieLayer setZPosition:kDefaultSliceZOrder];
////            [pieLayer setLineWidth:0.0];
//        }
//    }];
    return selectedIndex;
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
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
                [drawLayerView.layer addSublayer:sectorLayer];
                [animation setValue:@"sectorLayer" forKey:@"AnimationKey"];
                [sectorLayer addAnimation:animation forKey:@"sector"];
                
                index++;
            }
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
