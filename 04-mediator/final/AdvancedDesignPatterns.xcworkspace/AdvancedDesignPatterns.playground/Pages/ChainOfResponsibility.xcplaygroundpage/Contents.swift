/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Chain Of Responsibility
 - - - - - - - - - -
 ![Chain Of Responsibility Diagram](ChainOfResponsibility_Diagram.png)
 
The chain of responsibility pattern is a behavioral design pattern that allows an event to be processed by one of many handlers. It involves three types:
 
 1. The **client** accepts and passes events to an instance of a handler protocol.
 
 2. The **handler protocol** defines required properties and methods that concrete handlers must implement.
 
 3. The first **concrete handler** implements the handler protocol and is stored directly by the client. It first attempts to handle the event that's passed to it. If it's not able to do so, it passes the event onto its **next** concrete handler, which it holds as a strong property.
 
 ## Code Example
 */
import Foundation

// MARK: - Models
public class Coin {
  public class var standardDiameter: Double { return 0 }
  public class var standardWeight: Double { return 0 }
  public var centValue: Int { return 0 }
  public final var dollarValue: Double {
    return Double(centValue) / 100
  }
  
  public final let diameter: Double
  public final let weight: Double
  
  public required init(diameter: Double, weight: Double) {
    self.diameter = diameter
    self.weight = weight
  }
  
  public convenience init() {
    let diameter = type(of: self).standardDiameter
    let weight = type(of: self).standardWeight
    self.init(diameter: diameter, weight: weight)
  }
}

extension Coin: CustomStringConvertible {
  public var description: String {
    return String(format: "%@ { diameter: %0.3f, dollarValue: $0.2f, weight: %0.3f }",
                  "\(type(of: self))", diameter, dollarValue, weight)
  }
}

public class Penny: Coin {
  public override class var standardDiameter: Double { return 19.05 }
  public override class var standardWeight: Double { return 2.5 }
  public override var centValue: Int { return 1 }
}

public class Nickel: Coin {
  public override class var standardDiameter: Double { return 21.21 }
  public override class var standardWeight: Double { return 5.0 }
  public override var centValue: Int { return 5 }
}

public class Dime: Coin {
  public override class var standardDiameter: Double { return 17.91 }
  public override class var standardWeight: Double { return 2.268 }
  public override var centValue: Int { return 10 }
}

public class Quarter: Coin {
  public override class var standardDiameter: Double { return 24.26 }
  public override class var standardWeight: Double { return 5.670 }
  public override var centValue: Int { return 25 }
}
