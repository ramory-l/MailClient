//
//  AppDelegate.h
//  MailClient
//
//  Created by Roxane Amory on 10.01.2020.
//  Copyright © 2020 Roxane Amory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *loadingView;

- (void)showLoading;
- (void)hideLoading;

@end

