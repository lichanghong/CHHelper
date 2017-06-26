//
//  CHRootViewController.m
//  CHFirim
//
//  Created by lichanghong on 6/22/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHRootViewController.h"
#import "CHHomeCollectionViewController.h"
#import "CHVCManager.h"

@interface CHRootViewController ()


@end

@implementation CHRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    self.backgroundImage = [UIImage imageNamed:@"Stars"];

    self.scaleContentView = NO;
    [CHVCManager defaultManager].storyBoard = self.storyboard;
    self.contentViewController = [CHVCManager defaultManager].firimVC;
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
  
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
