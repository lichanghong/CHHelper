//
//  UMengManager.h
//  CHFirim
//
//  Created by lichanghong on 6/14/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMengManager : NSObject

+ (instancetype)defaultManager;

+ (void)startUmeng;
+ (void)logout;



@end
