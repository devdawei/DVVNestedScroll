//
//  SecondViewController.m
//  DVVNestedScroll
//
//  Created by David on 2022/2/28.
//

#import "SecondViewController.h"

@interface SecondViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SecondViewController

- (void)dealloc {
    [self.nestedScrollManager.subScrollViews removeObject:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.nestedScrollManager.subScrollViews addObject:self.tableView];
    
    CGSize size = UIScreen.mainScreen.bounds.size;
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height - 44 - 88);
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10*3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (indexPath.row%2) {
        cell.backgroundColor = UIColor.orangeColor;
    } else {
        cell.backgroundColor = UIColor.greenColor;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.nestedScrollManager handleSubWithScrollView:scrollView];
}

#pragma mark -

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 子滚动视图需要设置 alwaysBounceVertical = YES
        _tableView.alwaysBounceVertical = YES;
        
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
