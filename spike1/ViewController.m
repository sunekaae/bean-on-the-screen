//
//  ViewController.m
//  spike1
//
//  Created by Sune Kaae on 29/12/15.
//  Copyright © 2015 Sune Kaae. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "PhotoItem.h"

@interface ViewController ()

@end

@implementation ViewController
NSMutableArray *arrayOfPhotoItems;
AppDelegate *appDelegate;
NSTimer *timer;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStuff];
    

    if ([appDelegate authenticatedUser]) {
        // nothing.
    }
    
    // via: http://stackoverflow.com/questions/11637709/get-the-current-displaying-uiviewcontroller-on-the-screen-in-appdelegate-m
    UIViewController *vc = [[appDelegate window] rootViewController];
    NSLog(@"vc title: %@", [vc title]);
    NSLog(@"string a : %@", NSStringFromClass([self class]));
    NSLog(@"string b : %@", NSStringFromClass([vc class]));
    
    UIView *view = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    NSLog(@"view description: %@", [view description]);
    NSLog(@"string c : %@", NSStringFromClass([view class]));
    
    NSLog(@"scenename: %@", [self loadSceneName]);
    
    if ([[self loadSceneName] isEqual:@"slideshow"])
    {
        [self parseJson];
        //    [self printImageUrls];
        
        // http://stackoverflow.com/questions/7700352/repeating-a-method-every-few-seconds-in-objective-c
        
        [self scheduleTimer];
        //        [self tick];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelTimer];
}

-(void)scheduleTimer
{
    NSLog(@"starting timer.");
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];
}

-(void) initStuff {
    appDelegate = [[UIApplication sharedApplication] delegate];
    arrayOfPhotoItems = [[NSMutableArray alloc] init];
    
    lblStatus.text = @"";
    
    [self setTextBoxesToHardcodedLogin];
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


-(void) printImageUrls {
    NSLog(@"count in array: %d", (int)arrayOfPhotoItems.count);
    NSLog(@"array %@", arrayOfPhotoItems);
}

-(void) parseJson {

    // get JSON from disk

//    NSString *jsonFromDisk = [self getJsonFromDisk];
//    NSData* data = [jsonFromDisk dataUsingEncoding:NSUTF8StringEncoding];
        
    
    // get JSON from web
    // example from http://stackoverflow.com/questions/10300353/nsurlrequest-post-data-and-read-the-posted-page

    // using entries endpoint
//    NSString *urlString = [NSString stringWithFormat:@"%@/entries?clientId=13bcd503-2137-9085-a437-d9f2ac9281a1&fetchSize=200&idsOnly=1&since=1451000041977", [self loadJournalId]];
    
    // using latest endpoint
    NSString *urlString = [NSString stringWithFormat:@"%@/latestUpdates/200?clientId=13bcd503-2137-9085-a437-d9f2ac9281a1", [self loadJournalId]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"calling URL: %@", url);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];

    NSString *authTokenUrlPartial = [NSString stringWithFormat:@"access_token=%@", [self loadAuthToken]];
    [req setValue:authTokenUrlPartial forHTTPHeaderField:@"Cookie"];
    [req setValue:[self loadAuthToken] forHTTPHeaderField:@"Authorization"];
    
    NSError *err = nil;
    NSHTTPURLResponse *res = nil;
    NSData *retData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    if (err)
    {
        NSLog(@"error happened calling API");
    }
    else
    {
        // handle response and returning data
//        NSData *jsonFeed = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://tinybeans.com/api/1/journals/425579/entries?clientId=13bcd503-2137-9085-a437-d9f2ac9281a1&fetchSize=200&idsOnly=1&since=1451000041977"]];
  //      NSLog(@"json: %@", jsonFeed);
    }
    NSData* data = retData;
    
    
//    NSData *jsonFeed = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://tinybeans.com/api/1/journals/425579/entries?clientId=13bcd503-2137-9085-a437-d9f2ac9281a1&fetchSize=200&idsOnly=1&since=1451000041977"]];
//    NSLog(@"json: %@", jsonFeed);
    
    [self fetchedData:data];
}

// http://www.raywenderlich.com/5492/working-with-json-in-ios-5
- (void)fetchedData:(NSData *)responseData {
    NSError *e = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: &e];
    
    if (!jsonData) {
        NSLog(@"Error parsing JSON: %@", e);
    }
    else {
        NSArray *entriesArray = [jsonData objectForKey:@"entries"];
//        NSLog(@"entry item %@", entriesArray[0]);
        for (NSDictionary* entryDictionary in entriesArray) {
//            NSLog(@"entry item %@", entryDictionary);
            NSDictionary *blobsDictionary = [entryDictionary objectForKey:@"blobs"];
//            NSLog(@"blob item %@", blobsDictionary);
            NSString *imageUrl = [blobsDictionary objectForKey:@"o"];
//            NSLog(@"imageUrl %@", imageUrl);
            PhotoItem *photoItem = [[PhotoItem alloc] init];
            [photoItem setImageUrl:imageUrl];
            [photoItem setYear: [entryDictionary objectForKey:@"year"]];
            NSNumber *monthNumber = [entryDictionary objectForKey:@"month"];
            NSString *monthString = [self getAsTwoDigitString:monthNumber];
            [photoItem setMonth: monthString];
            NSNumber *dayNumber = [entryDictionary objectForKey:@"day"];
            NSString *dayString = [self getAsTwoDigitString:dayNumber];
            [photoItem setDay: dayString];
            [arrayOfPhotoItems addObject:photoItem];
        }
    }
}

// take an integer as input, and return a string with a leading zero if needed to make a two digit string.
-(NSString*)getAsTwoDigitString:(NSNumber*) oneOrTwoDigitNumber {
    NSString *twoDigitString = [NSString stringWithFormat:@"%@", oneOrTwoDigitNumber];
    if ([twoDigitString length] == 1) { twoDigitString = [NSString stringWithFormat:@"0%@", twoDigitString]; }
    return twoDigitString;
}

-(bool)getJournal
{
    NSLog(@"get journal called");
    
    NSURL *url = [NSURL URLWithString:@"https://tinybeans.com/api/1/followings?clientId=13bcd503-2137-9085-a437-d9f2ac9281a1"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"GET"];
    NSString *authTokenUrlPartial = [NSString stringWithFormat:@"access_token=%@", [self loadAuthToken]];
    
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
            [self saveJournalId:journalUrl];
            return true;
        }
    }
    return false;
}

-(NSString*)getJsonFromDisk {
    // http://stackoverflow.com/questions/7064200/parse-json-contents-in-local-file
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example_response/latest_48_items" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if (!myJSON) {
        NSLog(@"File couldn't be read!");
        return nil;
    }
    return myJSON;
}


// http://stackoverflow.com/questions/160890/generating-random-numbers-in-objective-c
-(PhotoItem*)getRandomPhotoItem{
    NSLog(@"getRandomPhotoItem called");

    /*
     previously used hardcoded image items.
     NSArray *imageUrls = @[
     @"https://tinybeans.com/pv/e/25086002/bbf9ba00-cef9-478a-afee-dd7e0a72f46e-o.jpg",
     @"https://tinybeans.com/pv/e/24969285/60c86cea-623f-4bb2-b0b7-531c7a734737-o.jpg",
     @"https://tinybeans.com/pv/e/24974772/0684e447-bca4-4201-b414-2f6f3a55d174-o.jpg",
     @"https://tinybeans.com/pv/e/24974702/b0e28ae1-abf8-4a8d-86dc-fd9d8c0187b2-o.jpg",
     @"https://tinybeans.com/pv/e/24974763/8dfd618d-43a7-4c78-86a3-8659879a975c-o.jpg"];
     */
    
    NSInteger randomInt = arc4random_uniform((int)arrayOfPhotoItems.count);
    return arrayOfPhotoItems[randomInt];
}

-(void)tick {
    NSLog(@"tick...");
    
    PhotoItem* photoItem = [self getRandomPhotoItem];
    [self setPhotoItemOnScreen:photoItem];
}

-(void)setPhotoItemOnScreen:(PhotoItem*)photoItem {
    NSLog(@"About to set photoItem %@.", photoItem.day);
    [self setImageOnScreen:photoItem.imageUrl];
    [self setDateOnScreen:photoItem];
}

-(void)setImageOnScreen:(NSString*)imageUrl {
    NSLog(@"About to load image: %@ ", imageUrl);
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
}

-(void)setDateOnScreen:(PhotoItem*)photoItem {
    NSLog(@"About to set date. year: %@. month: %@. day: %@", photoItem.year, photoItem.month, photoItem.day);
    NSString *yearMonthDayString = [NSString stringWithFormat:@"%@-%@-%@", photoItem.year, photoItem.month, photoItem.day];
    [lblYearMonthDay setText:yearMonthDayString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleLoginButtonClick:(id)sender {
    NSLog(@"login");
    
    NSLog(@"txtEmail: %@", txtEmail.text);
    NSLog(@"txtPassword: %@", txtPassword.text);
    
    lblStatus.text = @"processing login...";
    
    [self doHttpLogin];
    
 
 //   [self saveAuthToken:@"b43acdd1-3ea9-4d03-8289-63d50f31a2e3"];

    
  }

-(void) changeToSlideshow
{
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"slideshow"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    appDelegateTemp.window.rootViewController = navigation;
}

-(bool) doHttpLogin
{
    // VIA: http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
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
                [self saveAuthToken:authToken];
                // via: http://stackoverflow.com/questions/28302019/getting-a-this-application-is-modifying-the-autolayout-engine-error
                dispatch_async(dispatch_get_main_queue(), ^{
                    lblStatus.text = @"login successful";
                    [self getJournal];
                });
                [self switchToOptions];
                
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

-(void) switchToSlideShow
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        lblStatus.text = @"login successful";
        
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"slideshow"];
        
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        appDelegateTemp.window.rootViewController = navigation;
        
        [self saveSceneName:@"slideshow"];
    });
}

-(void) switchToOptions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"options"];
        
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        appDelegateTemp.window.rootViewController = navigation;
        [self saveSceneName:@"options"];
    });
}

-(void) switchToLogin
{
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    appDelegateTemp.window.rootViewController = navigation;
    [self saveSceneName:@"login"];
}


-(void) saveAuthToken:(NSString*) authToken {
    // via: http://stackoverflow.com/questions/3074483/save-string-to-the-nsuserdefaults
    NSLog(@"saving auth token: %@", authToken);
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"tinyBeansAuthToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*) loadAuthToken {
    NSString *authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"tinyBeansAuthToken"];
    NSLog(@"loaded auth token: %@", authToken);
    return authToken;
}

-(void) clearAuthToken {
    NSLog(@"clearing auth token");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tinyBeansAuthToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) saveJournalId:(NSString*) journalId {
    NSLog(@"saving journal ID: %@", journalId);
    [[NSUserDefaults standardUserDefaults] setObject:journalId forKey:@"journalId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*) loadJournalId {
    NSString *journalId = [[NSUserDefaults standardUserDefaults] stringForKey:@"journalId"];
    NSLog(@"loaded journal ID: %@", journalId);
    return journalId;
}

-(void) clearJournalId {
    NSLog(@"clearing journal id");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"journalId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*) loadSceneName {
    NSString *sceneName = [[NSUserDefaults standardUserDefaults] stringForKey:@"sceneName"];
    NSLog(@"loadSceneName: %@", sceneName);
    return sceneName;
}

-(void) saveSceneName:(NSString*) sceneName {
    [[NSUserDefaults standardUserDefaults] setObject:sceneName forKey:@"sceneName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)handleTheLogoutButtonClick:(id)sender
{

}
- (IBAction)handleLogoutButtonClickTwo:(id)sender
{
    NSLog(@"logout");
    [self cancelTimer];
    [self clearAuthToken];
    
    [self switchToLogin];
}

- (IBAction)handleSlideshowButtonClick:(id)sender
{
    NSLog(@"slideshow button click");
    [self switchToSlideShow];
}

-(void) cancelTimer
{
    NSLog(@"cancel timer.");

    //BEFORE DOING SO CHECK THAT TIMER MUST NOT BE ALREADY INVALIDATED
    //Always nil your timer after invalidating so that
    //it does not cause crash due to duplicate invalidate
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}


- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    if ([[self loadSceneName] isEqual:@"slideshow"])
    {
        for(UIPress *press in presses) {
            if(press.type == UIPressTypeMenu)
            {
                [self switchToOptions];
                return;
            }
        }
    }
    [super pressesEnded:presses withEvent:event];
}

@end
