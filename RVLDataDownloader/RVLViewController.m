//
//  RVLViewController.m
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RVLViewController.h"

@implementation RVLViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://google.com"];
    RVLDataDownloader *downloader = [[RVLDataDownloader alloc] initWithURL:url];
    downloader.delegate = self;
    [downloader start];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Data Downloader Delegate Methods
- (void)dataDownloader:(RVLDataDownloader *)downloader didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)dataDownloader:(RVLDataDownloader *)downloader didFinishWithDownloadedData:(NSData *)data {
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:textView];
    textView.text = dataString;
}

@end
