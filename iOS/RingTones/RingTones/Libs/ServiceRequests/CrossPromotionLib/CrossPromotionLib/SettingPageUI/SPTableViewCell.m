//
//  SPTableViewCell.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/3/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "SPTableViewCell.h"


@implementation UIBUttonSP



-(void) dealloc
{
    [_indexPath release];
    
    [super dealloc];
}


@end



@implementation SPTableViewCell

static const CGFloat withLabeliPhone = 210.0f;
static const CGFloat withLabeliPad = 580.0f;

static const CGFloat sizeIconIPhone = 25;
static const CGFloat sizeIconIPad = 40;

static const CGFloat padding =  10.0f;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //--hide mpdescription
        self.mpDescription.hidden =  YES;
        self.mpTitle.hidden =  YES;
        
        //--icon size
        CGFloat sizeIcon = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?sizeIconIPhone:sizeIconIPad;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.mpIconApp.frame =  CGRectMake(15, 0, sizeIcon, sizeIcon);
        else
            self.mpIconApp.frame =  CGRectMake(40, 0, sizeIcon, sizeIcon);
        
        //--title
        self.spTitle = [UIBUttonSP buttonWithType:UIButtonTypeCustom];
        
        CGFloat withLabel = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?withLabeliPhone:withLabeliPad;
        CGRect frameTitle = self.mpTitle.frame;
        frameTitle.origin.x = self.mpIconApp.frame.origin.x +  self.mpIconApp.frame.size.width + padding;
        frameTitle.size.width =  withLabel;
        self.spTitle.frame = frameTitle;
        self.spTitle.backgroundColor =  [UIColor clearColor];
        self.spTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        [self.spTitle setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        [self addSubview:self.spTitle];
        
        
        
        //--button ads
        self.buttonAds = [[SPSwitch alloc] initWithFrame:CGRectMake(0, 0, 79, 27)];
        self.buttonAds.hidden =  YES;
        [self addSubview:self.buttonAds];
        
        
        self.bottomLineView.hidden =  YES;
        
    }
    
    return self;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



-(void) dealloc
{
    [_spTitle release];
    [_buttonAds release];
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
