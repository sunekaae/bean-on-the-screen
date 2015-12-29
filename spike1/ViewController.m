//
//  ViewController.m
//  spike1
//
//  Created by Sune Kaae on 29/12/15.
//  Copyright © 2015 Sune Kaae. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
NSMutableArray *arrayOfImageUrls;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStuff];

    [self parseJson];
    [self printImageUrls];
    
    // http://stackoverflow.com/questions/7700352/repeating-a-method-every-few-seconds-in-objective-c

    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [self tick];
}

-(void) initStuff {
    arrayOfImageUrls = [[NSMutableArray alloc] init];
}

-(void) printImageUrls {
    NSLog(@"count in array: %d", (int)arrayOfImageUrls.count);
    NSLog(@"array %@", arrayOfImageUrls);
}

-(void) parseJson {
    NSString *jsonFromDisk = [self getJsonFromDisk];
    NSData* data = [jsonFromDisk dataUsingEncoding:NSUTF8StringEncoding];
    [self fetchedData:data];
}

// http://www.raywenderlich.com/5492/working-with-json-in-ios-5
- (void)fetchedData:(NSData *)responseData {
    NSError *e = nil;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error: &e];
    
    if (!jsonData) {
        NSLog(@"Error parsing JSON: %@", e); }
    else {
        NSArray *entriesArray = [jsonData objectForKey:@"entries"];
//        NSLog(@"entry item %@", entriesArray[0]);
        
        //        NSDictionary *entryDictionary = entriesArray[0];
        for (NSDictionary* entryDictionary in entriesArray) {
//            NSLog(@"entry item %@", entryDictionary);
            NSDictionary *blobsDictionary = [entryDictionary objectForKey:@"blobs"];
//            NSLog(@"blob item %@", blobsDictionary);
            NSString *imageUrl = [blobsDictionary objectForKey:@"o"];
//            NSLog(@"imageUrl %@", imageUrl);
            [arrayOfImageUrls addObject:imageUrl];

            
            //            id value = [xyz objectForKey:key];
            // do stuff
        }
    }
    
    // earlier version written based on:
    // http://stackoverflow.com/questions/8588264/accessing-json-data-inside-an-nsdictionary-generated-from-nsjsonserialization
    
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



-(NSString*)getRandomImageUrl{
    // http://stackoverflow.com/questions/160890/generating-random-numbers-in-objective-c
/*
    NSArray *imageUrls = @[
                           @"https://tinybeans.com/pv/e/25086002/bbf9ba00-cef9-478a-afee-dd7e0a72f46e-o.jpg",
                           @"https://tinybeans.com/pv/e/24969285/60c86cea-623f-4bb2-b0b7-531c7a734737-o.jpg",
                           @"https://tinybeans.com/pv/e/24974772/0684e447-bca4-4201-b414-2f6f3a55d174-o.jpg",
                           @"https://tinybeans.com/pv/e/24974702/b0e28ae1-abf8-4a8d-86dc-fd9d8c0187b2-o.jpg",
                           @"https://tinybeans.com/pv/e/24974763/8dfd618d-43a7-4c78-86a3-8659879a975c-o.jpg"];
*/
    
    NSInteger randomInt = arc4random_uniform((int)arrayOfImageUrls.count);
    return arrayOfImageUrls[randomInt];
}

-(void)tick {
    NSLog(@"tick...");
    
    NSString* imageUrl = [self getRandomImageUrl];
    [self setImageOnScreen:imageUrl];
}

-(void)setImageOnScreen:(NSString*)imageUrl {
    NSLog(@"About to load image: %@ ", imageUrl);
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
