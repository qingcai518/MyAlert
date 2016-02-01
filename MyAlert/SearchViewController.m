//
//  ViewController.m
//  MyAlert
//
//  Created by user on 2016/01/20.
//  Copyright © 2016年 user. All rights reserved.
//

#import "SearchViewController.h"
@interface SearchViewController ()
@end
@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompletion:) name:@"RegisterCompletionNotification" object:nil];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home.jpg"]];
    backImage.userInteractionEnabled = YES;
    backImage.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    [self.view addSubview:backImage];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, rect.size.width - 20, 60)];
    title.font = [UIFont fontWithName:@"Verdana" size:40];
    title.textColor = [UIColor whiteColor];
    title.text = @"Mr. Alert";
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    self.stationTF = [[MLPAutoCompleteTextField alloc]initWithFrame:CGRectMake(30, 200, rect.size.width - 60 -40, 40)];
    self.stationTF.borderStyle = UITextBorderStyleRoundedRect;
    self.stationTF.backgroundColor = [UIColor whiteColor];
    self.stationTF.placeholder = @"駅名を入力してください";
    self.stationTF.font = [UIFont fontWithName:@"Verdana" size:18];
    self.stationTF.clearButtonMode = UITextFieldViewModeAlways;
    self.stationTF.returnKeyType = UIReturnKeyDone;
    self.stationTF.autoCompleteDataSource = self;
    self.stationTF.delegate = self;
    [self.stationTF addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.stationTF];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stationTF.frame), 200, 40, 40)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, rect.size.width - 20, 20)];
    self.label.text = @"現在設定中の駅一覧";
    self.label.font = [UIFont fontWithName:@"Verdana" size:15];
    self.label.textColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 320, rect.size.width - 60, rect.size.height - 320- 30) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.layer.cornerRadius = 5.0f;
    self.tableView.backgroundColor = [UIColor selectStationColor];
    [self.tableView setClipsToBounds:YES];
    [self.view addSubview:self.tableView];
    [self showParts];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) showParts {
    if (self.stations == nil || self.stations.count <= 0) {
        self.tableView.hidden = YES;
        self.label.hidden = YES;
    } else {
        self.tableView.hidden = NO;
        self.label.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.tableView reloadData];
    [self showParts];
}

- (void) handleTapGesture:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
}

- (void) textFieldChanged {
    self.textInput = self.stationTF.text;
}

- (void) doSearch {
    NSMutableArray *array = [DBManager getInfoByStationName:self.textInput];
    if (array.count > 0) {
        StationViewController *nextController =  [[StationViewController alloc] initWithStyle:UITableViewStylePlain data:array stations:self.stations];
        [self.navigationController pushViewController:nextController animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; // Dismiss the keyboard.
    [self doSearch];
    return YES;
}

#pragma datasource.
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        NSArray *completions;
        completions = [self getStations];
        handler(completions);
    });
}

- (NSArray *) getStations {
    return @[@"蓮根", @"志村三丁目", @"志村坂上", @"蓮沼", @"高島平", @"巣鴨", @"春日", @"大門", @"勝どき", @"月島", @"上野御徒町", @"新御徒町"];
}

-(void)registerCompletion:(NSNotification*)notification {
    self.stations = [[notification userInfo] valueForKey:@"stations"];
    [self.tableView reloadData];
    [self showParts];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self getCell:(int)indexPath.row tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StationCell *cell = [self getCell:(int)indexPath.row tableView:tableView];
    return cell.height;
}

- (StationCell *)getCell:(int)index tableView:(UITableView *)tableView {
//    NSString *cellId = @"id1";
//    StationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[StationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
    StationCell *cell = [[StationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary *dic = self.stations[index];
    [cell setContents:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.stations[indexPath.row];

}

@end
