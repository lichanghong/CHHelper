//
//  CHShareView.h
//  SharePan
//
//  Created by lichanghong on 6/16/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CHShareViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UILabel     *title;


@end

@interface CHShareView : UIView

@property (nonatomic,strong)NSData   *imageData;
@property (nonatomic,strong)NSString *imageName;
@property (nonatomic,strong)NSString *contentURLStr;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *detail;

 

+ (instancetype)createShareView;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
