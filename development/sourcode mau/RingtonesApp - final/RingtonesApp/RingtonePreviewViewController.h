//
//  RingtonePreviewViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"


@interface RingtonePreviewViewController : UIViewController {
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *labelDownloading;
    
    NSDictionary *dictRingtone;
    
    
    UIViewController *hostVC;
    
    NSTimer *timerUpdatePercent;
    
    ASIHTTPRequest *request;
    
}

- (void)updateFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ringtone:(NSDictionary *)dict;

- (void)loadPreviewOnViewController:(UIViewController *)viewController;
- (void)loadPreviewWithDict:(NSDictionary *)dict onViewController:(UIViewController *)viewController;
- (void)stopPreviewingAndRemoveFromSuperView;


@end
