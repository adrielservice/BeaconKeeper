//
//  MainViewController.h
//  BeaconKeeper
//
//  Created by David Beilis on 2013-07-28.
//  Copyright (c) 2013 Adriel Service. All rights reserved.
//

#import "FlipsideViewController.h"
#import "ScannerViewController.h"
#import "BeaconViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, ScannerViewControllerDelegate, BeaconViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (strong, nonatomic) UIPopoverController *scannerPopoverController;

@property (strong, nonatomic) UIPopoverController *beaconPopoverController;

@end
