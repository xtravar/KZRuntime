# KZRuntime
High-level type reflection for Apple's Swift that takes Swift metadata and Objective-C metadata and puts it together.

*WARNING:* This software is extremely fragile at the moment, not recommended for production use, and currently a proof-of-concept.

## Goal
To allow dynamic object serialization/deserialization with minimal type augmentation or rote code.

Also, to do accomplish the impossible, which is kind of fun.

## Dependencies

- [KZTypeReflection](https://github.com/xtravar/KZTypeReflection) - introspects both the ObjC and Swift type runtimes
- [KZSwiftBridging](https://github.com/xtravar/KZSwiftBridging) - helps with NSValue/NSNumber conversions
- [SwiftFFI](https://github.com/xtravar/SwiftFFI) - ONLY if you are feeling particularly dangerous and compile with the danger flag

## Basics - API
The API is modeled somewhat after C#'s reflection system.  To get a handle for a type's information, you use `let typeInfo = KZRuntime.sharedRuntime.registerType(MyClass.self) as! ClassInfo`

Notice this is a singleton, but does not exclude you from creating your own runtime with different parameters, if necessary, later.

Once you have a TypeInfo instance, you can do things like: 
```swift
  let prop = classInfo.propertyNamed("doubleProp")
  let value = Double(202)
  prop.set(testObject, value: value)
  let getValue: Double = prop.get(testObject)
```

The same works for fields - although, remember, fields don't play nice with ref-counted types.

## Options/Under-the-Hood
There are multiple failure points, which will be refined in upcoming releases.  Here are your options.

###Raw
You can use *direct* Swift getters/setters. I highly recommend against this - it requires my hacked up version of FFI, which is not reliable at all, and might be broken under certain cases.  This method supports non-NSObject classes and non-C structs.

Theoretically, any property type is supported under this system.

You'll have to find the compiler option for this. :)

###Objective-C with Swift info and binary symbol lookups
You can use Objective-C getters/setters with aided Swift type information. This is my preference, and is what is verified working at the moment.  It uses the Objective-C dynamic runtime getters/setters, along with information from KZTypeReflection, along with bridging from KZSwiftBridging, to perform its duties.

Objective-C bridged types are supported under this system, as are certain 'aided' types.  For example:
```swift
class Test1: NSObject {
    var intProp = Int()
    var uintProp = UInt()
    var int8Prop = Int8()
    var uint8Prop = UInt8()
    var floatProp = Float()
    var optIntProp: Int!
    var optUIntProp: UInt!
    
    var stringProp =  String()
    
    var optStringProp1: String!
    var optStringProp2: String?
    
    var decimalProp = NSDecimal()
    var optDecimalProp1: NSDecimal?
    var optDecimalProp2: NSDecimal!
    var decimalNumberProp: NSDecimalNumber!
    
    var intArrayProp = [Int]()
    var optIntArrayProp1: [Int]?
    var optIntArrayProp2: [Int]!
    
    var decimalArrayProp = [NSDecimal]()
    var optDecimalArrayProp1: [NSDecimal]?
    var optDecimalArrayProp2: [NSDecimal]!
    
    var stringArrayProp = [String]()
    var optStringArrayProp1: [String]?
    var optStringArrayProp2: [String]!
    
    var stringDictProp = [String: String]()
    var optStringDictProp1: [String: String]?
    var optStringDictProp2: [String: String]!
    
    var intSetProp = Set<Int>()
    var optIntSetProp1: Set<Int>?
    var optIntSetProp2: Set<Int>!
    
    var pointProp = CGPoint()
    var optPointProp1: CGPoint?
    var optPointProp2: CGPoint!
    
    var objProp = Test2()
    var optObjProp1: Test2?
    var optObjProp2: Test2!
    
    
    var pointArrayProp = [CGPoint]()
}

extension Test1 {
    private dynamic var optIntProp_runtime: NSNumber? {
        get { return NSNumber(self.optIntProp) }
        set { self.optIntProp = Int(newValue)}
    }
    
    private dynamic var optUIntProp_runtime: NSNumber? {
        get { return NSNumber(self.optUIntProp) }
        set { self.optUIntProp = UInt(newValue)}
    }
    
    private dynamic var optDecimalProp1_runtime: NSDecimalNumber? {
        get { return NSDecimalNumber(self.optDecimalProp1) }
        set { self.optDecimalProp1 = NSDecimal(newValue)}
    }
    
    private dynamic var optDecimalProp2_runtime: NSDecimalNumber? {
        get { return NSDecimalNumber(self.optDecimalProp2) }
        set { self.optDecimalProp2 = NSDecimal(newValue)}
    }
    
    private dynamic var optPointProp1_runtime: NSValue? {
        get { return NSValue(self.optPointProp1) }
        set { self.optPointProp1 = CGPoint?(optionalValue: newValue) }
    }
    
    private dynamic var optPointProp2_runtime: NSValue? {
        get { return NSValue(self.optPointProp2) }
        set { self.optPointProp2 = CGPoint?(optionalValue: newValue) }
    }
}
```

### Objective-C with Swift info and binary symbol lookups
The above uses a certain hacky method to look up type metadata for types not exposed through code - it trawls through the exposed binary symbols for type metadata (which is kind of awesome and terrifying).  Swap out `SwiftSymbolDecoderUnsafe` with `SwiftSymbolDecoder` and make sure to call `KZRuntime.sharedRuntime.registerClass(MyClass.self)` in the reverse order of dependency before using, and you reduce the changes of this going awry.

#Future
There is a lot of code cleanup to be done, as well as performance enhancements.  And of course, keeping up with Swift changes (ahem... "__C").  With Swift now Open Sourced, a lot of my reverse engineering sweat can be verified with real code.
