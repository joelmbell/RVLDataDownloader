//
//  RVLDataDownloader.h
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RVLDataDownloaderStatusRunning = 1,
    RVLDataDownloaderStatusStopped,
    RVLDataDownloaderStatusFailed,
    RVLDataDownloaderStatusCancelled
} RVLDataDownloaderStatus;


typedef enum {
    RVLDataDownloaderErrorCodeCancelled = 1000
} RVLDataDownloaderErrorCode;

@protocol RVLDataDownloaderDelegate;

@interface RVLDataDownloader : NSObject <NSURLConnectionDataDelegate> {
@protected
    NSMutableData *receivedData;
}

- (id)initWithURL:(NSURL *)url;

@property (nonatomic, readonly, strong) NSURL *url;
@property (nonatomic, readonly, assign) RVLDataDownloaderStatus status;
@property (nonatomic, weak) id <RVLDataDownloaderDelegate> delegate;

- (void)start;
- (void)cancel;

@end

@protocol RVLDataDownloaderDelegate <NSObject>

- (void)dataDownloader:(RVLDataDownloader *)downloader didFailWithError:(NSError *)error;
- (void)dataDownloader:(RVLDataDownloader *)downloader didFinishWithDownloadedData:(NSData *)data;

@end
