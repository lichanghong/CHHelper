//
//  CHShareView.m
//  SharePan
//
//  Created by lichanghong on 6/16/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHShareView.h"
#import <CHBaseUtil.h>
#import <CHShareUtil/CHQQShare.h>
#import <UIImageView+WebCache.h>
#import "CHWXShare.h"

@interface CHShareView ()<UIGestureRecognizerDelegate>

@end

@implementation CHShareViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat m = 20;
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(m, 0, ViewW(self)-2*m, ViewW(self)-2*m)];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,  MaxY(self.icon)+5, ViewW(self), 20)];
        self.title.font = [UIFont systemFontOfSize:12];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor blackColor];

        [self addSubview:self.icon];
        [self addSubview:self.title];
    }
    return self;
}



@end

static NSString *const CellIden = @"CHShareViewCell";
@interface CHShareView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableDictionary *itemDictionary;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end

@implementation CHShareView
{
    UILabel *titleLabel;
    UITapGestureRecognizer *tap;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        self.itemDictionary = [NSMutableDictionary dictionary];
        self.itemArray = [NSMutableArray array];
        [self.itemDictionary setObject:@"myhome_share_qq" forKey:@"QQ"];
        [self.itemDictionary setObject:@"myhome_share_qzone" forKey:@"QQ空间"];
        [self.itemDictionary setObject:@"myhome_share_weixin" forKey:@"微信"];
        [self.itemDictionary setObject:@"myhome_share_pengyou" forKey:@"朋友圈"];
        [self.itemArray addObject:@"QQ"];
        [self.itemArray addObject:@"QQ空间"];
        [self.itemArray addObject:@"微信"];
        [self.itemArray addObject:@"朋友圈"];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ViewY(self.collectionView)-40, KScreenWidth, 40)];
        titleLabel.text = @"分享到";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = RGB(239, 239, 239);
        
        [self addSubview:titleLabel];
        
        [self.collectionView registerClass:[CHShareViewCell class] forCellWithReuseIdentifier:CellIden];
  
        tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    
    }
    return self;
}

- (void)handleGesture:(id)sender
{
    [self dismiss];
}

- (void)dismiss
{
    [self endFrame];
    [UIView animateWithDuration:0.25 animations:^{
        [self beginFrame];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view
{
    [self beginFrame];
    [view addSubview:self];
    [view bringSubviewToFront:self];
    [UIView animateWithDuration:0.25 animations:^{
        [self endFrame];
    }];
}

- (void)beginFrame
{
    _collectionView.frame = CGRectMake(0,KScreenHeight, KScreenWidth, 150-40);
    titleLabel.frame = CGRectMake(0, KScreenHeight, KScreenWidth, 40);
    
}

- (void)endFrame
{
    _collectionView.frame = CGRectMake(0,KScreenHeight-100, KScreenWidth, 150-40);
    titleLabel.frame = CGRectMake(0, ViewY(self.collectionView)-40, KScreenWidth, 40);

    
}

+ (instancetype)createShareView
{
    CHShareView *shareView = [[CHShareView alloc]initWithFrame:KScreenRect];
    shareView.backgroundColor = ClearColor;
    return shareView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemDictionary.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIden forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSString *title = self.itemArray[indexPath.item];
    cell.icon.image = [UIImage imageNamed:[_itemDictionary objectForKey:title]];
    cell.title.text = title;
    return cell;
}

//@property (nonatomic,strong)NSString *imageName;
//@property (nonatomic,strong)NSString *contentURLStr;
//@property (nonatomic,strong)NSString *title;
//@property (nonatomic,strong)NSString *description;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==0) { //QQ
        if ([self.imageName hasPrefix:@"http"]) {
            [CHQQShare sendNewsMessageWithImageURL:self.imageName contentURL:self.contentURLStr title:self.title description:self.detail];
        }
        else
        {
            [CHQQShare sendNewsMessageWithLocalImage:self.imageName contentURL:self.contentURLStr title:self.title description:self.detail];
        }
    }
    else if(indexPath.item == 1)
    {
        if ([self.imageName hasPrefix:@"http"]) {
            [CHQQShare shareForQZoneTitle:self.title ImageDataArray:@[self.imageData]];
        }
        else
            [CHQQShare shareForQZoneTitle:self.title ImageDataArray:@[UIImagePNGRepresentation([UIImage imageNamed:self.imageName])]];
    }
    else if(indexPath.item == 2)
    {
        if ([self.imageName hasPrefix:@"http"]) {
            [CHWXShare sendNewsMessageWithImageData:self.imageData contentURL:self.contentURLStr title:self.title description:self.detail TimeLine:NO];
        }
        else
            [CHWXShare sendNewsMessageWithLocalImage:self.imageName contentURL:self.contentURLStr title:self.title description:self.detail TimeLine:NO];
    }
    else if(indexPath.item == 3)
    {
        if ([self.imageName hasPrefix:@"http"]) {
            
           [CHWXShare sendNewsMessageWithImageData:self.imageData contentURL:self.contentURLStr title:self.title description:self.detail TimeLine:YES];
        }
        else
            [CHWXShare sendNewsMessageWithLocalImage:self.imageName contentURL:self.contentURLStr title:self.title description:self.detail TimeLine:YES];
    }

    [self dismiss];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    if(touch.view == self)
        return YES;
    else
        return NO;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 10);

        CGFloat w = (KScreenWidth-20)/4.0;
        layout.itemSize = CGSizeMake(w, w);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,KScreenHeight-100, KScreenWidth, 150-40)
                                            collectionViewLayout:layout];
        
        _collectionView.delegate= self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
