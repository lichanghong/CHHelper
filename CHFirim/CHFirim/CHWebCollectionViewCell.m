//
//  CHWebCollectionViewCell.m
//  CHFirim
//
//  Created by lichanghong on 6/8/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHWebCollectionViewCell.h"
#import <CHBaseUtil/CHBaseUtil.h>
#import "CHShareView.h"

@interface CHWebCollectionViewCell () 
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)CHShareView *shareView;
@end

@implementation CHWebCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _shareView = [CHShareView createShareView];
        _bgView = [[UIView alloc]initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc]init];
        _typeImageView = [[UIImageView alloc]init];
        _shareButton = [[UIButton alloc]init];
        _name      = [[UILabel alloc]init];
        _bundleid  = [[UILabel alloc]init];
        _latest    = [[UILabel alloc]init];
        _Short     = [[UILabel alloc]init];
        [self addSubview:_bgView];
        [self.bgView addSubview:_imageView];
        [self.bgView addSubview:_typeImageView];
        [self.bgView addSubview:_shareButton];
        [self.bgView addSubview:_name];
        [self.bgView addSubview:_bundleid];
        [self.bgView addSubview:_latest];
        [self.bgView addSubview:_Short];
        [self layoutSubViewFrame];
        [self.shareButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];

        _typeImageView.backgroundColor = [UIColor clearColor];
        _imageView.layer.cornerRadius = 10;
        [_imageView.layer setMasksToBounds:YES];
        UIFont *font =  [UIFont systemFontOfSize:14];
        _name.font = font;
//        _name.textAlignment = NSTextAlignmentCenter;
        _bundleid.font = [UIFont systemFontOfSize:10];
//        _bundleid.textAlignment = NSTextAlignmentCenter;
        _latest.font = [UIFont systemFontOfSize:10];
//        _latest.textAlignment = NSTextAlignmentCenter;
        _Short.font = [UIFont systemFontOfSize:10];
//        _Short.textAlignment = NSTextAlignmentCenter;
        
        UIColor *textColor = [UIColor blackColor];
        _name.textColor = textColor;
        _bundleid.textColor = textColor;
        _latest.textColor = textColor;
        _Short.textColor = textColor;
 
        //设置缓存
        self.layer.shouldRasterize = YES;
        //设置抗锯齿边缘
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)layoutSubViewFrame
{
    self.bgView.frame = self.bounds;
    CGFloat marginL = 8;
    self.imageView.frame = CGRectMake(18, 10, ViewW(self)*0.37, ViewW(self)*0.37);
    self.typeImageView.frame = CGRectMake(ViewW(self)-30, 0, 30, 30);
    self.name.frame      = CGRectMake(marginL+10, MaxY(_imageView)+4, ViewW(self)-10, 15);
    self.shareButton.frame = CGRectMake(ViewW(self)-60, MaxY(self.imageView)-25, 30*2, 15*2);

    self.Short.frame      = CGRectMake(marginL, MaxY(_name)+10, ViewW(self)-10, 15);
    self.bundleid.frame      = CGRectMake(marginL, MaxY(_Short)+4, ViewW(self)-10, 15);
    self.latest.frame      = CGRectMake(marginL, MaxY(_bundleid)+4, ViewW(self)-10, 15);
    
}

- (void)handleAction:(id)sender
{
    self.shareView.imageName = self.imageName;
    UIImage *image = self.imageView.image;
    NSData *imagedata =UIImagePNGRepresentation(image);
    if (imagedata.length>1024*32) {
        imagedata = UIImageJPEGRepresentation(image, 0.5);
    }
    self.shareView.imageData = imagedata;
    self.shareView.contentURLStr = [[self.Short.text componentsSeparatedByString:@":"]lastObject];
    self.shareView.title = self.name.text;
    self.shareView.detail = @"我的App在Firim手机托管平台上面可以下载";
    [self.shareView showInView:[UIApplication sharedApplication].keyWindow];
}

//toggleApitoken()





@end
