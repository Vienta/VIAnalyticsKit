# VIAnalyticsKit

 **VIAnalyticsKit** is an open source software framework that makes it easy to catch the user's interaction in application.Whatever UIButton's target-action,UIAlertController's select item,UITableView/UICollectionView's `didSelectRowAtIndexPath`,or UIGestureRecognizer's gestures,this framework can catch these events.
 
[**VIAnalyticsKit**是以AOP进行埋点的，中文文章有解释说明](http://www.vienta.me/2016/09/21/AOP%E5%9C%A8iOS%E4%B8%AD%E7%9A%84%E5%AE%9E%E8%B7%B5%E4%B8%80%E7%BB%9F%E8%AE%A1%E5%9F%8B%E7%82%B9/)

It can be use for data collection and analysis.

## Requirements 

* Require iOS7 or later
* Require ARC

## Usage

`VIAnalyticsKit` will generate a `identifier string` depend on where the user's inteaction happened in the viewcontroller and what the SEL name it is. In `AppDelegate.m`, import `"VIAnalyticsAOP.h"`,then in `didFinishLaunchingWithOptions `:


	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    	// Override point for customization after application launch.
    
	    [VIAnalyticsAOP sharedInstance].analyticsIdentifierBlock = ^(NSString *identifier) {
	        NSLog(@"aop:::%@", identifier);
	        // Post identifier to your server
	    };
	    
	    return YES;
	}
	
The `identifier` will contain the action's infomation.You can collection those identifiers and post those to your server, those will help your company analyze user behavior.

## Advantage

The traditional method to analyze,like umeng in China,is adding the statistical code everywhere in your project.It is really a bad idea and wasting time.`VIAnalyticsKit` can helpfully solve this problem by using `objc/runtime` just like AOP in Java.  The `identifier` like as follows:

	2016-08-26 15:19:37.518 VIAnalyticsKit[6322:1628618] aop:::UIInputWindowController#viewWillAppear:
	2016-08-26 15:19:37.554 VIAnalyticsKit[6322:1628618] aop:::UINavigationController#viewDidAppear:
	2016-08-26 15:19:37.554 VIAnalyticsKit[6322:1628618] aop:::ViewController#viewDidAppear:
	2016-08-26 15:19:37.555 VIAnalyticsKit[6322:1628618] aop:::UIInputWindowController#viewDidAppear:
	2016-08-26 15:19:50.609 VIAnalyticsKit[6322:1628618] aop:::ViewController#UITapGestureRecognizer#liveshre_QQ#imageViewPan#ViewController
	2016-08-26 15:19:50.652 VIAnalyticsKit[6322:1628618] aop:::View2Controller#viewDidLoad
	2016-08-26 15:19:50.653 VIAnalyticsKit[6322:1628618] aop:::View2Controller#viewWillAppear:
	2016-08-26 15:19:51.277 VIAnalyticsKit[6322:1628618] aop:::View2Controller#viewDidAppear:
	2016-08-26 15:19:56.278 VIAnalyticsKit[6322:1628618] aop:::View2Controller#UITableView#0-0#View2Controller
	
This `identifier` contains `ViewController,method name,image name and so on`.


## Installation

Use cocoapods

	pod 'VIAnalyticsKit'

## License

	MIT License

	Copyright (c) 2016 Vienta

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

