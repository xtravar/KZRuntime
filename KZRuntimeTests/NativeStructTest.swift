//
//  NativeStructTest.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//


import XCTest
import KZRuntime

class NativeStructTest: XCTestCase {
    var structInfo: StructInfo! = nil
    var testValue: TestStruct = TestStruct()
    
    override func setUp() {
        super.setUp()
        structInfo =  KZRuntime.sharedRuntime.registerType(TestStruct.self) as! StructInfo
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    //MARK: struct fields
    func testStructFieldInt() {
        let prop = structInfo.fieldNamed("intField")
        let value: Int = Int(202)
        prop.set(&testValue, value: value)
        let getValue: Int = prop.get(&testValue)
        XCTAssert(getValue == value)
    }
    
    func testStructFieldOptInt() {
        let prop = structInfo.fieldNamed("optIntField")
        var value: Int? = Int(202)
        prop.set(&testValue, value: value)
        XCTAssert(prop.get(&testValue) == value)
        
        value = nil
        prop.set(&testValue, value: value)
        XCTAssert(prop.get(&testValue) == value)
    }
    
    func testStructFieldDouble() {
        let prop = structInfo.fieldNamed("doubleField")
        let value = Double(202)
        prop.set(&testValue, value: value)
        let getValue: Double = prop.get(&testValue)
        XCTAssert(getValue == value)
    }
    
    func testStructFieldOptDouble() {
        let prop = structInfo.fieldNamed("optDoubleField")
        var value: Double? = Double(202)
        prop.set(&testValue, value: value)
        XCTAssert(prop.get(&testValue) == value)
        
        value = nil
        prop.set(&testValue, value: value)
        XCTAssert(prop.get(&testValue) == value)
    }
    
    func testStructFieldPoint() {
        let prop = structInfo.fieldNamed("pointField")
        let setValue = CGPoint(x: 1.10, y: 2.20)
        prop.set(&testValue, value: setValue)
        let getValue: CGPoint = prop.get(&testValue)
        XCTAssert(getValue == setValue)
    }
    
    func testStructFieldOptPoint() {
        let prop = structInfo.fieldNamed("optPointField")
        var value: CGPoint? = CGPoint(x: 1.10, y: 2.20)
        prop.set(&testValue, value: value)
        var getValue: CGPoint? = prop.get(&testValue)
        XCTAssert(getValue == value)
        
        value = nil
        prop.set(&testValue, value: value)
        getValue = prop.get(&testValue)
        XCTAssert(getValue == value)
    }
    
    func testStructFieldRect() {
        let prop = structInfo.fieldNamed("rectField")
        let setValue = CGRect(x: 1, y: 2, width: 3, height: 4)
        prop.set(&testValue, value: setValue)
        let getValue: CGRect = prop.get(&testValue)
        XCTAssert(getValue == setValue)
    }
    
    func testStructFieldOptRect() {
        let prop = structInfo.fieldNamed("optRectField")
        var value: CGRect? = CGRect(x: 1, y: 3, width: 4, height: 5)
        prop.set(&testValue, value: value)
        var getValue: CGRect? = prop.get(&testValue)
        XCTAssert(getValue == value)
        
        value = nil
        prop.set(&testValue, value: value)
        getValue = prop.get(&testValue)
        XCTAssert(getValue == value)
    }
}

public struct TestStruct {
    private var intField = Int()
    private var optIntField: Int?
    
    private var doubleField = Double()
    private var optDoubleField: Double?
    
    private var pointField = CGPoint()
    private var optPointField: CGPoint?
    
    private var rectField = CGRect()
    private var optRectField: CGRect?
}