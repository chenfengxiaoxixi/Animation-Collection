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
@property (nonatomic, strong) NSMutableArray *gifImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"简单动画";
    
    [self buildUIStyle];
    [self configController];
    [self handleGifSrc];
    
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildUIStyle
{
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor,
                                NSFontAttributeName:SYSTEMFONT(18)}];
    UIImageView *beijing = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    beijing.image = [UIImage imageNamed:@"beijing-a"];
    [self.view addSubview:beijing];
}

- (void)configController
{
    _array = @[@{@"title":@"摇钱树",@"controller":@"YQSAnimationController"},
               @{@"title":@"唱片",@"controller":@"RecordAnimationController"},
               @{@"title":@"闪烁",@"controller":@"FlashAnimationController"},
               @{@"title":@"扇形统计图",@"controller":@"SectorChartController"}];
}

- (void)handleGifSrc
{
    _gifImages = [[NSMutableArray alloc] init];
    NSArray *array = @[@"yqs",@"recordCD",@"flashing",@"flashing"];
    
    for (int i = 0; i < array.count; i++) {
        
        NSArray *images = [self processingGIFPictures:array[i]];
        [_gifImages addObject:images];
    }
}

- (NSArray *)processingGIFPictures:(NSString *)name
{
    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"gif"];
    
    //获取Gif图的原数据
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifImageUrl, NULL);
    
    //获取Gif图有多少帧
    
    size_t gifcount = CGImageSourceGetCount(gifSource);
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < gifcount; i++) {
        
        //由数据源gifSource生成一张CGImageRef类型的图片
        
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        
        [images addObject:image];
        
        CGImageRelease(imageRef);
        
    }
    
    //得到图片数组
    return images;
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
    NSArray *images = _gifImages[indexPath.row];
    
    cell.titleStr.text = dic[@"title"];
    cell.imageView.animationDuration = 2;
    cell.imageView.image = images.firstObject;
    cell.imageView.animationImages = images;

    if (!cell.imageView.isAnimating) {
        [cell.imageView startAnimating];
    }
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemCount = 2;
    return CGSizeMake((Main_Screen_Width - 30)/itemCount, (Main_Screen_Width - 30)/itemCount + 120);
}

//距离collectionview的上下左右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20,10,20,10);
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
