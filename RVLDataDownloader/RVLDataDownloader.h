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

@interface RVLDataDownloader : NSObject <NSURLConnectionDelegate>

- (id)initWithURL:(NSURL *)url;

@property (nonatomic, readonly, strong) NSURL *url;
@property (nonatomic, readonly, strong) NSData *data;
@property (nonatomic, readonly, assign) RVLDataDownloaderStatus status;

- (void)start;
- (void)cancel;

@end
