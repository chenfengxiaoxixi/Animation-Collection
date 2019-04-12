//
//  DragAndRotateController.m
//  Animation
//
//  Created by chenfeng on 2019/4/11.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "DragAndRotateController.h"

@interface DragAndRotateController ()


@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation DragAndRotateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"dragAndRotateView"].CGImage;
    
    _startPoint = CGPointZero;
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _centerView.center = self.view.center;
    _centerView.backgroundColor = kBlueColor;
    _centerView.layer.contents = (__bridge id)[UIImage imageNamed:@"text_pic"].CGImage;
    [self.view addSubview:_centerView];
    
    //设置旋转透视效果
    CATransform3D transform = _centerView.layer.transform;
    transform.m34 = -1.f/500;
    _centerView.layer.transform = transform;
    
    //拖拽手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
}

- (void)configViewWithTransform3D:(CATransform3D )transform withView:(UIView *)view
{
    view.layer.transform = transform;
}

- (void)panGesture:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        
        _endPoint = [sender translationInView:sender.view];
        //终点坐标减去起点坐标得到向量坐标，向量的方向就是视图旋转的方向
        CGPoint point = CGPointMake(_endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
        
        _startPoint = _endPoint;
        
        CGFloat x = point.x * cos(M_PI_2) - point.y * sin(M_PI_2);
        CGFloat y = point.x * sin(M_PI_2) - point.y * cos(M_PI_2);
        //由于CATransform3DRotate方法是绕轴旋转，如：设置为（1，0，0），即为视图绕x轴旋转，可以通过左手定则判断。现在我们要的效果实为沿轴旋转，即沿着手势滑动的方向旋转，通过垂直关系由上面公式计算出新向量，对transform设置新向量的值
        self.centerView.layer.transform = CATransform3DRotate(self.centerView.layer.transform, 0.05, x, y, 0);
        
        
    } else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateEnded) {
        
        
    }
}

@end
