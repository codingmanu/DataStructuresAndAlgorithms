/*:
# Data Structures and Algorithms
#### Manuel Gomez @codingManu

Hash Tables, Linked Lists, Stacks, Queues, Trees, Tries, Graphs, Vectors, Heaps.

## 1. Hash Tables
---
*/
import Foundation

// Input data
let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dignissim dictum pulvinar. Morbi interdum mauris ac sodales pretium. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dignissim dictum pulvinar."
let words = text.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").components(separatedBy: " ")

// Hashing function, currently using the built in "hashValue" property. Extracted as function so the implementation can be customized.
func hash(_ input: String) -> Int {
    return input.hashValue
}

// Protocol allows for generic `HashTable` object where different types of `Bucket` can be used.
protocol Bucket: NSObject {
    associatedtype T: Any
    var elements: T { get set }
    func append(_ element: String)
    var description: String { get }
}

// Bucket with Array holding the objects
class ArrayBucket: NSObject, Bucket {
    
    internal var elements = [String]()
    
    func append(_ element: String) {
        elements.append(element)
    }
    
    override var description: String {
        return "\(elements.split(separator: ","))"
    }
}

// Bucket with Linked List holding the object. See section (2) for Linked List implementation.
class LinkedListBucket: NSObject, Bucket {
    
    internal var elements = LinkedList<String>()
    
    func append(_ element: String) {
        elements.append(element)
    }
    
    override var description: String {
        return "LinkedList Bucket."
    }
    
}

// Hash Table object.
class HashTable<T: Bucket> {
    
    private var hashTable = [Int: T]()
    
    func add(_ value: String) {
        let hashedValue = hash(value)
        
        if let bucket = hashTable[hashedValue] {
            bucket.append(value)
        } else {
            let bucket = T()
            bucket.append(value)
            hashTable[hashedValue] = bucket
        }
    }
    
    func printDescription() {
        for bucket in hashTable {
            print("Bucket: \(bucket.key), Elements: \(bucket.value.description)")
        }
    }
    
}

// Two different linked lists with different internal storage, same interfacing functions.
let exampleHashTable1 = HashTable<ArrayBucket>()
let exampleHashTable2 = HashTable<LinkedListBucket>()
for word in words {
    exampleHashTable1.add(word)
    exampleHashTable2.add(word)
}

//: ---
//:  Uncomment this block to print an example
/*
print("------------------- [ HASH TABLE EXAMPLE ] ------------------")
exampleHashTable1.printDescription()
exampleHashTable2.printDescription()
print("-------------------------------------------------------------")
*/
//: ---






/*:
## 2. Linked Lists
---
 */

// Input data.
let linkedListData = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
let listComponents = linkedListData.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "").components(separatedBy: " ")

// Linked List class holding only the first node (head).
class LinkedList<T: Equatable> {
    
    var head: LinkedListNode<T>?
    
    func append(_ data: T) {
        if head == nil {
            head = LinkedListNode(data)
        } else {
            head!.append(data: data)
        }
    }
    
    func find(data: T) -> LinkedListNode<T>? {
        guard let head = head else { return nil }
        return head.find(data)
    }
    
    func lastNode() -> LinkedListNode<T>? {
        guard let head = head else { return nil }
        return head.traverse()
    }
    
    func insert(_ data: T, afterNode: LinkedListNode<T>) {

        // If the node we're inserting after is the last one on the list, just add it as the nextNode.
        if afterNode.nextNode == nil {
            afterNode.nextNode = LinkedListNode<T>(data)
        } else {
            // If it's not empty, we insert it after the node, moving the previous next node to the new node.
            let newNode = LinkedListNode<T>(data)
            newNode.nextNode = afterNode.nextNode
            afterNode.nextNode = newNode
        }
    }
    
    func printDescription() {
        if head != nil {
            print("-------------------------------------------------------------")
            print("LinkedList: \(Unmanaged.passUnretained(self).toOpaque())")
            print("HEAD: \(Unmanaged.passUnretained(head!).toOpaque())")
            print("-------------------------------------------------------------")
            head!.printDescription(true)
        }
    }
}

// Nodes for LinkedList holding data and next node in the list.
class LinkedListNode<T: Equatable> {
    
    var data: T
    var nextNode: LinkedListNode<T>?
    
    init(_ data: T) {
        self.data = data
    }

    func append(data: T) {
        if nextNode == nil {
            nextNode = LinkedListNode(data)
        } else {
            nextNode!.append(data: data)
        }
    }
    
    // This will return the first matching item on the list.
    func find(_ data: T) -> LinkedListNode<T>? {
        if self.data == data {
            return self
        } else if nextNode != nil {
            return nextNode!.find(data)
        } else {
            return nil
        }
    }
    
    func traverse() -> LinkedListNode<T> {
        if nextNode != nil {
            return nextNode!.traverse()
        } else {
            return self
        }
    }
    
    func printDescription(_ includeNextNodes: Bool = false) {
        if nextNode == nil {
            print("Node: \(Unmanaged.passUnretained(self).toOpaque())")
            print("Data: \(data)")
            print("Next Node: nil")
            print(" --- End of list. ---")
            print("-------------------------------------------------------------")
        } else {
            print("Node: \(Unmanaged.passUnretained(self).toOpaque())")
            print("Data: \(data)")
            print("Next Node: \(Unmanaged.passUnretained(nextNode!).toOpaque())")
            print("---------------------")
            if includeNextNodes {
                nextNode!.printDescription(true)
            }
        }
    }
}

let exampleLinkedList = LinkedList<String>()

for word in listComponents {
    exampleLinkedList.append(word)
}
//: ---
//:  Uncomment this block to print an example
/*
print("------------------ [ LINKED LIST EXAMPLE ] ------------------")
exampleLinkedList.printDescription()

if let foundNode = exampleLinkedList.find(data: "ipsum") {
    print("*** Found node ***")
    foundNode.printDescription()
    
    print("*** Insert node after found one ***")
    exampleLinkedList.insert("TEST", afterNode: foundNode)
    
    print("*** Print list again to check if noded was inserted correctly ***")
    exampleLinkedList.printDescription()
}
print("-------------------------------------------------------------")
 */
//: ---

/*:
 ## 3. Doubly Linked lists
 ---
 */

class DoublyLinkedList<T: Equatable> {
    
    var head: DoublyLinkedListNode<T>?
    
    func append(_ data: T) {
        if head == nil {
            head = DoublyLinkedListNode(data)
        } else {
            head!.append(data: data)
        }
    }
    
    func pop() -> DoublyLinkedListNode<T>? {
        // Can't pop an empty list
        if head == nil {
            return nil
        }
        // Find last node and remove it from its parent
        let last = lastNode()
        last?.previousNode?.nextNode = nil
        return last?.previousNode
    }
    
    func find(data: T) -> DoublyLinkedListNode<T>? {
        guard let head = head else { return nil }
        return head.find(data)
    }
    
    func lastNode() -> DoublyLinkedListNode<T>? {
        guard let head = head else { return nil }
        return head.traverse()
    }
    
    func count() -> Int {
        if head == nil {
            return 0
        } else {
            return head!.count()
        }
    }
    
    func insert(_ data: T, afterNode: DoublyLinkedListNode<T>) {
        
        // If the node we're inserting after is the last one on the list, just add it as the nextNode.
        if afterNode.nextNode == nil {
            afterNode.nextNode = DoublyLinkedListNode<T>(data)
            afterNode.nextNode!.previousNode = afterNode
        } else {
            // If it's not empty, we insert it after the node, moving the previous next node to the new node.
            let newNode = DoublyLinkedListNode<T>(data)
            newNode.nextNode = afterNode.nextNode
            afterNode.nextNode = newNode
            afterNode.nextNode!.previousNode = afterNode
        }
    }
    
    func printDescription() {
        if head != nil {
            print("-------------------------------------------------------------")
            print("DoublyLinkedList: \(Unmanaged.passUnretained(self).toOpaque())")
            print("HEAD: \(Unmanaged.passUnretained(head!).toOpaque())")
            print("-------------------------------------------------------------")
            head!.printDescription(true)
        }
    }
}

// Nodes for DoublyLinkedList holding data, previous node and next node in the list.
class DoublyLinkedListNode<T: Equatable> {
    
    var data: T
    var nextNode: DoublyLinkedListNode<T>?
    var previousNode: DoublyLinkedListNode<T>?
    
    init(_ data: T) {
        self.data = data
    }
    
    func append(data: T) {
        if nextNode == nil {
            nextNode = DoublyLinkedListNode(data)
            nextNode!.previousNode = self
        } else {
            nextNode!.append(data: data)
            nextNode!.previousNode = self
        }
    }
    
    // This will return the first matching item on the list.
    func find(_ data: T) -> DoublyLinkedListNode<T>? {
        if self.data == data {
            return self
        } else if nextNode != nil {
            return nextNode!.find(data)
        } else {
            return nil
        }
    }
    
    func traverse() -> DoublyLinkedListNode<T> {
        if nextNode != nil {
            return nextNode!.traverse()
        } else {
            return self
        }
    }
    
    func count() -> Int {
        var count = 1
        
        if nextNode == nil {
            return count
        } else {
            count += nextNode!.count()
        }
        return count
    }
    
    func printDescription(_ includeNextNodes: Bool = false) {
        
        print("Node: \(Unmanaged.passUnretained(self).toOpaque())")
        print("Data: \(data)")
        
        if previousNode == nil {
            print("Previous Node: nil --> HEAD")
        }
        
        if previousNode != nil {
            print("Previous Node: \(Unmanaged.passUnretained(previousNode!).toOpaque())")
        }

        if nextNode == nil {
            print("Next Node: nil --> END OF LIST")
            print("-------------------------------------------------------------")
        } else {
            print("Next Node: \(Unmanaged.passUnretained(nextNode!).toOpaque())")
            print("---------------------")
            if includeNextNodes {
                nextNode!.printDescription(true)
            }
        }
    }
}

let exampleDoublyLinkedList = DoublyLinkedList<String>()

for word in listComponents {
    exampleDoublyLinkedList.append(word)
}
//: ---
//:  Uncomment this block to print an example
/*
 print("--------------- [ DOUBLY LINKED LIST EXAMPLE ] ---------------")
 exampleDoublyLinkedList.printDescription()
 
 if let foundDoublyNode = exampleDoublyLinkedList.find(data: "ipsum") {
 print("*** Found node ***")
 foundDoublyNode.printDescription()
 
 print("*** Insert node after found one ***")
 exampleDoublyLinkedList.insert("TEST", afterNode: foundDoublyNode)
 
 print("*** Print list again to check if noded was inserted correctly ***")
 exampleDoublyLinkedList.printDescription()
 }
 print("-------------------------------------------------------------")
 */
//: ---

/*:
 ## 4. Stacks
 ---
 */

// Input data.
let stackData = [1, 2, 3, 4, 5]

// Stack object implemented using a doubly linked list.
class Stack<T: Equatable> {
    
    private var elements = DoublyLinkedList<T>()
    
    func push(_ element: T) {
        elements.append(element)
    }
    
    @discardableResult func pop() -> DoublyLinkedListNode<T>? {
        return elements.pop()
    }
    
    func printDescription() {
        print("* Stack with \(elements.count()) elements:")
        elements.printDescription()
    }
}

let exampleStack = Stack<Int>()

for element in stackData {
    exampleStack.push(element)
}



//: ---
//:  Uncomment this block to print an example
/*
print("---------------------- [ STACK EXAMPLE ] ---------------------")
// Print complete stack
exampleStack.printDescription()

// Pop a couple items from the stack. The last item on the stack gets popped first.
print("Popped item: \(String(describing: exampleStack.pop()))")
print("Popped item: \(String(describing: exampleStack.pop()))")

// Print again to see items popped from the end of the stack.
exampleStack.printDescription()

// Add a couple more items
exampleStack.push(25)
exampleStack.push(15)

// Print to see they're added to the end of the stack, not matter the order.
exampleStack.printDescription()
print("-------------------------------------------------------------")
*/
//: ---
