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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentLocation:) name:@"CurrentLocationNotification" object:nil];
    
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.delegate = self; // これを追加
    [self.tableView addGestureRecognizer:tapGesture];
}

# pragma mark - UITapGestureRecognizer Delegate
- (void) handleTapGesture:(UITapGestureRecognizer*)sender {
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // UITapGestureが受け取っていい(= tableViewDidTap: が実行されていい)場合に YESを返す
    return [self canBecomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) showParts {
    if (LocationManagerSingleton.sharedSingleton.selectStations == nil || LocationManagerSingleton.sharedSingleton.selectStations.count <= 0) {
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

- (void) textFieldChanged {
    self.textInput = self.stationTF.text;
}

- (void) doSearch {
    if (self.stationTF.text == nil || [self.stationTF.text isEqualToString:@""]) {
        [JCAlertView showOneButtonWithTitle:@"My Alert" Message:@"駅名を入力してください。" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"OK" Click:^{}];
        return;
    }
    NSMutableArray *array = [DBManager getInfoByStationName:self.textInput];
    if (array.count > 0) {
        self.stationTF.text = @"";
        StationViewController *nextController =  [[StationViewController alloc] initWithStyle:UITableViewStylePlain data:array];
        [self.navigationController pushViewController:nextController animated:YES];
    } else {
        [JCAlertView showOneButtonWithTitle:@"My Alert" Message:@"入力した駅名が見つかりませんでした。" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"OK" Click:^{}];
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
    [self.tableView reloadData];
    [self showParts];
}

-(void)currentLocation:(NSNotification*)notification {
    self.current = [[notification userInfo] valueForKey:@"currentLocation"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return LocationManagerSingleton.sharedSingleton.selectStations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self getCell:(int)indexPath.row tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectStationCell *cell = [self getCell:(int)indexPath.row tableView:tableView];
    return cell.height;
}

- (SelectStationCell *)getCell:(int)index tableView:(UITableView *)tableView {
    SelectStationCell *cell = [[SelectStationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary *dic = LocationManagerSingleton.sharedSingleton.selectStations[index];
    [cell setContents:dic current:self.current];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewController *nextController = [[MapViewController alloc] init:indexPath.row];
    [self.navigationController pushViewController:nextController animated:YES];
}

@end
