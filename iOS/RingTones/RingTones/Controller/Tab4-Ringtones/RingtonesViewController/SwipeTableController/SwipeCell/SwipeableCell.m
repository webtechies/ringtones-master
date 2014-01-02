//
//  SwipeableCell.m
//  RingTones
//
//  Created by Nguyen Khoi Nguyen on 12/18/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "SwipeableCell.h"

@implementation SwipeableCell

@synthesize delegate;
@synthesize text = _text;
@synthesize labelText = _labelText;
@synthesize imageView_Streaming = _imageView_Streaming;
@synthesize view_Streaming = _view_Streaming;


#pragma mark -
#pragma mark Ultilities
/******************************************************************************/


//-------------------------------------------------------
//
- (void)setText:(NSString *)text {
	_text = [text copy];
	[self setNeedsDisplay];
}

-(void)setLabelText:(UILabel *)labelText
{
    _labelText = labelText;
    [self setNeedsDisplay];
    
}

-(void)setView_Streaming:(UIView *)view_Streaming
{
    _view_Streaming = view_Streaming;
    [self setNeedsDisplay];

}

-(void)setImageView_Streaming:(UIImageView *)imageView_Streaming
{
    _imageView_Streaming = imageView_Streaming;
    [self setNeedsDisplay];
}
/******************************************************************************/





#pragma mark -
#pragma mark Button Fuctions
/******************************************************************************/


//-------------------------------------------------------
//
-(void)btn_Share_Tapped: (UIButton *)button
{
    if ([delegate respondsToSelector:@selector(cellBackButtonWasTapped:)]){
		[delegate btn_Share_Tapped:self];
	}
}


//-------------------------------------------------------
//
-(void)btn_Rename_Tapped: (UIButton *)button
{
    if ([delegate respondsToSelector:@selector(cellBackButtonWasTapped:)]){
		[delegate btn_Rename_Tapped:self];
	}
}


//-------------------------------------------------------
//
-(void)btn_Edit_Tapped: (UIButton *)button
{
    if ([delegate respondsToSelector:@selector(cellBackButtonWasTapped:)]){
		[delegate btn_Edit_Tapped:self];
	}
}


//-------------------------------------------------------
//
-(void)btn_Delete_Tapped: (UIButton *)button
{
    if ([delegate respondsToSelector:@selector(cellBackButtonWasTapped:)]){
		[delegate btn_Delete_Tapped:self];
	}
}

/******************************************************************************/





#pragma mark -
#pragma mark TEXT
/******************************************************************************/


//-------------------------------------------------------
//
- (void)backViewWillAppear:(BOOL)animated {
	
    UIImage *image_Btn_Share = [UIImage imageNamed:@"Btn_share.png"];
    UIImage *image_Btn_Rename = [UIImage imageNamed:@"Btn_rename.png"];
    UIImage *image_Btn_Edit = [UIImage imageNamed:@"Btn_edit.png"];
    UIImage *image_Btn_Delete = [UIImage imageNamed:@"Btn_delete.png"];
    
	UIButton * btn_Share = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * btn_Rename = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * btn_Edit = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton * btn_Delete = [UIButton buttonWithType:UIButtonTypeCustom];
    
	[btn_Share addTarget:self action:@selector(btn_Share_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [btn_Rename addTarget:self action:@selector(btn_Rename_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [btn_Edit addTarget:self action:@selector(btn_Edit_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    [btn_Delete addTarget:self action:@selector(btn_Delete_Tapped:) forControlEvents:UIControlEventTouchUpInside];

    [btn_Share setImage:image_Btn_Share forState:UIControlStateNormal];
    [btn_Rename setImage:image_Btn_Rename forState:UIControlStateNormal];
    [btn_Edit setImage:image_Btn_Edit forState:UIControlStateNormal];
    [btn_Delete setImage:image_Btn_Delete forState:UIControlStateNormal];
    
	[btn_Share setFrame:CGRectMake(20, 0, image_Btn_Share.size.width, self.frame.size.height)];
    
    [btn_Edit setFrame:CGRectMake(65, 0, image_Btn_Edit.size.width, self.frame.size.height)];
    [btn_Rename setFrame:CGRectMake(110, 0, image_Btn_Rename.size.width, self.frame.size.height)];
    [btn_Delete setFrame:CGRectMake(self.frame.size.width - image_Btn_Delete.size.width, 0, image_Btn_Delete.size.width, image_Btn_Delete.size.height)];
    
    
	[self.backView addSubview:btn_Share];
    [self.backView addSubview:btn_Rename];
    [self.backView addSubview:btn_Edit];
    [self.backView addSubview:btn_Delete];
}


//-------------------------------------------------------
//
- (void)backViewDidDisappear:(BOOL)animated {
	// Remove any subviews from the backView.
	[self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


//-------------------------------------------------------
//
- (void)drawContentView:(CGRect)rect {
    
    [self.contentView addSubview:_labelText];
    [self.contentView addSubview:_view_Streaming];

	UIColor * textColor = [UIColor blackColor];
	if (self.selected || self.highlighted){
		textColor = [UIColor whiteColor];
	}
	else
	{
		[[UIColor whiteColor] set];
		UIRectFill(self.bounds);
	}
	
	[textColor set];
	
	UIFont * textFont = [UIFont boldSystemFontOfSize:22];
	CGSize textSize = [_text sizeWithFont:textFont constrainedToSize:rect.size];
	[_text drawInRect:CGRectMake(61,
                                 (rect.size.height / 2) - (textSize.height / 2),
                                 textSize.width, textSize.height)
             withFont:textFont];
   
}


//-------------------------------------------------------
//
- (void)drawBackView:(CGRect)rect {
	
	[[UIImage imageNamed:@"Topbar.png"] drawAsPatternInRect:rect];
	//[self drawShadowsWithHeight:10 opacity:0.3 InRect:rect forContext:UIGraphicsGetCurrentContext()];
}

- (void)drawShadowsWithHeight:(CGFloat)shadowHeight opacity:(CGFloat)opacity InRect:(CGRect)rect forContext:(CGContextRef)context {
	
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	
	CGFloat topComponents[8] = {0, 0, 0, opacity, 0, 0, 0, 0};
	CGGradientRef topGradient = CGGradientCreateWithColorComponents(space, topComponents, nil, 2);
	CGPoint finishTop = CGPointMake(rect.origin.x, rect.origin.y + shadowHeight);
	CGContextDrawLinearGradient(context, topGradient, rect.origin, finishTop, kCGGradientDrawsAfterEndLocation);
	
	CGFloat bottomComponents[8] = {0, 0, 0, 0, 0, 0, 0, opacity};
	CGGradientRef bottomGradient = CGGradientCreateWithColorComponents(space, bottomComponents, nil, 2);
	CGPoint startBottom = CGPointMake(rect.origin.x, rect.size.height - shadowHeight);
	CGPoint finishBottom = CGPointMake(rect.origin.x, rect.size.height);
	CGContextDrawLinearGradient(context, bottomGradient, startBottom, finishBottom, kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(topGradient);
	CGGradientRelease(bottomGradient);
}

@end
