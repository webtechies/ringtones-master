//
//  MPTableViewCell.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPTableViewCell : UITableViewCell


@property (nonatomic, strong) UILabel *mpTitle;
@property (nonatomic, strong) UILabel *mpDescription;
@property (nonatomic, strong) UIImageView *mpIconApp;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *backgroundViewCell
;



@end
