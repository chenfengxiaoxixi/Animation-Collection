//
//  ViewController.h
//  Animation
//
//  Created by cf on 2018/12/22.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DisplayAnimationType)
{
    DisplayAnimationTypeWith2D,
    DisplayAnimationTypeWith3D
};

@interface ViewController : UIViewController

@property (nonatomic, assign) DisplayAnimationType type;

@end

