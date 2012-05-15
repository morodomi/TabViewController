/**
 * @author dommy <shonan.shachu at gmail.com>
 * @version 1.0.0 updated on 2012-05-15
 */

#import <UIKit/UIKit.h>

#define PAGE_CONTACTS 0
#define PAGE_MESSAGES 1
#define PAGE_SETTINGS 2

@interface TabPagerViewController : UIViewController <UIScrollViewDelegate, UITabBarDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITabBar *tabBar;

@end
