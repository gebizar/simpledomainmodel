//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var value: Int = 0
    print("CHECK HERE", value, self.currency)
    switch self.currency {
    case "GBP":
        value = self.amount * 2
    case "EUR":
        value = (self.amount * 2) / 3
    case "CAN":
        value = (self.amount * 4) / 5
    default:
        value = self.amount
    }
    print(value)
    print(to)
    switch to {
    case "GBP":
        return Money(amount:value / 2, currency:to)
    case "EUR":
        return Money(amount:(value * 3) / 2, currency:to)
    case "CAN":
        return Money(amount:(value * 5) / 4, currency:to)
    default:
        return Money(amount:value, currency:to)
    }
  }
  
  public func add(_ to: Money) -> Money {
    let newMoney = Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
    return newMoney
  }
    
  public func subtract(_ from: Money) -> Money {
    let reducedMoney = Money(amount: self.amount - from.convert(self.currency).amount, currency: self.currency)
    return reducedMoney
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case let .Hourly(number):
        return Int(number) * hours
    case let .Salary(totalSal):
        return totalSal
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case let .Hourly(wage):
        let newWage = wage + amt
        self.type = .Hourly(newWage)
    case let .Salary(total):
        let newSal = total + Int(amt)
        self.type = .Salary(newSal)
    }
    }
}

////////////////////////////////////
// Person /////////////////////////
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return self._job
    }
    set(value) {
        if self.age < 21 {
            self._job = nil
        } else {
            self._job = value
        }
        
    }
  }
  
    fileprivate var _spouse: Person? = nil
  open var spouse : Person? {
    get {
        return self._spouse
    }
    set(value) {
        if self.age < 21 {
            self._spouse = nil
        } else {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
    open func toString() -> String {
        let retStr = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job ?? nil) spouse:\(self.spouse ?? nil)]"
        print(retStr)
        return retStr
    }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse != nil || spouse2.spouse != nil {
        return
    }
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    members.append(spouse1)
    members.append(spouse2)
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if members[0].age < 21 && members[1].age < 21 {
        return false
    }
    members.append(child)
    return true
}
  
  open func householdIncome() -> Int {
    var total = 0
    for member in self.members {
        if member.job != nil {
            total += member.job!.calculateIncome(2000)
        }
    }
    return total
  }
}





