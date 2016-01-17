//
//  AppDelegate.h
//  spike1
//
//  Created by Sune Kaae on 29/12/15.
//  Copyright © 2015 Sune Kaae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(BOOL)authenticatedUser;

-(void) saveAuthToken:(NSString*) authToken;
-(NSString*) loadAuthToken;
-(void) clearAuthToken;

-(NSString*) loadSceneName;
-(void) saveSceneName:(NSString*) sceneName;

-(void) saveJournalId:(NSString*) journalId;
-(NSString*) loadJournalId;
-(void) clearJournalId;

-(void) switchToOptions;

@end

