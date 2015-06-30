//
//  TempTableViewController.m
//  MLTransitionNavigationController
//
//  Created by molon on 7/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "TempTableViewController.h"
#import "TempViewController.h"

@interface TempTableViewController ()
<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@property (nonatomic, assign) NSUInteger cellCount;

@end

@implementation TempTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //这个其实只是为了测试下搜索bar显示时候的效果。
    
    self.tableView.tableHeaderView = self.searchBar;
    self.searchController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UISearchBar *)searchBar
{
	if (!_searchBar) {
        UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44.0f)];
        searchBar.placeholder = @"搜索";
        searchBar.delegate = self;
        [searchBar sizeToFit];
        _searchBar = searchBar;
	}
	return _searchBar;
}

- (UISearchDisplayController *)searchController
{
	if (!_searchController) {
		_searchController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsDelegate = self;
	}
	return _searchController;
}

#pragma mark - searchbar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //找到名字里有searchText关键字的
    if (searchText.length<=0) {
        self.cellCount = 0;
    }else{
        self.cellCount = 5;
    }
    [self.searchController.searchResultsTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self]) {
        return;
    }
    TempViewController *vc = [[TempViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return 4;
    }
    
    return self.cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}


@end
