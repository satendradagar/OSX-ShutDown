//
//  ProcessAccessor.m
//  ShutDown
//
//  Created by Satendra Dagar on 17/02/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

#import "ProcessAccessor.h"
#import <libproc.h>

@implementation ProcessAccessor

+ (NSSet<NSNumber *> *)pidsAccessingPath: (NSString *)path
{
    
    //    const char *pathFileSystemRepresentation = nil;
    int listpidspathResult = 0;
    int pidsSize = 0;
    pid_t *pids = nil;
    NSUInteger pidsCount = 0,
    i = 0;
    NSMutableSet *result = nil;
    
    NSParameterAssert(path && [path length]);
    
    const char *pathFileSystemRepresentation = [path fileSystemRepresentation];
    listpidspathResult = proc_listpidspath(PROC_ALL_PIDS, 0,
                                           pathFileSystemRepresentation, PROC_LISTPIDSPATH_EXCLUDE_EVTONLY, NULL, 0);
    
    //    ALAssertOrPerform(listpidspathResult >= 0, goto cleanup);
    result = [NSMutableSet set];

    if (listpidspathResult <= 0) {
        goto cleanup;
    }
    pidsSize = (listpidspathResult ? listpidspathResult : 1);
    pids = malloc(pidsSize);
    
    //    ALAssertOrPerform(pids, goto cleanup);
    if (pids == nil) {
        goto cleanup;
    }

    listpidspathResult = proc_listpidspath(PROC_ALL_PIDS, 0,
                                           pathFileSystemRepresentation, PROC_LISTPIDSPATH_EXCLUDE_EVTONLY, pids,
                                           pidsSize);
    
//        ALAssertOrPerform(listpidspathResult >= 0, goto cleanup);
    if (listpidspathResult <= 0) {
        goto cleanup;
    }

    pidsCount = (listpidspathResult / sizeof(*pids));
    
    for (i = 0; i < pidsCount; i++)
        [result addObject: [NSNumber numberWithInt: pids[i]]];
    
    cleanup :
    {
        if (pids)
        {
            (void)(free(pids)),
            pids = nil;
        }
    }
    
    return result;
    
}

@end
