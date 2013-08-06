//
//  ScannerViewController.m
//  BeaconKeeper
//
//  Created by David Beilis on 2013-07-28.
//  Copyright (c) 2013 Adriel Service. All rights reserved.
//

#import "ScannerViewController.h"
#import "AnimatedGif.h"
#import "ALCalibrationCalculator.h"
#import "ALDefaults.h"

@interface ScannerViewController ()

- (void)startRangingAllRegions;
- (void)stopRangingAllRegions;

@end

@implementation ScannerViewController {
    NSMutableDictionary *_beacons;
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
    
    int _clearNotificationCounter;
    
    ALCalibrationCalculator *_calculator;
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // CoreLocation will call this delegate method at 1 Hz with updated range information.
    // Beacons will be categorized and displayed by proximity.
    [_beacons removeAllObjects];
    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
    if([unknownBeacons count])
        [_beacons setObject:unknownBeacons forKey:[NSNumber numberWithInt:CLProximityUnknown]];
    
    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
    if([immediateBeacons count])
        [_beacons setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];
    
    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    if([nearBeacons count])
        [_beacons setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];
    
    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    if([farBeacons count])
        [_beacons setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];
    
    if ([beacons count] > 0) {
        _clearNotificationCounter = 0;
        NSUUID *uuid = [[beacons objectAtIndex:0] proximityUUID];
        self.foundPersonName.text = [[ALDefaults sharedDefaults] displayString:uuid];
        self.foundPersonImageView.image = [UIImage imageNamed:[[ALDefaults sharedDefaults] imageName:uuid]];
    } else {
        ++_clearNotificationCounter;
        if (_clearNotificationCounter > 5) {
            self.foundPersonName.text = @"Scanning...";
            self.foundPersonImageView.image = nil;
        }
    }
    
    // [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Start ranging to show the beacons available for calibration.
    [self startRangingAllRegions];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Cancel calibration (if it was started) and stop ranging when the view goes away.
    [_calculator cancelCalibration];
    [self stopRangingAllRegions];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _clearNotificationCounter = 0;
    
    // Populate the regions for the beacons we're interested in calibrating.
    _rangedRegions = [NSMutableArray array];
    [[ALDefaults sharedDefaults].supportedProximityUUIDs enumerateObjectsUsingBlock:^(id uuidObj, NSUInteger uuidIdx, BOOL *uuidStop) {
        NSUUID *uuid = (NSUUID *)uuidObj;
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        [_rangedRegions addObject:region];
    }];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"radar" ofType:@"gif"];
//    UIImageView * radarAnimatedGif = [AnimatedGif getAnimationForGifAtUrl: [NSURL URLWithString:path]];
//    self.radarImageView.image = radarAnimatedGif.image;
    
    _beacons = [[NSMutableDictionary alloc] init];
    
    // This location manager will be used to display beacons available for calibration.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRangingAllRegions
{
    [_rangedRegions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CLBeaconRegion *region = obj;
        [_locationManager startRangingBeaconsInRegion:region];
    }];
}

- (void)stopRangingAllRegions
{
    [_rangedRegions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CLBeaconRegion *region = obj;
        [_locationManager stopRangingBeaconsInRegion:region];
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // A special indicator appears if calibration is in progress.
    // This is handled throughout the table view controller delegate methods.
    return _beacons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger i = section;
    
    NSArray *sectionValues = [_beacons allValues];
    int numValues = [[sectionValues objectAtIndex:i] count];
    NSLog(@"These many values %d at %d section", numValues, i);
    return numValues;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger i = section;
    
    NSString *title = nil;
    NSArray *sectionKeys = [_beacons allKeys];
    
    NSNumber *sectionKey = [sectionKeys objectAtIndex:i];
    switch([sectionKey integerValue])
    {
        case CLProximityImmediate:
            title = @"Immediate";
            break;
            
        case CLProximityNear:
            title = @"Near";
            break;
            
        case CLProximityFar:
            title = @"Far";
            break;
            
        default:
            title = @"Unknown";
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *beaconCellIdentifier = @"BeaconCell";
    
    NSInteger i = indexPath.section;
    NSString *identifier = beaconCellIdentifier;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	}
    
    NSNumber *sectionKey = [[_beacons allKeys] objectAtIndex:i];
    CLBeacon *beacon = [[_beacons objectForKey:sectionKey] objectAtIndex:indexPath.row];
    NSString *name = [[ALDefaults sharedDefaults] displayString:beacon.proximityUUID];
    NSLog(@"Received update for - %@ at %d - %d", name, [sectionKey intValue], i);
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@, Acc: %.2fm", beacon.major, beacon.minor, beacon.accuracy];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *sectionKey = [[_beacons allKeys] objectAtIndex:indexPath.section];
    CLBeacon *beacon = [[_beacons objectForKey:sectionKey] objectAtIndex:indexPath.row];
    

    CLBeaconRegion *region = nil;
    if(beacon.proximityUUID && beacon.major && beacon.minor)
    {
        region = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.proximityUUID major:[beacon.major shortValue] minor:[beacon.minor shortValue] identifier:@"com.apple.AirLocate"];
    }
    else if(beacon.proximityUUID && beacon.major)
    {
        region = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.proximityUUID major:[beacon.major shortValue] identifier:@"com.apple.AirLocate"];
    }
    else if(beacon.proximityUUID)
    {
        region = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.proximityUUID identifier:@"com.apple.AirLocate"];
    }
    
//    if(region)
//    {
//        // We can stop ranging to display beacons available for calibration.
//        [self stopRangingAllRegions];
//        
//        // And we'll start the calibration process.
//        _calculator = [[ALCalibrationCalculator alloc] initWithRegion:region completionHandler:^(NSInteger measuredPower, NSError *error) {
//            if(error)
//            {
//                // Only display if the view is showing.
//                if(self.view.window)
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to calibrate device" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    
//                    // Resume displaying beacons available for calibration if the calibration process failed.
//                    [self startRangingAllRegions];
//                }
//            }
//        
//            _calculator = nil;
//            
//            [self.tableView reloadData];
//        }];
//                
//        [self.tableView reloadData];
//    }
}


#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate scannerViewControllerDidFinish:self];
}

@end
