//
//  AppDelegate.m
//  MailClient
//
//  Created by Roxane Amory on 10.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initLoader];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

-(void)initLoader{
    
    self.loadingView = [[UIView alloc] initWithFrame:self.window.frame];
    self.loadingView.backgroundColor  = [UIColor clearColor];
    
    
    UIView *loaderBGView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.loadingView.bounds)/2 - 35, CGRectGetHeight(self.loadingView.bounds)/2 -35, 70, 70)];
    loaderBGView.layer.cornerRadius = 12;
    loaderBGView.backgroundColor = [UIColor blackColor];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
    [indicatorView startAnimating];
    [loaderBGView addSubview:indicatorView];
    [self.loadingView addSubview:loaderBGView];
    
}

- (void)showLoading {
    [self.window addSubview:_loadingView];
}

-(void)hideLoading {
    [_loadingView removeFromSuperview];
}

@end
