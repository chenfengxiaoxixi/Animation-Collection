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
CGFloat radius = 100;

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

#pragma mark - SectorChartDataSource

- (NSArray *)getSectorChartDataSource
{
    return @[@(100),@(100),@(100),@(100),@(100)];
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
