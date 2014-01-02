//
//  RingtonesViewController.m
//  RingTones
//
//  Created by Vuong Nguyen on 12/13/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "RingtonesViewController.h"

#define kDownloadedTapImage @"Top_cell1.png"
#define kMyRingtonesTapImage @"Top_cell2.png"

@interface RingtonesViewController ()
{
    UIImageView *animationImageView;
    NSMutableArray *listRingtones;
    BOOL isDownloaded;
   
    UIButton *leftBarButton;
    UIButton *rightBarButton;
    //UIActivityViewController *activityViewController;

}
@end

@implementation RingtonesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
#pragma mark  - ViewDidLoad


/** Register notification center for view controller */
-(void) registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDropboxFileProgressNotification:)
                                                 name:GSDropboxUploaderDidGetProgressUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDropboxUploadDidStartNotification:)
                                                 name:GSDropboxUploaderDidStartUploadingFileNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDropboxUploadDidFinishNotification:)
                                                 name:GSDropboxUploaderDidFinishUploadingFileNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDropboxUploadDidFailNotification:)
                                                 name:GSDropboxUploaderDidFailNotification
                                               object:nil];
}




/** Set data when view did load.
 ** Be there. You can set up some variables, data, or any thing that have reletive to data type*/
-(void) setDataWhenViewDidLoad
{
    
    [self setVisualForTopCellDownloadedTap:YES];
    
}




/** Set view when view did load
 ** Be there. You can change the layout, view, button,..*/
-(void) setViewWhenViewDidLoad
{
    
    //[self loadViewForDevice];
    [self setUpAnimationLoading];
    tableView_Ringtones.delegate = self;
    tableView_Ringtones.dataSource = self;
    
    [self btn_SortByName_Tapped:nil];
    [self attachHelpButtonIntoNavBar];
    [self btn_Downloaded_Tapped:nil];
    view_Rename.hidden = YES;
    //[self setVisualForSegmentControl];
    
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
    if (isDownloaded)
    {
        [self initListDownloadedRingtone];
    }
    else
    {
        [self initListMyRingtone];
    }
}


/** Begin view WillAppear */
-(void) viewWillAppear:(BOOL)animated
{
    [self setDataWhenWillAppear];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [player pause];
    player = nil;
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */



#pragma mark -
#pragma mark Init list ringtones
/******************************************************************************/

//-------------------------------------------------------
//
-(void)initListDownloadedRingtone
{
    SongModel *songModel = [SongModel new];
    listRingtones = [songModel getDownloadeRingtonesInSongTable];
    songModel = nil;
    [tableView_Ringtones reloadData];
}




//-------------------------------------------------------
//
-(void)initListMyRingtone
{
    SongModel *songModel = [SongModel new];
    listRingtones = [songModel getMyRingtonesInSongTable];
    songModel = nil;
    [tableView_Ringtones reloadData];

}


/******************************************************************************/





#pragma mark -
#pragma mark Set Visual For View
/******************************************************************************/

//-------------------------------------------------------
//
-(void)loadViewForDevice
{
    NSString *nibNameString = [Common checkDevice:@"RingtonesViewController"];
    [[NSBundle mainBundle] loadNibNamed:nibNameString owner:self options:nil];
}







//-------------------------------------------------------
//
-(void)attachHelpButtonIntoNavBar
{
    //Show custom image
    UIImage *image = [UIImage imageNamed:@"Btn_help.png"];

    
    //right button
    rightBarButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightBarButton setTitle:@"" forState:UIControlStateNormal];
    rightBarButton.adjustsImageWhenHighlighted = YES;
    [rightBarButton setTitleColor:[UIColor colorWithRed:255/255.0f green:45/255.0f blue:85/255.0f alpha:1] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(btn_RightBar_Tapped:)forControlEvents:UIControlEventTouchUpInside];
    
    [rightBarButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];



    //left button
    leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    [leftBarButton setTitle:@"" forState:UIControlStateNormal];
    leftBarButton.adjustsImageWhenHighlighted = YES;
    [leftBarButton setTitleColor:[UIColor colorWithRed:255/255.0f green:45/255.0f blue:85/255.0f alpha:1] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(btn_Cancel_Tapped:)forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setFrame:CGRectMake(0, 0, 65, 20)];

    UIBarButtonItem *leftNavButton = [[UIBarButtonItem alloc]initWithCustomView:leftBarButton];
    
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 5;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,rightNavButton, nil];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftNavButton, nil];
    
    
}

-(void)changeBarButtonWhenEdit
{
    [rightBarButton setFrame:CGRectMake(0, 0, 45, 20)];
    [rightBarButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    [rightBarButton setTitle:@"Save" forState:UIControlStateNormal];
 
    
    [leftBarButton setTitle:@"Cancel" forState:UIControlStateNormal];

}

-(void)changeBarButtonWhenNotEdit
{
    //Show custom image
    UIImage *image = [UIImage imageNamed:@"Btn_help.png"];
    [rightBarButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightBarButton setTitle:@"" forState:UIControlStateNormal];
    [rightBarButton setFrame:CGRectMake(rightBarButton.frame.origin.x, rightBarButton.frame.origin.y, image.size.width, image.size.height)];

    [leftBarButton setTitle:@"" forState:UIControlStateNormal];
}

/******************************************************************************/






#pragma mark -
#pragma mark Actions
/******************************************************************************/


//-------------------------------------------------------
//
- (IBAction)btn_Downloaded_Tapped:(id)sender {
    [self setVisualForTopCellDownloadedTap:YES];
}




//-------------------------------------------------------
//
- (IBAction)btn_MyRingtones_Tapped:(id)sender {
    [self setVisualForTopCellDownloadedTap:NO];
}




//-------------------------------------------------------
//
-(void)setVisualForTopCellDownloadedTap: (BOOL)downloaded
{
    isDownloaded = downloaded;
    
    if (downloaded)
    {
        imageView_TopCell.image = [UIImage imageNamed:kDownloadedTapImage];
        [self initListDownloadedRingtone];
        
        [btn_Downloaded setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_MyRingtones setTitleColor:[UIColor colorWithRed:255/255.0f green:45/255.0f blue:85/255.0f alpha:1] forState:UIControlStateNormal];
    }
    else
    {
        imageView_TopCell.image = [UIImage imageNamed:kMyRingtonesTapImage];
         [self initListMyRingtone];
        
        [btn_Downloaded setTitleColor:[UIColor colorWithRed:255/255.0f green:45/255.0f blue:85/255.0f alpha:1] forState:UIControlStateNormal];
        [btn_MyRingtones setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}


/******************************************************************************/




#pragma mark -
#pragma mark Table view

/******************************************************************************/

#pragma mark -
#pragma mark Table view data source

//-------------------------------------------------------
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


//-------------------------------------------------------
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    
    return listRingtones.count;
}




//-------------------------------------------------------
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
         CellIdentifier = @"RingtoneiPadCell";
    }
    else
    {
        CellIdentifier = @"RingtoneTableCell";
    }
    
    
    //-- try to get a reusable cell --
    RingtoneTabelCell *cell = (RingtoneTabelCell *) [tableView_Ringtones dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //-- create new cell if no reusable cell is available --
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    if (cell == nil) {
        
         cell = (RingtoneTabelCell *) [nib objectAtIndex:0];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    SongField *songField = (SongField *)[listRingtones objectAtIndex:indexPath.row];
    
    
    //textfield ringtone name
    cell.textField_RingtoneName.text = songField.name;
    cell.textField_RingtoneName.enabled = NO;
    cell.textField_RingtoneName.delegate = self;
    
    //btn share
    [cell.btn_Share addTarget:self action:@selector(btn_Share_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Share.tag = indexPath.row;
    
    //btn edit
    [cell.btn_Edit addTarget:self action:@selector(btn_Edit_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Edit.tag = indexPath.row;
    
    
    //btn rename
    [cell.btn_Rename addTarget:self action:@selector(btn_Rename_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Rename.tag = indexPath.row;
    
    
    //btn delete
    [cell.btn_Delete addTarget:self action:@selector(btn_Delete_Tapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Delete.tag = indexPath.row;
    
    
    cell.imageView_Loading.hidden = YES;
    cell.label_playerTimer.hidden = YES;
    
    

    return cell;
}



//-------------------------------------------------------
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return view_TopCell.frame.size.height;
}


//-------------------------------------------------------
//
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return view_TopCell;
}



#pragma mark -
#pragma mark Table view delegate

//-------------------------------------------------------
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //if there's any cell is edit return to non-edit
    [editingCell hideBackView];
    
    if (!selectedIndex)
    {
        selectedIndex = indexPath;
    }

    RingtoneTabelCell *cell = (RingtoneTabelCell *)[tableView_Ringtones cellForRowAtIndexPath:selectedIndex];
    cell.label_playerTimer.hidden = YES;


    //set for current cell
    selectedIndex = indexPath;
    cell = (RingtoneTabelCell *)[tableView_Ringtones cellForRowAtIndexPath:indexPath];
    SongField *songField = (SongField *)[listRingtones objectAtIndex:indexPath.row];
    
    
    cell.imageView_Loading.hidden = NO;
    [cell.imageView_Loading addSubview:animationImageView];
    [animationImageView startAnimating];
    
    //buffering audio from path
    NSURL *url;
    
    if ([songField.type isEqualToString:@"0"])
    {
        url = [[NSURL alloc] initFileURLWithPath: [NSString stringWithFormat:@"%@.m4r", [Common savePathForDownloadedRingtonesWithRingtoneName:songField.name]]];
    }
    else
    {
        url = [[NSURL alloc] initFileURLWithPath: [NSString stringWithFormat:@"%@.m4r", [Common savePathForCreatedRingtonesWithRingtoneName:songField.name]]];
    }
    
    [self setupAVPlayerForURL:url];
	   
    

}



//-------------------------------------------------------
//
-(UIImageView *)setUpAnimationLoading
{
    // Load images
    NSArray *imageNames = @[@"ProgressGear1_Gray_small.png",
                            @"ProgressGear2_Gray_small.png",
                            @"ProgressGear3_Gray_small.png",
                            @"ProgressGear4_Gray_small.png",
                            @"ProgressGear5_Gray_small.png",
                            @"ProgressGear6_Gray_small.png",
                            @"ProgressGear7_Gray_small.png",
                            @"ProgressGear8_Gray_small.png",
                            @"ProgressGear9_Gray_small.png",
                            @"ProgressGear10_Gray_small.png",
                            @"ProgressGear11_Gray_small.png",
                            @"ProgressGear12_Gray_small.png",
                            @"ProgressGear13_Gray_small.png",
                            @"ProgressGear14_Gray_small.png",
                            @"ProgressGear15_Gray_small.png",
                            @"ProgressGear16_Gray_small.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
    animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 15)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 0.5;
    
    return animationImageView;
    
}


//-------------------------------------------------------
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


/******************************************************************************/






#pragma mark -
#pragma mark TEXT
/******************************************************************************/
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [tableView_Ringtones setContentOffset:CGPointMake(0, 120) animated:YES];
    tableView_Ringtones.scrollEnabled = NO;
}


//-------------------------------------------------------
//
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveRingtoneChanges];
    tableView_Ringtones.scrollEnabled = YES;
    return YES;
}

//-------------------------------------------------------
//
-(void)saveRingtoneChanges
{
    RingtoneTabelCell *cell = (RingtoneTabelCell *)[tableView_Ringtones cellForRowAtIndexPath:selectedIndex];
    SongField *songField = (SongField *)[listRingtones objectAtIndex:selectedIndex.row];
    SongModel *songModel = [SongModel new];
    songField.name = cell.textField_RingtoneName.text;
    [songModel updateRowInSongTable:songField];
    songModel = nil;
    
    [self exitRenameMode];

}


-(void)exitRenameMode
{
    RingtoneTabelCell *cell = (RingtoneTabelCell *)[tableView_Ringtones cellForRowAtIndexPath:selectedIndex];
    
    [cell.textField_RingtoneName resignFirstResponder];
    cell.textField_RingtoneName.enabled = NO;
    
    [cell hideBackView];
    [self hideDimBackground];
    
    //Enable another function
    btn_SortOption.userInteractionEnabled = YES;
    view_TopCell.userInteractionEnabled = YES;
}
/******************************************************************************/




#pragma mark -
#pragma mark Cell Actions
/******************************************************************************/
//-------------------------------------------------------
//
-(void)editingCell:(RingtoneTabelCell *)cell
{
    if (editingCell != cell)
    {
        [editingCell hideBackView];
        editingCell = cell;
    }
   
    
}


//-------------------------------------------------------
//
-(void)btn_Share_Tapped: (UIButton *)sender
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];


    
    
    [self shareRingtoneWithRingtoneIndex:index andButton:sender];
}


//-------------------------------------------------------
//
-(void)btn_Rename_Tapped:(UIButton *)sender
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    selectedIndex = index;
    RingtoneTabelCell *cell = (RingtoneTabelCell *)[tableView_Ringtones cellForRowAtIndexPath:selectedIndex];
    
    
    [cell btn_Rename_Tapped:nil];
    cell.textField_RingtoneName.enabled = YES;
    [cell.textField_RingtoneName becomeFirstResponder];
    [self dimBackgroundWhenRenameCell:cell];

    [self changeBarButtonWhenEdit];

    //Disable another function
    btn_SortOption.userInteractionEnabled = NO;
    view_TopCell.userInteractionEnabled = NO;
    
    
}



//-------------------------------------------------------
//
-(void)btn_Edit_Tapped:(UIButton *)sender
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];

    makerView = [MainMakerViewController new];
    SongField *songField = (SongField *)[listRingtones objectAtIndex:index.row];
    makerView.songid = songField.rowid;
    [self.navigationController pushViewController:makerView animated:YES];
}



//-------------------------------------------------------
//
-(void)btn_Delete_Tapped:(UIButton *)sender
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
   // RingtoneTabelCell *cell = (RingtoneTabelCell *)[tableView_Ringtones cellForRowAtIndexPath:index];
    
    
    SongField *songField = (SongField *)[listRingtones objectAtIndex:index.row];
    SongModel *songModel = [SongModel new];
    [songModel deleteRowByRowId:songField.rowid];
    [listRingtones removeObjectAtIndex:index.row];
    songModel = nil;
    [tableView_Ringtones reloadData];
    
}

/******************************************************************************/



#pragma mark -
#pragma mark SortView Actions
/******************************************************************************/

//-------------------------------------------------------
//
- (IBAction)btn_SortByName_Tapped:(id)sender
{
    [self resetSortOption];
    imageView_NameChecked.hidden = NO;
    [self sortRingtonesByName];
    [self btn_SortOption_Tapped:nil];
}



//-------------------------------------------------------
//
- (IBAction)btn_SortByDuration_Tapped:(id)sender
{
    [self resetSortOption];
    imageView_DurationChecked.hidden = NO;
    [self sortRingtonesByDuration];
    [self btn_SortOption_Tapped:nil];
}


//-------------------------------------------------------
//
- (IBAction)btn_SortByDate_Tapped:(id)sender
{
    [self resetSortOption];
    imageView_DateChecked.hidden = NO;
    [self sortRingtonesByDate];
    [self btn_SortOption_Tapped:nil];
}



//-------------------------------------------------------
//
- (IBAction)btn_SortOption_Tapped:(id)sender
{
    if (view_SortRingtones.hidden)
    {
        view_SortRingtones.hidden = NO;
        [self dimBackgroundWhenSort];
    }
    else
    {
        view_SortRingtones.hidden = YES;
        [self hideDimBackground];
    }
    
}



//-------------------------------------------------------
//
-(void)resetSortOption
{
    imageView_NameChecked.hidden = YES;
    imageView_DurationChecked.hidden = YES;
    imageView_DateChecked.hidden = YES;
}

/******************************************************************************/



#pragma mark -
#pragma mark Sort Methods
/******************************************************************************/

//-------------------------------------------------------
//
-(void)sortRingtonesByName
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    listRingtones = [NSMutableArray arrayWithArray:[listRingtones sortedArrayUsingDescriptors:sortDescriptors]];
    
    
    [listRingtones sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         SongField *songField1 = obj1;
         SongField *songField2 = obj2;
         
         return [songField1.name caseInsensitiveCompare:songField2.name];
         return YES;
     }];
    
    //reload table
    [tableView_Ringtones reloadData];
}



//-------------------------------------------------------
//
-(void)sortRingtonesByDate
{
    
    NSMutableArray *tempArray=[NSMutableArray array];
    for(int i=0;i<[listRingtones count];i++)
    {
        
        NSDateFormatter *df = [NSDateFormatter new];
        SongField *objModel=[listRingtones objectAtIndex:i];
        NSString *inspectionDateTime = objModel.date;
        
        NSRange range = [inspectionDateTime rangeOfString:@"-"];
        if (range.location != NSNotFound)
        {
            inspectionDateTime = [inspectionDateTime stringByReplacingCharactersInRange:range withString:@" "];
        }
        
        [df setDateFormat:@"yyyy MM-dd_HH:mm:ss"];
        NSDate *date=[df dateFromString:inspectionDateTime];
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:objModel forKey:@"entity"];
        [dict setObject:date forKey:@"date"];
        [tempArray addObject:dict];
    }
    
    NSInteger counter=[tempArray count];
    NSDate *compareDate;
    NSInteger index;
    for(int i=0;i<counter;i++)
    {
        index=i;
        compareDate=[[tempArray objectAtIndex:i] valueForKey:@"date"];
        NSDate *compareDateSecond;
        for(int j=i+1;j<counter;j++)
        {
            compareDateSecond=[[tempArray objectAtIndex:j] valueForKey:@"date"];
            NSComparisonResult result = [compareDate compare:compareDateSecond];
            if(result == NSOrderedAscending)
            {
                compareDate=compareDateSecond;
                index=j;
            }
        }
        if(i!=index)
            [tempArray exchangeObjectAtIndex:i withObjectAtIndex:index];
    }
    
    
    [listRingtones removeAllObjects];
    
    for(int i=0;i<[tempArray count];i++)
    {
        [listRingtones addObject:[[tempArray objectAtIndex:i] valueForKey:@"entity"]];
    }
    
    listRingtones = [NSMutableArray arrayWithArray:[[listRingtones reverseObjectEnumerator] allObjects]];
    
    //  reload table
    [tableView_Ringtones reloadData];
    
}



//-------------------------------------------------------
//
-(void)sortRingtonesByDuration
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"duration" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    listRingtones = [NSMutableArray arrayWithArray:[listRingtones sortedArrayUsingDescriptors:sortDescriptors]];
    
    
    [listRingtones sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         SongField *songField1 = obj1;
         SongField *songField2 = obj2;
         
         return [songField1.duration caseInsensitiveCompare:songField2.duration];
         return YES;
     }];
    
    //reload table
    [tableView_Ringtones reloadData];
}

/******************************************************************************/




#pragma mark -
#pragma mark Audio Streaming
/******************************************************************************/

//-------------------------------------------------------
//
-(void) setupAVPlayerForURL: (NSURL*) url {
    if (player)
    {
        player = nil;
    }
    AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
    
    player = [AVPlayer playerWithPlayerItem:anItem];
    [player addObserver:self forKeyPath:@"status" options:0 context:nil];
}

//-------------------------------------------------------
//
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (object == player && [keyPath isEqualToString:@"status"])
    {
        if (player.status == AVPlayerStatusFailed)
        {
            NSLog(@"AVPlayer Failed");
        }
        else if (player.status == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"AVPlayer Ready to Play");
            [player removeObserver:self forKeyPath:@"status"];
            playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
            
            [player play];
        }
        else if (player.status == AVPlayerItemStatusUnknown)
        {
            NSLog(@"AVPlayer Unknown");
        }
    }
}


//-------------------------------------------------------
//
- (void)updateTimer:(NSTimer*)timer
{
    [self updateDisplay];
}



#pragma mark - Display Update

//-------------------------------------------------------
//
- (void)updateDisplay
{
    
    AVPlayerItem *currentItem = player.currentItem;
    
    float currentTime = CMTimeGetSeconds(currentItem.currentTime);
    float duration = CMTimeGetSeconds(currentItem.duration);
    
    RingtoneTabelCell *cell = (RingtoneTabelCell *)[tableView_Ringtones cellForRowAtIndexPath:[tableView_Ringtones indexPathForSelectedRow]];
    
    [animationImageView stopAnimating];
    cell.imageView_Loading.hidden = YES;
    cell.label_playerTimer.hidden = NO;
    cell.label_playerTimer.text = [Common returnMusicTimeFormatWithValue:duration - currentTime];
    if (duration - currentTime == 0)
    {
        cell.label_playerTimer.hidden = YES;

    }
    
}




/******************************************************************************/



#pragma mark -
#pragma mark Sharing Methods
/******************************************************************************/
- (void)shareRingtoneWithRingtoneIndex: (NSIndexPath *)index andButton:(UIButton *)button
{
     RingtoneTabelCell *cell = (RingtoneTabelCell *)[tableView_Ringtones cellForRowAtIndexPath:index];
    
    SongField *songField = (SongField *)[listRingtones objectAtIndex:index.row];
    NSString *sharingString = [NSString stringWithFormat:KPostStatus, songField.name, songField.url];
        
    
    NSURL *ringtoneFileUrl;
    
    if ([songField.type isEqualToString:@"0"])
    {
        ringtoneFileUrl = [[NSURL alloc] initFileURLWithPath: [NSString stringWithFormat:@"%@.m4r", [Common savePathForDownloadedRingtonesWithRingtoneName:songField.name]]];
    }
    else
    {
        ringtoneFileUrl = [[NSURL alloc] initFileURLWithPath: [NSString stringWithFormat:@"%@.m4r", [Common savePathForCreatedRingtonesWithRingtoneName:songField.name]]];
    }

    
    NSArray *objectsToShare = @[sharingString, ringtoneFileUrl];
    NSArray *activities = @[[[GSDropboxActivity alloc] init]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:activities];
    
    // Exclude some default activity types to keep this demo clean and simple.
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                 UIActivityTypeCopyToPasteboard,
                                UIActivityTypeMessage,
                                 UIActivityTypePostToWeibo,
                                 UIActivityTypePrint,];
    
  
    
    //show sharing menu
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        if (activityPopoverController.isPopoverVisible)
        {
            // If the popover's visible, hide it
            [activityPopoverController dismissPopoverAnimated:YES];
        }
        else
        {
            if (activityPopoverController == nil) {
                activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            }
            else
            {
                activityPopoverController.contentViewController = activityViewController;
            }
            
            // Set a completion handler to dismiss the popover
            [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed){
                [activityPopoverController dismissPopoverAnimated:YES];
            }];
            
            [activityPopoverController presentPopoverFromRect:CGRectMake(button.frame.origin.x, cell.center.y, button.frame.size.width, button.frame.size.height) inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
    else
    {
        
        
        [self presentViewController:activityViewController animated:YES completion:NULL];
    }
    
    
    
 
}



//-------------------------------------------------------
//
- (void)handleDropboxFileProgressNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    float progress = [notification.userInfo[GSDropboxUploaderProgressKey] floatValue];
    NSLog(@"Upload of %@ now at %.0f%%", fileURL.absoluteString, progress * 100);
    
    //self.progressView.progress = progress;
}

- (void)handleDropboxUploadDidStartNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    NSLog(@"Started uploading %@", fileURL.absoluteString);
    
    [self showMessageWithTitleWithMessage:@"Ringtone has been uploading in background! You will recieve notify when it's done"];
    //self.progressView.progress = 0.0;
    //self.progressView.hidden = NO;
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)handleDropboxUploadDidFinishNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    NSLog(@"Finished uploading %@", fileURL.absoluteString);
    
    [self showMessageWithTitleWithMessage:@"Ringtone has been uploaded"];
    //self.progressView.hidden = YES;
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)handleDropboxUploadDidFailNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    NSLog(@"Failed to upload %@", fileURL.absoluteString);
    [self showMessageWithTitleWithMessage:@"Upload failed! Please check your connection and try again"];
    //self.progressView.hidden = YES;
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
/******************************************************************************/




#pragma mark -
#pragma mark Bar Buttons
/******************************************************************************/
-(void)btn_RightBar_Tapped: (UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"Save"])
    {
        [self saveRingtoneChanges];

    }
    else
    {
        HelpViewController *helpView = [HelpViewController new];
        helpView.isHelp = YES;
        [self.navigationController pushViewController:helpView animated:YES];
    }
}


-(void)btn_Cancel_Tapped: (id)sender
{
    [self changeBarButtonWhenNotEdit];
    [self exitRenameMode];
    
}
/******************************************************************************/



#pragma mark -
#pragma mark Dim background
/******************************************************************************/

//-------------------------------------------------------
//dim when searchbar active
-(void)dimBackgroundWhenSort
{
    UIView *dimBackground = [[UIView alloc] initWithFrame:CGRectMake(0, view_SortRingtones.frame.origin.y, tableView_Ringtones.frame.size.width, tableView_Ringtones.frame.size.height)];
    dimBackground.tag = 1000;
    dimBackground.backgroundColor = [UIColor blackColor];
    dimBackground.alpha = 0.5;
    [self.view insertSubview:dimBackground belowSubview:view_SortRingtones];
	
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    dimBackground.alpha = 0.5;
    [UIView commitAnimations];
}




//-------------------------------------------------------
//light when searchbar inactive
-(void)hideDimBackground
{
    for(UIView *subView in self.view.subviews)
        if (subView.tag == 1000)
        {
            [UIView beginAnimations:@"FadeOut" context:nil];
            [UIView setAnimationDuration:0.5];
            subView.alpha = 0.0;
            [UIView commitAnimations];
            
            [subView removeFromSuperview];
        }
}



//-------------------------------------------------------
//
-(void)dimBackgroundWhenRenameCell: (RingtoneTabelCell *)cell
{
    UIView *dimTopBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 44, tableView_Ringtones.frame.size.width, cell.frame.origin.y - 44)];
    dimTopBackground.tag = 1000;
    dimTopBackground.backgroundColor = [UIColor blackColor];
    dimTopBackground.alpha = 0.5;
    [self.view addSubview:dimTopBackground];
	
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    dimTopBackground.alpha = 0.5;
    [UIView commitAnimations];
    
    UIView *dimBottomBackground = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.origin.y + cell.frame.size.height, cell.frame.size.width, tableView_Ringtones.frame.size.height - cell.frame.size.height)];
    dimBottomBackground.tag = 1000;
    dimBottomBackground.backgroundColor = [UIColor blackColor];
    dimBottomBackground.alpha = 0.5;
    [self.view addSubview:dimBottomBackground];
	
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    dimBottomBackground.alpha = 0.5;
    [UIView commitAnimations];

}
/******************************************************************************/



//-------------------------------------------------------

-(void) showMessageWithTitleWithMessage:(NSString *) message
{
    UIAlertView *alertview = nil;
    alertview = [[UIAlertView alloc] initWithTitle:@"Ringtone" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alertview show];
    
}

@end
