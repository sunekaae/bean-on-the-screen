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





- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSInteger randomInt = arc4random_uniform(3);

    NSString* imageUrl = [self getImageUrl:randomInt];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];

    
    // http://stackoverflow.com/questions/7700352/repeating-a-method-every-few-seconds-in-objective-c
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(foo) userInfo:nil repeats:YES];
    
    
}

-(NSString*)getImageUrl:(NSInteger)imageNumber {
    NSArray *imageUrls = @[@"https://www.adaptiveshop.se/uploads/news/53/ssl.png", @"https://7star.se/wp-content/uploads/2014/08/SSL-Security.jpg", @"https://upload.wikimedia.org/wikipedia/commons/0/03/SSL_SL6000E_and_baby_-_20090722.jpg"];
    return imageUrls[imageNumber];
}

-(void)foo {
    NSLog(@"testsune");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
