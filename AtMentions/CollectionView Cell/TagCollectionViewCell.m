//
//  TagCollectionViewCell.m
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell
@synthesize delegate;

- (IBAction)userNamePressed:(id)sender
{
    if ([delegate respondsToSelector:@selector(namePressed:)])
    {
        [delegate namePressed:self.label.text];
    }
}
@end
