//
//  CalculatorBrain.h
//  Calculator
//
//  Created by John on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
-(void)pushOperand:(double)operand;
-(void)pushVariable:(NSString *)variable;
-(double)performOperation:(NSString *)operation;
-(void)clearOperands;

@property (readonly) id program;
+(double)runProgram:(id)program;
+(NSString *)descriptionOfProgram:(id)program;

+(double)runProgram:(id)program
    usingVariableValues:(NSDictionary*)variableValues;
+(NSSet *)variablesUsedInProgram:(id)program;
@end
