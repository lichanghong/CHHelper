//
//  AppItem.m
//  CHFirim
//
//  Created by lichanghong on 6/12/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "AppItem.h"

@implementation AppItem


- (NSString *)description
{
    return [NSString stringWithFormat:@"imageurl =%@ | name=%@ | bundleid=%@ | latest=%@ | short=%@ | ",self.imageurl,self.name,self.bundleid,self.latest,self.Short];
}


@end
