//
//  YMADManager.h
//  YMAD
//
//  Created by lichanghong on 6/20/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YMADManager : NSObject

+ (instancetype)defaultManager;
+ (void)startYMAD;
+ (void)showADInController:(UIViewController * )VC;
+ (void)loadYunSettings;

@end
