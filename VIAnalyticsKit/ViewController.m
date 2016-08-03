//
//  ViewController.m
//  VIAnalyticsKit
//
//  Created by Vienta on 8/3/16.
//  Copyright © 2016 Vienta. All rights reserved.
//

#import "ViewController.h"
#import "VIAnalyticsAOP.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    UIImage *image = [UIImage imageNamed:@"liveshre_QQ"];
//    NSLog(@"image name:%@", image.imageName);
//    NSLog(@"image %@:", image);
//    [self.imageView setImage:image];
    NSLog(@"imageview.image %@ imageName:%@", self.imageView.image, self.imageView.image.imageName);
    
//    [self.imageView setImage:[UIImage imageNamed:@"liveshre_QQ"]];
//    NSLog(@"self.imageView.image.imageName:%@", self.imageView.image.imageName);    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
