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
    NSMutableArray * descriptions = [[NSMutableArray alloc] init];
    while ([stack count] != 0) {
        [descriptions addObject:[self describeProgram:stack]];
    }
    return [descriptions componentsJoinedByString:@","];
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
            NSString *nextOperation = [stack lastObject];
            NSString *right = [self describeProgram:stack];
            if ([self isOperation:nextOperation] && [self getPrecedence:operation] > [self getPrecedence:nextOperation])
                result = [NSString stringWithFormat:@"%@ %@ (%@)",[self describeProgram:stack] , operation, right];
            else if ([self isOperation:nextOperation] && [self getPrecedence:nextOperation] > [self getPrecedence:operation])
                result = [NSString stringWithFormat:@"(%@) %@ %@",[self describeProgram:stack], operation, right];
            else
                result = [NSString stringWithFormat:@"%@ %@ %@",[self describeProgram:stack] , operation, right];
        }else if (numberOfOperands == 0) {
            return operation;
        }
    }
    return result;
}

+(bool)isOperation:(NSString*)operation
{
    NSSet *operations = [NSSet setWithObjects:@"*", @"/", @"+", @"-", nil];
    if ([operations containsObject:operation])
        return YES;
    return NO;
}

+(double)getPrecedence:(NSString *)operation
{
    NSSet *additions = [NSSet setWithObjects:@"-", @"+", nil];
    if ([additions containsObject:operation])
        return 1;
    NSSet *multiplication = [NSSet setWithObjects:@"/", @"*", nil];
    if ([multiplication containsObject:operation])
        return 2;
    return 3;
}


+(double) getNumberOfOperands:(NSString *)operation
{
    NSSet *functions = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", nil];
    if ([functions containsObject:operation])
        return 1;
    NSSet *operations = [NSSet setWithObjects:@"*", @"/", @"+", @"-", nil];
    if ([operations containsObject:operation])
        return 2;
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
    [_programStack removeAllObjects];
}
@end
