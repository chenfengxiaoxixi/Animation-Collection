//
//  SectorChartController.m
//  Animation
//
//  Created by chenfeng on 2018/12/28.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "SectorChartController.h"
#import "SectorChartView.h"

//半径
CGFloat radius = 80;

@interface SectorChartController ()<SectorChartDataSource>
{
    UIImageView *bgImage;
    SectorChartView *chartView;
}

@end

@implementation SectorChartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self buildUI];
}

- (void)buildUI
{
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    bgImage.image = [UIImage imageNamed:@"chart_bg"];
    [self.view addSubview:bgImage];
    
    chartView = [[SectorChartView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - radius, Main_Screen_Height/2 - radius, radius * 2, radius * 2)];
    chartView.dataSource = self;
    [self.view addSubview:chartView];
}

#pragma mark - method

- (NSArray *)getSectorChartDataSource
{
    return @[@(100),@(80),@(60),@(40),@(20)];
}

#pragma mark - method

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:chartView];
//
//    //先判断是否在园内
//    if ([MathTool point:point inCircleRect:chartView.bounds]) {
//
//       // [self calculatedPointInWhichRegion:point];
//    }
//
////
////    //NSLog(@"pointX = %f,pointY = %f,",point.x,point.y);
////
////    for (int i = 0; i < bezierPathArray.count; i++) {
////        UIBezierPath *path = bezierPathArray[i];
////        if (CGPathContainsPoint(path.CGPath, NULL, point, NO)) {
////
////            CAShapeLayer *layer = layerArray[i];
////
////            NSLog(@"name = %@",layer.name);
////
////        }
////
////    }
//
////
////    NSLog(@"layer = %@",layer);
////
////    CATransform3D t = CATransform3DIdentity;
////    t.m34 = 0.004;
////    [layer setTransform:t];
////    layer.zPosition = 100;
////
////    [UIView animateWithDuration:0.25f animations:^{
////        layer.transform = CATransform3DRotate(t, 7/90.0 * M_PI_2, 1, 0, 0);
////
////    }completion:^(BOOL finished) {
////        [UIView animateWithDuration:0.25f animations:^{
////            layer.transform = CATransform3DTranslate(t, 0, -50, -50);
////        }];
////    }];
//
//
////    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
////    //[self notifyDelegateOfSelectionChangeFrom:_selectedSliceIndex to:selectedIndex];
////    [self touchesCancelled:touches withEvent:event];
//}


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
