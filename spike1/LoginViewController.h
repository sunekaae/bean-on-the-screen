//
//  LoginViewController.h
//  Bean on the Screen
//
//  Created by Sune Kaae on 17/01/16.
//  Copyright © 2016 Sune Kaae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    __weak IBOutlet UIButton *login;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UILabel *lblStatus;
}

@end
