//
//  FirstViewController.h
//  DVVNestedScroll
//
//  Created by David on 2022/2/28.
//

#import <UIKit/UIKit.h>
#import "DVVNestedScrollManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirstViewController : UIViewController

@property (nonatomic, weak) DVVNestedScrollManager *nestedScrollManager;

@end

NS_ASSUME_NONNULL_END
