//
//  BannerViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerViewController : UIViewController {
    IBOutlet UIButton *buttonAd;
    
    NSInteger selectedIndex;
    
    NSMutableArray *arrSource;
    
    NSMutableDictionary *dictAds;
    
    NSTimer *timerChangeAd;
}

- (IBAction)buttonAddClicked:(id)sender;

- (void)startRandomAd;

@end
