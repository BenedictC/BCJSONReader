//
//  AttemptSalvage.h
//  TypeCheckedCollectionAccess
//
//  Created by Benedict Cohen on 21/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#ifndef AttemptSalvage_h
#define AttemptSalvage_h

/**
 ATTEMPT/SALVAGE is a control-flow construct similiar to TRY/CATCH. It takes two blocks of code, an ATTEMPT block and
  a SALVAGE block. During 'normal' execution the ATTEMPT block is invoked and the SALVAGE block is not. The SALVAGE
  block is only executed if one of the following occurs:
 - On completion of the ATTEMPT block there is at least 1 entry in the FAILURE_INFO dictionary.
 - ABANDON() is called from within the ATTEMPT block.

 Calling return from within an ATTEMPT block will return from the parent scope of the ATTEMPT block. Calling break will
 jump to after the SALVAGE block.

 ABANDON is the ATTEMPT/SALVAGE equivilant to RAISE in TRY/CATCH but ABANDON has less powerful behavour. RAISE can be
 called within *any* functions/block and the exception will bubble up to the nearest CATCH block. However, ABANDON can
 only be called within the immediate scope of an ATTEMPT block and not within called functions or nested blocks.
 
 FAILURE_INFO and SET_FAILURE_INFO are used to access and set key/value pairs in a dictionary that is shared between
 the ATTEMPT and SALVAGE blocks.

 The syntax for ATTEMPT/SALVAGE blocks is as follows:
 ATTEMPT({
     //This is the ATTEMPT block
 }) //End of ATTEMPT. Note that there is NOT a sem-colon before SALVAGE (only whitespace and comments are allowed).
 SALVAGE ({
    //This is the SALVAGE block
 }); //End of SALVAGE. Note that the semi-colon is optional.

 */



/**
 Begins an ATTEMPT/SALVAGE control structure. A call to ATTEMPT must be immediately followed by a call to SALVAGE.

 @param ATTEMPT_BLOCK The code block used during the ATTEMPT stage.

 */
#define ATTEMPT(ATTEMPT_BLOCK) do { \
    NSMutableDictionary * const __failureInfo__ = [NSMutableDictionary new]; \
    BOOL __hasSalvaged__ = NO;\
    ATTEMPT_BLOCK \
    if ([__failureInfo__ count] == 0) break; /* If we reach the end of ATTEMPT_BLOCK and haven't any failures then
                                                  bail out and don't fall through into SALVAGE_BLOCK. */ \
    goto Salvage; /* Avoid 'unused label' warning. */ \
    Salvage: \
    NSCAssert(!__hasSalvaged__, @"Error within ATTEMPT/SALVAGE. Most likely this is due to ABANDON() being called with the SALVAGE block"); \
    __hasSalvaged__ = YES;



/**
 Ends an ATTEMPT/SALVAGE control structure. A call to SALVAGE must be immediately preceeded by a call to ATTEMPT.

 @param SALVAGE_BLOCK The code block used during the SALVAGE stage.

 */
#define SALVAGE(SALVAGE_BLOCK) SALVAGE_BLOCK \
} while(0); /* Close the ATTEMPT block. */



/**
 Can be called within an ATTEMPT block. When invoke execution of the ATTEMPT block ends and jumps to the SALVAGE block.

 @return none;
 */
#define ABANDON() do {goto Salvage;} while(0)



/**
 Set a value in the FAILURE_INFO dictionary which is availble to the ATTEMPT and SALVAGE blocks. To remove a value 
 use nil as the value.

 @param KEY  The key to use in the FAILURE_INFO dictionary.
 @param VALUE The value to associated with KEY in the FAILURE_INFO dictionary.

 @return none;
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

 @param KEY  The key in the FAILURE_INFO dictionary to retrieve.

 @return The value for the provided key or nil if the value is not set.
 */
#define FAILURE_INFO(KEY) [__failureInfo__ objectForKey:(KEY)]



#endif
