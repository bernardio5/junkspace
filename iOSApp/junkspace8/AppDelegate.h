//
//  AppDelegate.h
//  junkspace8
//
//  Created by Neal McDonald on 8/14/12.
//  Copyright (c) 2012 Neal McDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    int slowFactor;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
