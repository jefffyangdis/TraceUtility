//
//  CaAllocations.m
//  Cafair
//
//  Created by admin on 2020/5/21.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CaAllocations.h"
#import "CaDefines.h"
#import "InstrumentsPrivateHeader.h"

static NSString *csvFileName(NSString *tracePath) {
    NSURL *url = [NSURL URLWithString:tracePath];
    NSString *fileName = [[[url URLByDeletingPathExtension] URLByAppendingPathExtension:@"csv"] absoluteString];
    return fileName;
}

static void createFile(NSString *fileName) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:fileName error:nil];

    if (![fileManager createFileAtPath:fileName contents:nil attributes:nil]) {
        TUPrint(@"csvfile create fail");
    }
}

@implementation CaAllocations

- (void)handle:(XRInstrument *)instrument tracePath:(NSString *)tracePath
{
    XRTimeRange range;
    range.start = 0;
    range.length = 10.0*1000000000;
    XRRun *run = instrument.currentRun;
    XRObjectAllocInstrument *allocInstrument = (XRObjectAllocInstrument *)instrument;
    // 4 contexts: Statistics, Call Trees, Allocations List, Generations.
    [allocInstrument._topLevelContexts[2] display];
    XRManagedEventArrayController *arrayController = TUIvar(TUIvar(allocInstrument, _objectListController), _ac);
    NSArrayController *summary = TUIvar(allocInstrument, _summaryController);
    TUPrint(@"count:%@,%@",@([(NSArray*)arrayController.arrangedObjects count]),@([(NSArray*)summary.arrangedObjects count]));
    //                    NSArray *sumobjects = summary.arrangedObjects;
    //                    NSMutableDictionary<NSNumber *, NSNumber *> *sizeGroupedByTime = [NSMutableDictionary dictionary];
    //                    NSArray *arrobjects = arrayController.arrangedObjects;
    //                    for (XRObjectAllocEvent *event in arrobjects) {
    //                        NSNumber *time = @(event.timestamp / NSEC_PER_SEC);
    //                        NSNumber *size = @(sizeGroupedByTime[time].integerValue + event.size);
    //                        sizeGroupedByTime[time] = size;
    //                    }
    //                    NSArray<NSNumber *> *sortedTime = [sizeGroupedByTime.allKeys sortedArrayUsingComparator:^(NSNumber *time1, NSNumber *time2) {
    //                        return [sizeGroupedByTime[time2] compare:sizeGroupedByTime[time1]];
    //                    }];
    //                    NSByteCountFormatter *byteFormatter = [[NSByteCountFormatter alloc]init];
    //                    byteFormatter.countStyle = NSByteCountFormatterCountStyleBinary;
    //                    for (NSNumber *time in sortedTime) {
    //                        NSString *size = [byteFormatter stringForObjectValue:sizeGroupedByTime[time]];
    //                        TUPrint(@"%@ %@\n", time, size);
    //                    }
    NSString *filename = csvFileName(tracePath);
    if (!filename) {
        TUPrint(@"invalid filename:%@",filename);
        return;
    }
    TUPrint(@"got filename :%@",filename);
    createFile(filename);
    NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filename];
    //将节点调到文件末尾
    [fileHandle seekToEndOfFile];

    range.start = 0;
    range.length = 0;
    for( double time = 0.02; time < run.endTime-run.startTime; time += 0.02) {
        range.length = time*1000000000;
        if ( [run respondsToSelector:@selector(setSelectedTimeRange:)] ) {
            [(XRObjectAllocRun *)run setSelectedTimeRange:range];
        }
        allocInstrument.currentRun = run;
        NSArrayController *summary = TUIvar(allocInstrument, _summaryController);
        id a = [(NSArray *)summary.arrangedObjects firstObject];
        [fileHandle writeData:[[NSString stringWithFormat:@"%7.2f  %10.2f\n",time,[[a valueForKey:@"livingBytes"] unsignedLongLongValue]/1024.0/1024.0] dataUsingEncoding:NSUTF8StringEncoding]];
        //                        TUPrint(@"%7.2f  %10.2f",time,[[a valueForKey:@"livingBytes"] unsignedLongLongValue]/1024.0/1024.0);
    }
    [fileHandle closeFile];
}

@end
