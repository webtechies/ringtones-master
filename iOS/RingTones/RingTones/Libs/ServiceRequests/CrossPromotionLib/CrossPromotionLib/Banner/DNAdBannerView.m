//
//  DNAdBannerView.m
//  Demo
//
//  Created by Duc Nguyen on 9/14/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "DNAdBannerView.h"
#import "AppRecord.h"




@interface DNAdBannerView()

@property (nonatomic, retain) NSArray *listBanners;


@property (nonatomic, retain) UIImageView *viewShowBanner;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger atIndexAds;
@property (nonatomic, assign) NSInteger countSeconds;


@end


@implementation DNAdBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
        
    }
    return self;
}


#pragma mark Initialization


// iPhone and iPod Touch ad size. Typically 320x50
const DNAdSize  kDNAdSizeBanner = {320, 45};

const DNAdSize kDNAdSizeBanneriPad = {768, 75 };

// iPhone full screen  ad size. Typically 320 x 480
const  DNAdSize kDNAdSizeFullScreen = {320, 480};

const  DNAdSize  kDNAdSizeFullScreeniPad = {512, 768};


-(id) initWithAdSize:(DNAdSize) size origin:(CGPoint) origin
{
    CGRect frameBanner = CGRectZero;
    frameBanner.origin = origin;
    frameBanner.size =  size.size;
    
    self = [super initWithFrame:frameBanner];
    
    if (self)
    {
        self.adSize = size;
        self.countSeconds =  0;
        
        
        if (!_viewShowBanner)
        {
            CGRect frame = CGRectZero;
            frame.size = self.adSize.size;
            frame.origin =  CGPointZero;
            
            _viewShowBanner  = [[UIImageView alloc] initWithFrame:frame];
            _viewShowBanner.frame =  frame;
            [self addSubview:_viewShowBanner];
            
        }
   
    }
    
    return self;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //UITouch *touch = [touches anyObject];
    
    if (self.viewShowBanner && self.listBanners.count > 0)
    {
        AppRecord *apprecord = (AppRecord *) [self.listBanners objectAtIndex:self.atIndexAds];
        NSString *url = [apprecord appURLAppStoreString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }
    
    
}


-(id) initWithAdSize:(DNAdSize) size
{
    CGRect frameBanner = CGRectZero;
    frameBanner.origin = CGPointZero;
    frameBanner.size =  size.size;
    
    self = [self initWithAdSize:size origin:CGPointZero];
    if (self)
    {
        
    }
    
    return self;

}


#pragma mark Delegate request





#pragma mark Making an Ad Request

-(void) loadRequest
{
    DNAdRequest *request = [[DNAdRequest alloc] init];
    [request requestWithUnitId:self.adUnitId typeSize:self.adSize completionHandler:^(BOOL success, NSArray *listImages, DNAdsRequestError *error) {
       
        if (success == NO)
        {
            if ([self.delegate respondsToSelector:@selector(adView:didFailToReceiveAdWithError:)])
            {
                [self.delegate adView:self didFailToReceiveAdWithError:error];
            }
            
            return;
        }
        
        //--has list images
        if (self.viewShowBanner)
        {
            self.listBanners =  listImages;
            
            if (!_timer)
            {
                //-- show banner
                [self showBanner];
                
                //--interval change image after 1.0s
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeImageBanner) userInfo:nil repeats:YES];
                [self.timer fire];
                
                //--fire delegate
                if ([self.delegate respondsToSelector:@selector(adViewDidReceiveAd:)])
                {
                    [self.delegate adViewDidReceiveAd:self];
                }                
            }
        }
        
    }];
    [request release];
}


-(void) changeImageBanner
{
    self.countSeconds = self.countSeconds +1;
    if (self.countSeconds >= 3) //--change imagae banner
    {
        self.countSeconds = 0;
        self.atIndexAds = self.atIndexAds + 1;
        
        if (self.atIndexAds == self.listBanners.count) //--reset
        {
            self.atIndexAds = 0;
        }
        
        if (self.listBanners.count > 0 && self.atIndexAds >= self.listBanners.count)
        {
            self.atIndexAds = 0;
        }
        
        
        [self showBanner];
    }
}



-(void) showBanner
{
    
    if (self.viewShowBanner && self.listBanners.count > 0)
    {
        AppRecord *apprecord = (AppRecord *) [self.listBanners objectAtIndex:self.atIndexAds];
        //NSLog(@"Size: %@", NSStringFromCGSize(apprecord.appIcon.size));
        
        self.viewShowBanner.image = apprecord.appIcon;

    }

}


#pragma mark - Destroy



-(void) dealloc
{
    [_adUnitId release];
    [_viewShowBanner release];
    [_timer release];
    [_listBanners release];
    
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
        
    }
    
    [super dealloc];
}



@end
