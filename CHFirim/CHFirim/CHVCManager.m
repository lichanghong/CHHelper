//
//  CHVCManager.m
//  CHFirim
//
//  Created by lichanghong on 6/24/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHVCManager.h"
#import "Header.h"

@implementation CHVCManager

+ (instancetype)defaultManager
{
    static CHVCManager *manager = nil;
    @synchronized (self) {
        if (!manager) {
            manager = [[CHVCManager alloc]init];
        }
    }
    return manager;
}

- (UINavigationController *)firimVC
{
    if (!_firimVC) {
        _firimVC = [self.storyBoard instantiateViewControllerWithIdentifier:@"navcontentViewController"];
        _firimVC.view.tag = type_firim;
    }
    return _firimVC;
}
- (UINavigationController *)pgyerVC
{
    if (!_pgyerVC) {
        _pgyerVC = [self.storyBoard instantiateViewControllerWithIdentifier:@"navcontentViewController"];
        _pgyerVC.view.tag = type_pgyer;
    }
    return _pgyerVC;
}
- (UINavigationController *)dafuvipVC
{
    if (!_dafuvipVC) {
        _dafuvipVC = [self.storyBoard instantiateViewControllerWithIdentifier:@"navcontentViewController"];
        _dafuvipVC.view.tag = type_dafuvip;
    }
    return _dafuvipVC;
}


@end
