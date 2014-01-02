//
//  SPTableViewCell.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/3/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "MPTableViewCell.h"
#import "SPSwitch.h"

@interface UIBUttonSP : UIButton
{

}

@property (nonatomic, retain)  NSIndexPath *indexPath;

@end
@interface SPTableViewCell : MPTableViewCell
{
    
}

@property (nonatomic, retain) UIBUttonSP *spTitle;
@property (nonatomic, retain) SPSwitch *buttonAds;

@end
