//
//  VIAnalyticsAOP.m
//  VIAnalyticsKit
//
//  Created by Vienta on 8/3/16.
//  Copyright © 2016 Vienta. All rights reserved.
//

#import "VIAnalyticsAOP.h"
#import <objc/runtime.h>

@implementation VIAnalyticsAOP

@end


@implementation UIImage (imageName)

+ (void)load
{
    SEL originalSEL = @selector(imageNamed:);
    SEL swizzledSEL = @selector(vi_imageNamed:);
    
    Method originalMethod = class_getClassMethod([self class], originalSEL);
    Method swizzledMethod = class_getClassMethod([self class], swizzledSEL);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    SEL originalSEL1 = @selector(initWithCoder:);
    SEL swizzledSEL1 = @selector(vi_initWithCoder:);
    
    Method originalMethod1 = class_getInstanceMethod([self class], originalSEL1);
    Method swizzledMethod1 = class_getInstanceMethod([self class], swizzledSEL1);
    
    method_exchangeImplementations(originalMethod1, swizzledMethod1);
}

- (id)vi_initWithCoder:(NSCoder *)aDecoder
{
    UIImageView *aSelf = [self vi_initWithCoder:aDecoder];
    
    return aSelf;
}

+ (nullable UIImage *)vi_imageNamed:(NSString *)name
{
    UIImage *image = [UIImage vi_imageNamed:name];
    image.imageName = name;
    
    return image;
}


- (NSString *)imageName
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setImageName:(NSString *)imageName
{
    objc_setAssociatedObject(self, @selector(imageName), imageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


@implementation UIImageView (imageName)

+ (void)load
{
    SEL originalSEL = @selector(setImage:);
    SEL swizzledSEL = @selector(vi_setImage:);
    
    Method originalMethod = class_getInstanceMethod([self class], originalSEL);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSEL);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    SEL originalSEL1 = @selector(initWithCoder:);
    SEL swizzledSEL1 = @selector(vi_initWithCoder:);
    
    Method originalMethod1 = class_getInstanceMethod([self class], originalSEL1);
    Method swizzledMethod1 = class_getInstanceMethod([self class], swizzledSEL1);
    
    method_exchangeImplementations(originalMethod1, swizzledMethod1);
}

- (id)vi_initWithCoder:(NSCoder *)aDecoder
{
    UIImageView *aSelf = [self vi_initWithCoder:aDecoder];
    
    return aSelf;
}

- (void)vi_setImage:(UIImage *)image
{
    [self vi_setImage:image];
    self.image.imageName = image.imageName;
}

@end