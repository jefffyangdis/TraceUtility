//
//  CaCommand.h
//  Cafair
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XRInstrument;
@protocol CaCommandProtocol <NSObject>

@required
- (void)handle:(XRInstrument *)instrument tracePath:(NSString *)tracePath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CaCommand : NSObject



@end

NS_ASSUME_NONNULL_END
