//
//  ViewController.m
//  PictureRequst&LoginByAFNetWorking
//
//  Created by G.Z on 16/5/21.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "ViewController.h"
#import "Path.h"
#import "AFHTTPRequestOperationManager.h"
#import "GZAlbumViewController.h"

@interface ViewController ()<UIAlertViewDelegate>
{
    GZAlbumViewController *album;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    album = [[GZAlbumViewController alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtn:(id)sender
{
    self.nameTextField.text = @"";
    self.pswTextField.text = @"";
}

- (IBAction)loginBtn:(id)sender
{
    //<1>创建请求操作管理者对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //<2>设置接收的数据类型（json、xml）
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //<3>拼接请求体
    //AFNetWorking中请求体是使用字典存放的
    //字典的键是参数名称 字典的值就是参数值（从键盘输入的内容）
    NSDictionary * dic = @{@"username":self.nameTextField.text,@"password":self.pswTextField.text};
    //<4>请求数据并解析
    [manager POST:LOGINPATH parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString * code = responseObject[@"code"];
         NSString * message = responseObject[@"message"];
         
         //---------关键-------------
         NSString * token = responseObject[@"m_auth"];
         album.albumToken = token;
         //token用户的唯一标识
         
         
         if([code isEqualToString:@"login_success"])
         {
             UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
             [alertView show];
             alertView.tag = 100;
         }
         else
         {
             UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error.description);
     }];
}
#pragma mark UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
        if(buttonIndex == 0)
        {
            //跳转到相册界面
            [self presentViewController:album animated:YES completion:nil];
        }
    }
    else
    {
        self.nameTextField.text = @"";
        self.pswTextField.text = @"";
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end

