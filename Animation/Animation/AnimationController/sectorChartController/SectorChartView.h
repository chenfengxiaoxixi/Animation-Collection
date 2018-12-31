//
//  SectorChartView.h
//  Animation
//
//  Created by cf on 2018/12/31.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SectorChartView;

@protocol SectorChartDataSource <NSObject>

@required
- (NSArray *)getSectorChartDataSource;

@end

@protocol SectorChartDelegate <NSObject>

- (void)sectorChart:(SectorChartView *)sectorChart didSelectedWithIndex:(NSInteger )index;

@end

@interface SectorChartView : UIView

@property (nonatomic, weak) id<SectorChartDataSource> dataSource;
@property (nonatomic, weak) id<SectorChartDelegate> delegate;

@end
