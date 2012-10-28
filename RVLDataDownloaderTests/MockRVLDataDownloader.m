//
//  MockRVLDataDownloader.m
//  RVLDataDownloader
//
//  Created by Joel Bell on 10/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MockRVLDataDownloader.h"

@implementation MockRVLDataDownloader

- (void)setReceivedData:(NSData *)data {
    receivedData = [data mutableCopy];
}

- (NSData *)receivedData {
    return [receivedData copy];
}


@end
