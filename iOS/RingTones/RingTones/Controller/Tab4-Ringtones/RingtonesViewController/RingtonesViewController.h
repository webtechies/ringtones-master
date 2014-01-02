//
//  RingtonesViewController.h
//  RingTones
//
//  Created by Vuong Nguyen on 12/13/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "RingtoneTabelCell.h"
#import "MainMakerViewController.h"
#import "HelpViewController.h"
#import "Config.h"

//for audio streamer
#import "AudioStreamer.h"
#import <AVFoundation/AVFoundation.h>


//for gropbox sharing
#import "GSDropboxActivity.h"
#import "GSDropboxUploader.h"
#import "GSDropboxDestinationSelectionViewController.h"

@interface RingtonesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, RingtoneTabelCellDelegate, GSDropboxDestinationSelectionViewControllerDelegate>

{
    
    
    __weak IBOutlet UITableView *tableView_Ringtones;
    NSIndexPath *selectedIndex;
    RingtoneTabelCell *editingCell;
    MainMakerViewController *makerView;
    
    //sharing
    UIPopoverController *activityPopoverController;
    
    //view top cell
   IBOutlet UIView *view_TopCell;
    __weak IBOutlet UIButton *btn_Downloaded;
    __weak IBOutlet UIButton *btn_MyRingtones;
    __weak IBOutlet UIImageView *imageView_TopCell;
    
    
    //Rename View
    IBOutlet UIView *view_Rename;
    __weak IBOutlet UITextField *textField_Rename;
    
    
    //audio streamer
    AudioStreamer *streamer;
    AVPlayer *player;
	NSTimer *playbackTimer;

    //sort view
    IBOutlet UIView *view_SortRingtones;
    __weak IBOutlet UIImageView *imageView_NameChecked;
    
    __weak IBOutlet UIImageView *imageView_DurationChecked;
    
    __weak IBOutlet UIImageView *imageView_DateChecked;
    
     __weak IBOutlet UIButton *btn_SortOption;
}





//sort view action
- (IBAction)btn_SortByName_Tapped:(id)sender;
- (IBAction)btn_SortByDuration_Tapped:(id)sender;
- (IBAction)btn_SortByDate_Tapped:(id)sender;
- (IBAction)btn_SortOption_Tapped:(id)sender;


//view top cell
- (IBAction)btn_Downloaded_Tapped:(id)sender;
- (IBAction)btn_MyRingtones_Tapped:(id)sender;




@end
