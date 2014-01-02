//
//  RingtoneTabelCell.h
//  RingTones
//
//  Created by Nguyen Khoi Nguyen on 12/23/13.
//  Copyright (c) 2013 Vuong Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RingtoneTabelCell;
@protocol RingtoneTabelCellDelegate <NSObject>

-(void)editingCell: (RingtoneTabelCell *)cell;

@end

@interface RingtoneTabelCell : UITableViewCell
{
    
    __weak IBOutlet UIView *view_Back;
    __weak IBOutlet UIView *view_Front;
}

@property (nonatomic, weak) id <RingtoneTabelCellDelegate> delegate;
@property   (nonatomic, assign) BOOL isEditing;

@property (weak, nonatomic) IBOutlet UILabel *label_playerTimer;
@property (weak, nonatomic) IBOutlet UITextField *textField_RingtoneName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Loading;
@property (weak, nonatomic) IBOutlet UIButton *btn_Share;
@property (weak, nonatomic) IBOutlet UIButton *btn_Edit;
@property (weak, nonatomic) IBOutlet UIButton *btn_Rename;
@property (weak, nonatomic) IBOutlet UIButton *btn_Delete;

- (IBAction)btn_Rename_Tapped:(id)sender;
-(void)hideBackView;

@end
