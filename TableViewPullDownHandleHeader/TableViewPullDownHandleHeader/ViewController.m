//
//  ViewController.m
//  TableViewPullDownHandleHeader
//
//  Created by HaoHuoBan on 2019/9/12.
//  Copyright © 2019年 HaoHuoBan. All rights reserved.
//

#import "ViewController.h"

#define  screenW  [UIScreen mainScreen].bounds.size.width
#define  screenH  [UIScreen mainScreen].bounds.size.height
#define  navH  88
#define scale 1.777778
#define headerHeight (screenW*scale - navH)/2
@interface NavView : UIView
{
    UILabel *_titleLabel;
}
@property (nonatomic, copy) NSString *title;

@end

@implementation NavView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        self.frame = CGRectMake(0, 0, screenW, navH);
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat labelW = 100;
        CGFloat labelX = screenW/2 - labelW/2;
        CGFloat labelY = 0;
        CGFloat labelH = navH;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        _titleLabel.text = self.title;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = title;
    }
}

@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NavView *_nav;
    UIImageView *_headerImgv;
    CGRect _headerViewFrame;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _headerImgv = [[UIImageView alloc] init];
    _headerImgv.image = [UIImage imageNamed:@"0x0ss_3.jpeg"];
    _headerImgv.frame = CGRectMake(0, 0, screenW, screenW * scale);
    [self.view addSubview:_headerImgv];
    _headerViewFrame = _headerImgv.frame;
    
    _nav =[[NavView alloc] init];
    [self.view addSubview:_nav];
    _nav.title = @"首页";
    
    UIView *headerView = [[UIView alloc] init];
    headerView.bounds = CGRectMake(0, 0, screenW, headerHeight);
    headerView.backgroundColor = [UIColor clearColor];
    CGRect tableFrame = CGRectMake(0, navH , screenW, screenH-navH);
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.tableHeaderView = headerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行",indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    // 处理导航颜色
    if (offsetY < headerHeight) {
        CGFloat colorAlpha = offsetY / headerHeight;
        NSLog(@"ccc = %f",colorAlpha);
        _nav.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:colorAlpha];
    } else {
        _nav.backgroundColor = [UIColor purpleColor];
    }
    
    // 处理图片缩放
    if (offsetY > 0) { // 往上移动
        CGRect frame = _headerViewFrame;
        frame.origin.y = frame.origin.y - offsetY;
        _headerImgv.frame = frame;
    } else {
        CGRect frame = _headerViewFrame;
        frame.size.height = _headerViewFrame.size.height - offsetY;
        frame.size.width = frame.size.height / scale;
        frame.origin.x = frame.origin.x - (frame.size.width - _headerViewFrame.size.width)/2;
        _headerImgv.frame = frame;
    }
}

@end
