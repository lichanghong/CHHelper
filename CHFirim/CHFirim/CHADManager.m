//
//  CHADManager.m
//  CHFirim
//
//  Created by lichanghong on 6/18/17.
//  Copyright © 2017 lichanghong. All rights reserved.
//

#import "CHADManager.h"

@implementation CHADManager

+ (void)getDomainSuccess:(void (^)(id content))success failure:(void (^)(id err))fail
{
 
    NSString *urlstr = @"https://github.com/lichanghong/yun/blob/master/api.txt";
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            fail(error);
        }
        else
        {
            NSString *str = [NSString stringWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
            NSString *domain =  [[[str componentsSeparatedByString:@"AAAA|"] lastObject] componentsSeparatedByString:@"|AAAA"][0];
            if (domain) {
                NSURL *apiurl = [NSURL URLWithString:domain];
               NSURLSessionDataTask *mtask = [session dataTaskWithURL:apiurl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                   if (error) {
                       fail(error);
                   }
                   else
                   {
                       NSString *content =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                       NSDictionary*dic = [CHADManager dictionaryWithJsonString:content];
                       success(dic);
                   }
                }];
                [mtask resume];
            }
            else fail(@"domain=nil");
        }
    }];
    
    
    [task resume];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}




- (instancetype)init
{
    self = [super init];
    if (self) {
      
        
    }
    return self;
}

@end
