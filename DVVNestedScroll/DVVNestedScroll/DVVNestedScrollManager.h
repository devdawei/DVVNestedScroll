//
//  DVVNestedScrollManager.h
//  DVVNestedScroll
//
//  Created by David on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DVVNestedScrollManager : NSObject

@property (nonatomic, readonly, assign) BOOL docked;

@property (nonatomic, strong) NSMutableArray<UIScrollView *> *subScrollViews;

- (void)handleSuperWithScrollView:(UIScrollView *)scrollView;

- (void)handleSubWithScrollView:(UIScrollView *)scrollView;

+ (BOOL)handleGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end


@interface UIScrollView (DVVNestedScrollManager)

@property (nonatomic, assign) BOOL dvv_canScroll;

@end


@interface DVVNestedScrollTableView : UITableView

@end


@interface DVVNestedScrollView : UIScrollView

@end


@interface DVVNestedScrollCollectionView : UICollectionView

@end

NS_ASSUME_NONNULL_END
