//
//  SearcTableCell.h
//  RingTones
//
//  Created by Nguyen Khoi Nguyen on 12/19/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressOverlayView.h"

@class SearcTableCell;

@protocol SearcTableCellDelegate <NSObject>

-(void)didDoubleTapOnCell: (SearcTableCell *)cell;

@end

@interface SearcTableCell : UITableViewCell

@property (nonatomic, weak) id <SearcTableCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *label_playerTimer;
@property (weak, nonatomic) IBOutlet UILabel *label_RingtoneName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Loading;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Download;
@property (weak, nonatomic) IBOutlet UIButton *btn_Download;
@property (strong, nonatomic) DAProgressOverlayView *dimOverLayProgress;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Rating;


@end
