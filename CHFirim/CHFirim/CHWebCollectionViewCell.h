//
//  CHWebCollectionViewCell.h
//  CHFirim
//
//  Created by lichanghong on 6/8/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <UIKit/UIKit.h>

 


@interface CHWebCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *typeImageView;

@property (nonatomic,strong)NSString *imageName;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *bundleid;
@property (nonatomic,strong)UILabel *latest;
@property (nonatomic,strong)UILabel *Short;
@property (nonatomic,strong)UIButton *shareButton;

 

@end
