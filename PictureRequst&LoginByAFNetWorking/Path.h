
//
//  Path.h
//  PictureRequst&LoginByAFNetWorking
//
//  Created by G.Z on 16/5/21.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#ifndef Path_h
#define Path_h

//服务器接口
#define SERVERPATH @"http://10.0.8.8/sns"
//登录接口
#define LOGINPATH (SERVERPATH@"/my/login.php")
//上传图片到指定分组
#define UPLOADPATH (SERVERPATH@"/my/upload_photo.php")
//下载相册名称
#define ALBUMPATH (SERVERPATH@"/my/album_list.php")

#endif /* Path_h */
