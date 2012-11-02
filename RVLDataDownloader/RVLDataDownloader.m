//
//  RVLDataDownloader.m
//  RVLDataDownloader
//
// Created by Joel Bell on 10/26/12.
// Copyright (c) 2012, Joel Bell
// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following
// conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list of conditions and the following
// disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
// disclaimer in the documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
// USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
// OF THE POSSIBILITY OF SUCH DAMAGE.

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
