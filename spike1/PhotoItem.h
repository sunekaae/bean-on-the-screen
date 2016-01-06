//
//  PhotoItem.h
//  Bean on the Screen
//
//  Created by Sune Kaae on 06/01/16.
//  Copyright © 2016 Sune Kaae. All rights reserved.
//

// via https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html
#import <Foundation/Foundation.h>

@interface PhotoItem : NSObject

@property NSString *imageUrl;
@property NSString *year;
@property NSString *month;
@property NSString *day;

@end
