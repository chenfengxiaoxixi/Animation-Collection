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
        self.backgroundColor = kClearColor;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        bgView.backgroundColor = kWhiteColor;
        bgView.alpha = 0.3;
        [self.contentView addSubview:bgView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.width, self.width + 60)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _titleStr = [[UILabel alloc] initWithFrame:CGRectMake(15, self.width + 80, self.width - 30, 20)];
        _titleStr.textAlignment = NSTextAlignmentCenter;
        _titleStr.font = SYSTEMFONT(16);
        _titleStr.textColor = kDarkGrayColor;
        [self.contentView addSubview:_titleStr];
    
}
    
    return self;
}

@end
