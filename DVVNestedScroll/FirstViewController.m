//
//  FirstViewController.m
//  DVVNestedScroll
//
//  Created by David on 2022/2/28.
//

#import "FirstViewController.h"

@interface FirstViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FirstViewController

- (void)dealloc {
    [self.nestedScrollManager.subScrollViews removeObject:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.nestedScrollManager.subScrollViews addObject:self.collectionView];
    
    CGSize size = UIScreen.mainScreen.bounds.size;
    self.collectionView.frame = CGRectMake(0, 0, size.width, size.height - 44 - 88);
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.redColor;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.nestedScrollManager handleSubWithScrollView:scrollView];
}

#pragma mark -

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        CGSize size = UIScreen.mainScreen.bounds.size;
        flowLayout.itemSize = CGSizeMake((size.width - 10*3)/2.0, 200);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // 子滚动视图需要设置 alwaysBounceVertical = YES
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
    }
    return _collectionView;
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
