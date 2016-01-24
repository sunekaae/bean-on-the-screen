//
//  OptionsViewController.m
//  Bean on the Screen
//
//  Created by Sune Kaae on 17/01/16.
//  Copyright © 2016 Sune Kaae. All rights reserved.
//

#import "OptionsViewController.h"
#import "AppDelegate.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController {
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initStuff];
}

-(void) initStuff {
    appDelegate = [[UIApplication sharedApplication] delegate];
    lblStatus.text = @"";
}


- (IBAction)handleTheLogoutButtonClick:(id)sender
{
    
}
- (IBAction)handleLogoutButtonClickTwo:(id)sender
{
    NSLog(@"logout");
    [appDelegate clearAuthToken];
    
    [self switchToLogin];
}

- (IBAction)handleSlideshowButtonClick:(id)sender
{
    NSLog(@"slideshow button click");
    dispatch_async(dispatch_get_main_queue(), ^{
        lblStatus.text = @"Loading slideshow images...";
    });

    [self switchToSlideShow];
}


-(void) switchToSlideShow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        lblStatus.text = @"login successful";
        [appDelegate saveSceneName:@"slideshow"];
        
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"slideshow"];
        
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        appDelegateTemp.window.rootViewController = navigation;
        
    });
}


-(void) switchToLogin
{
    [appDelegate saveSceneName:@"login"];
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    appDelegateTemp.window.rootViewController = navigation;
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

@end
