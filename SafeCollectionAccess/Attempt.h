//
//  Attempt.h
//  TypeCheckedCollectionAccess
//
//  Created by Benedict Cohen on 21/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef Attempt_control_flow_h
#define Attempt_control_flow_h

/**
 ATTEMPT/SALVAGE is a control-flow construct similiar to TRY/CATCH. It takes two blocks of code, an ATTEMPT block and
  a SALVAGE block. During 'normal' execution the ATTEMPT block is invoked and the SALVAGE block is not. The SALVAGE
  block is only executed if one of the following occurs:
 - On completion of the ATTEMPT block there is at least 1 entry in the FAILURE_INFO dictionary.
 - ABANDON() is called from within the ATTEMPT block.

 ATTEMPT/SALVAGE differs from TRY/CATCH. With TRY/CATCH, RAISE can be called within *any* functions/block and the
 exception will bubble up to the nearest CATCH block. However, with ATTEMPT/SALVAGE, ABANDON can only be called within 
 the immediate scope of the ATTEMPT block and not within nested blocks or functions.
 
 When writing code a call to ATTEMPT must be immediately followed by a call to SALVAGE.

 Examples:
 
 //Valid example:
 ATTEMPT({
    if (somePredicate) {
        ABANDON();
    }
    ABANDON();
 }) SALVAGE ({
    NSLog(@"%@", REASON);
 });
 


 //Invalid example 1:
 // This will not compile because the call to ABANDON is within a nested block.
 ATTEMPT({
    ^{
         ABANDON();
     }();
 }) SALVAGE ({
    NSLog(@"%@", REASON);
 });
 
 

 //Invalid example 2:
 // This will not compile because ABANDON is in an separate function.
 void arbitaryFunction() {
    //...
    ABANDON();
    //...
 }

 ATTEMPT({
    arbitaryFunction();
 }) SALVAGE ({
     NSLog(@"%@", REASON);
 });

 */



/**
 <#Description#>

 @param ATTEMPT_BLOCK <#ATTEMPT_BLOCK description#>

 @return <#return value description#>
 */
#define ATTEMPT(ATTEMPT_BLOCK) do { \
    NSMutableDictionary * const __failureInfo__ = [NSMutableDictionary new]; \
    ATTEMPT_BLOCK \
    if ([__failureInfo__ count] == 0) break; /* If we reach the end of ATTEMPT_BLOCK and haven't any failures then
                                                  bail out and don't fall through into SALVAGE_BLOCK. */ \
    goto Salvage; /* Avoid 'unused label' warning. */ \
    Salvage:


/**
 <#Description#>

 @param SALVAGE_BLOCK <#SALVAGE_BLOCK description#>

 @return <#return value description#>
 */
#define SALVAGE(SALVAGE_BLOCK) SALVAGE_BLOCK \
} while(0); /* Close the ATTEMPT block. */



/**
 To be called within ATTEMPT blocks. When invoke execution of the ATTEMPT block ends and jumps to the SALVAGE block.

 @param FAILURE_INFO_OBJ <#FAILURE_INFO_OBJ description#>

 @return <#return value description#>
 */
#define ABANDON() do {goto Salvage;} while(0)



/**
 Set a value in the failureInfo dictionary.

 @param KEY  <#KEY description#>
 @param VALUE <#INFO description#>

 @return <#return value description#>
 */
#define SET_FAILURE_INFO(KEY, VALUE) do {\
id aValue = (VALUE); \
id aKey = (KEY); \
if (aValue == nil) { \
    [__failureInfo__ removeObjectForKey:aKey]; \
} else { \
    [__failureInfo__ setObject:aValue forKey:aKey];\
} \
} while(0)



/**
 Retrieve a value from the failureInfo dictionary.

 @param KEY  <#KEY description#>

 @return <#return value description#>
 */
#define FAILURE_INFO(KEY) [__failureInfo__ objectForKey:(KEY)]



#endif
