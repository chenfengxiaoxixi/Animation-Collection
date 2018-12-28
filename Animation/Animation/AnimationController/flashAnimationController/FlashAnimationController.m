//
//  FlashAnimationController.m
//  Animation
//
//  Created by chenfeng on 2018/12/25.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "FlashAnimationController.h"

@interface FlashAnimationController ()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation FlashAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)buildUI
{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    bgImage.image = [UIImage imageNamed:@"flash_bgImage"];
    [self.view addSubview:bgImage];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - 30, Main_Screen_Height/2 - 30, 60, 60)];
    _headImageView.image = [UIImage imageNamed:@"flash_headImage"];
    [bgImage addSubview:_headImageView];
    [self headImageViewStartFlashAnimation];
    
    //第一个扩散红波纹
    
    //最初半径
    CGFloat radius = 40;
    //开始角
    CGFloat startAngle = 0;
    //结束角
    CGFloat endAngle = M_PI * 2;
    //中心点
    CGPoint center = CGPointMake(40, 40);
    //创建圆
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    //创建layer
    CAShapeLayer *circularLayer1 = [[CAShapeLayer alloc] init];
    circularLayer1.frame = CGRectMake(Main_Screen_Width/2 - 40, Main_Screen_Height/2 - 40, 80, 80);
    circularLayer1.path = bezierPath1.CGPath;//设置path
    circularLayer1.strokeColor = kRedColor.CGColor;//边框颜色
    circularLayer1.fillColor = kClearColor.CGColor;//内部填充颜色
    //添加layer对象
    [bgImage.layer addSublayer:circularLayer1];
    [self circularLayerStartFlashAnimationTwo:circularLayer1];
    
    //第二个静止红波纹
    
    //最初半径
    CGFloat radius2 = 35;
    //开始角
    CGFloat startAngle2 = 0;
    //结束角
    CGFloat endAngle2 = M_PI * 2;
    //中心点
    CGPoint center2 = CGPointMake(35, 35);
    //创建圆
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithArcCenter:center2 radius:radius2 startAngle:startAngle2 endAngle:endAngle2 clockwise:YES];
    
    //生成layer对象
    CAShapeLayer *circularLayer2 = [[CAShapeLayer alloc] init];
    circularLayer2.frame = CGRectMake(Main_Screen_Width/2 - 35, Main_Screen_Height/2 - 35, 70, 70);
    circularLayer2.path = bezierPath2.CGPath;//设置path
    circularLayer2.strokeColor = kRedColor.CGColor;//边框颜色
    circularLayer2.fillColor = kClearColor.CGColor;//内部填充颜色
    circularLayer2.lineWidth = 0.8;//边宽
    //添加layer对象
    [bgImage.layer addSublayer:circularLayer2];
}

#pragma mark - method

- (void)headImageViewStartFlashAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.0,@1.3,@1.0];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    animation.calculationMode = kCAAnimationCubic;
    //animation.fillMode = kCAFillModeForwards;
    [_headImageView.layer addAnimation:animation forKey:@"flash1"];
}

- (void)circularLayerStartFlashAnimationTwo:(CAShapeLayer *)shapeLayer
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.removedOnCompletion = YES;
//    // 添加动画曲线。关于其他的动画曲线，也可以自行尝试
//    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.0,@1.3];
    
    //添加动画path为layer的strokeColor
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    //如果需要精确控制颜色变化，可以使用rgb。
    animation2.values = @[(__bridge id)kRedColor.CGColor,
                          (__bridge id)kClearColor.CGColor];
    
    animationGroup.animations = @[animation,animation2];
    
    [shapeLayer addAnimation:animationGroup forKey:@"flash2"];
    
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
