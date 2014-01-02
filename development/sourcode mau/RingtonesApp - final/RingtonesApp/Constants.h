//
//  Constants.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum {
    DataSourceTypeFeature = 0,
    DataSourceTypeNewest,
    DataSourceTypeTopRated,
    DataSourceTypeMostDownloaded,
    DataSourceTypeMostCommented
} DataSourceType;

#define kNavigationBkgTag 1234


/// View title
#define TITLE_VIEW_BROWSE @"Browse"
#define TITLE_VIEW_CATEGORIES @"Categories"
#define TITLE_VIEW_LIST_IPOD_SONG @"Choose a song"
#define TITLE_VIEW_RINGTONE @"Ringtones"
#define TITLE_VIEW_HELP @"Help"
#define TITLE_VIEW_MORE @"More"


// Button titles
#define BUTTON_ACTIONSHEET_CANCEL @"Cancel"
#define BUTTON_ACTIONSHEET_SEND_EMAIL @"Send via Email"
#define BUTTON_ACTIONSHEET_RING_DOWNLOAD @"Download"
#define BUTTON_ACTIONSHEET_RING_PREVIEW @"Preview"

#define BUTTON_UPGRADE @"Upgrade"
#define BUTTON_CLOSE @"Close"
#define BUTTON_RESET @"Reset"
#define BUTTON_LIST_EDIT @"Edit"
#define BUTTON_LIST_DONE @"Done"
#define BUTTON_LIST_DELETE_ALL @"Delete All"
#define BUTTON_GO_TO_FULL_VER @"Go"

#define BUTTON_OK @"OK"
#define BUTTON_NO @"No"
#define BUTTON_YES @"Yes"


#define kNoItemsPerPage 10

#define kTimeoutDownloadRingtone 60.0f
#define kTimeoutGetRingtone 60.0f
#define kTimeoutSearch 60.0f

#define kMaxConcurrentDownloading 4

#define kDefaultRingtoneCutLength 20
#define kDefaultRingtoneCutStartPoint 10
#define kRingtoneCutMinDuration 10.0
#define kRingtoneCutMaxDuration 41.0
#define durationPerScroll 60.0f


#define CELL_IMAGE_MAX_WIDTH 30.0f
#define CELL_IMAGE_MAX_HEIGHT 30.0f
#define CELL_IMAGE_CONRNER_RADIUS 8.0f

//Tag
#define TAG_ACTIONSHEET_PREVIEW_DOWNLOAD 1124
#define TAG_PREVIEW 8899
#define TAG_PLAYER 8888

#define TAG_MAX_DOWNLOAD_LIMIT 541
#define TAG_ALERT_LINK_FULL_VER 543

//Database
#define DATABASE_FILENAME_FULL @"db.sqlite"

// Documents folder path
#define DOCUMENTS_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

///server api
#define SERVER_API @"http://ios-lab.net/ring_api/data.php?cmd=%@"
#define SERVER_API_GETLISTCAT @"http://ios-lab.net/ring_api/data.php?cmd=getlistcat"
#define SERVER_API_GETITEMBYCAT @"http://ios-lab.net/ring_api/data.php?cmd=getitembycat&cid=%d&id=%d&limit=%d"
#define SERVER_API_SEARCH @"http://ios-lab.net/ring_api/data.php?cmd=search&keyword=%@&id=%d&limit=%d"
#define SERVER_API_GETITEMBYTYPE @"http://ios-lab.net/ring_api/data.php?cmd=getitembytype&type=%@&itemcount=%d&limit=%d"
#define SERVER_API_GETITEMBYID @"http://ios-lab.net/ring_api/data.php?cmd=getitem&id=%d"
#define SERVER_API_INCREASE_VIEW @"http://ios-lab.net/ring_api/data.php?cmd=viewitem&id=%d"
#define SERVER_API_INCREASE_DOWN @"http://ios-lab.net/ring_api/data.php?cmd=downitem&id=%d"


//Link app
#define kLinkAppFull @"http://itunes.apple.com/us/app/ringtone/id493295909?ls=1&mt=8"
#define kLinkAppLite @"http://itunes.apple.com/us/app/free-ringtone/id493301226?ls=1&mt=8"
#define kLinkAppFree @"http://itunes.apple.com/us/app/free-ringtone/id493301227?ls=1&mt=8"

//Link review
#define kLinkAppReviewFull @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=493295909&onlyLatestVersion=false&type=Purple+Software"
#define kLinkAppReviewLite @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=493301226&onlyLatestVersion=false&type=Purple+Software"
#define kLinkAppReviewFree @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=493301227&onlyLatestVersion=false&type=Purple+Software"

//Link moreapp
#define kLinkMoreApp @"http://google.com.jp"

//link help
#define kHelpLink @"http://ios-lab.net/FAQ/index.html"

// Product iap
//#define kProductIAP @"123456" 
//test product
#define kProductIAP @"com.plumgame.newTestIAP.testproduct"

#define kMaxRingtoneFree 5

#define MSG_MAX_DOWNLOAD_LIMIT @"Upgrade to Full Version now to download/create unlimit ringtones"
#define MSG_LINK_FULL_VER @"You reached maximum download limit. Download Full Version now?"

//Banner
#define kBannerUpdateInterval 5.0f
#define kBannerImg1 @"AdBanner1.png"
#define kBannerLink1 @"http://google.com"
#define kBannerImg2 @"AdBanner2.png"
#define kBannerLink2 @"http://yahoo.com"
#define kBannerImg3 @"AdBanner3.png"
#define kBannerLink3 @"http://plumgame.com"
#define kBannerImg4 @"AdBanner4.png"
#define kBannerLink4 @"http://www.google.com.vn/imghp?hl=vi&tab=wi"
#define kBannerImg5 @"AdBanner5.png"
#define kBannerLink5 @"http://news.google.com.vn/nwshp?hl=vi&tab=in"




// Inapp purchase 
#define ALERT_ALARM_TITLE @""
#define ALERT_CONTENT_CANNOT_IAP @"Disable to make purchases inside applications. Please enabled to make purchase.\n"
#define ALERT_CONTENT_MISSING_PRODUCT @"Missing product from App store.\n"
#define ALERT_CONTENT_MISSING_PRODUCT_NO_MATCH @"Missing product from App store.No match Identifier found.\n"
#define ALERT_CONTENT_REQUEST_FAIL @"Request product from App store failed.\n\n%@"
#define ALERT_CONTENT_PURCHASE_SUCCESS @"Purchased successfully."
#define ALERT_CONTENT_PAYMENT_CANCEL @"Payment Cancelled\n\n%@"

#define kPurchaseKey @"didPurchase"

#define kDownloadedCount @"KeyDownloadedCount"

//email
#define kEmailTemplate @"Ringtone %@ from Ringtones App"

#define kEmailBodyShareFriend @"Use Ringtones For Free... Download at <a href=\"http://itunes.apple.com/us/app/ringtone/id493295909?ls=1&mt=8\">http://itunes.apple.com/us/app/ringtone/id493295909?ls=1&mt=8</a>"
#define kEmailSubjectShareFriend @"Free Ringtones for your iPhone"


//Notificaion
#define kNotificationDoneDownloadRingtone @"DidFinishDownloadRingtone"
#define kNotificationStartDownloadRingtone @"DidStartDownloadRingtone"
#define kNotificationCompleteOneDownloadRingtone @"DidFinishDownloadOneRingtone"
#define kNotificationDidChooseSendEmail @"DidChooseSendEmail"

#define kTempFolderPreview @"tmp"
#define kTempFolderConvert @"tempConvert"

@interface Constants : NSObject

@end
