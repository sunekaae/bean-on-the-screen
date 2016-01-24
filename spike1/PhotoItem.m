//
//  PhotoItem.m
//  Bean on the Screen
//
//  Created by Sune Kaae on 06/01/16.
//  Copyright © 2016 Sune Kaae. All rights reserved.
//

#import "PhotoItem.h"


@implementation PhotoItem


-(NSString*) getDateStringFormattedYYMMDDWithDashes {
    NSString *yearMonthDayString = [NSString stringWithFormat:@"%@-%@-%@", self.year, self.month, self.day];
    return yearMonthDayString;
}

@end
