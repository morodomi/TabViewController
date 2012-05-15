/**
 * @description
 *      ModalViewController
 * @author dommy <shonan.shachu at gmail.com>
 * @version 1.0.0 updated on 2012-05-15
 */

#import "ModalViewController.h"
#import "AppDelegate.h"

@interface ModalViewController ()
-(void)onClickBackButton;
@end

@implementation ModalViewController

@synthesize navigationItem;
@synthesize backButton;

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
    [navigationItem setTitle:@"Modal View"];
    [backButton setTarget:self];
    [backButton setAction:@selector(onClickBackButton)];
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

- (void)onClickBackButton {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    UIViewController *root = delegate.window.rootViewController;
    [root dismissModalViewControllerAnimated:YES];
}
@end
