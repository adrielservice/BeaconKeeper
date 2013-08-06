//
//  ScannerViewController.h
//  BeaconKeeper
//
//  Created by David Beilis on 2013-07-28.
//  Copyright (c) 2013 Adriel Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@class ScannerViewController;

@protocol ScannerViewControllerDelegate
- (void)scannerViewControllerDidFinish:(ScannerViewController *)controller;
@end

@interface ScannerViewController : UIViewController<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <ScannerViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView* radarImageView;

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (weak, nonatomic) IBOutlet UILabel *foundPersonName;

@property (weak, nonatomic) IBOutlet UIImageView *foundPersonImageView;

- (IBAction)done:(id)sender;

@end
