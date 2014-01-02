//
//  RingtoneTabelCell.m
//  RingTones
//
//  Created by Nguyen Khoi Nguyen on 12/23/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "RingtoneTabelCell.h"

enum {
    kOnLeft = 0,
    kCenter = 1,
    kOnRight = 2,
    };

@implementation RingtoneTabelCell
{
    
    int frontViewPostion;
}


@synthesize label_playerTimer;
@synthesize textField_RingtoneName;
@synthesize imageView_Loading;
@synthesize btn_Share, btn_Delete, btn_Edit,btn_Rename;
@synthesize delegate;
@synthesize isEditing;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//-------------------------------------------------------
//Set layout for cell
-(void)layoutSubviews
{
    [super layoutSubviews];
    
  
    
    UISwipeGestureRecognizer * swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedRight:)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UISwipeGestureRecognizer * swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwipedLeft:)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [view_Front addGestureRecognizer:swipeLeftRecognizer];
    [view_Front addGestureRecognizer:swipeRightRecognizer];
    
    frontViewPostion = kCenter;
    

}



//-------------------------------------------------------
//Detect cell swipe right
- (void)cellWasSwipedRight:(UISwipeGestureRecognizer *)recognizer
{
    if (frontViewPostion == kCenter)
    {
        frontViewPostion = kOnRight;
        [self.delegate editingCell:self];
        [self revealLeftMenu];
    }
    
    if (frontViewPostion == kOnLeft)
    {
        //frontViewPostion = kCenter;
        [self hideBackView];
    }
    
}



//-------------------------------------------------------
//Detect cell swipe left
- (void)cellWasSwipedLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (frontViewPostion == kCenter)
    {
        
        frontViewPostion = kOnLeft;
        [self.delegate editingCell:self];
        [self revealDeleteButton];
    }
    
    if (frontViewPostion == kOnRight)
    {
        //frontViewPostion = kCenter;
        [self hideBackView];
    }

}




//-------------------------------------------------------
//
-(void)revealLeftMenu
{
    
    [UIView animateWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
       [view_Front setFrame:CGRectMake(150, 0, view_Front.frame.size.width, view_Front.frame.size.height)];
    } completion:nil];
    
}



//-------------------------------------------------------
//
-(void)revealDeleteButton
{
    [UIView animateWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
        [view_Front setFrame:CGRectMake(- 82, 0, view_Front.frame.size.width, view_Front.frame.size.height)];
    } completion:nil];
    
}




//-------------------------------------------------------
//Swipe to origin
-(void)hideBackView
{
    
    frontViewPostion = kCenter;
    
    [UIView animateWithDuration:0.4 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [view_Front setFrame:CGRectMake(0, 0, view_Front.frame.size.width, view_Front.frame.size.height)];
        [view_Back setFrame:CGRectMake(0, 0, view_Front.frame.size.width, view_Front.frame.size.height)];

    } completion:nil];
    
}


//-------------------------------------------------------
//
- (IBAction)btn_Rename_Tapped:(id)sender
{
    [UIView animateWithDuration:0.4 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [view_Front setFrame:CGRectMake(45, 0, view_Front.frame.size.width, view_Front.frame.size.height)];
        [view_Back setFrame:CGRectMake(- 100, 0, view_Front.frame.size.width, view_Front.frame.size.height)];
        
    } completion:nil];
}


@end
