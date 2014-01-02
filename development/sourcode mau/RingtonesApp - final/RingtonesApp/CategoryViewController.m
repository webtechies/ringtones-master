//
//  CategoryViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "CommonUtils.h"
#import "Constants.h"
#import "CategoryDetailViewController.h"




@interface CategoryViewController(methods)

- (void)doneLoadData:(ASIHTTPRequest *)request;    
- (void)didPurchased:(NSNotification *)notif;

@end

@implementation CategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
//    NSLog(@"call init category");
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma custom method
- (void)reloadDataSource;
{
    if (isDownloading) {
        return;
    }
    
    isDownloading = TRUE;
    
    NSString *urlServer = [NSString stringWithFormat:SERVER_API_GETLISTCAT];
    NSLog(@"urlServer: %@", urlServer);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlServer]];
    [request setDelegate:self];
    [request setTimeOutSeconds:kTimeoutGetRingtone];
    [request setFailedBlock:^{
        isDownloading = FALSE;
    }];
    
    [request setCompletionBlock:^{
        isDownloading = FALSE;
        F_RELEASE(arrSource);
        //get new source here
        arrSource = [[[RingtoneHelpers defaultHelper]convertDataToList:[request responseData]] retain];
        
        [mainTableView reloadData];
    }];
    
    [request startAsynchronous];
    
//    if ([request error] == nil) {
//        [self doneLoadData:request];
//    } else {
//        NSLog(@"FAILED load cat list");
//    }
    
    [request release];
    
}

- (void)doneLoadData:(ASIHTTPRequest *)request;
{
    isDownloading = FALSE;
    
    F_RELEASE(arrSource);
    //get new source here
    arrSource = [[[RingtoneHelpers defaultHelper]convertDataToList:[request responseData]] retain];
    
    [mainTableView reloadData];

}


#pragma Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrSource count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    NSDictionary *dict = [arrSource objectAtIndex:indexPath.row];
    NSString *title = [dict objectForKey:@"title"];
    cell.textLabel.text = title;
    
    return cell;
}

#pragma tableview delegate
- (void)handleTapCellForIndex:(NSInteger)index
{
    NSDictionary *dict = [arrSource objectAtIndex:index];
    
    CategoryDetailViewController *detail = [[CategoryDetailViewController alloc]initWithNibName:@"CategoryDetailViewController" bundle:nil category:dict];
    
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self handleTapCellForIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self handleTapCellForIndex:indexPath.row];
}



#pragma -Purchase delegate from App Delegate
- (void)purchaseDidFinish {
    [self didPurchased:nil];
    
    NSLog(@"purchaseDidFinish category ");
}

- (void)purchaseDidFail {
    NSLog(@"purchaseDidFail category ");
}

- (void)didPurchased:(NSNotification *)notif
{
    NSLog(@"did purchased on category, remove banner");
    //re-frame view and remove banner
    [viewBannerPlaceHolder removeFromSuperview];
    
    CGRect tableFrame = mainTableView.frame;
    CGFloat navHeight = 0;
    tableFrame.origin.y = navHeight;
    tableFrame.size.height = self.view.frame.size.height - navHeight;
    mainTableView.frame = tableFrame;

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LOCALIZE(TITLE_VIEW_CATEGORIES);
    
    
#ifdef kFullVersion
    [self didPurchased:nil];
#else
    
#ifdef kFreeVersion
    
    BOOL purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
    NSLog(@"purchased: %d", purchased);
    if (!purchased) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didPurchased:) name:kPurchaseKey object:nil];
#endif
        //add banner view
        banner = [[BannerViewController alloc]initWithNibName:@"BannerViewController" bundle:nil];
        
        banner.view.frame = CGRectMake(0.0f, 0.0f, viewBannerPlaceHolder.frame.size.width, viewBannerPlaceHolder.frame.size.height);
        [viewBannerPlaceHolder addSubview:banner.view];
        
        [banner startRandomAd]; 
        
#ifdef kFreeVersion
    } else {
        [self didPurchased:nil];
    }
#endif 
#endif

        // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [self reloadDataSource]; 
    
    
#ifdef kFreeVersion    
    BOOL purchased = [[[NSUserDefaults standardUserDefaults]objectForKey:kPurchaseKey] boolValue];
    NSLog(@"purchased: %d", purchased);
    if (purchased) {
        [self didPurchased:nil];
    }
#endif 

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    banner = nil;
    
    //remove observer
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
