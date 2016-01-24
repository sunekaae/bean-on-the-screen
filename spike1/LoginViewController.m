//
//  LoginViewController.m
//  Bean on the Screen
//
//  Created by Sune Kaae on 17/01/16.
//  Copyright © 2016 Sune Kaae. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
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
    
    //[self setTextBoxesToHardcodedLogin];
}

-(void) setTextBoxesToHardcodedLogin
{
    txtEmail.text = @"sunekaae+tinybeans@gmail.com";
    txtPassword.text = @"FiveOpal25";
    
    /*
     txtEmail.text = @"sune151231@gmail.com";
     txtPassword.text = @"ABcdefgh";
     */
    
}

- (IBAction)handleLoginButtonClick:(id)sender {
    NSLog(@"login");
    
    NSLog(@"txtEmail: %@", txtEmail.text);
    NSLog(@"txtPassword: %@", txtPassword.text);
    
    lblStatus.text = @"processing login...";
    
    [self doHttpLogin];
    
    
    //   [self saveAuthToken:@"b43acdd1-3ea9-4d03-8289-63d50f31a2e3"];
    
    
}

-(bool) doHttpLogin
{
    // VIA: http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://tinybeans.com/api/1/authenticate"];
    NSLog(@"calling URL: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"d324d503-0127-4a85-a547-d9f2439ffeae", @"clientId",
                             txtEmail.text, @"username",
                             txtPassword.text, @"password",
                             nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"data handler?");
        NSLog(@"error: %@", error);
        NSLog(@"response: %@", response);
        
        if (nil!=error)
        {
            NSLog(@"Error making http request: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                lblStatus.text = @"error trying to login";
            });
        }
        
        NSError *newe = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &newe];
        
        if (!jsonData)
        {
            NSLog(@"Error parsing JSON: %@", newe);
            dispatch_async(dispatch_get_main_queue(), ^{
                lblStatus.text = @"error happened";
            });
        }
        else
        {
            NSLog(@"jsonData: %@", jsonData);
            NSString *authToken = [jsonData objectForKey:@"accessToken"];
            NSLog(@"authToken: %@", authToken);
            if (nil!=authToken)
            {
                [appDelegate saveAuthToken:authToken];
                // via: http://stackoverflow.com/questions/28302019/getting-a-this-application-is-modifying-the-autolayout-engine-error
                dispatch_async(dispatch_get_main_queue(), ^{
                    lblStatus.text = @"login successful";
                    [self getJournal];
                });
                [appDelegate switchToOptions];
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    lblStatus.text = @"login failed.";
                });
            }
        }
    }];
    
    [postDataTask resume];
    return true;
}

-(bool)getJournal
{
    NSLog(@"get journal called");
    
    NSURL *url = [NSURL URLWithString:@"https://tinybeans.com/api/1/followings?clientId=13bcd503-2137-9085-a437-d9f2ac9281a1"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    NSString *authTokenUrlPartial = [NSString stringWithFormat:@"access_token=%@", [appDelegate loadAuthToken]];
    
    [req setValue:authTokenUrlPartial forHTTPHeaderField:@"Cookie"];
    
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSLog(@"getting URL: %@", url);
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err)
    { NSLog(@"getJournal: error happened calling API"); }
    else
    { NSLog(@"getJournal: getting response calling API"); }
    
    NSError *e = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &e];
    
    if (!jsonData)
    { NSLog(@"Error parsing JSON: %@", e); }
    else
    {
        NSArray *entriesArray = [jsonData objectForKey:@"followings"];
        NSLog(@"entry item %@", entriesArray[0]);
        NSDictionary *journalDictionary = [entriesArray[0] objectForKey:@"journal"];
        NSLog(@"journalDictionary %@", journalDictionary);
        NSString *journalUrl = [journalDictionary objectForKey:@"URL"];
        NSLog(@"journalUrl %@", journalUrl);
        if (nil!=journalUrl)
        {
            [appDelegate saveJournalId:journalUrl];
            return true;
        }
    }
    return false;
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
