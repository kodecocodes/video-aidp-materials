/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Composite
 - - - - - - - - - -
 ![Composite Diagram](Composite_Diagram.png)
 
 The composite pattern is a structural pattern that groups a set of objects into a tree so that they may be manipulated as though they were one object. It uses three types:
 
 1. The **component protocol** ensures all constructs in the tree can be treated the same way.
 2. A **leaf** is a component of the tree that does not have child elements.
 3. A **composite** is a container that can hold leaf objects and composites.
 
 ## Code Example
 */
import Foundation

protocol File {
  var name: String { get set }
  func open()
}

struct eBook: File {
  var name: String
  var author: String
  
  func open() {
    print("Opening \(name) by \(author) in iBooks...")
  }
}

struct Music: File {
  var name: String
  var artist: String
  
  func open() {
    print("Opening \(name) by \(artist) in Music...")
  }
}

struct Folder: File {
  var name: String
  var files: [File] = []
  
  mutating func addFile(_ file: File) {
    self.files.append(file)
  }
  
  func open() {
    print("Displaying files in \(name)...")
    for file in files {
      print("- \(file.name)")
    }
  }
}

let psychoKiller = Music(name: "Psycho Killer", artist: "The Talking Heads")
let rebelRebel = Music(name: "Rebel Rebel", artist: "David Bowie")
let blisterInTheSun = Music(name: "Blister in the Sun", artist: "Violent Femmes")
let justKids = eBook(name: "Just Kids", author: "Patti Smith")

var documents = Folder(name: "Documents")
var musicFolder = Folder(name: "Great 70s Music")

documents.addFile(musicFolder)
documents.addFile(justKids)

musicFolder.addFile(psychoKiller)
musicFolder.addFile(rebelRebel)

blisterInTheSun.open()
justKids.open()
print("")

documents.open()
print("")

musicFolder.open()
print("")
