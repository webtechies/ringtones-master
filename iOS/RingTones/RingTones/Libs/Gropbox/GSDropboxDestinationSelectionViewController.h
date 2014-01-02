//
//  GSDropboxDestinationSelectionViewController.h
//
//  Created by Simon Whitaker on 06/11/2012.
//  Copyright (c) 2012 Goo Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GSDropboxDestinationSelectionViewControllerDelegate;

@interface GSDropboxDestinationSelectionViewController : UITableViewController<UIAlertViewDelegate>

@property (nonatomic, strong) NSString *rootPath;
@property (nonatomic, assign) id<GSDropboxDestinationSelectionViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *numberDownload;
@end

@protocol GSDropboxDestinationSelectionViewControllerDelegate <NSObject>

- (void)dropboxDestinationSelectionViewController:(GSDropboxDestinationSelectionViewController*)viewController
                         didSelectDestinationPath:(NSString *)destinationPath;
- (void)dropboxDestinationSelectionViewControllerDidCancel:(GSDropboxDestinationSelectionViewController*)viewController;

@end