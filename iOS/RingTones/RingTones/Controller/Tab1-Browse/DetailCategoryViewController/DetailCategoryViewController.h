//
//  DetailCategoryViewController.h
//  RingTones
//
//  Created by Vuong Nguyen on 12/26/13.
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

@interface DetailCategoryViewController : UIViewController< UITableViewDataSource, UITableViewDelegate, ASIProgressDelegate,UIScrollViewDelegate>
{
 
    __weak IBOutlet UITableView *tableData;
    AudioStreamer *streamer;
    NSTimer *playbackTimer;
    AVPlayer *player;
    UIImageView *animationImageView;

}
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *idCategory;
@end
