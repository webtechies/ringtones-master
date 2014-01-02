//
//  GSDropboxDestinationSelectionViewController.m
//
//  Created by Simon Whitaker on 06/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import "GSDropboxDestinationSelectionViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "GSDropboxUploader.h"
#define kDropboxConnectionMaxRetries 2

@interface GSDropboxDestinationSelectionViewController () <DBRestClientDelegate>
@property (nonatomic) BOOL isLoading;
@property (nonatomic) BOOL isStartDownload;
@property (nonatomic, strong) NSArray *subdirectories;
@property (nonatomic, strong) DBRestClient *dropboxClient;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *labelNumber;
@property (assign) int numberSuccess;
@property (nonatomic) NSUInteger dropboxConnectionRetryCount;

- (void)handleApplicationBecameActive:(NSNotification *)notification;
- (void)handleCancel;
- (void)handleSelectDestination;

@end

@implementation GSDropboxDestinationSelectionViewController
@synthesize progressView,numberDownload,isStartDownload,numberSuccess,labelNumber;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _isLoading = YES;
        self.dropboxConnectionRetryCount = 0;
    }
    return self;
}

- (void)dealloc
{
    //--[progressView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[super dealloc];
}

- (void)viewDidLoad
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
    
    [self.navigationController setNavigationBarHidden:NO];
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Đóng" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancel)];

    
    self.toolbarItems = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Chọn", @"Title for button that user taps to specify the current folder as the storage location for uploads.")
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(handleSelectDestination)]
    ];
    
    [self.navigationController setToolbarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.toolbar.tintColor = [UIColor darkGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationBecameActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(self.navigationController.toolbar.frame.size.width/2 - 150/2, self.navigationController.toolbar.frame.size.height/2 - 9/2, 150,9);
    self.progressView.hidden = YES;
    self.labelNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, self.navigationController.toolbar.frame.size.height)];
    [self.labelNumber setBackgroundColor:[UIColor clearColor]];
     self.labelNumber.hidden = YES;
    [self.navigationController.toolbar addSubview:self.labelNumber];
    [self.navigationController.toolbar addSubview:self.progressView];
    self.numberSuccess = 0;
    [self updateChooseButton];
  
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateChooseButton];
    
    if (self.rootPath == nil)
        self.rootPath = @"/";
    
    if ([self.rootPath isEqualToString:@"/"]) {
        self.title = @"Dropbox";
    } else {
        self.title = [self.rootPath lastPathComponent];
    }
    self.navigationItem.prompt = NSLocalizedString(@"Chọn vị trí để tải lên.", @"Prompt asking user to select a destination folder on Dropbox to which uploads will be saved.") ;
    self.isLoading = YES;
 
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void) updateChooseButton {
    NSArray* toolbarButtons = self.toolbarItems;
    if(toolbarButtons.count < 2) {
        //Not found
        return;
    }
    UIBarButtonItem *item = toolbarButtons[1];
    if (self.isStartDownload == YES)
    {
        item.enabled = NO;
        return;
    }
    BOOL hasValidData = [self hasValidData];
    item.enabled = hasValidData;
}

- (BOOL) hasValidData {
    BOOL valid = self.subdirectories != nil && self.isLoading == NO;
    return valid;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[DBSession sharedSession] isLinked]) {
        [self showLoginDialogOrCancel];
    } else {
        [self.dropboxClient loadMetadata:self.rootPath];
    }
}

- (void) showLoginDialogOrCancel {
    if(self.dropboxConnectionRetryCount < kDropboxConnectionMaxRetries) {
        self.dropboxConnectionRetryCount++;
        //disable cancel button, as if the user pressed it while we're presenting
        //the loging viewcontroller (async), UIKit crashes with multiple viewcontroller
        //animations
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [[DBSession sharedSession] linkFromController:self];
    } else {
        [self.delegate dropboxDestinationSelectionViewControllerDidCancel:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (DBRestClient *)dropboxClient
{
    if (_dropboxClient == nil && [DBSession sharedSession] != nil) {
        _dropboxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _dropboxClient.delegate = self;
    }
    return _dropboxClient;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self hasValidData] || self.subdirectories.count < 1) return 1;

    return [self.subdirectories count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (self.isLoading) {
        cell.textLabel.text = NSLocalizedString(@"Xin chờ...", @"Progress message while app is loading a list of folders from Dropbox");
    } else if (self.subdirectories == nil) {
        cell.textLabel.text = NSLocalizedString(@"Error loading folder contents", @"Error message if the app couldn't load a list of a folder's contents from Dropbox");
    } else if ([self.subdirectories count] == 0) {
        cell.textLabel.text = NSLocalizedString(@"Chưa có dữ liệu", @"Status message when the current folder contains no sub-folders");
    } else {
        cell.textLabel.text = [[self.subdirectories objectAtIndex:indexPath.row] lastPathComponent];
        cell.imageView.image = [UIImage imageNamed:@"folder-icon.png"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.subdirectories count] > indexPath.row) {
        GSDropboxDestinationSelectionViewController *vc = [[GSDropboxDestinationSelectionViewController alloc] init];
        vc.delegate = self.delegate;
        vc.rootPath = [self.rootPath stringByAppendingPathComponent:[self.subdirectories objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        [self updateChooseButton];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Dropbox client delegate methods

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    NSMutableArray *array = [NSMutableArray array];
    for (DBMetadata *file in metadata.contents) {
        if (file.isDirectory && [file.filename length] > 0 && [file.filename characterAtIndex:0] != '.') {
            [array addObject:file.filename];
        }
    }
    self.subdirectories = [array sortedArrayUsingSelector:@selector(compare:)];
    self.isLoading = NO;
    [self updateChooseButton];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    // Error 401 gets returned if a token is invalid, e.g. if the user has deleted
    // the app from their list of authorized apps at dropbox.com
    if (error.code == 401) {
        [self showLoginDialogOrCancel];
    } else {
        self.isLoading = NO;
    }
    [self updateChooseButton];
}

- (void)setIsLoading:(BOOL)isLoading
{
    if (_isLoading != isLoading) {
        _isLoading = isLoading;
        [self.tableView reloadData];
    }
}

- (void)handleCancel
{
    id<GSDropboxDestinationSelectionViewControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dropboxDestinationSelectionViewControllerDidCancel:)]) {
        [delegate dropboxDestinationSelectionViewControllerDidCancel:self];
    }
}

- (void)handleSelectDestination
{
    if (self.isStartDownload == YES) {
        return;
    }
    id<GSDropboxDestinationSelectionViewControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(dropboxDestinationSelectionViewController:didSelectDestinationPath:)])
    {
    
        [delegate dropboxDestinationSelectionViewController:self
                                   didSelectDestinationPath:self.rootPath];
        
    }
}

- (void)handleApplicationBecameActive:(NSNotification *)notification
{
    // Happens after user has been bounced out to Dropbox.app or Safari.app
    // to authenticate
    [self.dropboxClient loadMetadata:self.rootPath];
    self.isLoading = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self updateChooseButton];
}



- (void)handleDropboxFileProgressNotification:(NSNotification *)notification
{
    
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    float progress = [notification.userInfo[GSDropboxUploaderProgressKey] floatValue];
    //NSLog(@"Upload of %@ now at %.0f%%", fileURL.absoluteString, progress * 100);
    //NSLog(@"self.numberDownload %@",self.numberDownload);
    [self.labelNumber setText:[NSString stringWithFormat:@"(%d/%@)",self.numberSuccess + 1,self.numberDownload]];
     self.progressView.progress = progress;
}



- (void)handleDropboxUploadDidStartNotification:(NSNotification *)notification
{

    self.isStartDownload = YES;
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    //NSLog(@"Started uploading %@", fileURL.absoluteString);
    self.progressView.hidden = NO;
    self.progressView.progress = 0.0;
    self.labelNumber.hidden = NO;
    [self updateChooseButton];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)handleDropboxUploadDidFinishNotification:(NSNotification *)notification
{
    self.numberSuccess ++ ;
    if (self.numberSuccess == [self.numberDownload integerValue]) {
        self.isStartDownload = NO;
        UIAlertView *aleview = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Upload dữ liệu thành công" delegate:self cancelButtonTitle:@"Đồng ý" otherButtonTitles: nil];
        [aleview show];
        aleview.tag =100;
       
    }
    else{
        
        self.isStartDownload = YES;
    }
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    //NSLog(@"Finished uploading %@", fileURL.absoluteString);
    
    self.progressView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
         [self dismissViewControllerAnimated:YES completion:^{
             
         }];
    }
}

- (void)handleDropboxUploadDidFailNotification:(NSNotification *)notification
{
    NSURL *fileURL = notification.userInfo[GSDropboxUploaderFileURLKey];
    NSLog(@"Lỗi upload %@", fileURL.absoluteString);
    self.isStartDownload = NO;
    self.progressView.hidden = YES;
    self.labelNumber.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



@end
