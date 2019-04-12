//
//  BaseTabBarController.m
//  Animation
//
//  Created by chenfeng on 2019/4/11.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

#import "BaseTabBarController.h"
#import "ViewController.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
    ViewController *vc1 = [[ViewController alloc] init];
    vc1.tabBarItem.title = @"2D效果";
    vc1.type = DisplayAnimationTypeWith2D;
    
    ViewController *vc2 = [[ViewController alloc] init];
    vc2.tabBarItem.title = @"3D效果";
    vc2.type = DisplayAnimationTypeWith3D;
    
    self.viewControllers = @[vc1,vc2];

    
    [self setTabbarTitleColor];
}

- (void)setTabbarTitleColor{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    tabBarController.selectedIndex = [self.viewControllers indexOfObject:viewController];
    
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
