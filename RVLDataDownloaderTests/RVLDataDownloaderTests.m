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
#import "MockDataDownloaderDelegateNoMethods.h"

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

#pragma mark - Connection Reset Methods
- (void)testConnectionIsResetAfterFailure {
    [downloader start];
    [downloader connection:nil didFailWithError:testError];

    STAssertNil(downloader.connection, @"make sure connection is reset after a failure");
}

- (void)testConnectionIsResetAfterCancelation {
    [downloader start];
    [downloader cancel];
    
    STAssertNil(downloader.connection, @"make sure connection is reset after a cancellation");
}

- (void)testConnectionIsResetAfterSuccess {
    [downloader start];
    [downloader connectionDidFinishLoading:nil];
    
    STAssertNil(downloader.connection, @"make sure connection is reset after a successful download");
}

#pragma mark - Notification Tests
- (void)testNotificationSentOnFailure {
    // ???
}

- (void)testNotificationSentOnSuccess {
    // ???
}

- (void)testNotificationSentOnCancellation {
    // ???
}

#pragma mark - Delegate Tests
- (void)testDelegateIsOptional {
    downloader.delegate = nil;
    [downloader start];
    
    STAssertNoThrow([downloader connection:nil didFailWithError:testError], @"test didFailWithError doesn't throw exception when it tries to call delegate method from non-existant delegate");
    STAssertNoThrow([downloader connectionDidFinishLoading:nil], @"test didFinishLoading doesn't throw exception when it tries to call delegate method from non-existant delegate");
    STAssertNoThrow([downloader cancel], @"test cancel dosen't throw exception when it tries to call delegate method from non-existant delegate");
}

- (void)testDelegateMethodsAreOptional {
    MockDataDownloaderDelegateNoMethods *delegateNoMethods = [[MockDataDownloaderDelegateNoMethods alloc] init];
    downloader.delegate = delegateNoMethods;
    STAssertNoThrow([downloader connection:nil didFailWithError:testError], @"Test didFailWithError doesn't throw an exception when it tries to call a method from a delegate that doesn't implement that method");
    STAssertNoThrow([downloader cancel], @"Test cancel dosen't throw exception when it tries to call a delegate method");
    STAssertNoThrow([downloader connectionDidFinishLoading:nil], @"Test connectionDidFinishLoading doesn't throw and exception when it tries to call a delegate method that isn't implemented");
}

- (void)testDelegateIsNotifiedInEventOfFailure {
    [downloader start];
    [downloader connection:[[NSURLConnection alloc] init] didFailWithError:testError];
    STAssertEqualObjects(testError, delegate.failedError, @"make sure delegate is notified in event of failure");
}

- (void)testDelegateIsNotifiedAndPassedDataInEventOfSuccess {
    [downloader start];
    NSData *testData = [@"DownloadFinished!" dataUsingEncoding:NSUTF8StringEncoding];
    downloader.receivedData = testData;
    [downloader connectionDidFinishLoading:nil];
    STAssertEqualObjects(delegate.downloadedData, testData, @"Test that the delegate is passed data on event of success");
}

- (void)testDelegateIsNotifiedInEventOfCancellationWithProperInfo {
    [downloader start];
    [downloader cancel];
    NSError *canceledError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
    STAssertEqualObjects([delegate.failedError domain], canceledError.domain, @"Test that the canceled request returns the correct error domain for a cancelation");
    STAssertEquals([delegate.failedError code], canceledError.code, @"Test that the canceled request returns the correct error code for cancelation");
    STAssertEqualObjects(downloader.url, [delegate.failedError.userInfo objectForKey:NSURLErrorFailingURLErrorKey], @"Make sure the failing error is sent to the delegate");
}


@end
