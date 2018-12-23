//
//  HomeCollectionViewCell.m
//  Animation
//
//  Created by cf on 2018/12/23.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.backgroundColor = KBackgroundColor;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.width, self.width)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _titleStr = [[UILabel alloc] initWithFrame:CGRectMake(15, self.width + 15, self.width - 30, 20)];
        _titleStr.font = SYSTEMFONT(14);
        _titleStr.textColor = kBlackColor;
        [self.contentView addSubview:_titleStr];
    
        
    }
    
    return self;
}

@end
