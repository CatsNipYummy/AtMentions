//
//  QuestReplyViewController.h
//  Quest
//
//  Created by fishsticks on 30/6/14.
//

#import <UIKit/UIKit.h>
#import "CSAnimationView.h"

@interface ViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet CSAnimationView *collectionViewEmbedView;

@property (nonatomic, strong) NSMutableArray *names;


@end
