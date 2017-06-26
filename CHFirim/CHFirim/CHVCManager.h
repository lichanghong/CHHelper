//
//  CHVCManager.h
//  CHFirim
//
//  Created by lichanghong on 6/24/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHHomeCollectionViewController.h"

@interface CHVCManager : NSObject

@property (nonatomic,strong)UIStoryboard *storyBoard;
@property (nonatomic,strong)UINavigationController *firimVC;
@property (nonatomic,strong)UINavigationController *pgyerVC;
@property (nonatomic,strong)UINavigationController *dafuvipVC;
 

+ (instancetype)defaultManager;

@end
