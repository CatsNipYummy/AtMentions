//
//  TagCollectionViewCell.h
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagCollectionViewCellDelegate <NSObject>

- (void) namePressed:(NSString*) currentUserName;

@end

@interface TagCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIButton *userNameButton;
@property (nonatomic, weak) IBOutlet UIView *separatorView;
@property (nonatomic, weak) id delegate;
- (IBAction)userNamePressed:(id)sender;

@end
