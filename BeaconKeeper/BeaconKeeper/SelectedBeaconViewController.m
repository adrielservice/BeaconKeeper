//
//  SelectedBeaconViewController.m
//  BeaconKeeper
//
//  Created by David Beilis on 2013-07-28.
//  Copyright (c) 2013 Adriel Service. All rights reserved.
//

#import "SelectedBeaconViewController.h"
#import "ALCalibrationCalculator.h"
#import "ALDefaults.h"

#import <CoreLocation/CoreLocation.h>

@interface SelectedBeaconViewController ()

- (void) startAdvertising;
- (void) stopAdvertising;

- (void) updateSwitchStatus;

@end

@implementation SelectedBeaconViewController

{
    CBPeripheralManager *_peripheralManager;
    
    BOOL _enabled;
    NSUUID *_uuid;
    NSNumber *_power;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	id sender = [self.delegate getSelectedSender];
    NSString *imageName = [[ALDefaults sharedDefaults].supportedImageNames objectAtIndex:([sender tag] - 1)];
    NSLog(@"Selected image - %@", imageName);
    self.selectedImage.image = [UIImage imageNamed:imageName];
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    _uuid = [[ALDefaults sharedDefaults].supportedProximityUUIDs objectAtIndex:([sender tag] - 1)];
    _power = [ALDefaults sharedDefaults].defaultPower;
    
    [self.enabledSwitch addTarget:self action:@selector(configurationChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self updateSwitchStatus];

}

- (void) updateSwitchStatus {
    if (_enabled) {
        self.status.text = @"Transmiting signal...";
    } else {
        self.status.text = @"iBeacon is OFF";
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // Refresh the enabled switch.
    // Refresh the enabled switch.
    _enabled = _enabledSwitch.on = _peripheralManager.isAdvertising;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Cancel calibration (if it was started) and stop ranging when the view goes away.
    [self stopAdvertising];
}

- (void) configurationChanged:(id)sender {
    
    if(sender == _enabledSwitch) {
        _enabled = _enabledSwitch.on;
    }
    
    if (_enabled) {
        [self startAdvertising];
    } else {
        [self stopAdvertising];
    }
    
    [self updateSwitchStatus];
    
}

- (void) startAdvertising {
    
    if(_peripheralManager.state < CBPeripheralManagerStatePoweredOn)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Bluetooth must be enabled" message:@"To configure your device as a beacon" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
        return;
    }
    
    if(_enabled)
    {
        // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
        NSDictionary *peripheralData = nil;

        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:_uuid identifier:@"com.apple.AirLocate"];
        peripheralData = [region peripheralDataWithMeasuredPower:_power];
    
        // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
        if(peripheralData)
        {
            [_peripheralManager startAdvertising:peripheralData];
            NSLog(@"Started advertising...");
        }
    }
    
}

- (void) stopAdvertising {
    NSLog(@"Stopping advertisment...");
    [_peripheralManager stopAdvertising];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate selectedBeaconViewControllerDidFinish:self];
}

@end
