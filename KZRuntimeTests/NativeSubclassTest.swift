//
//  NativeSubclassTest.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//


import XCTest
import KZRuntime
#if SWIFT_INVOCATION
public class TestSubclass : TestClass {
    public required init() {}
}

class NativeSubclassTest: XCTestCase {
    var classInfo: ClassInfo! = nil
    var testObject: TestSubclass! = nil
    
    override func setUp() {
        super.setUp()
        classInfo = KZRuntime.sharedRuntime.registerType(TestSubclass.self) as! ClassInfo
        testObject = classInfo.newInstance() as! TestSubclass
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
        XCTAssert(prop.get(testObject) == value)
        
        value = nil
        prop.set(testObject, value: value)
        XCTAssert(prop.get(testObject) == value)
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
#endif
