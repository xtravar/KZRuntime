//
//  ObjCClassTest.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import XCTest
import KZRuntime
import KZSwiftBridging
import KZTypeReflection


/*
extension Optional where Wrapped: NSNumberWrappable {
    typealias _ObjectiveCType = NSNumber?
    
    static func _isBridgedToObjectiveC() -> Bool {
        return true
    }
    
    static func _getObjectiveCType() -> Any.Type {
        return (NSNumber?).self
    }
    
    func _bridgeToObjectiveC() -> NSNumber? {
        if case .Some(let value) = self {
            return value.toNSNumber()
        }
        return nil
    }
    
    static func _forceBridgeFromObjectiveC(x: NSNumber?, inout result: Wrapped!?) {
        
    }
    static func _conditionallyBridgeFromObjectiveC(x: NSNumber?, inout result: Wrapped!?) -> Bool {
        _forceBridgeFromObjectiveC(x, result: &result)
        return true
    }
}*/

public class TestObjCClass: NSObject {
    public override init() {}
    public var intProp = Int()
    public var optIntProp: Int!
    
    public var doubleProp = Double()
    public var optDoubleProp: Double?
    
    public var pointProp = CGPoint()
    public var optPointProp: CGPoint?
    
    public var rectProp = CGRect()
    public var optRectProp: CGRect?
    
    public var arrayProp = [Int]()
    public var optArrayProp: [Int]?
    
    public var dictProp = [String: Int]()
    public var optDictProp: [String: Int]?
    
    public var pointArrayProp = [CGPoint]()
    
    internal var intField = Int()
    private var optIntField: Int?
    
    private var doubleField = Double()
    private var optDoubleField: Double?
    
    private var pointField = CGPoint()
    private var optPointField: CGPoint?
    
    private var rectField = CGRect()
    private var optRectField: CGRect?
}

extension TestObjCClass {
    
    dynamic private var optIntProp_runtime: NSNumber? {
        get { return NSNumber(optIntProp)}
        set { optIntProp = Int(newValue) }
    }
    
    dynamic private var optDoubleProp_runtime: NSNumber? {
        get { return optDoubleProp?.toNSNumber()}
        set { optDoubleProp = Double(newValue) }
    }
    
    dynamic private var optPointProp_runtime: NSValue? {
        get { return NSValue(optPointProp)}
        set {
            optPointProp = CGPoint?(optionalValue: newValue)
        }
    }
    
    dynamic private var optRectProp_runtime: NSValue? {
        get { return NSValue(optRectProp)}
        set { optRectProp = CGRect?(optionalValue: newValue) }
    }
}

class ObjCClassTest: XCTestCase {
    var classInfo: ClassInfo! = nil
    var testObject: TestObjCClass! = nil
    
    override func setUp() {
        super.setUp()
        classInfo = KZRuntime.sharedRuntime.registerType(TestObjCClass.self) as! ClassInfo
        testObject = classInfo.newInstance() as! TestObjCClass
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClassPropertyInt() {
        let prop = classInfo.propertyNamed("intProp")
        let value: Int = Int(202)
        prop.set(testObject, value: value)
        let getValue: Int = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    func testClassPropertyOptInt() {
        let prop = classInfo.propertyNamed("optIntProp")
        var value: Int? = Int(202)
        prop.set(testObject, value: value)
        XCTAssert(prop.get(testObject) == value)
        
        value = nil
        prop.set(testObject, value: value)
        XCTAssert(prop.get(testObject) == value)
    }
    
    func testClassPropertyDouble() {
        let prop = classInfo.propertyNamed("doubleProp")
        let value = Double(202)
        prop.set(testObject, value: value)
        let getValue: Double = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    func testClassPropertyOptDouble() {
        let prop = classInfo.propertyNamed("optDoubleProp")
        var value: Double? = Double(202)
        prop.set(testObject, value: value)
        var getValue: Double? = prop.get(testObject)
        XCTAssert(getValue == value)
        
        value = nil
        prop.set(testObject, value: value)
        getValue = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    func testClassPropertyPoint() {
        let prop = classInfo.propertyNamed("pointProp")
        let setValue = CGPoint(x: 1.10, y: 2.20)
        prop.set(testObject, value: setValue)
        let getValue: CGPoint = prop.get(testObject)
        XCTAssert(getValue == setValue)
    }
    
    func testClassPropertyOptPoint() {
        let prop = classInfo.propertyNamed("optPointProp")
        var value: CGPoint? = CGPoint(x: 1.10, y: 2.20)
        prop.set(testObject, value: value)
        var getValue: CGPoint? = prop.get(testObject)
        XCTAssert(getValue == value)
        
        value = nil
        prop.set(testObject, value: value)
        getValue = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    func testClassPropertyRect() {
        let prop = classInfo.propertyNamed("rectProp")
        let setValue = CGRect(x: 1, y: 2, width: 3, height: 4)
        prop.set(testObject, value: setValue)
        let getValue: CGRect = prop.get(testObject)
        XCTAssert(getValue == setValue)
    }
    
    func testClassPropertyOptRect() {
        let prop = classInfo.propertyNamed("optRectProp")
        var value: CGRect? = CGRect(x: 1, y: 3, width: 4, height: 5)
        prop.set(testObject, value: value)
        var getValue: CGRect? = prop.get(testObject)
        XCTAssert(getValue == value)
        
        value = nil
        prop.set(testObject, value: value)
        getValue = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    func testClassPropertyArray() {
        let prop = classInfo.propertyNamed("arrayProp")
        let setValue = [Int(10), Int(20)]
        prop.set(testObject, value: setValue)
        let getValue: [Int] = prop.get(testObject)
        XCTAssert(getValue == setValue)
    }
    
    func testClassPropertyOptArray() {
        let prop = classInfo.propertyNamed("optArrayProp")
        var value: [Int]? =  [Int(10), Int(20)]
        prop.set(testObject, value: value)
        var getValue: [Int]? = prop.get(testObject)
        XCTAssert(getValue! == value!)
        
        value = nil
        prop.set(testObject, value: value)
        getValue = prop.get(testObject)
        XCTAssert(getValue == nil)
    }
    
    func testClassPropertyDictionary() {
        let prop = classInfo.propertyNamed("dictProp")
        let setValue = ["x": Int(10), "y": Int(20)]
        prop.set(testObject, value: setValue)
        let getValue: [String: Int] = prop.get(testObject)
        XCTAssert(getValue == setValue)
    }
    
    func testClassPropertyOptDictionary() {
        let prop = classInfo.propertyNamed("optDictProp")
        var value: [String: Int]? =  ["x": Int(10), "y": Int(20)]
        prop.set(testObject, value: value)
        var getValue: [String: Int]? = prop.get(testObject)
        XCTAssert(getValue! == value!)
        
        value = nil
        prop.set(testObject, value: value)
        getValue = prop.get(testObject)
        XCTAssert(getValue == nil)
    }
    
    func testClassPropertyPointArray() {
        let prop = classInfo.propertyNamed("pointArrayProp")
        let value: [CGPoint] = [CGPoint(x: 1, y: 2), CGPoint(x: 3, y: 4), CGPoint(x: 5, y: 6)]
        prop.set(testObject, value: value)
        let getValue: [CGPoint] = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    //MARK: class fields
    
    func testClassFieldInt() {
        let prop = classInfo.fieldNamed("intField")
        let value: Int = Int(202)
        prop.set(testObject, value: value)
        let getValue: Int = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    func testClassFieldOptInt() {
        let prop = classInfo.fieldNamed("optIntField")
        var value: Int? = Int(202)
        prop.set(testObject, value: value)
        XCTAssert(prop.get(testObject) == value)
        
        value = nil
        prop.set(testObject, value: value)
        XCTAssert(prop.get(testObject) == value)
    }
    
    func testClassFieldDouble() {
        let prop = classInfo.fieldNamed("doubleField")
        let value = Double(202)
        prop.set(testObject, value: value)
        let getValue: Double = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    func testClassFieldOptDouble() {
        let prop = classInfo.fieldNamed("optDoubleField")
        var value: Double? = Double(202)
        prop.set(testObject, value: value)
        XCTAssert(prop.get(testObject) == value)
        
        value = nil
        prop.set(testObject, value: value)
        XCTAssert(prop.get(testObject) == value)
    }
    
    func testClassFieldPoint() {
        let prop = classInfo.fieldNamed("pointField")
        let setValue = CGPoint(x: 1.10, y: 2.20)
        prop.set(testObject, value: setValue)
        let getValue: CGPoint = prop.get(testObject)
        XCTAssert(getValue == setValue)
    }
    
    func testClassFieldOptPoint() {
        let prop = classInfo.fieldNamed("optPointField")
        var value: CGPoint? = CGPoint(x: 1.10, y: 2.20)
        prop.set(testObject, value: value)
        var getValue: CGPoint? = prop.get(testObject)
        XCTAssert(getValue == value)
        
        value = nil
        prop.set(testObject, value: value)
        getValue = prop.get(testObject)
        XCTAssert(getValue == value)
    }
    
    func testClassFieldRect() {
        let prop = classInfo.fieldNamed("rectField")
        let setValue = CGRect(x: 1, y: 2, width: 3, height: 4)
        prop.set(testObject, value: setValue)
        let getValue: CGRect = prop.get(testObject)
        XCTAssert(getValue == setValue)
    }
    
    func testClassFieldOptRect() {
        let prop = classInfo.fieldNamed("optRectField")
        var value: CGRect? = CGRect(x: 1, y: 3, width: 4, height: 5)
        prop.set(testObject, value: value)
        var getValue: CGRect? = prop.get(testObject)
        XCTAssert(getValue == value)
        
        value = nil
        prop.set(testObject, value: value)
        getValue = prop.get(testObject)
        XCTAssert(getValue == value)
    }
}


/*
extension CGPoint : _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = NSValue
    
    public static func _isBridgedToObjectiveC() -> Bool {
        return true
    }
    
    public static func _getObjectiveCType() -> Any.Type {
        return _ObjectiveCType.self
    }
    
    public func _bridgeToObjectiveC() -> _ObjectiveCType {
        var value = self
        let str = ObjCTypeEncoder.sharedEncoder.encode(CGPoint.self)
        return NSValue(&value, withObjCType: str)
    }
    
    public static func _forceBridgeFromObjectiveC(source: _ObjectiveCType, inout result: CGPoint?) {
        source.getValue(&result)
    }
    
    public static func _conditionallyBridgeFromObjectiveC(source: _ObjectiveCType, inout result: CGPoint?) -> Bool {
        _forceBridgeFromObjectiveC(source, result: &result)
        return true
    }
}*/
