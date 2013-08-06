//
//  BeaconViewController.h
//  BeaconKeeper
//
//  Created by David Beilis on 2013-07-28.
//  Copyright (c) 2013 Adriel Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedBeaconViewController.h"
#import "KYCircleMenu.h"

@class BeaconViewController;

@protocol BeaconViewControllerDelegate
- (void)beaconViewControllerDidFinish:(BeaconViewController *)controller;
@end

@interface BeaconViewController : KYCircleMenu<SelectedBeaconViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) id <BeaconViewControllerDelegate> delegate;

@property (nonatomic) id selectedSender;

- (IBAction)done:(id)sender;


@property (strong, nonatomic) UIPopoverController *selectedBeaconPopoverController;

- (IBAction)toggleSelectedBeacon:(id)sender;


@end
