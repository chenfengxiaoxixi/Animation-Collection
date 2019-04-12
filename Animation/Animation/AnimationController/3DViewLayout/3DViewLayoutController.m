//
//  3DViewLayoutController.m
//  Animation
//
//  Created by chenfeng on 2019/4/8.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "3DViewLayoutController.h"

@interface _DViewLayoutController ()


@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation _DViewLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"3DViewLayout_bg"].CGImage;
    
    _views = [[NSMutableArray alloc] init];
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _containerView.center = self.view.center;
    [self.view addSubview:_containerView];
    
    for (int i = 0; i < 6; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        view.backgroundColor = randomColor;
        [_containerView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75,75, 50, 50)];
        label.font = BOLDSYSTEMFONT(60);
        label.text = [NSString stringWithFormat:@"%d",i+1];
        label.textColor = kBlackColor;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        [_views addObject:view];
    }

    CATransform3D subLayerTransform = CATransform3DIdentity;
    //m34设置远小近大的透视效果
    subLayerTransform.m34 = -1.0/500.0;
    subLayerTransform = CATransform3DRotate(subLayerTransform, -M_PI_4, 1, 0, 0);
    subLayerTransform = CATransform3DRotate(subLayerTransform, M_PI_4, 0, 1, 0);
    //sublayerTransform是对_containerView.layer的所有子图层设置transform，避免挨个设置相同的一些属性，导致代码重复冗余。
    _containerView.layer.sublayerTransform = subLayerTransform;
    
    //view1
    //CATransform3DMakeTranslation(0, 0, 100)沿着z轴方向平移100
    CATransform3D transformWithChildView = CATransform3DMakeTranslation(0, 0, 100);
    [self configViewWithTransform3D:transformWithChildView withView:_views[0]];
    //view2
    transformWithChildView = CATransform3DMakeTranslation(100, 0, 0);
    //CATransform3DRotate(transformWithChildView, M_PI_2, 0, 1, 0)表示绕y轴旋转2分之PI，通过左手定则可以判断
    transformWithChildView = CATransform3DRotate(transformWithChildView, M_PI_2, 0, 1, 0);
    [self configViewWithTransform3D:transformWithChildView withView:_views[1]];
    //view3
    transformWithChildView = CATransform3DMakeTranslation(0, -100, 0);
    transformWithChildView = CATransform3DRotate(transformWithChildView, M_PI_2, 1, 0, 0);
    [self configViewWithTransform3D:transformWithChildView withView:_views[2]];
    //view4
    transformWithChildView = CATransform3DMakeTranslation(0, 100, 0);
    transformWithChildView = CATransform3DRotate(transformWithChildView, -M_PI_2, 1, 0, 0);
    [self configViewWithTransform3D:transformWithChildView withView:_views[3]];
    //view5
    transformWithChildView = CATransform3DMakeTranslation(-100, 0, 0);
    transformWithChildView = CATransform3DRotate(transformWithChildView, -M_PI_2, 0, 1, 0);
    [self configViewWithTransform3D:transformWithChildView withView:_views[4]];
    //view6
    transformWithChildView = CATransform3DMakeTranslation(0, 0, -100);
    transformWithChildView = CATransform3DRotate(transformWithChildView, M_PI, 0, 1, 0);
    [self configViewWithTransform3D:transformWithChildView withView:_views[5]];
}

- (void)configViewWithTransform3D:(CATransform3D )transform withView:(UIView *)view
{
    view.layer.transform = transform;
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
