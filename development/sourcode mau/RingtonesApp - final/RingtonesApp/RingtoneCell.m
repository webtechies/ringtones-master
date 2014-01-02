//
//  RingtoneCell.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RingtoneCell.h"

@implementation RingtoneCell


- (void)updateStars:(NSInteger)starCount;
{
    UIImageView *imgOff = (UIImageView *)[self viewWithTag:2];
    UIImageView *imgOn = (UIImageView *)[self viewWithTag:3];    
    CGRect frame = imgOn.frame;
    UIImage *img = [UIImage imageNamed:@"stars_on.png"];
    CGFloat widthEachStar = img.size.width/5.0;

    frame.size.width = widthEachStar * starCount;
    
    imgOn.frame = frame;
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}


@end
