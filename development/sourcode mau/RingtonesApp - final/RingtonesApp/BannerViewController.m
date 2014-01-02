//
//  BannerViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BannerViewController.h"
#import "Constants.h"
#import "CommonUtils.h"

@implementation BannerViewController

- (void)startTimer;
{
    if (![timerChangeAd isValid]) {
        timerChangeAd = [NSTimer scheduledTimerWithTimeInterval:kBannerUpdateInterval 
                                                         target:self 
                                                       selector:@selector(timerTick) 
                                                       userInfo:nil 
                                                        repeats:YES];
    }
}

- (void)stopTimer;
{
    if ([timerChangeAd isValid]) {
        [timerChangeAd invalidate];
        timerChangeAd = nil;
    }
}

- (void)timerTick;
{
    if (dictAds != nil) {
//        selectedIndex = arc4random() % [dictAds count];        

        //next index loop
        selectedIndex = (selectedIndex + 1) % [dictAds count];
        
        NSString *imgName = [[dictAds allKeys]objectAtIndex:selectedIndex];
        NSLog(@"randon: %d, count: %d, image: %@", selectedIndex, [dictAds count], imgName);
        UIImage *image = [UIImage imageNamed:imgName];
        if (image) {
            [buttonAd setBackgroundImage:image forState:UIControlStateNormal];
        }
        
    } else {
        [self stopTimer];
    }
    
}


- (IBAction)buttonAddClicked:(id)sender;
{
    //        [arrSource ob]
    [CommonUtils openURLExternalHandlerForLink:[[dictAds allValues]objectAtIndex:selectedIndex]];
}

- (void)startRandomAd; 
{
    F_RELEASE(dictAds);
    
    //init sources
    dictAds = [[NSMutableDictionary alloc]initWithObjectsAndKeys:kBannerLink1, kBannerImg1, kBannerLink2, kBannerImg2, kBannerLink3, kBannerImg3, kBannerLink4, kBannerImg4, kBannerLink5, kBannerImg5, nil];
    
    selectedIndex = 0;
    //set first banner
    [buttonAd setBackgroundImage:[UIImage imageNamed:kBannerImg1] forState:UIControlStateNormal];
    
    //start timer
    [self startTimer];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self stopTimer];
}


- (void)dealloc {
    
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
