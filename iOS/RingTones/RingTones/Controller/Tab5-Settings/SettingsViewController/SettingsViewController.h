//
//  SettingsViewController.h
//  RingTones
//
//  Created by Vuong Nguyen on 12/13/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
@class   HTTPServer;
@interface SettingsViewController : UIViewController<UINavigationControllerDelegate, SKStoreProductViewControllerDelegate>
{
    //sharing
    UIPopoverController *activityPopoverController;
    __weak IBOutlet UITableView *tableData;
     MBProgressHUD *loading;
    HTTPServer *httpServer;
    NSDictionary *addresses;
}
@property (nonatomic, retain) MBProgressHUD *loading;
@end
