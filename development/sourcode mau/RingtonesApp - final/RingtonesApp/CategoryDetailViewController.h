//
//  CategoryDetailViewController.h
//  RingtonesApp
//
//  Created by Dat Nguyen on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RingtoneCell.h"
#import "LoadmoreCell.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"

@interface CategoryDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, ASIHTTPRequestDelegate> {
    IBOutlet UITableView *mainTableView;
    RingtoneCell *customCell;
    
    LoadmoreCell *loadmoreCell;

//    NSInteger categoryId;
    NSDictionary *dicCategory;
    
    NSMutableArray *arrSource;
    NSMutableArray *arrLoadmore;
    
    NSInteger currentMinId;
    
    NSInteger selectedIndex;
    
    BOOL isLoading;
}


@property(assign) NSInteger categoryId;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSDictionary *)dict;


@end
