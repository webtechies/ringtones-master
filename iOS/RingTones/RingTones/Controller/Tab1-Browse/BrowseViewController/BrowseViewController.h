//
//  BrowseViewController.h
//  RingTones
//
//  Created by Vuong Nguyen on 12/12/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalegoriesCell.h"
#import "Model.h"
#import "UIFont+VFF.h"
#import "RemoteService.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "SearcTableCell.h"
#import "MBProgressHUD.h"
#import "DAProgressOverlayView.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "AudioStreamer.h"

@class ASINetworkQueue;
@interface BrowseViewController : UIViewController< UITableViewDataSource, UITableViewDelegate, ASIProgressDelegate,UIScrollViewDelegate>
{
    
    __weak IBOutlet UIImageView *bgSegment;
    
    __weak IBOutlet UIButton *btPopular;
    __weak IBOutlet UIButton *btCategories;
    __weak IBOutlet UITableView *tablePopular;
    __weak IBOutlet UITableView *tableCategories;
    BOOL isPopular;
  
    AudioStreamer *streamer;
    NSTimer *playbackTimer;
    AVPlayer *player;
    UIImageView *animationImageView;
    __weak IBOutlet UIView *viewSegment;
}


- (IBAction)btPopular_Pressed:(id)sender;
- (IBAction)btCategories_Pressed:(id)sender;

@end
