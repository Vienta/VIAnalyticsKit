//
//  VIAnalyticsAOP.h
//  VIAnalyticsKit
//
//  Created by Vienta on 8/3/16.
//  Copyright © 2016 Vienta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VIAnalyticsAOP : NSObject

@property (weak, nonatomic) id delegate;
@property (copy, nonatomic) void (^analyticsIdentifierBlock)(NSString *identifier);

+ (instancetype)sharedInstance;

@end






@interface UIControl (AOP)

@end


@interface UIGestureRecognizer (AOP)

@end

@interface UITableView (AOP)

@end

@interface UICollectionView (AOP)

@end


@interface UIImage (imageName)

@property (nonatomic, copy) NSString *imageName;

@end

@interface UIViewController (TopMostViewController)

- (UIViewController *)topMostViewController;

@end


@interface UIApplication (TopMostViewController)

- (UIViewController *)topMostViewController;

@end


