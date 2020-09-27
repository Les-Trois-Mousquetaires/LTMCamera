//
//  AppDelegate.m
//  LTMCamera
//
//  Created by 柯南 on 2020/9/27.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    ViewController *homeVC = ViewController.alloc.init;
    homeVC.view.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = [UINavigationController.alloc initWithRootViewController:homeVC];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
