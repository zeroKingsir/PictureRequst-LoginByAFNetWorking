//
//  GZAlbumViewController.h
//  PictureRequst&LoginByAFNetWorking
//
//  Created by G.Z on 16/5/21.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZAlbumViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//接受token值
@property (nonatomic,copy)NSString *albumToken;

@end
