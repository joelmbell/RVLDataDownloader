//
//  RVLDataDownloaderTests.m
//  RVLDataDownloaderTests
//
//  Created by Joel Bell on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RVLDataDownloaderTests.h"
#import "MockRVLDataDownloader.h"
#import "MockDataDownloaderDelegate.h"

@implementation RVLDataDownloaderTests {
    MockRVLDataDownloader *downloader;
    MockDataDownloaderDelegate *delegate;
    UIApplication *application;
    NSError *testError;
}

- (void)setUp
{
    [super setUp];
    
    downloader = [[MockRVLDataDownloader alloc] initWithURL:[NSURL URLWithString:@"http://example.com"]];
    delegate = [[MockDataDownloaderDelegate alloc] init];
    downloader.delegate = delegate;
    application = [UIApplication sharedApplication];
    testError = [NSError errorWithDomain:@"Test Domain" code:0 userInfo:nil];
    // Set-up code here.
}

- (void)tearDown
{
    downloader = nil;
    application = nil;
    
    [super tearDown];
}

#pragma mark - URL Setting Tests

- (void)testURLSets {
    STAssertEqualObjects([downloader.url absoluteString], @"http://example.com", @"make sure that the data downloader can accept url's");
}

#pragma mark - Status Updating Tests

- (void)testDefaultStatusIsStopped {
    STAssertEquals(downloader.status, RVLDataDownloaderStatusStopped, @"Make sure the default status is stopped");
}

- (void)testStatusIsRunningWhenDownloadStarts {
    [downloader start];
    STAssertEquals(downloader.status, RVLDataDownloaderStatusRunning, @"make sure start download changes status to running");
}

- (void)testStatusIsCancelledWhenDownloadIsCancelled {
    [downloader start];
    [downloader cancel];
    STAssertEquals(downloader.status, RVLDataDownloaderStatusCancelled, @"make sure canceling the download sets the status appropriately");
}

- (void)testStatusIsFailedWhenDownloadFails {
    [downloader start];
    [downloader connection:[[NSURLConnection alloc] init] didFailWithError:testError];
    STAssertEquals(downloader.status, RVLDataDownloaderStatusFailed, @"make sure failed download sets the status to failed");
}

- (void)testStatusIsStoppedWhenDownloadCompleted {
    [downloader start];
    [downloader connectionDidFinishLoading:[[NSURLConnection alloc] init]];
    STAssertEquals(downloader.status, RVLDataDownloaderStatusStopped, @"make sure finished downloads have the status of stopped");
}

#pragma mark - System Network Activity Indicator

- (void)testSystemNetworkActivityIndicatorIsOffByDefault {
    STAssertEquals(application.networkActivityIndicatorVisible, NO, @"make sure the system network activity indicator is off by default");
}

- (void)testSystemNetworkActivityIndicatorStartsWhenDownloadStarts {
    [downloader start];
    STAssertEquals(application.networkActivityIndicatorVisible, YES, @"make sure the system network activity indicator is on when downloadeding");
}

- (void)testSystemNetworkActivityIndicatorStopsWhenCancelled {
    [downloader start];
    [downloader cancel];
    STAssertEquals(application.networkActivityIndicatorVisible, NO, @"make sure the system network activity indicator is of when download is cancelled");
}

- (void)testSystemNetworkActivityIndicatorStopsWhenDownloadFails {
    [downloader start];
    [downloader connection:[[NSURLConnection alloc] init] didFailWithError:testError];
    STAssertEquals(application.networkActivityIndicatorVisible, NO, @"make sure the system network activity indicator is off when download fails");
}

- (void)testSystemNetworkActivityIndicatorStopsWhenDownloadCompleted {
    [downloader start];
    [downloader connectionDidFinishLoading:[[NSURLConnection alloc] init]];
    STAssertEquals(application.networkActivityIndicatorVisible, NO, @"make sure the system network activity indicator is off after download completes");
}

#pragma mark - Download Tests

- (void)testDataDownloaderConformsToNSURLConnectionDataDelegate {
    STAssertTrue([downloader conformsToProtocol:@protocol(NSURLConnectionDataDelegate)], @"Make sure it conforms to the NSURLConnectionDataDelegate protocol");
}

- (void)testConnectionDidReceiveResponseClearsData {
    [downloader start];
    downloader.receivedData = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
    [downloader connection:[[NSURLConnection alloc] init] didReceiveResponse:nil];
    STAssertEquals([downloader.receivedData length], (NSUInteger)0, @"connection:didReceiveResponse should clear the receivedData");
}

- (void)testConnectionDidReceiveDataAppendsNewData {
    [downloader start];
    downloader.receivedData = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
    [downloader connection:nil didReceiveData:[@" - New Data" dataUsingEncoding:NSUTF8StringEncoding]];
    STAssertEqualObjects(downloader.receivedData, [@"Hello - New Data" dataUsingEncoding:NSUTF8StringEncoding], @"Make sure the downloaded Data is appended to existing data");
}

#pragma mark - Delegate Tests
- (void)testDelegateIsOptional {
    // ???
}

- (void)testDelegateMethodsAreOptional {
   // ??? 
}

- (void)testDelegateIsNotifiedInEventOfFailure {
    [downloader start];
    [downloader connection:[[NSURLConnection alloc] init] didFailWithError:testError];
    STAssertEqualObjects(testError, delegate.failedError, @"make sure delegate is notified in event of failure");
}

- (void)testDelegateIsNotifiedInEventOfSuccess {
    [downloader start];
    downloader.receivedData = [@"DownloadFinished!" dataUsingEncoding:NSUTF8StringEncoding];
    [downloader connectionDidFinishLoading:nil];
    STAssertEqualObjects(delegate.downloadedData, [@"DownloadFinished!" dataUsingEncoding:NSUTF8StringEncoding], @"Test that the delegate is notified on event of success");
}

- (void)testDelegateIsNotifiedInEventOfCancellation {
    
}

- (void)testCancellationErrorIsCorrectDomain {
    // ???
}

- (void)testCancellationErrorHasProperUserInfo {
    // ???
}

#pragma mark - Notification Tests



@end
