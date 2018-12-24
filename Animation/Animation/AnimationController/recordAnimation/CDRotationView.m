//
//  CDRotationView.m
//  Animation
//
//  Created by chenfeng on 2018/12/24.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "CDRotationView.h"

@interface CDRotationView ()

@property (strong, nonatomic) UIImageView *ro;
@property (strong, nonatomic) UIImage *onImage;
@property (strong, nonatomic) UIImage *offImage;

@end

@implementation CDRotationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _CDimageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2 - 65, self.height/2 - 65, 130, 130)];
        [self addSubview:_CDimageView];
        
        _ro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, ROTATION_WIDTH, ROTATION_WIDTH)];
        _ro.image = [UIImage imageNamed:@"diepian"];
        [self addSubview:_ro];
        
        _onImage = [UIImage imageNamed:@"play_overCD"];
        _offImage = [UIImage imageNamed:@"pause_overCD"];
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0,0,_onImage.size.width * 1.3, _onImage.size.height * 1.3);
        [self.btn setCenter:_CDimageView.center];
        [self.btn setImage:_onImage forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        
        [self addAnimation];
    }
    return self;
}

- (void)addAnimation
{
    //旋转动画
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 18;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO; //No Remove
    [self.layer addAnimation:rotationAnimation forKey:@"rotation"];
    
}

- (void)playOrPause
{
    _isPlay = !_isPlay;
    
    if (self.isPlay) {
        
        [self startRotation];
        [self.btn setImage:_onImage forState:UIControlStateNormal];
        
    }else{
        [self pauseRotation];
        [self.btn setImage:_offImage forState:UIControlStateNormal];
        
    }
    _playBlock(_isPlay);
    
}

- (void)setIsPlay:(BOOL)aIsPlay{
    
    _isPlay = aIsPlay;
    
    if (self.isPlay) {
        [self start];
        
    }else{
        [self stop];
        
    }
}

- (void)startRotation
{
    self.layer.speed = 1.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval pausedTime = [self.layer timeOffset];
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}


- (void)pauseRotation{
    [UIView animateWithDuration:1 animations:^{
        CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.layer.speed = 0.0;
        self.layer.timeOffset = pausedTime;
    }];
    
}

- (void)start
{
    [self startRotation];
    [self.btn setImage:_onImage forState:UIControlStateNormal];
}

- (void)stop
{
    self.layer.speed = 0;
    [self.btn setImage:_offImage forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
