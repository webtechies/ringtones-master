//
//  RingtonesViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadedViewController.h"
#import "DownloadingViewController.h"
#import "AppDelegate.h"


@interface RingtonesViewController : UIViewController<UIActionSheetDelegate> {

    IBOutlet UISegmentedControl *segDownloadManager;
    
    DownloadedViewController *downloadedVC;
    DownloadingViewController *downloadingVC;
    
    AppDelegate *delegate;
    
    NSDictionary *dictToSendEmail;
}

- (IBAction)segControlValueChanged:(id)sender;

@end
