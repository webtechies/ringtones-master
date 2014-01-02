//
//  DNAdRequest.m
//  Demo
//
//  Created by Duc Nguyen on 9/14/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "DNAdRequest.h"
#import "AppRecord.h"
#import "IconDownloader.h"
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))


@interface DNAdRequest()
@property (nonatomic, copy) RequestBannerCompletionHandler completionHandler;
@property (nonatomic, retain) NSMutableArray *listImages;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) ASIFormDataRequest *request;

@end



@implementation DNAdRequest


-(id) init
{
    self  = [super init];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanMemory:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        
        
        
    }
    
    return self;
    
}



- (void) requestWithUnitId:(NSString *) adUnitId typeSize:(DNAdSize) sizeBanner completionHandler:(RequestBannerCompletionHandler) completionBlock
{
    if (!_completionHandler)
    {
        _completionHandler =  [completionBlock copy];
        
        //--ASIHTT request
        [self loadRequest:adUnitId andSize:sizeBanner];
        
    }
}


-(void) dealloc
{
    [_completionHandler release];
    [_listImages release];
    [_imageDownloadsInProgress release];
    
    [super dealloc];
}


- (void)cleanMemory:(NSNotification *) notification
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"Received memory warning!");
}


#pragma mark - ASI


-(void) loadRequest:(NSString *) adUnitId andSize:(DNAdSize) size
{
    
    NSURL *url  = [NSURL URLWithString:@"http://ideashouse.co/service/getlistbanner"];
    
    self.request = [[ASIFormDataRequest alloc] initWithURL:url];
    [self.request setPostValue:adUnitId forKey:@"accountid"];
    
    [_request setTimeOutSeconds:180];
    
    [self.request setCompletionBlock:^{
        
        // Use when fetching text data
        NSString *responseString = [[self.request responseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        SBJsonParser *jsonParse = [[SBJsonParser alloc] init];
        NSDictionary *dictionary = [jsonParse objectWithString:responseString];
        [jsonParse release];
        
    
        
        BOOL status = [[dictionary valueForKey:@"status"] boolValue];
        
        
        if (status)
        {
            NSArray *listArray = (NSArray *)[dictionary valueForKey:@"data"];
            
            if([listArray isEqual:[NSNull null]])
                return ;
            
            NSMutableArray *listApps = [NSMutableArray array];
            if (listArray.count > 0) {
                
                [listArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    NSDictionary *dic = (NSDictionary *) obj;
    
                    
                    NSString *type = [NSString stringWithFormat:@"%@", [dic valueForKey:@"type"]];
                    //NSLog(@"type befire: %@", type);
                    
                    if ((size.size.width == kDNAdSizeBanner.size.width &&  size.size.height == kDNAdSizeBanner.size.height) || (size.size.width == kDNAdSizeBanneriPad.size.width && size.size.height == kDNAdSizeBanneriPad.size.height)) //--small size
                    {
                        
                        if ([type isEqualToString:@"0"]) //--data la loai small banner
                        {
                            AppRecord *objBanner = (AppRecord *)[self getBannerSmall:size andDataGetBanner:dic];
                            if (objBanner)
                            {
                                [listApps addObject:objBanner];
                            }
                        }
                        
                    }
                    
    
                    if (size.size.width == kDNAdSizeFullScreen.size.width && size.size.height == kDNAdSizeFullScreen.size.height)
                    {
                        if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"] )// -- big
                        {
                            AppRecord *objBanner = (AppRecord *)[self getBannerFullScreen:size andDataGetBanner:dic];
                            if (objBanner)
                            {
                                 [listApps addObject:objBanner];
                            }   
                        }
                    }
                    
                }];
            }
            
            
            
            if (listApps.count > 0)
            {
                self.listImages =  listApps;
                
                //--load images
                [self.listImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    AppRecord *object = (AppRecord *) obj;
                    if (object.isPopUp == NO){
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                        [self startIconDownload:object forIndexPath:indexPath];
                        
                    }
                }];
                
            }
            
        }
        
    }];
    
    [self.request setFailedBlock:^{
        
    }];
    
    [self.request startAsynchronous];
    
    
}


-(AppRecord *) getBannerFullScreen:(DNAdSize) sizeAds andDataGetBanner:(NSDictionary *) dictionary
{
    NSString *big_iphonenormal = [dictionary valueForKey:@"big_iphonenormal"];
    NSString *description = [dictionary valueForKey:@"body"];
    NSString *urlStore = [dictionary valueForKey:@"url"];
    NSString *type = [NSString stringWithFormat:@"%@", [dictionary valueForKey:@"type"]];
    NSString *name = [dictionary valueForKey:@"title"];
    //NSLog(@"type: %@", type);
    
    NSString *loweredExtension = [[big_iphonenormal pathExtension] lowercaseString];
    // Valid extensions may change.  Check the UIImage class reference for the most up to date list.
    NSSet *validImageExtensions = [NSSet setWithObjects:@"tif", @"tiff", @"jpg", @"jpeg", @"gif", @"png", @"bmp", @"bmpf", @"ico", @"cur", @"xbm", nil];
    if ([validImageExtensions containsObject:loweredExtension] && [type isEqualToString:@"1"])
    {
        // Do image things here.
        AppRecord *appRecord = [[[AppRecord alloc] init] autorelease];
        [appRecord setDescription:description];
        [appRecord setAppURLAppStoreString:urlStore];
        [appRecord setAppURLString:big_iphonenormal];
        [appRecord setSizeBanner:sizeAds.size];
        [appRecord setIsPopUp:NO];
               
        return appRecord;
        
    }else{
        
        if ([type isEqualToString:@"2"]){
        
         //NSLog(@"dic :%@", dictionary);
         // Do image things here.
         AppRecord *appRecord = [[[AppRecord alloc] init] autorelease];
         [appRecord setAppName:name];
         [appRecord setDescription:description];
         [appRecord setAppURLAppStoreString:urlStore];
         [appRecord setAppURLString:big_iphonenormal];
         [appRecord setSizeBanner:sizeAds.size];
         [appRecord setIsPopUp:YES];
            
        return appRecord;
            
        }

        
        
    }

    return nil;
    
}




-(AppRecord *) getBannerSmall:(DNAdSize) sizeAds andDataGetBanner:(NSDictionary *) dictionary
{
    NSString *description = @"";
    NSString *urlStore = [dictionary valueForKey:@"url"];
    
    AppRecord *appRecord = [[[AppRecord alloc] init] autorelease];
    [appRecord setDescription:description];
    [appRecord setAppURLAppStoreString:urlStore];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        NSString *small_iphonenormal = [dictionary valueForKey:@"small_iphonenormal"];
        if (IS_RETINA)
            small_iphonenormal = [dictionary valueForKey:@"small_iphoneretina"]; //--retina
      
        [appRecord setAppURLString:small_iphonenormal];
        [appRecord setSizeBanner:sizeAds.size];
        [appRecord setIsPopUp:NO];
        
    }else{
        
        NSString *small_ipadnormal = [dictionary valueForKey:@"small_ipadnormal"];
        if (IS_RETINA)
            small_ipadnormal = [dictionary valueForKey:@"small_ipadretina"]; //--retina
        
        [appRecord setAppURLString:small_ipadnormal];
        [appRecord setSizeBanner:sizeAds.size];
        [appRecord setIsPopUp:NO];
    }
    
    return appRecord;
}




#pragma mark - load image



#pragma mark -  Layzy Loader


// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            
            AppRecord *appRecordDownloaded = [self.listImages objectAtIndex:indexPath.row];
            appRecordDownloaded.appIcon = appRecord.appIcon;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
            if ([self checkCompleteBanner])
            {
                self.completionHandler(YES, self.listImages, nil);
                
            }else{
                
            }
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}



-(BOOL) checkCompleteBanner
{
    __block BOOL isFull =  YES;
    [self.listImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        AppRecord *appRecord = (AppRecord *) obj;
        if (!appRecord.appIcon && appRecord.isPopUp == NO)
        {
            isFull = NO;
            *stop =  YES;
        }
        
    }];
    
    return isFull;
}


/*
 - (void)loadImagesForOnscreenRows
 {
 if ([self.listData count] > 0)
 {
 NSArray *visiblePaths = [self.mpTableView indexPathsForVisibleRows];
 for (NSIndexPath *indexPath in visiblePaths)
 {
 AppRecord *appRecord = [self.listData objectAtIndex:indexPath.row];
 
 if (!appRecord.appIcon)
 // Avoid the app icon download if the app already has an icon
 {
 [self startIconDownload:appRecord forIndexPath:indexPath];
 }
 }
 }
 }
 */






@end
