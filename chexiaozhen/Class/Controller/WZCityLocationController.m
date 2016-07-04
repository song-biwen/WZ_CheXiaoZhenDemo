//
//  WZCityLocationController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/7/4.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZCityLocationController.h"
#import <CoreLocation/CoreLocation.h>

@interface WZCityLocationController ()
<
    CLLocationManagerDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>


{
    BOOL isLocationed;
}
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSString *currentCity;

/*
 *tableview
 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation WZCityLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置定位
    [self setupLocation];
    
    [self setupTableView];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section][@"cities"] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataSource[section][@"title"];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView  {
    return [self.sections copy];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    //点击索引，列表跳转到对应索引的行
    
    NSLog(@"%@",title);
    [tableView
     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.section][@"cities"][indexPath.row];
    if (indexPath.section == 0) {
        if (self.currentCity.length > 0) {
            cell.textLabel.text = self.currentCity;
        }else {
            cell.textLabel.text = @"正在定位中";
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma amrk - CLLocationManagerDelegate

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    
    if (!isLocationed) {
        
        isLocationed = YES;
        CLLocation *currentLocation = [locations lastObject];
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        //反编码
        [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (placemarks.count > 0) {
                CLPlacemark *placeMark = placemarks[0];
                self.currentCity = placeMark.locality;
                if (!self.currentCity) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    self.currentCity = placeMark.administrativeArea;
                }
                NSLog(@"%@",self.currentCity); //这就是当前的城市
                NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
                
                // 刷新
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else if (error == nil && placemarks.count == 0) {
                NSLog(@"No location and error return");
            }
            else if (error) {
                NSLog(@"location error: %@ ",error);
            }
            
        }];
        
    }
    
    
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        [self setupPrivacySetting];
    }
   
    
}

/** 设置定位 */
- (void)setupLocation {
    
    //设备是否开启定位
    if ([CLLocationManager locationServicesEnabled]) {
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (status == kCLAuthorizationStatusNotDetermined) {
            //表示应用在前台的时候可以搜到更新的位置信息
            [self.locationManager requestWhenInUseAuthorization];
            //开始定位，不断调用其代理方法
            [self.locationManager startUpdatingLocation];
            
        } else if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
            [self setupPrivacySetting];
            
        }else {
            //开始定位，不断调用其代理方法
            [self.locationManager startUpdatingLocation];
        }
        
    }else {
        NSLog(@"请打开定位");
    }
    
}


/** 打开隐私设置 */
- (void)setupPrivacySetting {
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"设置\"隐私\"定位服务" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return _locationManager;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = [UIColor lightGrayColor];
        
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (void)setupTableView {
    
    self.dataSource = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cityGroups" ofType:@"plist"]];
    self.sections = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in self.dataSource) {
        [self.sections addObject:dic[@"title"]];
    }
    
    [self.sections replaceObjectAtIndex:0 withObject:@"当前"];
    
    [self.tableView reloadData];
}

@end
