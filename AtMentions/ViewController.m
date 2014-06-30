//
//  QuestReplyViewController.m
//  Quest
//
//  Created by fishsticks on 30/6/14.
//

#import "ViewController.h"
#import "TagCollectionViewCell.h"

@interface ViewController () <TagCollectionViewCellDelegate>
{
    TagCollectionViewCell *_sizingCell;
    NSArray *_oldArray, *_currentNames;
    NSString *_currentName;
    NSMutableArray *_words;
}
@property (nonatomic, strong) NSMutableArray* array;

@end

@implementation ViewController
@synthesize names = _names;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Test names to check the @mention against
    _names = [[NSMutableArray alloc] initWithObjects:@"Aaron", @"Ajay", @"Amal", @"Ben", @"Dave", @"Dan", @"John", @"Jill", @"Jim", nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"TagCell"];
	
	// get a cell as template for sizing
	_sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.collectionViewEmbedView setHidden:YES];
    
    // Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.1f];
}

- (void) showKeyboard
{
    [self.textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark Changing Toolbar location

- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect frame = self.bottomView.frame;
    frame.origin.y = self.view.frame.size.height - 266.0;
    self.bottomView.frame = frame;
    [UIView commitAnimations];
    
}

- (void) positionToolbar
{
    //Position Toolbar
    CGRect frame = self.bottomView.frame;
    frame.size.height = 43.0f;
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    self.bottomView.frame = frame;
}

#pragma mark UITextView Delegates
- (void) textViewDidChange:(UITextView*) textView
{
    [self.collectionViewEmbedView setHidden:YES];
    // @ Mentions
    if (_names)
    {
        // Split the text into words and find the words beginning with the character '@'
        _words = [[self.textView.text componentsSeparatedByString:@" "] mutableCopy];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] '@'"];
        NSArray* names = [_words filteredArrayUsingPredicate:predicate];
        if (_oldArray)
        {
            // To find the current editing name
            NSMutableSet* set1 = [NSMutableSet setWithArray:names];
            NSMutableSet* set2 = [NSMutableSet setWithArray:_oldArray];
            [set1 minusSet:set2];
            if (set1.count > 0)
            {
                _currentName = [[set1 allObjects] componentsJoinedByString:@""];
                _currentName = [_currentName stringByReplacingOccurrencesOfString:@"@" withString:@""];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", _currentName];
                NSArray *results = [_names filteredArrayUsingPredicate:predicate];
                _currentNames = results;
                [self.collectionView reloadData];
                if (results.count > 0)
                {
                    [self.collectionViewEmbedView setHidden:NO];
                    [self.collectionViewEmbedView startCanvasAnimation];
                }
            }
        }
        _oldArray = [[NSArray alloc] initWithArray:names];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _currentNames.count;
}

- (void)_configureCell:(TagCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
	cell.label.text = [_currentNames objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.label.textColor = [UIColor blackColor];
    cell.separatorView.backgroundColor = [UIColor blackColor];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
	cell.delegate = self;
	[self _configureCell:cell forIndexPath:indexPath];
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self _configureCell:_sizingCell forIndexPath:indexPath];
	
	return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

#pragma mark TagCollectionViewCell Delegate
- (void) namePressed:(NSString *)currentUserName
{
    int index = 0;
    for (__strong NSString *word in _words.mutableCopy)
    {
        if ([word isEqualToString:[NSString stringWithFormat:@"@%@", _currentName]])
        {
            [_words replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"@%@ ", currentUserName]];
        }
        index++;
    }
    
    self.textView.text = [_words componentsJoinedByString:@" "];
    _oldArray = nil;
    [self.collectionViewEmbedView setHidden:YES];
}

@end
