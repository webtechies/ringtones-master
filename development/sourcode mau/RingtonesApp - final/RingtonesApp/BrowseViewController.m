//
//  BrowseViewController.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowseViewController.h"
#import "Constants.h"
#import "CommonUtils.h"
#import "BrowseDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BrowseViewController(privateMethod)

- (void)handleTapCellForIndexPath:(NSIndexPath *)indexPath;
- (void)didPurchased:(NSNotification *)notif;

@end

@implementation BrowseViewController

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


#pragma Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    if (section == 0) {
        rowCount = 2;
    } else {
        rowCount = 3;
    }
//    return [arrSource count];
    
    return rowCount;
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
    [cell.imageView.layer setCornerRadius:CELL_IMAGE_CONRNER_RADIUS];
    
    NSInteger index = indexPath.row;
    
    NSString *title;
    
    NSString *imageName;
    
    if (indexPath.section == 0) {
        if (index == 0) {
            title = [arrSource objectAtIndex:0];
            imageName = @"icon_featured.png";
        } else {
            title = [arrSource objectAtIndex:1];
            imageName = @"icon_newest.png";
        }
    } else {
        if (index == 0) {
            title = [arrSource objectAtIndex:2];
            imageName = @"icon_toprate.png";
        } else if (index == 1){
            title = [arrSource objectAtIndex:3];
            imageName = @"icon_download.png";
        } else {
            title = [arrSource objectAtIndex:4];
            imageName = @"icon_comment.png";
        }
    }
    
    cell.textLabel.text = title;
    
    UIImage *image = [UIImage imageNamed:imageName];
    cell.imageView.image = image;
    
    
    
    return cell;
}

#pragma tableview delegate
- (void)handleTapCellForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    if (indexPath.section == 0) {
        index = indexPath.row;
    } else {
        index = 2 + indexPath.row;
    }

    
    BrowseDetailViewController *detail = [[BrowseDetailViewController alloc]initWithNibName:@"BrowseDetailViewController" bundle:nil dataSourceType:index];
    
    [self.navigationController pushViewController:detail animated:YES];
    [detail setTitle:[arrSource objectAtIndex:index]];
    
    [detail release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self handleTapCellForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

    [self handleTapCellForIndexPath:indexPath];
}


#pragma -Purchase delegate from App Delegate
- (void)purchaseDidFinish {
    [self didPurchased:nil];
    
    NSLog(@"purchaseDidFinish browse ");
}

- (void)purchaseDidFail {
    NSLog(@"purchaseDidFail browse ");
}

- (void)didPurchased:(NSNotification *)notif
{
    NSLog(@"did purchased on browse, remove banner");
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
    
    self.title = LOCALIZE(TITLE_VIEW_BROWSE);
    
    F_RELEASE(arrSource);
    
    arrSource = [[NSMutableArray alloc]init];
    
    [arrSource addObject:@"Featured"];
    [arrSource addObject:@"Newest"];
    [arrSource addObject:@"Top Rated"];
    [arrSource addObject:@"Most Downloaded"];
    [arrSource addObject:@"Most Commented"];

     
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
