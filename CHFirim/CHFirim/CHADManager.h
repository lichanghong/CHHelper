//
//  CHADManager.h
//  CHFirim
//
//  Created by lichanghong on 6/18/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHADManager : NSObject

+ (void)getDomainSuccess:(void (^)(id content))success failure:(void (^)(id err))fail;




@end
