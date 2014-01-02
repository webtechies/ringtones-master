//
//  SearchViewController.h
//  RingTones
//
//  Created by Vuong Nguyen on 12/12/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
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
@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, ASIProgressDelegate, SearcTableCellDelegate, UIAlertViewDelegate>

{
    AVPlayer *player;
	NSTimer *playbackTimer;
    UIImageView *animationImageView;
    NSMutableData *ringtoneData;
    ASINetworkQueue  *networkQueue;
    AudioStreamer *streamer;

    
    __weak IBOutlet UISearchBar *searchBar_RingtoneSearch;
    __weak IBOutlet UITableView *tableView_RingtoneSearch;
}


@end
