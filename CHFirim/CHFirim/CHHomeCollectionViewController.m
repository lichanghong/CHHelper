//
//  CHHomeCollectionViewController.m
//  CHFirim
//
//  Created by lichanghong on 6/8/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHHomeCollectionViewController.h"
#import "CHBaseUtil/CHBaseUtil.h"
#import "CHWebCollectionViewCell.h"
#import "HeaderWebView.h"
#import "AppItem.h"
#import <UIImageView+WebCache.h>
#import "UMMobClick/MobClick.h"
#import "QRCodeReaderViewController.h"
#import <Alert.h>
#import "CHADManager.h"
#import "YMADManager.h"


@interface CHHomeCollectionViewController ()<QRCodeReaderDelegate>
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@property (nonatomic,strong)UIRefreshControl *refreshControl;
@property (nonatomic,strong)HeaderWebView *headerWebView;
@property (nonatomic,strong)QRCodeReaderViewController *qrVC;

@end

@implementation CHHomeCollectionViewController
{
    NSString *_login_user_name_key;
}

static NSString * const reuseIdentifier = @"CHWebCollectionViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
      
    _dataSourceArr = [NSMutableArray array];
    

    _login_user_name_key = [NSString stringWithFormat:@"login_user_name_%ld",self.navigationController.view.tag];
    NSString *postName = [NSString stringWithFormat:@"didFinishNavigation_%lu",self.navigationController.view.tag];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishNavigation:) name:postName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout) name:@"logoutNotification" object:nil];
    
    // Uncomment the following line to preserve selection between presentations
    _layout =(id) self.collectionViewLayout;
    // Register cell classes
    [self.collectionView registerClass:[CHWebCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.layout.collectionView setContentInset:UIEdgeInsetsMake(15, 15, 50, 15)];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.center = self.collectionView.center;
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    
    
    self.headerWebView = [[HeaderWebView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.headerWebView.ctype = self.navigationController.view.tag;
    
    [self.view addSubview:self.headerWebView];
//    self.headerWebView.refresh = NO;
    
    // Create the reader object
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    _qrVC = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    
    // Set the presentation style
    _qrVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    _qrVC.delegate = self;
    // Or use blocks
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        
        [_qrVC dismissViewControllerAnimated:YES completion:^{
            Alert *alert = [[Alert alloc] initWithTitle:@"扫码结果" message:resultAsString
                                               delegate:nil
                                      cancelButtonTitle:(@"取消")
                                      otherButtonTitles:(@"复制"),@"前往", nil];
            alert.alertStyle = AlertStyleDefault;
            [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    UIPasteboard *board = [UIPasteboard generalPasteboard];
                    [board  setString:resultAsString];
                    [self.view makeToast:@"已复制成功" duration:2 position:CSToastPositionCenter];
                }
                else if(buttonIndex == 1)
                {
                    NSURL *url = [NSURL URLWithString:resultAsString];
                    if ([[UIApplication sharedApplication]canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    else
                    {
                        UIPasteboard *board = [UIPasteboard generalPasteboard];
                        [board  setString:resultAsString];

                        [self.view makeToast:@"打开网址失败,已复制" duration:2 position:CSToastPositionCenter];
                    }
                }
                else
                {
                    
                }
            }];
            
            [alert show];
        }];
    }];
    self.collectionView.backgroundColor = [UIColor colorForHex:@"#E6E5E6"];
    // Do any additionasl setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [YMADManager showADInController:self];
    NSLog(@"type = %lu",self.navigationController.view.tag);
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)refreshData
{
    self.headerWebView.refresh = YES;
}

- (void)navTitleWithCtype:(type_class)type
{
    if (type==type_firim) {
        self.navigationItem.title = @"firim应用管理";
    }
    else if (type==type_pgyer) {
        self.navigationItem.title = @"蒲公英应用管理";
    }
    else if (type==type_dafuvip) {
        self.navigationItem.title = @"大福应用管理";
    }
}

- (void)didFinishNavigation:(NSNotification *)sender
{
    [self.refreshControl endRefreshing];
    [_dataSourceArr removeAllObjects];
    NSDictionary *dic = (id)sender.object;

    type_class ctype =  [[dic objectForKey:@"ctype"] intValue];
    [self navTitleWithCtype:ctype];
    
    NSString *html   =  [dic objectForKey:@"content"];
    _login_user_name_key = [NSString stringWithFormat:@"login_user_name_%ld",ctype];
    if (ctype == type_firim) {
        NSString *username = [[[html componentsSeparatedByString:@"<div class=\"email\"><span ng-bind=\"currentUser.email\" class=\"ng-binding\">"] lastObject]componentsSeparatedByString:@"<"][0];
        [[NSUserDefaults standardUserDefaults]setObject:username forKey:_login_user_name_key];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
    }
    else if (ctype == type_pgyer)
    {
        NSString *username = [[[html componentsSeparatedByString:@"fa fa-user hide\"></i> <span style=\"margin-left: 5px\">"] lastObject]componentsSeparatedByString:@"<"][0];
        [[NSUserDefaults standardUserDefaults]setObject:username forKey:_login_user_name_key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else if (ctype == type_dafuvip)
    {
        NSString *username = [[[[[[html componentsSeparatedByString:@"<div class=\"cursor\" data-toggle=\"dropdown\">\n"] lastObject] stringByReplacingOccurrencesOfString:@" " withString:@""]componentsSeparatedByString:@"<span>"][1] componentsSeparatedByString:@"<"]firstObject];
        [[NSUserDefaults standardUserDefaults]setObject:username forKey:_login_user_name_key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    self.headerWebView.frame = CGRectMake(0, 0, KScreenWidth, 64);
    [self.layout setItemSize:CGSizeMake(KScreenWidth/2.0-20, KScreenHeight/3.4-10)];
    [self parseAppInfo:html ctype:ctype];
    [self.collectionView reloadData];
   

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CHHomeCollectionViewController"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CHHomeCollectionViewController"];
}
- (void)logout
{
    [_dataSourceArr removeAllObjects];
    [self.headerWebView logoutToClear];
    self.headerWebView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight);
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:_login_user_name_key];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (IBAction)handleScan:(id)sender {
    [self presentViewController:_qrVC animated:YES completion:^{
        
    }];
}

 


- (void)parseAppInfo:(NSString *)html ctype:(type_class)ctype
{
    if (ctype == type_firim)
    {
        NSString *matchType = @"type-icon ";
        NSMutableArray *types = [NSMutableArray arrayWithArray:[html componentsSeparatedByString:matchType]];
        [types removeObjectAtIndex:0];//移除第一个无用app
        
        for (NSString *type in types)
        {
            NSString *apptype = [type componentsSeparatedByString:@"\""][0];
            NSString *icon = [[[type componentsSeparatedByString:@"<img class=\"icon ng-isolate-scope\" app-icon=\"app.icon_url\" width=\"100\" height=\"100\" src=\""] lastObject] componentsSeparatedByString:@"\""][0];
            NSString *name = [[[type componentsSeparatedByString:@"::app.name\" class=\"ng-binding\">"] lastObject] componentsSeparatedByString:@"</"][0];
            
            NSString *shortname = [[[type componentsSeparatedByString:@"\" class=\"ng-binding\">http://fir.im/"]lastObject] componentsSeparatedByString:@"<"][0];
            NSString *Short = [NSString stringWithFormat:@"http://fir.im/%@",shortname];
            
            NSString *BundleIDcom = [[html componentsSeparatedByString:@"BundleID:</td><td><span ng-bind=\"::app.bundle_id\" title=\""]lastObject];
            NSString *bundleid = [[BundleIDcom componentsSeparatedByString:@"\""]objectAtIndex:0];
            
            NSString *latestcom = [[html componentsSeparatedByString:@"最新版本:</td><td><span class=\"ng-binding\">"] lastObject];
            NSString *latest=[[latestcom componentsSeparatedByString:@"<"]firstObject];
            AppItem *item = [[AppItem alloc]init];
            item.imageurl = icon;
            item.name     = name;
            item.Short    = Short;
            item.latest   = latest;
            item.bundleid = bundleid;
            item.isAndroid= [apptype isEqualToString:@"icon-android"]?YES:NO;
            [_dataSourceArr addObject:item];
            
        }
        
    }
    else if (ctype == type_pgyer)
    {
        NSString *matchType = @"identifier=\"";
        NSMutableArray *types = [NSMutableArray arrayWithArray:[html componentsSeparatedByString:matchType]];
        [types removeObjectAtIndex:0];//移除第一个无用app
        
        for (NSString *type in types)
        {
            NSString *bundleid = [[type componentsSeparatedByString:@"\""]objectAtIndex:0];
            NSString *icon = [[type componentsSeparatedByString:@"<img src=\""][1] componentsSeparatedByString:@"\""][0];
            NSString *name = [[[type componentsSeparatedByString:@"class=\"appTitle\">"] lastObject] componentsSeparatedByString:@"</"][0];
            NSString *shortname = [[type componentsSeparatedByString:@"<a href=\"/manager/dashboard/app/"][1] componentsSeparatedByString:@"\""][0];
            NSString *Short = [NSString stringWithFormat:@"https://www.pgyer.com/manager/dashboard/app/%@",shortname];
            NSString *apptype = [[type componentsSeparatedByString:@"</i> <span class=\"middle\">"][1] componentsSeparatedByString:@"<"][0];
            
            NSString *latest = [[html componentsSeparatedByString:@"class=\"fa fa-code-fork\"></i>\n                                    "][1] componentsSeparatedByString:@"\n"][0];
            
            AppItem *item = [[AppItem alloc]init];
            item.imageurl = icon;
            item.name     = name;
            item.Short    = Short;
            item.latest   = latest;
            item.bundleid = bundleid;
            item.isAndroid= [apptype isEqualToString:@"iOS"]?NO:YES;
            [_dataSourceArr addObject:item];
            
        }
        
    }
    else if (ctype == type_dafuvip)
    {
        NSString *matchType = @" <i class=\"fa fa-apple\" title=\"";
        NSMutableArray *types = [NSMutableArray arrayWithArray:[html componentsSeparatedByString:matchType]];
        [types removeObjectAtIndex:0];//移除第一个无用app
        
        for (NSString *type in types)
        {
            NSString *apptype = [[type componentsSeparatedByString:@"\""]objectAtIndex:0];
            NSArray *shortAndName = [type componentsSeparatedByString:@"\" target=\"_blank\" title=\""];
            NSString *Shortname = [[[shortAndName firstObject] componentsSeparatedByString:@"/"]lastObject];
            NSString *Short = [NSString stringWithFormat:@"http://dafuvip.com/%@",Shortname];
            NSString *name = [[shortAndName[1] componentsSeparatedByString:@"\""]firstObject];

            NSString *iconname = [[shortAndName[1] componentsSeparatedByString:@"<img src=\"/"][1] componentsSeparatedByString:@"\""][0];
            NSString *icon = [NSString stringWithFormat:@"http://dafuvip.com/%@",iconname];
            
            //下载次数
            NSString *bundleid = [[[[[type componentsSeparatedByString:@"p></td>\n"][1] stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"<tdclass=\"clickable\">"][1]componentsSeparatedByString:@"<"] firstObject];
//

            //更新时间
            NSString *latestTime = [[[[[html componentsSeparatedByString:@"</a></td>"][1] stringByReplacingOccurrencesOfString:@" " withString:@""]componentsSeparatedByString:@"\n<tdclass=\"center\">"][1]componentsSeparatedByString:@"<"]firstObject] ;
            NSString *md = [latestTime substringWithRange:NSMakeRange(5, 5)];
            NSString *hms = [latestTime substringWithRange:NSMakeRange(10, 5)];
            NSString *latest = [NSString stringWithFormat:@"%@ %@",md,hms];
            AppItem *item = [[AppItem alloc]init];
            item.imageurl = icon;
            item.name     = name;
            item.Short    = Short;
            item.latest   = latest;
            item.bundleid = bundleid;
            item.isAndroid= [apptype isEqualToString:@"IOS"]?NO:YES;
            [_dataSourceArr addObject:item];
            
        }
        
    }
    
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHWebCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    AppItem *item = [self.dataSourceArr objectAtIndex:indexPath.item];
    if ([item.imageurl hasPrefix:@"http"]) {
        cell.imageName = item.imageurl;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.imageurl]];
    }
    else if([item.imageurl isEqualToString:@"qrcode"])
    {
        cell.imageName = @"qrcode";
        UIImage *image =  [UIImage imageNamed:@"qrcode"];
        cell.imageView.image =image;
    }
    else
    {
        cell.imageName = @"ndef";
        UIImage *image =  [UIImage imageNamed:@"ndef"];
        cell.imageView.image =image;
    }
    
    if (item.isAndroid) {
        cell.typeImageView.image = [UIImage imageNamed:@"android"];
    }
    else cell.typeImageView.image = [UIImage imageNamed:@"ios"];
    cell.typeImageView.backgroundColor = [UIColor clearColor];
    
    cell.name.text = item.name;
    
    NSMutableAttributedString *attshort = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"短连接:%@",item.Short]];
    //添加文字颜色
    [attshort addAttribute:NSForegroundColorAttributeName value:[UIColor colorForHex:@"9b9b9b"] range:NSMakeRange(0, 4)];
    cell.Short.attributedText      = attshort;

    if (self.headerWebView.ctype == type_dafuvip) {
        NSMutableAttributedString *bundleatt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"下载次数:%@",item.bundleid]];
        //添加文字颜色
        [bundleatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorForHex:@"9b9b9b"] range:NSMakeRange(0, 5)];
        cell.bundleid.attributedText   = bundleatt;
        
        NSMutableAttributedString *latestatt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"更新时间:%@",item.latest]];
        //添加文字颜色
        [latestatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorForHex:@"9b9b9b"] range:NSMakeRange(0, 5)];
        
        cell.latest.attributedText     = latestatt;
    }
    else
    {
        NSMutableAttributedString *bundleatt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"包名:%@",item.bundleid]];
        //添加文字颜色
        [bundleatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorForHex:@"9b9b9b"] range:NSMakeRange(0, 3)];
        cell.bundleid.attributedText   = bundleatt;
        
        NSMutableAttributedString *latestatt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"版本号:%@",item.latest]];
        //添加文字颜色
        [latestatt addAttribute:NSForegroundColorAttributeName value:[UIColor colorForHex:@"9b9b9b"] range:NSMakeRange(0, 4)];
        
        cell.latest.attributedText     = latestatt;
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:_login_user_name_key];
    AppItem *item = [self.dataSourceArr objectAtIndex:indexPath.item];
    NSDictionary *dict = @{@"username" : username, @"iteminfo" : item.description};
    [MobClick event:@"click_install_App" attributes:dict];
    NSURL *url = [NSURL URLWithString:item.Short];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }
    else
    {
        Alert *alert = [[Alert alloc] initWithTitle:@"提示" message:@"您的应用可能是无效链接，在iOS设备上打不开，如有疑问可以联系我们"                                               delegate:nil
                                  cancelButtonTitle:(@"知道了")
                                  otherButtonTitles:nil, nil];
        alert.alertStyle = AlertStyleDefault;
        [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
        }];
        [alert show];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
