//
//  RVLDataDownloader.m
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RVLDataDownloader.h"

@implementation RVLDataDownloader {
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
    
    NSDictionary *userInfo = nil;
    if (self.url != nil) {
        userInfo = [NSDictionary dictionaryWithObject:self.url forKey:NSURLErrorFailingURLErrorKey];
    }
    NSError *canceledError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
    
    if ([_delegate respondsToSelector:@selector(dataDownloader:didFailWithError:)]) {
        [_delegate dataDownloader:self didFailWithError:canceledError];
    }
    
    connection = nil;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error {
    _status = RVLDataDownloaderStatusFailed;
    application.networkActivityIndicatorVisible = NO;
    
    if ([_delegate respondsToSelector:@selector(dataDownloader:didFailWithError:)]) {
        [_delegate dataDownloader:self didFailWithError:error];
    }
    
    connection = nil;
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response {
   if (receivedData) {
        [receivedData setLength:0];
    } else {
        receivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    _status = RVLDataDownloaderStatusStopped;
    application.networkActivityIndicatorVisible = NO;
    
    if ([_delegate respondsToSelector:@selector(dataDownloader:didFinishWithDownloadedData:)]) {
        [_delegate dataDownloader:self didFinishWithDownloadedData:[NSData dataWithData:receivedData]];
    }
    
    connection = nil;
}

@end
