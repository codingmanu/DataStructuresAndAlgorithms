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
    
    func removeLast() -> LinkedListNode<T>? {
        guard let head = head else { return nil }
        if head.nextNode == nil {
            self.head = nil
            return head
        } else {
            return head.removeLast()
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
    
    func removeLast() -> LinkedListNode<T>? {
        guard let nextNode = nextNode else { return nil }
        if nextNode.nextNode == nil {
            self.nextNode = nil
            return nextNode
        } else {
            return nextNode.removeLast()
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
 
 print("*** Find last ***")
 if let lastNode = exampleLinkedList.lastNode() {
 lastNode.printDescription()
 }
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

// Stack object using a doubly linked list. LIFO implementation (LAST IN FIRST OUT)
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

/*:
 ## 6. Queues
 ---
 */

// Input data.
let queueData = [1, 2, 3, 4, 5]

// Queue Object. FIFO implementation (FIRST IN, FIRST OUT)
class Queue<T: Equatable> {
    
    private var elements = LinkedList<T>()
    
    func enqueue(_ element: T) {
        let newNode = LinkedListNode(element)
        guard let head = elements.head else {
            elements.head = newNode
            return
        }
        newNode.nextNode = head
        elements.head = newNode
    }
    
    @discardableResult func dequeue() -> LinkedListNode<T>? {
        guard let head = elements.head else { return nil }
        return head.removeLast()
    }
    
    func printDescription() {
        elements.printDescription()
    }
    
}

let exampleQueue = Queue<Int>()
for element in queueData {
    exampleQueue.enqueue(element)
}

//: ---
//:  Uncomment this block to print an example
/*
print("---------------------- [ QUEUE EXAMPLE ] ---------------------")
// Print complete queue
exampleQueue.printDescription()

// Dequeue a couple items from the queue. The first item that entered the queue gets removed first.
print("Dequeued item: \(String(describing: exampleQueue.dequeue()!.data))")
print("Dequeued item: \(String(describing: exampleQueue.dequeue()!.data))")

// Print again to see items popped from the end of the stack.
exampleQueue.printDescription()

// Add a couple more items
exampleQueue.enqueue(15)
exampleQueue.enqueue(30)

// Print to see they're always added to the back of the queue.
exampleQueue.printDescription()
print("-------------------------------------------------------------")
*/
//: ---


/*:
 ## 7. Trees
 ---
 */
/*:
 #### a) Binary Tree example from FB Interview Prep
 ---
 */
// Given the root node of a binary tree, return an array with the average values of each level.
/*
       4
      /  \
     7    9
    / \    \
   10  2    6
        \
         6
        /
       2
 */

func fillExampleBinaryTree() -> BinaryTreeNode<Int> {
    let root = BinaryTreeNode(4)
    root.leftNode = BinaryTreeNode(7)
    root.rightNode = BinaryTreeNode(9)
    root.leftNode?.leftNode = BinaryTreeNode(10)
    root.leftNode?.rightNode = BinaryTreeNode(2)
    root.rightNode?.rightNode = BinaryTreeNode(6)
    root.leftNode?.rightNode?.rightNode = BinaryTreeNode(6)
    root.leftNode?.rightNode?.rightNode?.leftNode = BinaryTreeNode(2)
    return root
}

class BinaryTreeNode<T> {
    
    var data: T
    var leftNode: BinaryTreeNode<T>?
    var rightNode: BinaryTreeNode<T>?
    
    init(_ data: T) {
        self.data = data
    }
}
extension BinaryTreeNode: CustomStringConvertible where T == Int {
    var description: String {
        return "\(self.data)"
    }
}

// Categorize nodes using Depth First Search.
func categorizeWithArrays(node: BinaryTreeNode<Int>, data: inout [Int:[BinaryTreeNode<Int>]], depth: Int = 0) {
    if data[depth] == nil {
        data[depth] = [BinaryTreeNode<Int>]()
    }
    data[depth]?.append(node)
    
    if let leftNode = node.leftNode {
        categorizeWithArrays(node: leftNode, data: &data, depth: depth + 1)
    }
    if let rightNode = node.rightNode {
        categorizeWithArrays(node: rightNode, data: &data, depth: depth + 1)
    }
}

func averagesForArrayData(data: inout [Int:[BinaryTreeNode<Int>]]) -> [Int] {
    var result = [Int]()
    
    for level in data.sorted(by: { $0.key < $1.key }) {
        let sum = level.value.reduce(into: 0) { (result, node) in
            return result += node.data
        }
        result.append(sum / level.value.count)
    }
    return result
}

func categorizeWithTuples(node: BinaryTreeNode<Int>, data: inout [Int:(Int, Int)], depth: Int = 0) {
    if data[depth] == nil {
        data[depth] = (node.data,1)
    } else {
        data[depth]?.0 += node.data
        data[depth]?.1 += 1
    }
    if let leftNode = node.leftNode {
        categorizeWithTuples(node: leftNode, data: &data, depth: depth + 1)
    }
    if let rightNode = node.rightNode {
        categorizeWithTuples(node: rightNode, data: &data, depth: depth + 1)
    }
}

func averagesForTuplesData(data: inout [Int:(Int, Int)]) -> [Int] {
    var result = [Int]()

    for level in data.sorted(by: { $0.key < $1.key }) {
        result.append(level.value.0 / level.value.1)
    }
    
    return result
}

// Using arrays
print("categorizeWithArrays() --> More space complexity: O(n) where n=number of elements in tree")
var binaryTreeWithArraysData = [Int:[BinaryTreeNode<Int>]]() // Depth : [Elements]
categorizeWithArrays(node: fillExampleBinaryTree(), data: &binaryTreeWithArraysData)
print(binaryTreeWithArraysData.sorted(by: { $0.key < $1.key }))
print(averagesForArrayData(data: &binaryTreeWithArraysData))

// Using tuples
print("categorizeWithTuples() --> Lesser space complexity: O(n) where n= number of levels in tree")
var binaryTreeWithTuplesAverages = [Int:(Int, Int)]() // Depth : (Sum, Count))
categorizeWithTuples(node: fillExampleBinaryTree(), data: &binaryTreeWithTuplesAverages)
print(binaryTreeWithTuplesAverages.sorted(by: { $0.key < $1.key }))
print(averagesForTuplesData(data: &binaryTreeWithTuplesAverages))
