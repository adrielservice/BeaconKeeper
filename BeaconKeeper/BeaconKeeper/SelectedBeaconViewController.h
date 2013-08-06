//
//  SelectedBeaconViewController.h
//  BeaconKeeper
//
//  Created by David Beilis on 2013-07-28.
//  Copyright (c) 2013 Adriel Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


@class SelectedBeaconViewController;

@protocol SelectedBeaconViewControllerDelegate
- (void)selectedBeaconViewControllerDidFinish:(SelectedBeaconViewController *)controller;
- (id)getSelectedSender;
@end

@interface SelectedBeaconViewController : UIViewController<CBPeripheralManagerDelegate>

@property (weak, nonatomic) id <SelectedBeaconViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;

@property (weak, nonatomic) IBOutlet UILabel *status;

- (IBAction)done:(id)sender;

@end
