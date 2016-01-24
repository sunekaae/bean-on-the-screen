//
//  OptionsViewController.h
//  Bean on the Screen
//
//  Created by Sune Kaae on 17/01/16.
//  Copyright © 2016 Sune Kaae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController {
    __weak IBOutlet UIButton *logout;
    __weak IBOutlet UIButton *slideshow;
    __weak IBOutlet UILabel *lblStatus;
}

@end
