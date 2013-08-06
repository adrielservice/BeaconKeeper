//
//  MainViewController.m
//  BeaconKeeper
//
//  Created by David Beilis on 2013-07-28.
//  Copyright (c) 2013 Adriel Service. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "KYCircleMenu.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)beaconViewControllerDidFinish:(BeaconViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.beaconPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)scannerViewControllerDidFinish:(ScannerViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.scannerPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
    self.beaconPopoverController = nil;
    self.scannerPopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    } else if ([[segue identifier] isEqualToString:@"showScanner"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.scannerPopoverController = popoverController;
            popoverController.delegate = self;
        }
    } else if ([[segue identifier] isEqualToString:@"showBeacon"]) {
        [[segue destinationViewController] setDelegate:self];
        (void) [[segue destinationViewController]
                initWithButtonCount:kKYCCircleMenuButtonsCount
                menuSize:kKYCircleMenuSize
                buttonSize:kKYCircleMenuButtonSize
                buttonImageNameFormat:kKYICircleMenuButtonImageNameFormat
                centerButtonSize:kKYCircleMenuCenterButtonSize
                centerButtonImageName:kKYICircleMenuCenterButton
                centerButtonBackgroundImageName:kKYICircleMenuCenterButtonBackground];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.beaconPopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (IBAction)toggleScanner:(id)sender
{
    if (self.scannerPopoverController) {
        [self.scannerPopoverController dismissPopoverAnimated:YES];
        self.scannerPopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showScanner" sender:sender];
    }
}

- (IBAction)toggleBeacon:(id)sender
{
    if (self.beaconPopoverController) {
        [self.beaconPopoverController dismissPopoverAnimated:YES];
        self.beaconPopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showBeacon" sender:sender];
    }
}

@end
