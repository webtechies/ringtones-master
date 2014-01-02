//
//  NewsLetterCell.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/12/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "NewsLetterCell.h"

@implementation NewsLetterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //--label title
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 6, 150, 30)];
        self.labelTitle.textColor = [UIColor blackColor];
        
        self.labelTitle.font =  [UIFont boldSystemFontOfSize:14];
        self.labelTitle.numberOfLines = 0;
        self.labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
        self.labelTitle.contentMode =  UIViewContentModeTop;
        self.labelTitle.textAlignment =  NSTextAlignmentLeft;
        self.labelTitle.adjustsFontSizeToFitWidth =  YES;
        self.labelTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelTitle];
        
        // Adding the text field
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.clearsOnBeginEditing = NO;
        self.textField.textAlignment = UITextAlignmentLeft;
        self.textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.textField];
        
        //--button
        self.subscrible = [FTCustomButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *originalImage = [UIImage imageNamed:@"BarButton.png"];
        originalImage =  [originalImage stretchableImageWithLeftCapWidth:4
                                                            topCapHeight:4];
        
        UIImage *highlight = [UIImage imageNamed:@"BarButton-Pressed.png"];
        highlight =  [highlight stretchableImageWithLeftCapWidth:4
                                                    topCapHeight:4];
        
        
        [self.subscrible setBackgroundImage:originalImage forState:UIControlStateNormal];
        [self.subscrible setBackgroundImage:highlight forState:UIControlStateHighlighted];
        
        [self.subscrible setTitle:@"Subscribe" forState:UIControlStateNormal];
        
        self.subscrible.frame =  CGRectMake(90, 0, 140, CellButtonHeight);
        self.subscrible.hidden =  NO;
        [self.subscrible.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        
        [self.contentView addSubview:self.subscrible];
        
    }
    return self;
}




#pragma mark -
#pragma mark Laying out subviews

- (void)layoutSubviews {
    
    CGFloat withTextField =  CellTextFieldWidth;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        withTextField = 380;
    
    CGRect rect = CGRectMake(100,
                             12.0,
                             withTextField,
                             25.0);
    [self.textField setFrame:rect];
    
    CGRect rect2 = CGRectMake(MarginBetweenControls,
                              10.0,
                              self.contentView.bounds.size.width - CellTextFieldWidth - MarginBetweenControls,
                              25.0);

    [self.labelTitle setFrame:rect2];
    
    
    CGRect rect3 = CGRectZero;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
       rect3 =  CGRectMake((self.contentView.bounds.size.width/2 - CellButtonWidth/2),
                              0,
                             CellButtonWidth,
                              CellButtonHeight);
    }else{
        
        rect3 =  CGRectMake((self.contentView.bounds.size.width/2 - CellButtonWidth/2) + 90,
                            3,
                            CellButtonWidth,
                            CellButtonHeight);
        
    }
    
    [self.subscrible setFrame:rect3];
    
}


- (void)dealloc {
    
    [_labelTitle release];
    [_textField release];
    [_subscrible release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
