//
//  ViewController.m
//  Animation
//
//  Created by cf on 2018/12/22.
//  Copyright © 2018年 chenfeng. All rights reserved.
//

#import "ViewController.h"
#import "HomeCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    
    self.title = @"动画集合";
    
    _array = @[@{@"title":@"摇钱树",@"controller":@"YQSAnimationController"}];
    
    [self.view addSubview:self.collectionView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectionCell = @"CollectionCell";
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    
    NSDictionary *dic = _array[indexPath.row];
    
    cell.titleStr.text = dic[@"title"];
    
    NSString *imageName = [NSString stringWithFormat:@"commodity_%ld",(long)indexPath.row + 1];
    
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemCount = 2;
    return CGSizeMake((Main_Screen_Width - 25)/itemCount, (Main_Screen_Width - 25)/itemCount + 80);
}

//距离collectionview的上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10,10,10);
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _array[indexPath.row];
    
    UIViewController *vc = [[NSClassFromString(dic[@"controller"]) alloc] init];
    vc.title = dic[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UI

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TopHeight) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kClearColor;
        [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
       
        //去掉顶部偏移
        if (@available(iOS 11.0, *))
        {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _collectionView;
}



@end
