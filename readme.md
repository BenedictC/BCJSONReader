# BCJJSONContinuations

## TL;DR
BCJJSONContinuations is a library for processing the crazy JSON structures that exist in the real world. Its key features are:
+ Flexible. Provides functionality for handling many JSON usage styles.
+ Extensible. Easy to integrate new processing (e.g. peculiar date formats).
//+ Documented.
//+ Tested.



Examples:

````
//TODO:

````



## There are lots of other libraries for handling JSON, why not use one of them?
Other JSON libraries tends to make simplifying assumptions about the JSON structures that they'll be faced with. Theseassumptions may be suitable for a specific JSON structure but not for all. The promise of these libraries tend to break down when faced with JSON that does not conform to the assumptions. When these assumptions fail we're left in a worse position that if we hadn't used the library: first we must figure out how to breakout of the library and only then can we write the manual code that the library claimed to help use avoid. Other undesirable and common patterns in JSONlibraries are:
    - Forcing the model objects being coupled with either the JSON library (e.g. by requiring inheriting from a specfic class) 
    - Implicitly coupling model objects to the JSON structure by encouraging 'magical' mapping. Such magic becomes painful when debugging as it requires the coder to have an intimate knowledge of the assumptions of the JSON library. This knowldege is can only by found by reading the documentation (if there is any) or digging into the libraries codebase.



## So what's different about BCJJSONContinuations?
First and foremost BCJJSONContinuations provides the infrastructure for processing JSON (this infrastructure is actually provided by another library, BCLContinuations, which is included with BCJJSONContinuations). BCJJSONContinuations then builds on top this infrastructure and provides functions for the common steps that occur whenprocessing JSON. 

If you're lucky enough to be dealing with well structed JSON then you may be better off using a simplier library.
