//
//  ViewController.m
//  Lesson10
//
//  Created by Azat Almeev on 05.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "ViewController.h"

typedef NSArray *Arr;
typedef BOOL (^SortCompletionBlock)(Arr);

@interface NSArray (Divisible)
@property (nonatomic, readonly) Arr firstPart;
@property (nonatomic, readonly) Arr secondPart;

- (Arr)subarrayFromIndex:(NSUInteger)index;
@end

@interface NSArray (Printable)

@property (nonatomic, readonly) NSString *printString;
@end

@implementation NSArray (Divisible)

- (Arr)firstPart {
    NSInteger center = self.count / 2;
    return [self subarrayWithRange:NSMakeRange(0, center)];
}

- (Arr)secondPart {
    NSInteger center = self.count / 2;
    return [self subarrayWithRange:NSMakeRange(center, self.count - center)];
}

- (Arr)subarrayFromIndex:(NSUInteger)index {
    return [self subarrayWithRange:NSMakeRange(index, self.count - index)];
}

@end

@implementation NSArray (Printable)

- (NSString *)printString {
//    NSMutableString *result = [NSMutableString new];
//    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [result appendFormat:@"%@, ", obj];
//    }];
//    return [NSString stringWithFormat:@"(%@)", [result stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]]];
    return [NSString stringWithFormat:@"(%@)", [self componentsJoinedByString:@", "]];
}
@end

@implementation ViewController

//http://stackoverflow.com/a/9201774/1565335
- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger num = 1;
    void (^demoBlock)(NSInteger) = ^(NSInteger param){
        NSLog(@"%ld, %ld", (long)num, (long)param);
    };
    num++;
    NSLog(@"%ld", (long)num);
    demoBlock(num);
    [self sortArray:@[ @5, @8, @7, @2, @9, @0 ] completion:^BOOL(Arr array) {
        if (array.count == 0)
            return YES;
        BOOL isCorrect = YES;
        NSNumber *current = array.firstObject;
        for (NSInteger index = 1; index < array.count; index++) {
            NSNumber *num = array[index];
            if ([num integerValue] < [current integerValue]) {
                isCorrect = NO;
                break;
            }
            else {
                current = num;
            }
        }
        return isCorrect;
    }];
}

- (void)sortArray:(NSArray *)input completion:(SortCompletionBlock)completion {
    __block Arr (^mergeSortBlock)(Arr, Arr) = nil;
    Arr (^mergeSort)(Arr, Arr) = ^(Arr arr1, Arr arr2) {
        if (arr1.count < 2 && arr2.count < 2) {
            if (arr1.count == 1 && arr2.count == 1)
                return [arr1.firstObject integerValue] < [arr2.firstObject integerValue] ? @[ arr1.firstObject, arr2.firstObject ] : @[ arr2.firstObject, arr1.firstObject ];
            else if (arr1.count == 1)
                return arr1;
            else if (arr2.count == 1)
                return arr2;
            else
                return @[];
        }
        NSArray *merged1 = mergeSortBlock(arr1.firstPart, arr1.secondPart);
        NSArray *merged2 = mergeSortBlock(arr2.firstPart, arr2.secondPart);
        
        NSInteger index1 = 0, index2 = 0;
        NSMutableArray *result = [NSMutableArray new];
        for (; index1 < merged1.count || index2 < merged2.count; ) {
            if (index1 < merged1.count && index2 < merged2.count)
                if ([merged1[index1] integerValue] < [merged2[index2] integerValue])
                    [result addObject:merged1[index1++]];
                else
                    [result addObject:merged2[index2++]];
            else if (index1 < merged1.count) {
                [result addObjectsFromArray:[merged1 subarrayFromIndex:index1]];
                break;
            }
            else {
                [result addObjectsFromArray:[merged2 subarrayFromIndex:index2]];
                break;
            }
        }
        return (Arr)result.copy;
    };
    mergeSortBlock = mergeSort;
    Arr result = mergeSort(input.firstPart, input.secondPart);
    NSLog(@"Sorted array [%@] was %@", result.printString, completion(result) ? @"correct" : @"incorrect");
}

@end
