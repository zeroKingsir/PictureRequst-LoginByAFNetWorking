//
//  ViewController.h
//  PictureRequst&LoginByAFNetWorking
//
//  Created by G.Z on 16/5/21.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *pswTextField;
- (IBAction)cancelBtn:(id)sender;
- (IBAction)loginBtn:(id)sender;


@end

