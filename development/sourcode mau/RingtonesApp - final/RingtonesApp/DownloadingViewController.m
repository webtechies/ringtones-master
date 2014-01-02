//
//  DownloadingViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadingViewController.h"
#import "CommonUtils.h"
#import "Constants.h"
#import "DownloaderManager.h"
#import "ASIHTTPRequest.h"


@interface DownloadingViewController(privateMethods) 

- (void)reloadDataSource;
- (void)clearData;
- (void)handleTapCellForIndex:(NSInteger)index;
- (void)starTimer;
- (void)stopTimer;
- (void)timerTickUpdateDownloadingStatus;

@end


@implementation DownloadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma -custom methods
- (void)reloadDataSource;
{
//    F_RELEASE(arrSource);
//    
//    //get source here
//    arrSource = [[NSMutableArray alloc]initWithCapacity:4];
//    for (int i=0; i<4; i++) {
//        [arrSource addObject:[NSString stringWithFormat:@"cell: %d", i]];
//    }
    
    [mainTableView reloadData];
}

- (void)clearData;
{
    //remove queue
    [[[DownloaderManager defaultManager] networkQueue] cancelAllOperations];
       
//       
//    F_RELEASE(arrSource);
//    arrSource = [[NSMutableArray alloc]init];
    
    [mainTableView reloadData];
}

- (void)removeDownloadingForIndexPath:(id)sender;
{
    UIButton *button = (UIButton *)sender;
    
    NSInteger index = [[button titleForState:UIControlStateDisabled] intValue];
    NSLog(@"clicked for remove index: %d", index);
    
    isDeleting = YES;
    
    NSLog(@"BEFORE delete count: %d", [[[DownloaderManager defaultManager] networkQueue]operationCount]);
    if (index < [[[[DownloaderManager defaultManager] networkQueue] operations]count]) {
        ASIHTTPRequest *request = [[[[DownloaderManager defaultManager] networkQueue]operations]objectAtIndex:index];
        
//        [[[DownloaderManager defaultManager] networkQueue]requestFailed:request];

        [request removeTemporaryDownloadFile];
        [request cancel];
//        [request clearDelegatesAndCancel];
        
//        [request ];
        
        
    }

    NSLog(@"AFTER delete count: %d", [[[DownloaderManager defaultManager] networkQueue]operationCount]);

    
    isDeleting = FALSE;
    //reload the tableview 
    [mainTableView reloadData];

}


#pragma Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [arrSource count];
    return [[[DownloaderManager defaultManager] networkQueue] operationCount];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownloadingCell";
    
    downloadingCell = (DownloadingCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (downloadingCell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DownloadingCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[DownloadingCell class]])
            {
                downloadingCell = (DownloadingCell *)currentObject;
                break;
            }
        }
        
        downloadingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *buttonRemove = (UIButton *)[downloadingCell viewWithTag:4];
        [buttonRemove setTitle:[NSString stringWithFormat:@"%d", indexPath.row] forState:UIControlStateDisabled];
        [buttonRemove addTarget:self action:@selector(removeDownloadingForIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    if (indexPath.row < [[[[DownloaderManager defaultManager] networkQueue] operations]count]) {
        ASIHTTPRequest *request = [[[[DownloaderManager defaultManager] networkQueue]operations]objectAtIndex:indexPath.row];
        

        //get view by tag
        UILabel *labelName = (UILabel *)[downloadingCell viewWithTag:1];
        UIProgressView *progresView = (UIProgressView *)[downloadingCell viewWithTag:2];
        UILabel *labelStatus = (UILabel *)[downloadingCell viewWithTag:3];
        
        NSString *url = [[request url]absoluteString];
        labelName.text = url;
        NSArray *array = [url componentsSeparatedByString:@"/"];
        if (array != nil && [array count] > 0) {
            NSString *name = [array objectAtIndex:[array count] - 1];
            labelName.text = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSDictionary *dict = [request userInfo];
        
        

        if ([request isReady] && [request isExecuting]) {
            [request setDownloadProgressDelegate:progresView];
            
            [request updateDownloadProgress];
            
            unsigned long long downloadedSize = [request totalBytesRead];
            unsigned long long totalSize = [[dict objectForKey:@"file_size"] intValue];
            CGFloat downloaded = downloadedSize / 1024.0;
            CGFloat total = totalSize / 1024.0;
            
            
            CGFloat percent = (totalSize == 0) ?  0 : 100 * (float)downloadedSize/(float)totalSize;
            labelStatus.text = [NSString stringWithFormat:@"Downloaded:%.2fkb, Total:%.2fkb : %.2f%%", downloaded, total, percent];
        } else {
            
            if ([request isCancelled]) {
                NSLog(@"request cancelled at %d", indexPath.row);
            }

            NSError *error = [request error];
            
            if (error != nil) {
                NSLog(@"error %d: %@", indexPath.row, [error localizedDescription]);
            }
            [progresView setProgress:0.0f];
            
            //show ready text
            labelStatus.text = @"Preparing to download ...";
        }
        
    }

    
    
//    downloadingCell.textLabel.textAlignment = UITextAlignmentLeft;

    
    return downloadingCell;
}

#pragma tableview delegate
- (void)handleTapCellForIndex:(NSInteger)index
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self handleTapCellForIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self handleTapCellForIndex:indexPath.row];
}

#pragma Notification handler
- (void)doneDownloading:(NSNotification *)notif;
{
    NSLog(@"Receive notification DONE downloading");
    if (notif != nil) {
        
    }
    
    [mainTableView reloadData];
    [self stopTimer];
    
    //goto downloaded view
    
}

- (void)startDownloading:(NSNotification *)notif;
{
    NSLog(@"Receive notification START downloading");
    if (notif != nil) {
        
    }
    
    [mainTableView reloadData];
    [self starTimer];
}




- (void)starTimer;
{
    if (![timerDownloading isValid]) {
        timerDownloading = [NSTimer scheduledTimerWithTimeInterval:0.1 
                                                            target:self 
                                                          selector:@selector(timerTickUpdateDownloadingStatus) 
                                                          userInfo:nil repeats:YES];
    }
}

- (void)stopTimer;
{
    if ([timerDownloading isValid]) {
        [timerDownloading invalidate];
        timerDownloading = nil;
    }

}

- (void)timerTickUpdateDownloadingStatus;
{
    
//    F_RELEASE(arrSource);
    
    //list of downloading in queue
//    for (int i = 0; i < [[[DownloaderManager defaultManager] networkQueue] requestsCount]; i++) {
//        ASIHTTPRequest *request = [[[[DownloaderManager defaultManager] networkQueue]operations]objectAtIndex:i];
//        
//        
//    }
//    
    
    if (!isDeleting) {
//        NSLog(@"tick update");
        
        [mainTableView reloadData];
    }

}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self reloadDataSource];
    
    [self starTimer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doneDownloading:) name:kNotificationDoneDownloadRingtone object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startDownloading:) name:kNotificationStartDownloadRingtone object:nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self starTimer];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}

@end
