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
    NSLog(@"imageview.image %@ imageName:%@", self.imageView.image, self.imageView.image.imageName);
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPan)];
    [self.imageView addGestureRecognizer:tapGes];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(90, 90, 80, 80);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (void)btnTap:(id)sender
{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题"
                                                                                 message:@"测试点击事件" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击确定");
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
        }];
        
        [alertController addAction:action1];
        [alertController addAction:action2];
        
        [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imageViewPan
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self imageViewTapped];
}

- (void)dddd
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)imageViewTapped
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)imageViewLongPress
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)btnTapped:(id)sender {
    [self imageViewTapped];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
