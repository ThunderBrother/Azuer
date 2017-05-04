//
//  OTSImageBrowserVC.m
//  OneStoreLight
//
//  Created by HUI on 16/9/28.
//  Copyright © 2016年 Yihaodian. All rights reserved.
//

#import "OTSImageBrowserVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <PureLayout/PureLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "OTSPlaceHolderImageView.h"
#import "OTSCollectionViewCell.h"
#import "AZFuncDefine.h"
#import "NSArray+safe.h"
#import "UIColor+Utility.h"
#import "OTSConvertImageString.h"
#import "OTSTransition.h"
#import "UIView+Frame.h"

/*****************************BigImageItemCVC**************************************/
@interface BigImageItemCVC : OTSCollectionViewCell<UIScrollViewDelegate>

@property(nonatomic, strong) RACCommand *dismissPCCommand;

@property(nonatomic, strong) UIScrollView *bgScrollView;
@property(nonatomic, strong) OTSPlaceHolderImageView *itemImageView;
@property(nonatomic, assign) CGFloat lastScale;
@property(nonatomic, assign) BOOL flag;

- (void)updateWithDeafaultImageUrl:(NSString *)defaultUrl
               highQualityImageURL:(NSString *)highQualityImageURL;

@end

@implementation BigImageItemCVC

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lastScale = 1.f;
        self.flag = NO;
        
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        self.bgScrollView.showsHorizontalScrollIndicator = NO;
        self.bgScrollView.contentSize = self.contentView.bounds.size;
        self.bgScrollView.minimumZoomScale = 0.5;
        self.bgScrollView.maximumZoomScale = 10.0;
        self.bgScrollView.zoomScale = 1.0;
        self.bgScrollView.bouncesZoom = YES;
        self.bgScrollView.delegate = self;
        [self.contentView addSubview:self.bgScrollView];
        
        self.itemImageView = [[OTSPlaceHolderImageView alloc] initWithFrame:self.bgScrollView.bounds];
        
        [self.bgScrollView addSubview:self.itemImageView];
        [self.bgScrollView autoPinEdgesToSuperviewEdges];
        
        // 单击
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPC)];
        [self.bgScrollView addGestureRecognizer:singleTapGesture];
        // 双击
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self.bgScrollView addGestureRecognizer:doubleTapGesture];
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.bgScrollView.zoomScale = 1.f;
}

#pragma mark - 大图手势事件
- (void)dismissPC {
    [self.dismissPCCommand execute:nil];
}

//双击实现放大和缩小一倍
- (void)handleDoubleTapFrom {
    if (self.lastScale != 1 && self.lastScale != 2) {
        [self animationWithScale:1];
    } else {
        if (self.flag == YES) {
            [self animationWithScale:1];
            self.flag = NO;
        }
        else {
            [self animationWithScale:2];
            self.flag = YES;
        }
    }
}

- (void)animationWithScale:(CGFloat)scale {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScrollView.zoomScale = scale;
    } completion:^(BOOL finished) {
        self.lastScale = scale;
    }];
}

- (void)updateWithDeafaultImageUrl:(NSString *)defaultUrl
               highQualityImageURL:(NSString *)highQualityImageURL {
    self.itemImageView.transform = CGAffineTransformMakeScale(1, 1);
    WEAK_SELF;
    [[SDImageCache sharedImageCache] diskImageExistsWithKey:highQualityImageURL completion:^(BOOL isInCache) {
        STRONG_SELF;
        //如果高清图的缓存，就直接使用
        if (isInCache) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:highQualityImageURL];
            self.itemImageView.image = image;
            self.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        }//没有就先显示模糊的图片，等待高清图片下载
        else{
            //让重复添加的loading视图消失
            [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:defaultUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                STRONG_SELF;
                if (![defaultUrl isEqualToString:highQualityImageURL]) {
                    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:highQualityImageURL] placeholderImage:nil options:0 | SDWebImageDelayPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    }];
                }
                self.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
            }];
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.itemImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale > 1) {
        self.itemImageView.center = CGPointMake(scrollView.contentSize.width / 2, scrollView.contentSize.height / 2);
    } else {
        self.itemImageView.center = self.contentView.center;
    }
}

@end


/*****************************OTSImageBrowserVC**************************************/
@interface OTSImageBrowserVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *scanImageCV;
@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation OTSImageBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainView];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupMainView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scanImageCV];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.layer.cornerRadius = 11;
    effectView.layer.masksToBounds = YES;
    effectView.clipsToBounds = YES;
    effectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:effectView];
    [effectView.contentView addSubview:self.indexLabel];

    [effectView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [effectView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:35];
    [effectView autoSetDimensionsToSize:CGSizeMake(65, 22)];
    [self.indexLabel autoPinEdgesToSuperviewEdges];
    
    [self.scanImageCV autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.scanImageCV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.scanImageCV autoSetDimensionsToSize:CGSizeMake(UI_CURRENT_SCREEN_WIDTH, UI_CURRENT_SCREEN_HEIGHT)];
}

- (void)setupData {
    NSString *string = [NSString stringWithFormat:@"%zd of %zd", self.scrollIndex + 1, self.scanImageArray.count];
    self.indexLabel.text = string;
    if (self.scanImageArray.count > 0){// 有数据的时候就刷新
        [self.scanImageCV reloadData];
        [self.scanImageCV layoutIfNeeded];
        // 滚动指定index
        [self.scanImageCV selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.scrollIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    }
}

#pragma mark - Getter & Setter
- (UICollectionView *)scanImageCV {
    if (!_scanImageCV){
        // fv
        UICollectionViewFlowLayout *scanImageFV = [[UICollectionViewFlowLayout alloc] init];
        scanImageFV.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        scanImageFV.minimumInteritemSpacing = 0.f;
        scanImageFV.minimumLineSpacing = 0.0;
        // cv
        _scanImageCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:scanImageFV];
        _scanImageCV.translatesAutoresizingMaskIntoConstraints = NO;
        _scanImageCV.alwaysBounceHorizontal = YES;
        _scanImageCV.backgroundColor = [UIColor clearColor];
        [_scanImageCV setShowsHorizontalScrollIndicator:NO];
        _scanImageCV.delegate = self;
        _scanImageCV.dataSource = self;
        _scanImageCV.pagingEnabled = YES;
        [_scanImageCV registerClass:[BigImageItemCVC class] forCellWithReuseIdentifier:NSStringFromClass([BigImageItemCVC class])];
    }
    return _scanImageCV;
}

- (UILabel *)indexLabel {
    if (_indexLabel == nil) {
        _indexLabel = [UILabel newAutoLayoutView];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor colorWithRGB:0x333333];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        ;
    }
    return _indexLabel;
    
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(UI_CURRENT_SCREEN_WIDTH, UI_CURRENT_SCREEN_HEIGHT);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.scanImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BigImageItemCVC *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BigImageItemCVC class]) forIndexPath:indexPath];
    WEAK_SELF;
    cell.dismissPCCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        STRONG_SELF;
        [self dismissViewControllerAnimated:YES completion:nil];
        return [RACSignal empty];
    }];
    
    NSString *string = [self.scanImageArray safeObjectAtIndex:indexPath.item];
    CGFloat cellWidth = UI_CURRENT_SCREEN_WIDTH;
    NSString *picUrl = [OTSConvertImageString convertPicURL:string viewWidth:cellWidth viewHeight:cellWidth];
    [cell updateWithDeafaultImageUrl:picUrl highQualityImageURL:picUrl];
    return cell;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/UI_CURRENT_SCREEN_WIDTH;
    self.scrollIndex = index;
    NSString *string = [NSString stringWithFormat:@"%@ of %@",@(index + 1),@(self.scanImageArray.count)];
    self.indexLabel.text = string;
}

#pragma mark - OTSTransitionAnimationDataSource
- (NSArray<UIView*>*)viewsForAssociatedTransitionAnimation {
    return @[self.scanImageCV, self.indexLabel.superview.superview];
}

- (NSArray<NSValue*>*)fixedFramesForAssociatedTransitionAnimation {
    [self.view layoutIfNeeded];
    return @[[NSValue valueWithCGRect:CGRectMake(0, (self.view.height - self.view.width) * .5, self.view.width, self.view.width)],
             [NSValue valueWithCGRect:self.indexLabel.superview.superview.frame]];
}

- (NSDictionary*)paramBeforeTransitionBegin {
    return @{@"index": @(self.scrollIndex)};
}

@end
