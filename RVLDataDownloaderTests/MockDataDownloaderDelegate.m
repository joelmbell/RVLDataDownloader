//
//  MockDataDownloaderDelegate.m
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MockDataDownloaderDelegate.h"

@implementation MockDataDownloaderDelegate
@synthesize failedError=_failedError;
@synthesize downloadedData=_downloadedData;

- (void)dataDownloader:(RVLDataDownloader *)downloader didFailWithError:(NSError *)error {
    _failedError = error;
}

- (void)dataDownloader:(RVLDataDownloader *)downloader didFinishWithDownloadedData:(NSData *)data {
    _downloadedData = data;
}
@end
