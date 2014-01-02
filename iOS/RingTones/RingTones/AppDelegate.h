//
//  AppDelegate.h
//  RingTones
//
//  Created by Vuong Nguyen on 12/12/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppModel.h"
@class MasterNavigation;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
      AppModel *appModel;
    
}

@property (strong, nonatomic) AppModel *appModel;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *navigationBrowse;
@property (strong, nonatomic) UIViewController *navigationSearch;
@property (strong, nonatomic) UIViewController *navigationMaker;
@property (strong, nonatomic) UIViewController *navigationRingTones;
@property (strong, nonatomic) UIViewController *navigationSettings;
@property (strong, nonatomic) UIViewController *viewController;
@end
