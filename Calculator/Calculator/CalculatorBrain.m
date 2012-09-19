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

-(void)pushVariable:(NSString *)variable
{    
    [self.programStack addObject:variable];
}

-(double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+(NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray* stack = program;
    NSArray* variables = [stack filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"SELF in %@", [NSArray arrayWithObjects:@"x", @"a", @"b", nil]]];
    if ([variables count] > 0)
    {
        return [NSSet setWithArray:variables];
    }
    return nil;
}

-(id) program 
{
    return [self.programStack copy];
}

+(NSString *)descriptionOfProgram:(id)program  
{
    NSMutableArray * stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    NSString * description = @"";
    while ([stack count] != 0) {
        description = [description stringByAppendingFormat:@"%@, ", [self describeProgram:stack]];    
    }
    return description;
}

+(NSString *)describeProgram:(NSMutableArray *)stack
{
    NSString * result = @"";
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [NSString stringWithFormat:@"%@", topOfStack];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        double numberOfOperands = [self getNumberOfOperands:operation]; 
        if (numberOfOperands == 1) {
            result = [NSString stringWithFormat:@"%@(%@)", operation, [self describeProgram:stack]];
        }else if (numberOfOperands == 2) {
            result = [NSString stringWithFormat:@"%@ %@ %@", [self describeProgram:stack], operation, [self describeProgram:stack]];
        }else if (numberOfOperands == 0) {
            return operation;
        }
    }
    return result;
}

+(double) getNumberOfOperands:(NSString *)operation
{
    NSSet *functions = [NSSet setWithObjects:@"x", @"a", @"b", nil];
    return 0;
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
