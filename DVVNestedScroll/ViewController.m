//
//  ViewController.m
//  DVVNestedScroll
//
//  Created by David on 2022/2/28.
//

#import "ViewController.h"
#import "DVVSegmentedView.h"
#import "DVVScrollPageView.h"
#import "DVVNestedScrollManager.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, DVVSegmentedViewDelegate, DVVScrollPageViewDelegate>

@property (nonatomic, strong) DVVNestedScrollTableView *tableView;

@property (nonatomic, strong) DVVNestedScrollManager *nestedScrollManager;

@property (nonatomic, strong) UITableViewCell *pagesCell;
@property (nonatomic, strong) DVVSegmentedView *segmentedView;
@property (nonatomic, strong) NSMutableArray<DVVSegmentedModel *> *segmentedModelArray;
@property (nonatomic, strong) DVVScrollPageView *scrollPageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nestedScrollManager = [[DVVNestedScrollManager alloc] init];
    
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat pagesCellHeight = size.height - 88;
    self.pagesCell.frame = CGRectMake(0, 0, size.width, pagesCellHeight);
    [self.pagesCell.contentView addSubview:self.segmentedView];
    CGFloat segmentedViewHeight = 44;
    self.segmentedView.frame = CGRectMake(0, 0, size.width, segmentedViewHeight);
    self.scrollPageView.frame = CGRectMake(0, segmentedViewHeight, size.width, pagesCellHeight - segmentedViewHeight);
    [self.pagesCell.contentView addSubview:self.segmentedView];
    [self.pagesCell.contentView addSubview:self.scrollPageView];
    
    self.tableView.frame = CGRectMake(0, 88, size.width, size.height - 88);
    [self.view addSubview:self.tableView];
    
    NSInteger count = 10;
    _segmentedModelArray = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        NSString *title = [NSString stringWithFormat:@"第%@个", @(i + 1)];
        [self.segmentedModelArray addObject:[self segmentedModelWithTitle:title]];
    }
    [self.segmentedView refreshWithDataModelArray:self.segmentedModelArray];
    [self.scrollPageView refreshWithPageCount:self.segmentedModelArray.count];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        return 100;
    } else {
        return UIScreen.mainScreen.bounds.size.height - 88;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = UIColor.redColor;
        return cell;
    } else {
        return self.pagesCell;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.nestedScrollManager handleSuperWithScrollView:scrollView];
}

#pragma mark - DVVSegmentedViewDelegate
#pragma mark 通过点击标题切换页面
- (void)segmentedView:(DVVSegmentedView *)segmentedView didSelectAtIndex:(NSInteger)index {
    [self.scrollPageView selectIndex:index animated:YES];
}

#pragma mark - DVVScrollPageViewDelegate
#pragma mark 返回需要显示的控制器
- (UIViewController *)scrollPageView:(DVVScrollPageView *)scrollPageView viewControllerAtIndex:(NSInteger)index {
    if (index%2 == 0) {
        FirstViewController *vc = [[FirstViewController alloc] init];
        vc.nestedScrollManager = self.nestedScrollManager;
        return vc;
    } else {
        SecondViewController *vc = [[SecondViewController alloc] init];
        vc.nestedScrollManager = self.nestedScrollManager;
        return vc;
    }
}

#pragma mark 页面滚动时调用
- (void)scrollPageView:(DVVScrollPageView *)scrollPageView scrollProgress:(CGFloat)scrollProgress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.segmentedView refreshItemStatusWithScrollProgress:scrollProgress fromIndex:fromIndex toIndex:toIndex];
}

#pragma mark 切换页面后调用
- (void)scrollPageView:(DVVScrollPageView *)scrollPageView didChangeCurrentSelectedIndex:(NSInteger)index {
    [self.segmentedView selectIndex:index animated:YES];
}

#pragma mark 结束滚动时调用
- (void)scrollPageViewDidEndScrolling:(DVVScrollPageView *)scrollPageView {
    [self.segmentedView refreshItemStatusCompletion];
}

#pragma mark -

- (DVVSegmentedModel *)segmentedModelWithTitle:(NSString *)title {
    DVVSegmentedModel *model = [[DVVSegmentedModel alloc] init];
    
    model.title = title;
    
    model.normalFont = [UIFont systemFontOfSize:15];
    model.selectedFont = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    
    model.normalTextColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    model.selectedTextColor = [UIColor whiteColor];
    
    model.normalBackgroundColor = [UIColor clearColor];
    model.selectedBackgroundColor = [UIColor clearColor];
    
    model.followerBarColor = [UIColor orangeColor];
    model.fixedFollowerBarWidth = 30;
    
    return model;
}

#pragma mark -

- (DVVNestedScrollTableView *)tableView {
    if (!_tableView) {
        _tableView = [[DVVNestedScrollTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 父滚动视图需要设置 showsVerticalScrollIndicator = NO
        _tableView.showsVerticalScrollIndicator = NO;
        // 父滚动视图需要设置 contentInsetAdjustmentBehavior 为 Never
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        // 父滚动视图需要设置 automaticallyAdjustsScrollIndicatorInsets = NO
        if (@available(iOS 13.0, *)) {
            _tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
    }
    return _tableView;
}

- (UITableViewCell *)pagesCell {
    if (!_pagesCell) {
        _pagesCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PagesCell"];
        _pagesCell.backgroundColor = UIColor.orangeColor;
    }
    return _pagesCell;
}

- (DVVSegmentedView *)segmentedView {
    if (!_segmentedView) {
        _segmentedView = [[DVVSegmentedView alloc] init];
        _segmentedView.backgroundColor = [UIColor colorWithRed:0/255.0 green:100/255.0 blue:255/255.0 alpha:1];
        _segmentedView.delegate = self;
        _segmentedView.contentNeedToCenter = YES;
    }
    return _segmentedView;
}

- (DVVScrollPageView *)scrollPageView {
    if (!_scrollPageView) {
        _scrollPageView = [[DVVScrollPageView alloc] init];
        _scrollPageView.backgroundColor = [UIColor whiteColor];
        _scrollPageView.delegate = self;
        _scrollPageView.rootViewController = self;
        _scrollPageView.bounces = NO;
    }
    return _scrollPageView;
}

@end
