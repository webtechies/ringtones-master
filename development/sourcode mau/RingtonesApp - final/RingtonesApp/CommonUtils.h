//
//  CommonUtils.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



#define F_RELEASE(__p) {if(__p!=nil){[__p release]; __p=nil;}}

#define LOCALIZE(__p) NSLocalizedString(__p, @"")

#define DegreesToRadians(__p) __p * M_PI / 180
#define RadiansToDegrees(__p) __p * 180/M_PI

//CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
//CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};


@interface UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)scaleToMaxWidth:(float)maxWidth 
                   maxHeight:(float) maxHeight;


@end

@interface CommonUtils : NSObject {
    
}
+ (NSString *)pathForSourceFile:(NSString *)file inDirectory:(NSString *)directory;
+ (NSString *)fullPathFromFile:(NSString *)path;
+ (void) openURLExternalHandlerForLink: (NSString *) urlLink;
+ (void) copyFilePlistIfNeccessaryForFileName: (NSString *) filename withFileType:(NSString *)fileType;

+ (void) showAlertViewWithTitle: (NSString *) title 
                        message:(NSString*)msg 
              cancelButtonTitle:(NSString*)cancelTitle;

+ (void) showAlertViewWithTitle: (NSString *) title 
                        message:(NSString*)msg 
              cancelButtonTitle:(NSString*)cancelTitle 
              otherButtonTitles: (NSString *) otherButtonTitles, ...;

+ (void) showAlertViewWithTag: (NSInteger) tag 
                     delegate:(id) delegate 
                    withTitle: (NSString *) title 
                      message:(NSString*)msg 
            cancelButtonTitle:(NSString*)cancelTitle 
            otherButtonTitles: (NSString *) otherButtonTitles, ... ;



+ (BOOL) isDeviceSupportMultitasking;
+ (BOOL) isIOS5OrGreater;

+ (void) showNetworkIndicator;
+ (void) hideNetworkIndicator;

+ (void) startIndicatorDisableViewController: (UIViewController *) viewController ;
+ (void) stopIndicatorDisableViewController: (UIViewController *) viewController ;

+ (void) startIndicatorDisableViewController: (UIViewController *) viewController willDisableNavigation:(BOOL)disable ;
+ (void) stopIndicatorDisableViewController: (UIViewController *) viewController willDisableNavigation:(BOOL)disable;


+ (void)blurViewController:(UIViewController *)viewController;
+ (void)blurViewController:(UIViewController *)viewController withColor:(UIColor *)color withAlpha:(CGFloat)alpha;
+ (void)removeBlurViewController:(UIViewController *)viewController;

+ (NSString *) getBundleVersion;

+ (NSString*) loadHTMLfile: (NSString *) fileName; 


+ (UIImage*)loadLocalImage:(NSString*)fileName;

+ (NSString *)getSafeValueForKey:(NSString *)key inDictionary:(NSDictionary *)dict;

+ (NSString *)convertToDateTimeFrom:(NSInteger)value;

@end
