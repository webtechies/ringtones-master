//
//  SearcTableCell.m
//  RingTones
//
//  Created by Nguyen Khoi Nguyen on 12/19/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "SearcTableCell.h"

@implementation SearcTableCell

@synthesize label_playerTimer;
@synthesize label_RingtoneName;
@synthesize imageView_Loading;
@synthesize imageView_Download;
@synthesize btn_Download;
@synthesize imageView_Rating;
@synthesize delegate;

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


-(void)layoutSubviews
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

-(void)doDoubleTap
{
    [self.delegate didDoubleTapOnCell:self];
}

@end
