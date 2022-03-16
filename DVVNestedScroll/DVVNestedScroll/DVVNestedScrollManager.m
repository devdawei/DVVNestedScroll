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

- (void)handleScrollViewsCanScroll:(BOOL)canScroll {
    for (UIScrollView *scrollView in self.subScrollViews) {
        scrollView.dvv_canScroll = canScroll;
    }
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
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    CGFloat maxOffsetY = contentHeight - scrollView.bounds.size.height;
    if (maxOffsetY < 0) {
        return;
    }
//    NSLog(@"%@ %@", @(currentOffsetY), @(maxOffsetY));
    if (currentOffsetY >= maxOffsetY) {
//        NSLog(@"已停靠");
        self.docked = YES;
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        [self handleScrollViewsCanScroll:YES];
    } else {
        if (self.docked) {
//            NSLog(@"暂未停靠：docked=YES");
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        } else {
//            NSLog(@"暂未停靠");
            [self handleScrollViewsScrollToTop];
        }
    }
}

- (void)handleSubWithScrollView:(UIScrollView *)scrollView {
    if (self.subScrollViews.count == 0) {
        return;
    }
    if (scrollView.dvv_canScroll) {
        if (scrollView.contentOffset.y <= 0) {
            scrollView.dvv_canScroll = NO;
            self.docked = NO;
        }
    } else {
        scrollView.dvv_canScroll = NO;
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


@implementation UIScrollView (DVVNestedScrollManager)

static char DVVNestedScrollCanScroll;

- (void)setDvv_canScroll:(BOOL)dvv_canScroll {
    objc_setAssociatedObject(self, &DVVNestedScrollCanScroll, @(dvv_canScroll), OBJC_ASSOCIATION_ASSIGN);
    
    self.showsVerticalScrollIndicator = dvv_canScroll;
    if (!dvv_canScroll) {
        self.contentOffset = CGPointZero;
    }
}

- (BOOL)dvv_canScroll {
    id obj = objc_getAssociatedObject(self, &DVVNestedScrollCanScroll);
    if (obj) {
        return [obj boolValue];
    } else {
        // default value.
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
