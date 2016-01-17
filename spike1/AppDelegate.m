//
//  AppDelegate.m
//  spike1
//
//  Created by Sune Kaae on 29/12/15.
//  Copyright © 2015 Sune Kaae. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate {
    NSMutableArray *arrayOfPhotoItems;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    application.idleTimerDisabled = true;
    
    // via: http://stackoverflow.com/questions/19962276/best-practices-for-storyboard-login-screen-handling-clearing-of-data-upon-logou
    if (![self authenticatedUser])
    {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    else
    {
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"slideshow"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];

        self.window.rootViewController = navigation;
    }
    return YES;
}

-(BOOL)authenticatedUser {
    NSString *authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"tinyBeansAuthToken"];
    NSLog(@"auth token: %@", authToken);
    if (nil==authToken) {
        return false;
    }
    else {
        return true;
    }
}

-(void) switchToOptions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self saveSceneName:@"options"];
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"options"];
        
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        appDelegateTemp.window.rootViewController = navigation;
    });
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


-(NSString*) loadSceneName {
    NSString *sceneName = [[NSUserDefaults standardUserDefaults] stringForKey:@"sceneName"];
    NSLog(@"loadSceneName: %@", sceneName);
    return sceneName;
}

-(void) saveSceneName:(NSString*) sceneName {
    [[NSUserDefaults standardUserDefaults] setObject:sceneName forKey:@"sceneName"];
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

-(NSMutableArray*) getArrayOfPhotoItems {
//    NSMutableArray *arrayOfPhotoItems = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrayOfPhotoItems"];
    NSLog(@"arrayOfPhotoItems: %@", arrayOfPhotoItems);
    if (nil == arrayOfPhotoItems) {
        NSLog(@"arrayOfPhotoItems is nil. doing init");
        arrayOfPhotoItems = [[NSMutableArray alloc] init];
//        [[NSUserDefaults standardUserDefaults] setObject:arrayOfPhotoItems forKey:@"arrayOfPhotoItems"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return arrayOfPhotoItems;
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
