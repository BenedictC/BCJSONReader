//
//  BCJAdditionalTypes.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 31/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuation.h"
#import "BCJDefines.h"
#import "BCJConstants.h"
#import "BCJContainerProtocols.h"



#pragma mark - NSDate epoch functions
/**
 <#Description#>

 @param array        <#array description#>
 @param idx          <#idx description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param outDate      <#outDate description#>
 @param outError     <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSinceEpoch(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) __attribute__((nonnull(1,5,6)));

/**
 <#Description#>

 @param dict         <#dict description#>
 @param key          <#key description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param outDate      <#outDate description#>
 @param outError     <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetDateFromTimeIntervalSinceEpoch(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) __attribute__((nonnull(1,2,5,6)));



#pragma mark - NSDate epoch continuations
/**
 <#Description#>

 @param array        <#array description#>
 @param idx          <#idx description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param target       <#target description#>
 @param targetKey    <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,5,6)));
/**
 <#Description#>

 @param array     <#array description#>
 @param idx       <#idx description#>
 @param target    <#target description#>
 @param targetKey <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

/**
 <#Description#>

 @param dict         <#dict description#>
 @param key          <#key description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param target       <#target description#>
 @param targetKey    <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
/**
 <#Description#>

 @param dict      <#dict description#>
 @param key       <#key description#>
 @param target    <#target description#>
 @param targetKey <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromTimeIntervalSinceEpoch(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - NSDate ISO 8601 functions
/**
 <#Description#>

 @param array        <#array description#>
 @param idx          <#idx description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param outDate      <#outDate description#>
 @param outError     <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) __attribute__((nonnull(1,5,6)));

/**
 <#Description#>

 @param dict         <#dict description#>
 @param key          <#key description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param outDate      <#outDate description#>
 @param outError     <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetDateFromISO8601String(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue, NSDate **outDate, NSError **outError) __attribute__((nonnull(1,2,5,6)));



#pragma mark - NSDate ISO 8601 continuations
/**
 <#Description#>

 @param array        <#array description#>
 @param idx          <#idx description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param target       <#target description#>
 @param targetKey    <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSDate *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,5,6)));
/**
 <#Description#>

 @param array     <#array description#>
 @param idx       <#idx description#>
 @param target    <#target description#>
 @param targetKey <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

/**
 <#Description#>

 @param dict         <#dict description#>
 @param key          <#key description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param target       <#target description#>
 @param targetKey    <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSDate *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
/**
 <#Description#>

 @param dict      <#dict description#>
 @param key       <#key description#>
 @param target    <#target description#>
 @param targetKey <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetDateFromISO8601String(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - GET NSURL functions
/**
 <#Description#>

 @param array        <#array description#>
 @param idx          <#idx description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param outURL       <#outURL description#>
 @param outError     <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetURL(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSURL *defaultValue, NSURL **outURL, NSError **outError) __attribute__((nonnull(1,5,6)));

/**
 <#Description#>

 @param dict         <#dict description#>
 @param key          <#key description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param outURL       <#outURL description#>
 @param outError     <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetURL(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSURL *defaultValue, NSURL **outURL, NSError **outError) __attribute__((nonnull(1,2,5,6)));



#pragma mark - Set NSURL continuations
/**
 <#Description#>

 @param array        <#array description#>
 @param idx          <#idx description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param target       <#target description#>
 @param targetKey    <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, NSURL *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,5,6)));
/**
 <#Description#>

 @param array     <#array description#>
 @param idx       <#idx description#>
 @param target    <#target description#>
 @param targetKey <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id<BCJIndexedContainer> array, NSUInteger idx, id target, NSString *targetKey) __attribute__((nonnull(1,3,4)));

/**
 <#Description#>

 @param dict         <#dict description#>
 @param key          <#key description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param target       <#target description#>
 @param targetKey    <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, NSURL *defaultValue, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6)));
/**
 <#Description#>

 @param dict      <#dict description#>
 @param key       <#key description#>
 @param target    <#target description#>
 @param targetKey <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetURL(id<BCJKeyedContainer> dict, id key, id target, NSString *targetKey) __attribute__((nonnull(1,2,3,4)));



#pragma mark - Get Enum functions
/**
 <#Description#>

 @param array        <#array description#>
 @param idx          <#idx description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param enumMapping  <#enumMapping description#>
 @param outValue     <#outValue description#>
 @param outError     <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetEnum(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id *outValue, NSError **outError) __attribute__((nonnull(1,5,6)));

/**
 <#Description#>

 @param dict         <#dict description#>
 @param key          <#key description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param enumMapping  <#enumMapping description#>
 @param outValue     <#outValue description#>
 @param outError     <#outError description#>

 @return <#return value description#>
 */
BOOL BCJ_OVERLOADABLE BCJGetEnum(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id *outValue, NSError **outError) __attribute__((nonnull(1,2,5,6)));



#pragma mark - Set Enum continuations
/**
 <#Description#>

 @param array        <#array description#>
 @param idx          <#idx description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param enumMapping  <#enumMapping description#>
 @param target       <#target description#>
 @param targetKey    <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(id<BCJIndexedContainer> array, NSUInteger idx, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id target, NSString *targetKey) __attribute__((nonnull(1,5,6,7)));

/**
 <#Description#>

 @param dict         <#dict description#>
 @param key          <#key description#>
 @param options      <#options description#>
 @param defaultValue <#defaultValue description#>
 @param enumMapping  <#enumMapping description#>
 @param target       <#target description#>
 @param targetKey    <#targetKey description#>

 @return <#return value description#>
 */
id<BCLContinuation> BCJ_OVERLOADABLE BCJSetEnum(id<BCJKeyedContainer> dict, id key, BCJGetterOptions options, id defaultValue, NSDictionary *enumMapping, id target, NSString *targetKey) __attribute__((nonnull(1,2,5,6,7)));
