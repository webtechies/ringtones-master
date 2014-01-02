//
//  MPTableViewCell.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "MPTableViewCell.h"


@implementation MPTableViewCell

static const CGFloat sizeIcon = 57.0f;
static const CGFloat padding = 8.0f;

static const CGFloat withLabeliPhone = 222.0f;
static const CGFloat withLabeliPad = 662.0f;

static const CGFloat fontiPhone = 13.0f;
static const CGFloat fontiPad = 17.0f;


- (NSString *) reuseIdentifier {
    return @"MPTableViewCell";
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        
        //backgroundview
        self.backgroundViewCell = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *bgImg = [UIImage imageNamed:@"Cell 1.png"];
        [_backgroundViewCell setBackgroundImage:bgImg forState:UIControlStateNormal];
        [_backgroundViewCell setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:self.backgroundViewCell];
        
        
        //--image view
        _mpIconApp = [[UIImageView alloc] init];
        self.mpIconApp.frame =  CGRectMake(8, 8, sizeIcon, sizeIcon);
        
        //--title
        CGFloat originX = self.mpIconApp.frame.origin.x + sizeIcon + padding;
        
        CGFloat sizeWithLimit = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?withLabeliPhone:withLabeliPad;
        CGFloat fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?fontiPhone:fontiPad;
        
        _mpTitle = [[UILabel alloc] initWithFrame:CGRectMake(originX, 6, sizeWithLimit, 30)];
        self.mpTitle.textColor = [UIColor blackColor];
        
        self.mpTitle.font =  [UIFont boldSystemFontOfSize:fontSize];
        self.mpTitle.numberOfLines = 0;
        self.mpTitle.lineBreakMode = NSLineBreakByCharWrapping;
        self.mpTitle.contentMode =  UIViewContentModeTop;
        self.mpTitle.textAlignment =  NSTextAlignmentLeft;
        self.mpTitle.adjustsFontSizeToFitWidth =  YES;
        
        //--description
        _mpDescription = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, sizeWithLimit, 30)];
        self.mpDescription.textColor = [UIColor blackColor];
        self.mpDescription.font =  [UIFont systemFontOfSize:fontSize-2.0f];
        [self.mpDescription setNumberOfLines:0];
        [self.mpDescription setLineBreakMode:NSLineBreakByCharWrapping];
        self.mpDescription.textColor = [UIColor darkGrayColor];
        
              
        [self addSubview:self.mpIconApp];
        [self addSubview:self.mpTitle];
        [self addSubview:self.mpDescription];
        
        
        CGRect  rectBreaLine = CGRectMake(0, 0, 320, 2);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            rectBreaLine =  CGRectMake(0, 0, 768, 2);
        
        UIImageView *av = [[UIImageView alloc] initWithFrame:rectBreaLine];
        av.backgroundColor = [UIColor clearColor];
        av.image = [UIImage imageNamed:@"Cell break@2x.png"];
        av.tag = 100;
        
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 2)];
        self.bottomLineView.backgroundColor = [UIColor clearColor];
        [_bottomLineView addSubview:av];
        
        [av release];
        
        
        [self addSubview:self.bottomLineView];
        
        
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
    [_backgroundViewCell release];
    [_mpDescription release];
    [_mpIconApp release];
    [_mpTitle release];
    [_bottomLineView release];
    
    [super dealloc];
}


@end
