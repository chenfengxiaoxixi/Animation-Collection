//
//  YQSAnimationController.m
//  Animation
//
//  Created by cf on 2018/12/23.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "YQSAnimationController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YQSAnimationController ()<CAAnimationDelegate>
{
    UIImageView * yqsImage;
    UIImageView *bgImage;
    NSMutableArray *ybArray;
}

@end

@implementation YQSAnimationController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TopHeight)];
    bgImage.image = [UIImage imageNamed:@"yqs_bg.png"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    [bgImage becomeFirstResponder];
    
    yqsImage = [[UIImageView alloc]initWithFrame:CGRectMake(Main_Screen_Width/2- 215/2, Main_Screen_Height - 245 - 200, 215 ,245)];
    yqsImage.image = [UIImage imageNamed:@"yqs_shu.png"];
    
    CALayer * imageLayer = [yqsImage layer];
    imageLayer.anchorPoint = CGPointMake(0.5, 0.8);//锚点值改变，会影响坐标
    
    ybArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< 32; i++) {
        
        int x = rand()%160;
        int y = rand()%60 + 60;
        
        UIImageView * yb = [[UIImageView alloc]initWithFrame:CGRectMake(x + MinX(yqsImage), y + MinY(yqsImage), 20, 20)];
        yb.hidden = YES;
        int a = rand()%12+1;
        yb.image = [UIImage imageNamed:[NSString stringWithFormat:@"yqs_yb%d",a]];
        [bgImage addSubview:yb];
        [ybArray addObject:yb];
    }
    
    [bgImage addSubview:yqsImage];
    
    UIImageView * caibao = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 - (169*1.5)/2, MaxY(yqsImage) - 50, 169 *1.5, 77 * 1.5)];
    caibao.image = [UIImage imageNamed:@"yqs_caibao.png"];
    [bgImage addSubview:caibao];
    
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//系统震动
    
    [self ybAnimation];
    [self shakeYQS:yqsImage];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

//摇钱树
- (void)shakeYQS:(UIImageView *)view
{
    //    CAAnimationGroup * group = [CAAnimationGroup animation];
    
    //表示以z坐标轴为中心轴旋转
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.values = @[@(0),@(-M_PI_4/2),@(0),@(M_PI_4/2),@(0),
                         @(-M_PI_4/3),@(0),@(M_PI_4/3),@(0),
                         @(-M_PI_4/4),@(0),@(M_PI_4/4),@(0),
                         @(-M_PI_4/5),@(0),@(M_PI_4/6),@(0)];
    animation.repeatCount = 1;
    animation.duration = 1;
    
    
    [view.layer addAnimation:animation forKey:@"shake"];
    
}

//元宝掉落
- (void)ybAnimation
{
    
    for (int i = 0; i< ybArray.count; i++) {
        
        UIImageView * yb = ybArray[i];
        
        int x = rand()%160;
        int y = rand()%60 + 60;
        yb.frame = CGRectMake(x + MinX(yqsImage), y + MinY(yqsImage), yb.frame.size.width, yb.frame.size.height);
        
        
        yb.hidden = NO;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
        animation.delegate = self;
        animation.values = @[@(yb.frame.origin.y), @(yb.frame.origin.y+200)];
        
        float startTime = 0 ;
        
        animation.repeatCount = 1;
        
        float endTime = (float)(arc4random()%100) / 100 + 0.5;
        
        animation.keyTimes = @[@(startTime), @(endTime)];
        animation.duration = endTime;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        [animation setValue:@"ybDrop" forKey:@"ybAnimation"];
        [animation setValue:yb forKey:@"animationView"];
        [yb.layer addAnimation:animation forKey:@"ybAnimation"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if ([[anim valueForKey:@"ybAnimation"] isEqualToString:@"ybDrop"]) {
            
            UIImageView *imageView = [anim valueForKey:@"animationView"] ;
            [imageView.layer removeAllAnimations];
            imageView.hidden = YES;
        }
    }
}

- (void)shake:(UIButton *)shake
{
    
    NSLog(@"dasdas");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
