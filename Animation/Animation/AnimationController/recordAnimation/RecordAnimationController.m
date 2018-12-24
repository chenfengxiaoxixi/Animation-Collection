//
//  RecordAnimationController.m
//  Animation
//
//  Created by chenfeng on 2018/12/24.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "RecordAnimationController.h"
#import "CDRotationView.h"

@interface RecordAnimationController ()

@property (nonatomic, strong) CDRotationView *center_rotationView;

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;

@end

@implementation RecordAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)buildUI
{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    bgImage.image = [UIImage imageNamed:@"beijing_cd"];
    [self.view addSubview:bgImage];
    
    WeakSelf(self);
    CDRotationView *r_view = [[CDRotationView alloc] initWithFrame:CGRectMake((Main_Screen_Width - (ROTATION_WIDTH + 20))/2, self.view. height/2 - (ROTATION_WIDTH + 20)/2, ROTATION_WIDTH + 20, ROTATION_WIDTH + 20)];
    r_view.CDimageView.image = [UIImage imageNamed:@"cdImage"];
    r_view.playBlock = ^(BOOL is){
        if (is) {
            [weakself startWithAnimation];
        }
        else
        {
            [weakself pauseWithAnimation];
        }
    };
    [self.view addSubview:r_view];
    
    r_view.isPlay = YES;
    
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/2+100,MinY(r_view) - 20, 70, 70)];
    _imageView1.image = [UIImage imageNamed:@"changzhen_2"];
    [self.view addSubview:_imageView1];
    
    //中间的唱针
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.x - 10, MinY(r_view) - 105, 264*0.5, 485*0.5)];
    _imageView2.image = [UIImage imageNamed:@"changzhen_1"];
    _imageView2.layer.anchorPoint = CGPointMake(1, 0.15);//锚点重设会导致x,y坐标发生偏移
    [self.view addSubview:_imageView2];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-0.15);
    _imageView2.transform = transform;
    
    _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.x+5,MinY(r_view) - 13, 60, 60)];
    _imageView3.image = [UIImage imageNamed:@"changzhen_3"];
    [self.view addSubview:_imageView3];
}

#pragma mark - method

//唱针动画
- (void)pauseWithAnimation {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(-0.4);
        _imageView2.transform = transform;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)startWithAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(-0.15);
        _imageView2.transform = transform;
    } completion:^(BOOL finished) {
        
    }];
    
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
