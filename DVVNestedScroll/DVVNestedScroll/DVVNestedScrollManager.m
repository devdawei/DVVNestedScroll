//
//  DVVNestedScrollManager.m
//  DVVNestedScroll
//
//  Created by David on 2022/2/28.
//

#import "DVVNestedScrollManager.h"
#import <objc/runtime.h>

@interface DVVNestedScrollManager ()

@property (nonatomic, readwrite, assign) BOOL docked;

@end

@implementation DVVNestedScrollManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _subScrollViews = [NSMutableArray array];
    }
    return self;
}

- (void)handleScrollViewsScrollToTop {
    for (UIScrollView *scrollView in self.subScrollViews) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (void)handleSuperWithScrollView:(UIScrollView *)scrollView {
    if (self.subScrollViews.count == 0) {
        return;
    }
    CGFloat contentHeight = scrollView.contentSize.height;
    if (contentHeight <= 0) {
        return;
    }
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    CGFloat maxOffsetY = contentHeight - scrollView.bounds.size.height;
    if (maxOffsetY < 0) {
        return;
    }
    if (currentOffsetY > maxOffsetY || self.docked) {
        self.docked = true;
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
    }
}

- (void)handleSubWithScrollView:(UIScrollView *)scrollView {
    if (self.subScrollViews.count == 0) {
        return;
    }
    if (self.docked) {
        if (scrollView.contentOffset.y < 0) {
            self.docked = false;
            [self handleScrollViewsScrollToTop];
        }
    } else {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

+ (BOOL)handleGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[self class]]) {
        return YES;
    } else {
        if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
            && [otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
            // 解决 scrollView 横向滚动与其他 scrollView 纵向滚动同时进行的问题
            if (fabs(scrollView.contentOffset.x) > 0 && fabs(scrollView.contentOffset.y) == 0) {
                return NO;
            }
            return YES;
        }
        return NO;
    }
}

@end


@implementation DVVNestedScrollTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [DVVNestedScrollManager handleGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
}

@end


@implementation DVVNestedScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [DVVNestedScrollManager handleGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
}

@end


@implementation DVVNestedScrollCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [DVVNestedScrollManager handleGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
}

@end
