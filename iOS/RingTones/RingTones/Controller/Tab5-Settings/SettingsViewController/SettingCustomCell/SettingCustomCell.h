//
//  SettingCustomCell.h
//  RingTones
//
//  Created by Vuong Nguyen on 12/26/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCustomCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *lbCell;
@property (weak, nonatomic) IBOutlet UISwitch *btSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *imgDetail;

@property (weak, nonatomic) IBOutlet UIImageView *imgLine1;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine2;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

@end
