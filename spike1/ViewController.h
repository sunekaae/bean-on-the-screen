//
//  ViewController.h
//  spike1
//
//  Created by Sune Kaae on 29/12/15.
//  Copyright © 2015 Sune Kaae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *login;
    __weak IBOutlet UIButton *logout;
    __weak IBOutlet UIButton *slideshow;
    
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtPassword;
    __weak IBOutlet UILabel *lblStatus;
}


@end

