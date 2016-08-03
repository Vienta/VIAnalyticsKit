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
    //Exchange imageNamed: implementation
    Method imageNameOriginalMethod = class_getClassMethod([self class], @selector(imageNamed:));
    Method imageNameSwizzledMethod = class_getClassMethod([self class], @selector(vi_imageNamed:));
    
    method_exchangeImplementations(imageNameOriginalMethod, imageNameSwizzledMethod);

    //Exchange initWithCoder: implementation in order to get the resource file
    Method initWithCoderOriginalMethod = class_getInstanceMethod(NSClassFromString(@"UIImageNibPlaceholder"), @selector(initWithCoder:));
    Method initWithCoderSwizzledMethod = class_getInstanceMethod([self class], @selector(vi_initWithCoder:));
    
    method_exchangeImplementations(initWithCoderOriginalMethod, initWithCoderSwizzledMethod);
    
//    imageWithContentsOfFile
    Method imageWithContentsOfFileOriginalMethod = class_getClassMethod([self class], @selector(imageWithContentsOfFile:));
    Method imageWithContentsOfFileSwizzledMethod = class_getClassMethod([self class], @selector(vi_imageWithContentsOfFile:));
    
    method_exchangeImplementations(imageWithContentsOfFileOriginalMethod, imageWithContentsOfFileSwizzledMethod);
}

- (id)vi_initWithCoder:(NSCoder *)aDecoder
{
    UIImage *image = [self vi_initWithCoder:aDecoder];
    
    NSString *resourceName = [aDecoder decodeObjectForKey:@"UIResourceName"];
    if ([resourceName isKindOfClass:[NSString class]] && resourceName) {
        image.imageName = resourceName;
    }
    return image;
}

+ (nullable UIImage *)vi_imageNamed:(NSString *)name
{
    UIImage *image = [UIImage vi_imageNamed:name];
    image.imageName = name;
    
    return image;
}

+ (nullable UIImage *)vi_imageWithContentsOfFile:(NSString *)path
{
    UIImage *image = [UIImage vi_imageWithContentsOfFile:path];
    
    NSURL *urlPath = [NSURL fileURLWithPath:path];
    NSString *imageName = [[urlPath.lastPathComponent componentsSeparatedByString:@"."] firstObject];
    image.imageName = imageName;
    
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

//+ (void)load
//{
//    Method originalMethod = class_getInstanceMethod([self class], @selector(setImage:));
//    Method swizzledMethod = class_getInstanceMethod([self class], @selector(vi_setImage:));
//    
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//}
//
//- (void)vi_setImage:(UIImage *)image
//{
//    [self vi_setImage:image];
//    self.image.imageName = image.imageName;
//}

@end