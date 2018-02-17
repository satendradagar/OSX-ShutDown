//
//  ProcessAccessor.h
//  ShutDown
//
//  Created by Satendra Dagar on 17/02/18.
//  Copyright © 2018 Satendra Dagar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessAccessor : NSObject

+ (NSSet<NSNumber *> *)pidsAccessingPath: (NSString *)path;

@end
