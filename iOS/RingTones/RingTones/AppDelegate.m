//
//  AppDelegate.m
//  RingTones
//
//  Created by Vuong Nguyen on 12/12/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import "AppDelegate.h"
#import "BrowseViewController.h"
#import "MasterNavigation.h"
#import "MakerViewController.h"
#import "RingtonesViewController.h"
#import "SettingsViewController.h"
#import "SearchViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import <DropboxSDK/DropboxSDK.h>
#import "Config.h"
#import "iRate.h"
@implementation AppDelegate
@synthesize appModel;



+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    
    //[iRate sharedInstance].applicationBundleID = @"com.ideahouse.app.idelete";
    //[iRate sharedInstance].appStoreID = 721125070;
    
    [iRate sharedInstance].applicationBundleID = kDomain;
    [iRate sharedInstance].appStoreID = kAppleID;
    
    [iRate sharedInstance].DaysUntilPrompt = 1;
    [iRate sharedInstance].UsesUntilPrompt = 10;
    
	[iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    //enable preview mode
    [iRate sharedInstance].previewMode = NO;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if (!appModel)
    {
        appModel = [[AppModel alloc] init];
    }
    [self setupViewControllers];
  
    //s
    //[self setupTabBarController];
    //[self setupColorNaviBarControllerIOS7];
    
    DBSession* dbSession = [[DBSession alloc] initWithAppKey:DROPBOX_APP_KEY
                                                   appSecret:DROPBOX_APP_SECRET
                                                        root:kDBRootDropbox]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
     [self customizeInterface];

    
    // Override point for customization after application launch.
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked to Dropbox successfully");
        } else {
            NSLog(@"App not linked to Dropbox!");
        }
        return YES;
    }
    return NO;
}


#pragma mark - Methods


- (void)setupViewControllers {
    
    BrowseViewController *browseViewController = nil;
    SearchViewController *searchViewController = nil;
    MakerViewController *makerViewController = nil;
    RingtonesViewController *ringtonesViewController = nil;
    SettingsViewController *settingsViewController = nil;
    
    _navigationBrowse = [self setAllocNavigationBar:browseViewController andNavigation:_navigationBrowse andNameString:@"BrowseViewController" andTitle:@"Browse"];
    
    _navigationSearch =  [self setAllocNavigationBar:searchViewController andNavigation:_navigationSearch andNameString:@"SearchViewController" andTitle:@"Search"];
    
    _navigationMaker = [self setAllocNavigationBar:makerViewController andNavigation:_navigationMaker andNameString:@"MakerViewController" andTitle:@"Maker"];
    
    _navigationRingTones = [self setAllocNavigationBar:ringtonesViewController andNavigation:_navigationRingTones andNameString:@"RingtonesViewController" andTitle:@"Ringtones"];
    
    _navigationSettings = [self setAllocNavigationBar:settingsViewController andNavigation:_navigationSettings andNameString:@"SettingsViewController" andTitle:@"Settings"];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[_navigationBrowse, _navigationSearch,
                                           _navigationMaker,_navigationRingTones,_navigationSettings]];
    self.viewController = tabBarController;
    [self customizeTabBarForController:tabBarController];
    
    [self setFontTitle];

}


-(void) setFontTitle
{
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont helveticaNeueMediumFontSize:18] forKey:UITextAttributeFont];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
}


-(UIViewController *) setAllocNavigationBar:(UIViewController *) viewControllerP andNavigation:(UIViewController *) _navigation andNameString:(NSString *) nameStringClass andTitle:(NSString *) title
{
    viewControllerP = [[NSClassFromString(nameStringClass) alloc] init];
  
    viewControllerP = [[NSClassFromString(nameStringClass) alloc] initWithNibName:[Common checkDevice: nameStringClass] bundle:nil];
    _navigation = [[MasterNavigation alloc] initWithRootViewController:viewControllerP];
    
    viewControllerP.title = title;
  
  
    return _navigation;
}


- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"Tabbbar_BG"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"Tabbbar_BG"];
    NSArray *tabBarItemImages = @[@"Tabbar_icon_list", @"Tabbar_icon_search", @"Tabbar_icon_maker", @"Tabbar_icon_tones", @"Tabbar_icon_more"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"Top_cell"]
                                      forBarMetrics:UIBarMetricsDefault];
        
    } else {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"Top_cel_IO6"]
                                      forBarMetrics:UIBarMetricsDefault];
        
        NSDictionary *textAttributes = nil;
        
     
        
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
            textAttributes = @{
                               NSFontAttributeName: [UIFont helveticaNeueMediumFontSize:18],
                               NSForegroundColorAttributeName: [UIColor blackColor],
                               };
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            textAttributes = @{
                               UITextAttributeFont: [UIFont helveticaNeueMediumFontSize:18],
                               UITextAttributeTextColor: [UIColor blackColor],
                               UITextAttributeTextShadowColor: [UIColor clearColor],
                               UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                               };
#endif
        }
        
        [navigationBarAppearance setTitleTextAttributes:textAttributes];
    }
}

/*

-(void)setupTabBarController
{
    NSMutableArray *viewControllers = [NSMutableArray array];
    self.tabBarController = [[UITabBarController alloc] init];
    BrowseViewController *browseViewController = nil;
    SearchViewController *searchViewController = nil;
    MakerViewController *makerViewController = nil;
    RingtonesViewController *ringtonesViewController = nil;
    SettingsViewController *settingsViewController = nil;
    
    [self setNaviBarItems:_navigationBrowse andNameString:@"BrowseViewController" andViewController:browseViewController andTitle:@"Browse" andImage:@"Tabbar_icon_list.png" andArrayViewController:viewControllers];
    
    [self setNaviBarItems:_navigationBrowse andNameString:@"SearchViewController" andViewController:searchViewController andTitle:@"Search" andImage:@"Tabbar_icon_search.png" andArrayViewController:viewControllers];
    
    [self setNaviBarItems:_navigationBrowse andNameString:@"MakerViewController" andViewController:makerViewController andTitle:@"Maker" andImage:@"Tabbar_icon_maker.png" andArrayViewController:viewControllers];
    
    [self setNaviBarItems:_navigationBrowse andNameString:@"RingtonesViewController" andViewController:ringtonesViewController andTitle:@"Ringtones" andImage:@"Tabbar_icon_tones.png" andArrayViewController:viewControllers];
    
    [self setNaviBarItems:_navigationBrowse andNameString:@"SettingsViewController" andViewController:settingsViewController andTitle:@"Settings" andImage:@"Tabbar_icon_more.png" andArrayViewController:viewControllers];
    
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = viewControllers;
    self.tabBarController.selectedIndex = 0;
    [self.tabBarController.delegate tabBarController:self.tabBarController didSelectViewController:[self.tabBarController.viewControllers objectAtIndex:0]];
}


-(void) setNaviBarItems:(MasterNavigation *) _navigation andNameString:(NSString *) nameStringClass andViewController:(UIViewController *) viewController andTitle:(NSString *) title andImage:(NSString *) nameImage andArrayViewController:(NSMutableArray *)viewControllers
{
    viewController = [[NSClassFromString(nameStringClass) alloc] initWithNibName:[Common checkDevice: nameStringClass] bundle:nil];
    _navigation = [[MasterNavigation alloc] initWithRootViewController:viewController];
    _navigation.navigationBar.translucent = NO;
    viewController.tabBarItem.image = [UIImage imageNamed:nameImage];
    viewController.title = title;
    [self setupColorNaviBarControllerIOS6:_navigation];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    [_navigation setTabBarItem:tabBarItem];
    [viewControllers addObject:_navigation];
    
}


-(void) setupColorNaviBarControllerIOS7
{
    if (SYSTEM_VERSION_EQUAL_TO_OR_GREATER_THAN(@"7.0"))
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor  colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0]];
        //[[UINavigationBar appearance] setTintColor:[UIColor redColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor  colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0]];
        [self.tabBarController.tabBar setBarTintColor:[UIColor  colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0]];
    }

    

    [self.tabBarController.tabBar setTintColor:[UIColor  colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor redColor] }
                                             forState:UIControlStateSelected];
   // self.tabBarController.tabBar.selectedImageTintColor = [UIColor redColor];
}



- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
    
    
    NSUInteger index=[[theTabBarController viewControllers] indexOfObject:viewController];
  
      switch (index) {
          case 0:
          {
       
                 theTabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"Tabbar_icon_list_selected.png"];
          }
          
              break;
          case 1:
              theTabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"Tabbar_icon_search_selected.png"];
              break;
          case 2:
              theTabBarController.tabBar.selectionIndicatorImage =[UIImage imageNamed:@"Tabbar_icon_maker_selected.png"];
              break;
          case 3:
              theTabBarController.tabBar.selectionIndicatorImage =[UIImage imageNamed:@"Tabbar_icon_tones_selected.png"];
              break;
          case 4:
              theTabBarController.tabBar.selectionIndicatorImage =[UIImage imageNamed:@"Tabbar_icon_more_selected.png"];
              break;
  
          default:
              break;
      }
    
}



-(void)setupColorNaviBarControllerIOS6:(MasterNavigation *) _navigation
{
    if (SYSTEM_VERSION_EQUAL_TO_OR_GREATER_THAN(@"7.0"))
    {
      
    } else {
        _navigation.navigationBar.tintColor = [UIColor  colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0];
    }
 
    
}


*/

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
