//
//  MakerViewController.m
//  RingTones
//
//  Created by Vuong Nguyen on 12/13/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "MakerViewController.h"
#import "ListIPodSongsViewController.h"
#import "RingtonesViewController.h"
#import "RecordViewController.h"
#import "LisSongDownladedViewController.h"


@interface MakerViewController ()

@end

@implementation MakerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/********************************************************************************/
#pragma mark - get song in app for maker ringtone

- (IBAction)listSonginApp:(id)sender {
    LisSongDownladedViewController *creator = [[LisSongDownladedViewController alloc]initWithNibName:[Common checkDevice: @"LisSongDownladedViewController"] bundle:nil];
    
    [self.navigationController pushViewController:creator animated:YES];

}



/********************************************************************************/
#pragma mark - recoder

- (IBAction)recoderAudio:(id)sender {
    RecordViewController *recoderVC = [[RecordViewController alloc] initWithNibName:[Common checkDevice: @"RecordViewController"] bundle:nil];
    [self.navigationController pushViewController:recoderVC animated:YES];
}



/********************************************************************************/
#pragma mark - library iPod

- (IBAction)showListiPadSong:(id)sender {
    ListIPodSongsViewController *creator = [[ListIPodSongsViewController alloc]initWithNibName:[Common checkDevice: @"ListIPodSongsViewController"] bundle:nil];
    
    [self.navigationController pushViewController:creator animated:YES];
}




/********************************************************************************/


/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - ViewDidLoad


/** Register notification center for view controller */
-(void) registerNotification
{
    
}


/** Set data when view did load.
 ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
-(void) setDataWhenViewDidLoad
{
    
    
}



/** Set view when view did load
 ** Be there. You can change the layout, view, button,..*/
-(void) setViewWhenViewDidLoad
{
    
}

/** Begin view controller */
- (void)viewDidLoad
{
    [self registerNotification];
    [self setDataWhenViewDidLoad];
    [self setViewWhenViewDidLoad];
    [super viewDidLoad];
    
}


/** Set data when view Will Appear. */
-(void) setDataWhenWillAppear
{
    
}


/** Begin view WillAppear */
-(void) viewWillAppear:(BOOL)animated
{
    [self setDataWhenWillAppear];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */



@end
