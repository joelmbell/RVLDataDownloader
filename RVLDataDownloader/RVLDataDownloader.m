//
//  RVLDataDownloader.m
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RVLDataDownloader.h"

@implementation RVLDataDownloader {
    NSURLConnection *connection;
    UIApplication *application;
}

@synthesize url=_url;
@synthesize status=_status;
@synthesize delegate=_delegate;

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _url = [url copy];
        _status = RVLDataDownloaderStatusStopped;
        
        application = [UIApplication sharedApplication];
        application.networkActivityIndicatorVisible = NO;
    }
    
    return self;
}

- (void)start {
    _status = RVLDataDownloaderStatusRunning;
    application.networkActivityIndicatorVisible = YES;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_url];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancel {
    _status = RVLDataDownloaderStatusCancelled;
    application.networkActivityIndicatorVisible = NO;
    
    [_delegate dataDownloader:self didFailWithError:nil];
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _status = RVLDataDownloaderStatusFailed;
    application.networkActivityIndicatorVisible = NO;
    
    [_delegate dataDownloader:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {    
   if (receivedData) {
        [receivedData setLength:0];
    } else {
        receivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _status = RVLDataDownloaderStatusStopped;
    application.networkActivityIndicatorVisible = NO;
    
    [_delegate dataDownloader:self didFinishWithDownloadedData:[NSData dataWithData:receivedData]];
}

@end
