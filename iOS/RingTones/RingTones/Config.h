//
//  Config.h
//  iCleaner
//
//  Created by Duc Nguyen on 10/11/13.
//  Copyright (c) 2013 Duc Nguyen. All rights reserved.
//


#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define recordFileTemp @"MySound.caf"
#define kDefaultDuration 240
#define kDefaultDurationPerScreen 40

//------------------------------------------------------------------------------------------------


#define keyGetInfoFacebookUser @"infoUser"

#define kFaceBookAppID @"1400180920223951"
#define kLikeShareFacebook @"https://itunes.apple.com/us/app/guess-the-familiar-images/id663618434?ls=1&mt=8"

//--define rating
#define kDomain @"com.bizzon.app.buzzmusic" //-- bundle id app cần rating
#define kAppleID 598873219  //-- app id trên iTunes Connect app cần rating


#define keyNameDisplayAdsWhenRemoved @"showads" // never change
#define keyNameRemoveAds @"removeads" // never change


// Configure for version free, free ads, premium
#define LinkfreeIAP_Premium @"com.ideashouse.app.wallpapers.upgrade" // never change
#define Unlock_LinkfreeIAP_Premium @"Unlock_LinkfreeIAP_Premium"

#define freepro @"freepro" // never change
#define freeads @"freeads" //never change
#define premium @"premium" // never change

//#define kVersionApp @"freepro" //--has three values: freepro, freeads, premium
#define kVersionApp (![[NSUserDefaults standardUserDefaults] stringForKey:@"kVersionApp"])?@"freepro":[[NSUserDefaults standardUserDefaults] stringForKey:@"kVersionApp"]

//-- set show 3 version in setting : 1 (show) -  0 (hidden)
#define isDebugApp @"1"


#define kPlistCategories @"CategoriesList.plist"

// id account quản lý trên ideahouse.com/admcm
#define kAdUnitId @"6"

// define post id (info page request to back-end) in setting page
#define kPostID @"2"


// --link to pro version
#define LinkAppPro @"https://itunes.apple.com/vn/app/iclean-remove-clean-all-deleted/id661800424?mt=8"



// message show local notification sau 2 ngày.
#define  kLocaltionNotification1  @"Don't give up yet! Here's a hint: the answer starts with"
#define  kLocaltionNotification2  @"Did you give up? The answer is:"



//--IAP mesage
#define kMesssageLoadingWhenBuying @"It takes some minutes to buy"
#define kMessageIAPFailed @"Upgrade version has been failed. Please try again!"

//--msg downloadFaild

#define kMessageDownloadFaild @"Get data faild! Please check your again"

//--Dropbox key
#define DROPBOX_APP_KEY                 @"1hb63d90nn3s8si"
#define DROPBOX_APP_SECRET              @"5no2mrqf2qp1byp"

//Sharing
#define KPostStatus @"I have downloaded ringtone %@ at %@ With Ringtones App. Check it out"

#define kShareApp @"I have use Ringtones"
#define kImageShare  @"Tabbar_icon_tones_selected.png"

