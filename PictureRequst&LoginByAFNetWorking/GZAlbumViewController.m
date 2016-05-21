//
//  GZAlbumViewController.m
//  PictureRequst&LoginByAFNetWorking
//
//  Created by G.Z on 16/5/21.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "GZAlbumViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Path.h"


@interface GZAlbumViewController ()
{
    NSMutableArray *dataSource;
    UITableView *table;
}

@end

@implementation GZAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization  可以自定制Xib
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
    dataSource = [[NSMutableArray alloc]init];
}

-(void)createUI
{
    NSArray * array = @[@"获取相册名称",@"上传头像"];
    for(int i = 0;i<2;i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 20 + 60 * i, self.view.frame.size.width, 40);
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        [self.view addSubview:btn];
    }
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 130) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}
-(void)pressBtn:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:ALBUMPATH parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * array = responseObject[@"albums"];
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:array];
            [table reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error.description);
        }];
    }
    else
    {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从本地获取图片",@"从相册获取图片", nil];
        [sheet showInView:self.view];
    }
}

//实现协议方法
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 3)
    {
        //<1>创建相机视图控制器对象
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        //<2>设置相机的功能样式(拍照、存储相片、获取相册)
        /*
         UIImagePickerControllerSourceTypePhotoLibrary,//相册
         UIImagePickerControllerSourceTypeCamera,//拍照
         UIImagePickerControllerSourceTypeSavedPhotosAlbum//存储
         */
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //<3>设置代理
        picker.delegate = self;
        //<4>跳转到相册界面
        [self presentViewController:picker animated:YES completion:nil];
    }
    
    //拍照获取
    else if (buttonIndex == 1){
        
        //<1>创建相机视图控制器对象
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        //<2>设置相机的功能样式(拍照、存储相片、获取相册)
        /*
         UIImagePickerControllerSourceTypePhotoLibrary,//相册
         UIImagePickerControllerSourceTypeCamera,//拍照
         UIImagePickerControllerSourceTypeSavedPhotosAlbum//存储
         */
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //<3>设置代理
        picker.delegate = self;
        //<4>跳转到相册界面
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //<1>获取图片信息
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //<2>图片的上传要上传二进制格式
    NSData * imageData = UIImagePNGRepresentation(image);
    
    //<3>开始数据请求
    NSDictionary * dic = @{@"m_auth":self.albumToken,@"albumid":@(0),@"pic_title":@"image.png"};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //上传二进制数据
    [manager POST:UPLOADPATH parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //将图片的二进制与接口进行拼接
        /*
         1、上传的图片的二进制格式
         2、上传的二进制对应的参数名称 
         3、上传的文件的名称（名称任意 但不能带有中文 最好添加后缀）
         4、格式是固定的 （image/png）
         */
        [formData appendPartWithFileData:imageData name:@"attach" fileName:@"hello.png" mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //数据请求并解析成功
        NSLog(@"%@",responseObject[@"message"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.description);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"string";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.textLabel.text = dataSource[indexPath.row][@"albumname"];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end