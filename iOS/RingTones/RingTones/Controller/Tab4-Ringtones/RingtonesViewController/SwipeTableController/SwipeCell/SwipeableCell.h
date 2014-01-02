//
//  SwipeableCell.h
//  RingTones
//
//  Created by Nguyen Khoi Nguyen on 12/18/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TISwipeableTableView.h"

@class SwipeableCell;

@protocol SwipeableCellDelegate <NSObject>
- (void)cellBackButtonWasTapped:(SwipeableCell *)cell;


-(void)btn_Share_Tapped: (SwipeableCell *)cell;
-(void)btn_Rename_Tapped: (SwipeableCell *)cell;
-(void)btn_Edit_Tapped: (SwipeableCell *)cell;
-(void)btn_Delete_Tapped: (SwipeableCell *)cell;


@end

@interface SwipeableCell : TISwipeableTableViewCell
@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UIView *view_Streaming;
@property (nonatomic, strong) UIImageView *imageView_Streaming;

- (void)drawShadowsWithHeight:(CGFloat)shadowHeight opacity:(CGFloat)opacity InRect:(CGRect)rect forContext:(CGContextRef)context;

@end
