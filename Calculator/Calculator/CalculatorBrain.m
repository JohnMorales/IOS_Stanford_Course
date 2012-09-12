//
//  CalculatorBrain.m
//  Calculator
//
//  Created by John on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

-(NSMutableArray *)programStack
{
    if (!_programStack)
    {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(void)pushOperand:(double)operand
{    
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}


-(double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

-(id) program 
{
    return [self.programStack copy];
}
+(NSString *)descriptionOfProgram:(id)program  
{
    return @"Implement this in assignment #2";
}

+(double) popOperationOffStack:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperationOffStack:stack] + [self popOperationOffStack:stack];
        }
        else if ([@"*" isEqualToString:operation]) {
            result = [self popOperationOffStack:stack] * [self popOperationOffStack:stack];
        }
        else if ([operation isEqualToString:@"-"]) {
            double subtrac = [self popOperationOffStack:stack];
            result = [self popOperationOffStack:stack] - subtrac;
        }
        else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperationOffStack:stack];
            if (divisor) result = [self popOperationOffStack:stack] / divisor;
        }
        else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperationOffStack:stack]);
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperationOffStack:stack]);
        }
        else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperationOffStack:stack]);
        }
        else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    return result;
}

+(double) runProgram:(id)program
{
    NSMutableArray * stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperationOffStack:stack];
}

-(void)clearOperands {
    [self.program removeAllObjects];
}
@end
