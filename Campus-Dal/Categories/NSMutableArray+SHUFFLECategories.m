//
//  NSMutableArray+SHUFFLECategories.m
//  
//
//  Created by Sukwon Choi on 8/13/15.
//
//

#import "NSMutableArray+SHUFFLECategories.h"

@implementation NSMutableArray(SHUFFLECategories)

- (void)shuffle
{
    
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
