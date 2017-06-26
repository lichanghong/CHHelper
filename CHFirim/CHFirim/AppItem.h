//
//  AppItem.h
//  CHFirim
//
//  Created by lichanghong on 6/12/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppItem : NSObject
@property (nonatomic,assign)BOOL     isAndroid;
@property (nonatomic,strong)NSString *imageurl;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *bundleid;
@property (nonatomic,strong)NSString *latest;
@property (nonatomic,strong)NSString *Short;

@end
