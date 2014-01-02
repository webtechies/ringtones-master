//
//  MoreViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKProduct.h>
#import "MyStoreObserver.h"
#import "AppDelegate.h"

@class   HTTPServer;

@interface MoreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PurchaseDelegate> {
    IBOutlet UITableView *mainTableView;
    
    HTTPServer *httpServer;
	NSDictionary *addresses;
    
    NSString *strWifiSharing;
    
    IBOutlet UISwitch *swiWifiSharing;

    BOOL purchased;
}


@end
