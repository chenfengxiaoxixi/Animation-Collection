//
//  CDRotationView.h
//  Animation
//
//  Created by chenfeng on 2018/12/24.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROTATION_WIDTH 300

@interface CDRotationView : UIView

@property (assign, nonatomic) BOOL isPlay;

@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) UIImageView *CDimageView;

@property (nonatomic,strong) void(^playBlock)(BOOL isPlay);

- (void)playOrPause;

@end


