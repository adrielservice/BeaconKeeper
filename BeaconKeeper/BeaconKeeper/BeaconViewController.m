//
//  BeaconViewController.m
//  BeaconKeeper
//
//  Created by David Beilis on 2013-07-28.
//  Copyright (c) 2013 Adriel Service. All rights reserved.
//

#import "BeaconViewController.h"

@interface BeaconViewController ()

@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Modify buttons' style in circle menu
    for (UIButton * button in [self.menu subviews])
        [button setAlpha:.95f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate beaconViewControllerDidFinish:self];
}

#pragma mark - Child view navigation

- (void)selectedBeaconViewControllerDidFinish:(SelectedBeaconViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.selectedBeaconPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.selectedBeaconPopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSelectedBeacon"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.selectedBeaconPopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)toggleSelectedBeacon:(id)sender
{
    NSLog(@"Selected beacon is - %d", [sender tag]);
    
    self.selectedSender = sender;
    
    if (self.selectedBeaconPopoverController) {
        [self.selectedBeaconPopoverController dismissPopoverAnimated:YES];
        self.selectedBeaconPopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showSelectedBeacon" sender:sender];
    }
}

- (id) getSelectedSender {
    return self.selectedSender;
}

#pragma mark - KYCircleMenu Button Action

// Run button action depend on their tags:
//
// TAG:        1       1   2      1   2     1   2     1 2 3     1 2 3
//            \|/       \|/        \|/       \|/       \|/       \|/
// COUNT: 1) --|--  2) --|--   3) --|--  4) --|--  5) --|--  6) --|--
//            /|\       /|\        /|\       /|\       /|\       /|\
// TAG:                             3       3   4     4   5     4 5 6
//
- (void)runButtonActions:(id)sender {
    [super runButtonActions:sender];
    
    [self toggleSelectedBeacon:sender];

}

@end
