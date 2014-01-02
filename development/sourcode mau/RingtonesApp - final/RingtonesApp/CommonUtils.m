//
//  CommonUtils.m
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonUtils.h"

#import "Constants.h"
#import "AppDelegate.h"

@implementation UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size ;
{
	// Create a bitmap graphics context
	// This will also set it as the current context
	UIGraphicsBeginImageContext(size);
	
	// Draw the scaled image in the current context
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// Create a new image from current context
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// Pop the current context from the stack
	UIGraphicsEndImageContext();
	
	// Return our new scaled image
	return scaledImage;
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{   
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox;
    
    if (!(degrees == 180.0 || degrees == 360.0 || degrees == 0.0))
        rotatedViewBox= [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    else
        rotatedViewBox= [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.height, self.size.width)];
    
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (UIImage *)scaleToMaxWidth:(float)maxWidth 
                   maxHeight:(float) maxHeight
{
	if(self != nil)
	{
		CGImageRef imgRef = self.CGImage;
		CGFloat width = CGImageGetWidth(imgRef);
		CGFloat height = CGImageGetHeight(imgRef);
		UIImageOrientation    originalOrientation = self.imageOrientation;
        switch (originalOrientation) 
		{
			case UIImageOrientationUp:
			{
			}
				break;
			case UIImageOrientationDown:
			{
			}
				break;
			case UIImageOrientationLeft:
			{
				height = CGImageGetWidth(imgRef);
				width = CGImageGetHeight(imgRef);
			}
				break;
			case UIImageOrientationRight:
			{
				height = CGImageGetWidth(imgRef);
				width = CGImageGetHeight(imgRef);
			}
				break;
			case UIImageOrientationUpMirrored:
			{
			}
				break;
			case UIImageOrientationDownMirrored:
			{
			}
				break;
			case UIImageOrientationLeftMirrored:
			{
			}
				break;
			case UIImageOrientationRightMirrored:
			{
			}
				break;
			default:
			{
			}
				break;
		}
		CGRect bounds = CGRectMake(0, 0, width, height);
		
		CGFloat ratio = width/height;
		CGFloat maxRatio = maxWidth/maxHeight;
		
		if(ratio > maxRatio)
		{
			bounds.size.width = maxWidth;
			bounds.size.height = bounds.size.width / ratio;
		}
		else
		{
			bounds.size.height = maxHeight;
			bounds.size.width = bounds.size.height * ratio;
		}
		
		//NSLog(@"after resize:%f,%f:",bounds.size.width,bounds.size.height);
		return [self scaleToSize:bounds.size];
	}
	return nil;
}

@end

#define RECT_TAG 1421
#define SPIN_TAG 4516

@implementation CommonUtils

#pragma File handler

+ (UIImage*)loadLocalImage:(NSString*)fileName{
    //TODO
    return [UIImage imageWithContentsOfFile:fileName];
}

+ (NSString *)pathForSourceFile:(NSString *)file inDirectory:(NSString *)directory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSString *path = nil;
	if(directory == nil)
	{
		path = [documentsDirectory stringByAppendingPathComponent:file];
	}
	else
	{
		// if folder not exist, it will be created
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *directoryPath = [documentsDirectory stringByAppendingPathComponent:directory];
		
		// create particular directory
		BOOL success = [fileManager createDirectoryAtPath:directoryPath
							  withIntermediateDirectories:YES
											   attributes:nil 
													error:NULL];
		
		if(success)
		{
			path = [directoryPath stringByAppendingPathComponent:file];
		}
	}
	
	return path;
}

+ (NSString *)fullPathFromFile:(NSString *)path
{
	if(path)
	{
		NSArray *components = [path componentsSeparatedByString:@"."];
		
		if([components count] > 1)
		{
			NSString *resourcePath =
			[[NSBundle mainBundle] pathForResource:[components objectAtIndex:0] 
											ofType:[components objectAtIndex:1]];
			
			return resourcePath;
		}
	}
	return nil;
}


#pragma Custom methods
+ (void) openURLExternalHandlerForLink: (NSString *) urlLink;
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlLink]];
}
#pragma App settings plist handler
+ (void) copyFilePlistIfNeccessaryForFileName: (NSString *) filename withFileType:(NSString *)fileType;
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.%@", filename,fileType]]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:filename ofType:fileType]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
}



#pragma -
#pragma Alertview 

// Method used to show alert view with Title, message content and cancel button title
+ (void) showAlertViewWithTitle: (NSString *) title 
                        message:(NSString*)msg 
              cancelButtonTitle:(NSString*)cancelTitle;
{
	
    UIAlertView *alertView = [[[UIAlertView alloc] 
                               initWithTitle:title 
                               message:msg 
                               delegate:self 
                               cancelButtonTitle:cancelTitle 
                               otherButtonTitles:nil] autorelease];
    [alertView show];    
}

// Method used to show alert view with Title, message content and cancel button title
+ (void) showAlertViewWithTitle: (NSString *) title 
                        message:(NSString*)msg 
              cancelButtonTitle:(NSString*)cancelTitle 
              otherButtonTitles: (NSString *) otherButtonTitles, ...
{
    // traditional alertview
    
    UIAlertView *alertView = [[[UIAlertView alloc]  init] autorelease];
    
    alertView.title = title;
    alertView.message = msg;
    alertView.delegate = self;
    
    if (cancelTitle != nil) {
        [alertView addButtonWithTitle:cancelTitle];
        alertView.cancelButtonIndex = 0;
    }
    
    if (otherButtonTitles != nil) {
        [alertView addButtonWithTitle: otherButtonTitles ];
        
        va_list args;
        va_start(args, otherButtonTitles);
        
        id arg;
        while ( nil != ( arg = va_arg( args, id ) ) ) 
        {
            if ( ![arg isKindOfClass: [NSString class] ] )
                break;
            
            [alertView addButtonWithTitle: (NSString*)arg ];
        }
        
    }
    
    [alertView show];
}

// Method used to show alert view with Title, message content and cancel button title
+ (void) showAlertViewWithTag: (NSInteger) tag 
                     delegate:(id) delegate 
                    withTitle: (NSString *) title 
                      message:(NSString*)msg 
            cancelButtonTitle:(NSString*)cancelTitle 
            otherButtonTitles: (NSString *) otherButtonTitles, ... ;
{
    // traditional alertview
    UIAlertView *alertView = [[[UIAlertView alloc]  init] autorelease];
    
    alertView.title = title;
    alertView.message = msg;
    alertView.delegate = delegate;
    alertView.tag = tag;
    
    if (cancelTitle != nil) {
        [alertView addButtonWithTitle:cancelTitle];
        alertView.cancelButtonIndex = 0;
    }
    
    if (otherButtonTitles != nil) {
        [alertView addButtonWithTitle: otherButtonTitles ];
        
        va_list args;
        va_start(args, otherButtonTitles);
        
        id arg;
        while ( nil != ( arg = va_arg( args, id ) ) ) 
        {
            if ( ![arg isKindOfClass: [NSString class] ] )
                break;
            
            [alertView addButtonWithTitle: (NSString*)arg ];
        }
        
    }
    
    [alertView show];
    
}


// Function to check if device support multitasking
// Return: TRUE if device supports multitasking, otherwise return NO
+ (BOOL) isDeviceSupportMultitasking;
{
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]) {
        backgroundSupported = device.multitaskingSupported;
    }
    
    //NSLog(@"support multitasking: %d ", backgroundSupported);
    return backgroundSupported;
}

+ (BOOL) isIOS5OrGreater;
{
    /* [[UIDevice currentDevice] systemVersion] returns "4.0", "3.1.3" and so on. */
    NSString* ver = [[UIDevice currentDevice] systemVersion];
    //    NSLog(@"Check ios410 %@",ver);
    /* I assume that the default iOS version will be 4.0, that is why I set this to 4.0 */
    float version = 5.0;
    
    if ([ver length]>=3)
    {
        /*
         The version string has the format major.minor.revision (eg. "3.1.3").
         I am not interested in the revision part of the version string, so I can do this.
         It will return the float value for "3.1", because substringToIndex is called first.
         */
        version = [[ver substringToIndex:3] floatValue];
    }
    return (version >= 5.0);
}

#pragma Network indicator show/hide animation
// Method used to show network indicator (top bar of device) animating while loading from server
+ (void) showNetworkIndicator;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// Method used to stop network indicator (top bar of device) animating after data is loaded successuflly
+ (void) hideNetworkIndicator;
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// start indicator animation with black screen
// Edited by DatNT 07/05/2011
// Purpose: add autosizing and contentMode, to auto resizing and center indicator when displaying Loading screen
+ (void) startIndicatorDisableViewController: (UIViewController *) viewController ;
{
    CGRect parentFrame = viewController.view.frame;
    if ([viewController.view viewWithTag:RECT_TAG] != nil) {
        return;
    }
    
    UIView* blackRect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    blackRect.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blackRect.contentMode = UIViewContentModeScaleToFill;
	blackRect.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	blackRect.tag = RECT_TAG;
	[[viewController view] addSubview:blackRect];
    
	UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinny.tag = SPIN_TAG;
	spinny.center = CGPointMake(parentFrame.size.width/2,parentFrame.size.height/2);
    spinny.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    spinny.contentMode = UIViewContentModeCenter;
    [spinny startAnimating];
    [viewController.view addSubview:spinny];
    
    if (spinny) {
        [spinny release];
    }
    
    if (blackRect) {
        [blackRect release];
    }
}

// stop indicator animation with black screen
+ (void) stopIndicatorDisableViewController: (UIViewController *) viewController ;
{
    UIView *spinny = [viewController.view viewWithTag:SPIN_TAG];
    [spinny removeFromSuperview];
    UIView *blk = [viewController.view viewWithTag:RECT_TAG];
    [blk removeFromSuperview];
}

+ (void) startIndicatorDisableViewController: (UIViewController *) viewController willDisableNavigation:(BOOL)disable ;
{
    UIView *mainView = (disable) ? viewController.navigationController.view : viewController.view;
    CGRect parentFrame = mainView.frame;
    if ([mainView viewWithTag:RECT_TAG] != nil) {
        return;
    }
    
    UIView* blackRect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    blackRect.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blackRect.contentMode = UIViewContentModeScaleToFill;
	blackRect.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	blackRect.tag = RECT_TAG;
	[mainView addSubview:blackRect];
    
	UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinny.tag = SPIN_TAG;
	spinny.center = CGPointMake(parentFrame.size.width/2,parentFrame.size.height/2);
    spinny.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    spinny.contentMode = UIViewContentModeCenter;
    [spinny startAnimating];
    [mainView addSubview:spinny];
    
    if (spinny) {
        [spinny release];
    }
    
    if (blackRect) {
        [blackRect release];
    }
}

// stop indicator animation with black screen
+ (void) stopIndicatorDisableViewController: (UIViewController *) viewController willDisableNavigation:(BOOL)disable;
{
    UIView *mainView = (disable) ? viewController.navigationController.view : viewController.view;
    
    UIView *spinny = [mainView viewWithTag:SPIN_TAG];
    [spinny removeFromSuperview];
    UIView *blk = [mainView viewWithTag:RECT_TAG];
    [blk removeFromSuperview];
}

+ (void)blurViewController:(UIViewController *)viewController;
{
    UIView *blurview = (UIView *)[viewController.navigationController.view viewWithTag:123];
    if (blurview == nil) {
        blurview = [[[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]]autorelease];
        blurview.tag = 123;
        blurview.backgroundColor = [UIColor colorWithWhite:0.6f alpha:0.7f];
        
        [viewController.navigationController.view addSubview:blurview];
    }
}

+ (void)blurViewController:(UIViewController *)viewController withColor:(UIColor *)color withAlpha:(CGFloat)alpha
{
    UIView *blurview = (UIView *)[viewController.navigationController.view viewWithTag:123];
    if (blurview == nil) {
        blurview = [[[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]]autorelease];
        blurview.tag = 123;
        blurview.backgroundColor = color;
        blurview.alpha = alpha;
        
        [viewController.navigationController.view addSubview:blurview];
    }
    
}

+ (void)removeBlurViewController:(UIViewController *)viewController
{
    UIView *blurview = (UIView *)[viewController.navigationController.view viewWithTag:123];
    if (blurview != nil) {
        [blurview removeFromSuperview];
    }
}

+ (NSString *) getBundleVersion;
{
    return [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}


// Method used to get app setting value by setting key
+ (NSString*) loadHTMLfile: (NSString *) fileName; 
{
    NSString *path = [CommonUtils fullPathFromFile:[NSString stringWithFormat: @"%@", fileName]];
    
    NSError *error;
    NSString * value = [[NSString alloc] initWithContentsOfFile:path 
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    
    return [value autorelease];
    // End DatNT8
    
}

+ (void) changeNagBarFor:(UIViewController *)viewController bkgImage: (NSString *)img
{
    //load navbar background  
    UIImageView *bkgNav = (UIImageView *)[viewController.navigationController.navigationBar viewWithTag:kNavigationBkgTag];
    
    if (bkgNav != nil) {
        [bkgNav removeFromSuperview];
    }
    
    bkgNav = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:img]] autorelease];
    
    bkgNav.tag = kNavigationBkgTag;
    [viewController.navigationController.navigationBar insertSubview:bkgNav atIndex:([CommonUtils isIOS5OrGreater]) ? 1 : 0];
}

+ (NSString *)getSafeValueForKey:(NSString *)key inDictionary:(NSDictionary *)dict;
{
    NSString *string = @"";
    if (dict != nil) {
        NSString *value = [dict objectForKey:key];
        if (value != nil) {
            string = value;
        }
    }
    
    return string;
}

+ (NSString *)convertToDateTimeFrom:(NSInteger)value;
{
    int newValue = (int) value;
    int minutes = newValue / 60;
    int seconds = newValue - minutes * 60;
    
    NSString *string = [NSString stringWithFormat:@"%.02d:%.02d", minutes, seconds];
    
    return string;
}

@end