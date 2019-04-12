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
@property (nonatomic, strong) NSMutableArray *animationTimeArray;

@end

@implementation ViewController

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _type = DisplayAnimationTypeWith2D;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    UIImageView *beijing = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    beijing.image = [UIImage imageNamed:@"beijing-a"];
    [self.view addSubview:beijing];
}

- (void)configController
{
    if (_type == DisplayAnimationTypeWith2D) {
        _array = @[@{@"title":@"摇钱树",@"controller":@"YQSAnimationController",@"gif":@"yqs"},
                   @{@"title":@"唱片",@"controller":@"RecordAnimationController",@"gif":@"recordCD"},
                   @{@"title":@"闪烁",@"controller":@"FlashAnimationController",@"gif":@"flashing"},
                   @{@"title":@"扇形统计图",@"controller":@"SectorChartController",@"gif":@"sectorChart"}];
    }
    else
    {
        _array = @[@{@"title":@"飞机游戏",@"controller":@"AirPlaneGameController",@"gif":@"airPlaneGame"},
                   @{@"title":@"立方体",@"controller":@"_DViewLayoutController",@"gif":@"3DViewLayout"},
                   @{@"title":@"拖拽旋转视图",@"controller":@"DragAndRotateController",@"gif":@"dragAndRotateView"}];
    }
}

- (void)handleGifSrc
{
    _gifImages = [[NSMutableArray alloc] init];
    _animationTimeArray = [[NSMutableArray alloc] init];
    NSArray *array = [_array valueForKey:@"gif"];
    
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
    
    CGFloat animationTime = gifcount/15.f;
    
    [_animationTimeArray addObject:@(animationTime)];
    
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
    CGFloat animationTime = [_animationTimeArray[indexPath.row] floatValue];
    
    cell.titleStr.text = dic[@"title"];
    cell.imageView.animationDuration = animationTime;
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TopHeight - TabbarHeight) collectionViewLayout:flowLayout];
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
