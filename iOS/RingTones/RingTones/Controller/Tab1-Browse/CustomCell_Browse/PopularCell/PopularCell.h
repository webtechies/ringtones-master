//
//  PopularCell.h
//  RingTones
//
//  Created by VinhTran on 12/15/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressOverlayView.h"
@interface PopularCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label_playerTimer;
@property (weak, nonatomic) IBOutlet UILabel *label_RingtoneName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Loading;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Download;
@property (weak, nonatomic) IBOutlet UIButton *btn_Download;
@property (strong, nonatomic) DAProgressOverlayView *dimOverLayProgress;
@end
