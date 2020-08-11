//
//  AppDelegate.m
//  junkspace8
//
//  Created by Neal McDonald on 8/14/12.
//  Copyright (c) 2012 Neal McDonald. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate


- (void)loadPreferences{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];

    NSDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithBool:YES] forKey:@"stars"];
    [dict setValue:[NSNumber numberWithBool:YES] forKey:@"horizon"];
    [dict setValue:[NSNumber numberWithInt: 100] forKey:@"faster"];
    [defaults registerDefaults: dict];
    
    [self.viewController takeSettings: [defaults boolForKey:@"stars"] :[defaults boolForKey:@"horizon"] : [defaults integerForKey:@"faster"] ];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    [self loadPreferences];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self loadPreferences];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self loadPreferences];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
