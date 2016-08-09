//
//  VIAnalyticsAOP.m
//  VIAnalyticsKit
//
//  Created by Vienta on 8/3/16.
//  Copyright © 2016 Vienta. All rights reserved.
//

#import "VIAnalyticsAOP.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation VIAnalyticsAOP

+ (instancetype)sharedInstance
{
    static VIAnalyticsAOP *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });

    return _sharedInstance;
}

- (void)vi_analyticsSource:(id)source action:(SEL)action target:(id)target
{
    NSLog(@"~~~analytics source:%@ action:%@ target:%@",source, NSStringFromSelector(action), target);
}

@end

@implementation UIControl (AOP)

+ (void)load
{
    Method initOriginalMethod = class_getInstanceMethod([self class], @selector(sendAction:to:forEvent:));
    Method initSwizzledMethod = class_getInstanceMethod([self class], @selector(vi_sendAction:to:forEvent:));
    
    method_exchangeImplementations(initOriginalMethod, initSwizzledMethod);
}

- (void)vi_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [self vi_sendAction:action to:target forEvent:event];
    [[VIAnalyticsAOP sharedInstance] vi_analyticsSource:self action:action target:target];
}

@end


@implementation UIGestureRecognizer (AOP)

+ (void)load
{
    Method initOriginalMethod = class_getInstanceMethod([self class], @selector(initWithTarget:action:));
    Method initSwizzledMethod = class_getInstanceMethod([self class], @selector(vi_initWithTarget:action:));
    
    method_exchangeImplementations(initOriginalMethod, initSwizzledMethod);
}

- (instancetype)vi_initWithTarget:(nullable id)target action:(nullable SEL)action
{
    UIGestureRecognizer *selfGestureRecognizer = [self vi_initWithTarget:target action:action];
    
    if (!target && !action) {
        return selfGestureRecognizer;
    }
    
    Class class = [target class];
    
    SEL originalSEL = action;
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"vi_%@", NSStringFromSelector(action)]);
    
    BOOL isAddMethod = class_addMethod(class, swizzledSEL, (IMP)vi_gestureAction, "v@:@");

    if (isAddMethod) {
        Method originalMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

    return selfGestureRecognizer;
}

void vi_gestureAction(id self, SEL _cmd, id sender) {
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"vi_%@", NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);
    [[VIAnalyticsAOP sharedInstance] vi_analyticsSource:sender action:_cmd target:self];
}



@end


@implementation UITableView (AOP)

+ (void)load
{
    Method delegateOriginalMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method delegateSwizzledMethod = class_getInstanceMethod([self class], @selector(vi_setDelegate:));
    
    method_exchangeImplementations(delegateOriginalMethod, delegateSwizzledMethod);
}

- (void)vi_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self vi_setDelegate:delegate];
    
    if (class_addMethod([self class], NSSelectorFromString(@"vi_didSelectRowAtIndexPath"), (IMP)vi_didSelectRowAtIndexPath, "v@:@@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"vi_didSelectRowAtIndexPath"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([self class], @selector(tableView:didSelectRowAtIndexPath:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void vi_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexPath)
{
    NSLog(@"cmd:%@", NSStringFromSelector(_cmd));
    SEL selector = NSSelectorFromString(@"vi_didSelectRowAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, selector, tableView, indexPath);
}

@end

@implementation UICollectionView (AOP)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(vi_setDelegate:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)vi_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [self vi_setDelegate:delegate];
    
    if (class_addMethod([self class], NSSelectorFromString(@"vi_didSelectItemAtIndexPath"), (IMP)vi_didSelectItemAtIndexPath, "v@:@@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"vi_didSelectItemAtIndexPath"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([self class], @selector(collectionView:didSelectItemAtIndexPath:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void vi_didSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, id indexPath)
{
    NSLog(@"cmd:%@", NSStringFromSelector(_cmd));
    SEL selector = NSSelectorFromString(@"vi_didSelectItemAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, selector, collectionView, indexPath);
}

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
    
    //Exchange imageWithContentsOfFile: implementation
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


@implementation UIViewController (TopMostViewController)

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil) {
        
        return self;
        
    } else if ([self.presentedViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    
    return [presentedViewController topMostViewController];
}

@end

@implementation UIApplication (TopMostViewController)

- (UIViewController *)topMostViewController
{
    return [self.keyWindow.rootViewController topMostViewController];
}

@end
