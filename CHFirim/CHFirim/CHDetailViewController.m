//
//  CHDetailViewController.m
//  CHFirim
//
//  Created by lichanghong on 6/13/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHDetailViewController.h"
#import "CHHomeCollectionViewController.h"
#import <CHBaseUtil.h>
#import "SettingItem.h"
#import "TableViewCell.h"
#import <Alert.h>
#import "UMengManager.h"
#import "UMMobClick/MobClick.h"
#import "CHShareView.h"


@interface CHDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dsArr;
@property (nonatomic,strong)UIButton *aggrementButton;
@property (nonatomic,strong)CHShareView *shareView;



@end

@implementation CHDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.aggrementButton];
    
    NSString *contactUs = [[NSUserDefaults standardUserDefaults]objectForKey:@"contact_us"];
    _dsArr = [NSMutableArray array];
    [_dsArr addObject:[self baseItemWithTitle:@"推荐给好友" detail:@""]];
    [_dsArr addObject:[self baseItemWithTitle:@"招商合作" detail:@""]];
    [_dsArr addObject:[self baseItemWithTitle:@"关于我们" detail:@""]];
    [_dsArr addObject:[self baseItemWithTitle:@"问题反馈" detail:contactUs]];
    [_dsArr addObject:[self baseItemWithTitle:@"退出登录" detail:@""]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TableViewCell"];
    // Do any additional setup after loading the view.
}

- (CHShareView *)shareView
{
    if (!_shareView) {
        _shareView = [CHShareView createShareView];
    }
    return _shareView;
}

- (UIButton *)aggrementButton
{
    if (!_aggrementButton) {
        _aggrementButton = [[UIButton alloc]init];
        [_aggrementButton setTitle:@"使用协议|免责声明" forState:UIControlStateNormal];
        [_aggrementButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _aggrementButton.frame = CGRectMake(0, KScreenHeight-40, KScreenWidth, 40);
        _aggrementButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_aggrementButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aggrementButton;
}
- (void)handleAction:(id)sender
{
    Alert *alert = [[Alert alloc] initWithTitle:@"免责声明" message:[self aggrement]
                                       delegate:nil
                              cancelButtonTitle:(@"知道了")
                              otherButtonTitles:nil, nil];
    alert.alertStyle = AlertStyleDefault;
    [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
    }];
    [alert show];
}
- (SettingItem*)baseItemWithTitle:(NSString *)title detail:(NSString *)detail
{
    SettingItem *item = [[SettingItem alloc]init];
    item.title = title;
    item.detail = detail;
    return item;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIImageView *header =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        header.image = [UIImage imageNamed:@"default"];
        self.tableView.tableHeaderView =header;
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell;
    SettingItem *item = _dsArr[indexPath.row];
    
    if (indexPath.row==self.dsArr.count-1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
        if ([self logined]) {
            [cell setUserInteractionEnabled:YES];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.text = item.title;
        }
        else
        {
            [cell setUserInteractionEnabled:NO];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.text = @"去登录";
        }
    }
    else
    {
        static NSString *const identifier = @"dshflksdfsd";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = (id)[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            UILabel *sep = [[UILabel alloc]initWithFrame:CGRectMake(15, ViewH(cell)-1, KScreenWidth-15, 0.5)];
            sep.backgroundColor = [UIColor lightGrayColor];
            [cell addSubview:sep];
        }
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.detail;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==self.dsArr.count-1) {
        
        Alert *alert = [[Alert alloc] initWithTitle:@"提示" message:@"考虑好了吗？要退出登录？"
                                           delegate:nil
                                  cancelButtonTitle:(@"取消")
                                  otherButtonTitles:@"退出", nil];
        alert.alertStyle = AlertStyleDefault;
        [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutNotification" object:nil];
                
                [UMengManager logout];
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_dsArr.count-1 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        
        [alert show];
     
    }
    else if(indexPath.row==0 )
    {
        self.shareView.imageName = @"default";
        self.shareView.contentURLStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"app_url"];
        self.shareView.title = @"托管助手";
        self.shareView.detail = @"大家都在用手机版APP托管助手平台";

        [self.shareView showInView:[UIApplication sharedApplication].keyWindow];
    }
    else if(indexPath.row==1 ) //招商合作
    {
        Alert *alert = [[Alert alloc] initWithTitle:@"招商合作" message:[self cooperation]
                                           delegate:nil
                                  cancelButtonTitle:(@"知道了")
                                  otherButtonTitles:nil, nil];
        alert.alertStyle = AlertStyleDefault;
        [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
        }];
        [alert show];
    }
    else if(indexPath.row==2 ) //关于我们
    {
        Alert *alert = [[Alert alloc] initWithTitle:@"关于我们" message:[self aboutUS]
                                           delegate:nil
                                  cancelButtonTitle:(@"知道了")
                                  otherButtonTitles:nil, nil];
        alert.alertStyle = AlertStyleDefault;
        [alert setClickBlock:^(Alert *alertView, NSInteger buttonIndex) {
        }];
        [alert show];
    }
}

- (NSString *)cooperation
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"cooperation"];
}

- (NSString *)aboutUS
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"about_us"];
}
- (bool)logined
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"LOGINED_0"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:_dsArr.count-1 inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    
    [MobClick beginLogPageView:@"CHDetailViewController"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CHDetailViewController"];
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


- (NSString *)aggrement
{
    return @"免责声明:\n\
    1、一切移动客户端用户在下载并浏览托管助手手机托管助手软件时均被视为已经仔细阅读本条款并完全同意。\
    凡以任何方式登陆本托管助手，或直接、间接使用本托管助手资料者，均被视为自愿接受本网站相关声明和用户服务协议的约束。\n\
    2、托管助手手机托管助手转载的内容并不代表托管助手手机托管助手之意见及观点，也不意味着本网赞同其观点或证实其内容的真实性。\n\
    3、托管助手手机托管助手转载的文字、图片、音视频等资料均由本托管助手用户提供，其真实性、准确性和合法性由信息发布人负责。\
    托管助手手机托管助手不提供任何保证，并不承担任何法律责任。\n\
    4、托管助手手机托管助手所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本托管助手对此不承担责任。\n\
    5、托管助手手机托管助手不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，\
    对于该外部链接指向的不由托管助手手机托管助手实际控制的任何网页上的内容，托管助手手机托管助手不承担任何责任。\n\
    6、用户明确并同意其使用托管助手手机托管助手网络服务所存在的风险将完全由其本人承担；\
    因其使用托管助手手机托管助手网络服务而产生的一切后果也由其本人承担，托管助手手机托管助手对此不承担任何责任。\n\
    7、除托管助手手机托管助手注明之服务条款外，其它因不当使用本托管助手而导致的任何意外、疏忽、\
    合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，托管助手手机托管助手概不负责，亦不承担任何法律责任。\n\
    8、对于因不可抗力或因黑客攻击、通讯线路中断等托管助手手机托管助手不能控制的原因造成的网络服务中断或其他缺陷，\
    导致用户不能正常使用托管助手手机托管助手，托管助手手机托管助手不承担任何责任，但将尽力减少因此给用户造成的损失或影响。\n\
    9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。\n\
    10、如侵犯了您的任何权益,请及时与我们联系,我们会立刻处理。\n\
    11、本应用相关声明版权及其修改权、更新权和最终解释权均属托管助手手机托管助手所有。\n";
}
@end
