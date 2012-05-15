/**
 * @description
 *      TabPagerViewController Document 3
 *      Can open modal view controller
 * @author dommy <shonan.shachu at gmail.com>
 * @version 1.0.0 updated on 2012-05-15
 */

#import "Document3ViewController.h"
#import "AppDelegate.h"
#import "ModalViewController.h"

@interface Document3ViewController ()
- (void)onClickModalButton;
@end

@implementation Document3ViewController

@synthesize navigationItem;
@synthesize modalButton;

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
    // Do any additional setup after loading the view from its nib.
    [navigationItem setTitle:@"Document 3"];
    [modalButton setTitle:@"modal"];
    [modalButton setTarget:self];
    [modalButton setAction:@selector(onClickModalButton)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onClickModalButton {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIViewController *root = delegate.window.rootViewController;
    ModalViewController *modalView = [[[ModalViewController alloc] 
                                        initWithNibName:@"ModalViewController" bundle:nil]
                                        autorelease];
    [modalView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [root presentModalViewController:modalView animated:YES];
}
@end
