/**
 * @description
 *      PagerView with Tabs
 * @author dommy <shonan.shachu at gmail.com>
 * @version 1.0.0 updated on 2012-05-15
 */

#import "TabPagerViewController.h"
#import "Document1ViewController.h"
#import "Document2ViewController.h"
#import "Document3ViewController.h"

@interface TabPagerViewController ()
@property (assign) BOOL pageControlUsed;
@property (assign) NSUInteger page;
@property (assign) NSArray *controllers;
@property (assign) NSArray *tabItems;
- (void)loadScrollViewWithPage:(int)page;
@end

@implementation TabPagerViewController

@synthesize scrollView;
@synthesize tabBar;
@synthesize pageControlUsed = _pageControlUsed;
@synthesize page = _page;
@synthesize controllers = _controllers;
@synthesize tabItems = _tabItems;

- (void)dealloc {
    [tabBar release];
    [scrollView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // initialize UIViewControllers
        self.controllers = [[NSArray alloc] 
                            initWithObjects:
                            [[Document1ViewController alloc] initWithNibName:@"Document1ViewController" bundle:nil],
                            [[Document2ViewController alloc] initWithNibName:@"Document2ViewController" bundle:nil],
                            [[Document3ViewController alloc] initWithNibName:@"Document3ViewController" bundle:nil],
                            nil];
        // UITabBarItem settings;
        self.tabItems = [[NSArray alloc]
                         initWithObjects:
                         [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:PAGE_CONTACTS] autorelease],
                         [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:PAGE_MESSAGES] autorelease],
                         [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:PAGE_SETTINGS] autorelease],
                         nil];
        [[self.tabItems objectAtIndex:PAGE_CONTACTS] setTitle:NSLocalizedString(@"TabItemTitleContacts", nil)];
        [[self.tabItems objectAtIndex:PAGE_MESSAGES] setTitle:NSLocalizedString(@"TabItemTitleMessages", nil)];
        [[self.tabItems objectAtIndex:PAGE_SETTINGS] setTitle:NSLocalizedString(@"TabItemTitleSettings", nil)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // UIScrollView settings
	[self.scrollView setPagingEnabled:YES];
	[self.scrollView setScrollEnabled:YES];
    [self.scrollView setBounces:NO];
	[self.scrollView setShowsHorizontalScrollIndicator:NO];
	[self.scrollView setShowsVerticalScrollIndicator:NO];
	[self.scrollView setDelegate:self];

    // UITabBar settings
    [self.tabBar setDelegate:self];
    [tabBar setItems:self.tabItems animated:NO];
	_page = 0;
    [tabBar setSelectedItem:[self.tabItems objectAtIndex:_page]];

    // Load View Controllers
	for (NSUInteger i =0; i < [self.controllers count]; i++) {
		[self loadScrollViewWithPage:i];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	UIViewController *viewController = [self.controllers objectAtIndex:self.tabBar.selectedItem.tag];
	if (viewController.view.superview != nil) {
		[viewController viewWillAppear:animated];
	}
    
	self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.controllers count], scrollView.frame.size.height);
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	UIViewController *viewController = [self.controllers objectAtIndex:self.tabBar.selectedItem.tag];
	if (viewController.view.superview != nil) {
		[viewController viewDidAppear:animated];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	UIViewController *viewController = [self.controllers objectAtIndex:self.tabBar.selectedItem.tag];
	if (viewController.view.superview != nil) {
		[viewController viewWillDisappear:animated];
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	UIViewController *viewController = [self.controllers objectAtIndex:self.tabBar.selectedItem.tag];
	if (viewController.view.superview != nil) {
		[viewController viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0 || page >= [self.controllers count])
        return;
    
	// replace the placeholder if necessary
    UIViewController *controller = [self.controllers objectAtIndex:page];
    if (controller == nil) {
		return;
    }
    
	// add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	UIViewController *oldViewController = [self.controllers objectAtIndex:_page];
	UIViewController *newViewController = [self.controllers objectAtIndex:self.tabBar.selectedItem.tag];
	[oldViewController viewDidDisappear:YES];
	[newViewController viewDidAppear:YES];
    
	_page = self.tabBar.selectedItem.tag;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (self.tabBar.selectedItem.tag != page) {
		UIViewController *oldViewController = [self.controllers objectAtIndex:self.tabBar.selectedItem.tag];
		UIViewController *newViewController = [self.controllers objectAtIndex:page];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
        [self.tabBar setSelectedItem:[self.tabItems objectAtIndex:page]];
		self.tabBar.selectedItem.tag = page;
		[oldViewController viewDidDisappear:YES];
		[newViewController viewDidAppear:YES];
		_page = page;
	}
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

#pragma mark -
#pragma mark UITabBarDelegate methods
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [scrollView scrollRectToVisible:CGRectMake(320 * item.tag, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    _pageControlUsed = YES;
}
@end
