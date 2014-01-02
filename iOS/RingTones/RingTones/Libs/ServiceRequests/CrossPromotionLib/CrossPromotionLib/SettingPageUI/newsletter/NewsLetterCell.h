//
//  NewsLetterCell.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/12/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define CellTextFieldWidth 200.0
#define MarginBetweenControls 20.0
#define CellButtonWidth 100.0
#define CellButtonHeight 30.0



#import "FTCustomButton.h"


@interface NewsLetterCell : UITableViewCell

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UILabel *labelTitle;
@property (nonatomic, retain) FTCustomButton *subscrible;

@end
