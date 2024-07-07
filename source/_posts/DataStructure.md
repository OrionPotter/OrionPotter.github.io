---
title: 数据结构和算法
description: 学习数据结构和算法的一些基本知识
tag:
- 数据结构
---

# 基础概念

## 算法定义

> 算法（algorithm）是解决问题的方法和步骤

五大特性：

- **输入**：具有0个或多个输入
- **输出**：具有1个或多个输出
- **有穷性**：算法执行有限个步骤后终止
- **确切性**：算法的每一步都有确切的定义
- **可行性**：每个计算步骤可以在有效的时间内完成

## 数据结构定义

> 数据结构（data structure）是计算机中组织和存储数据的方式

## 数据结构和算法的关系

> 数据结构是组织数据的方式，算法是处理这些数据的方法，二者共同决定了程序的效率和性能。

## 时间复杂度和空间复杂度

### 算法效率如何评估

> 算法设计出来以后，能够正确的解决问题，在正确解决问题的基础下，我们希望解决问题的算法即快又省内存，因此评估算法的效率我们从两个维度看，一个是时间维度，一个是空间维度。

### 什么是时间复杂度

> 算法中的基本操作的执行次数，为算法的时间复杂度。

### 什么是空间复杂度

> 算法在运行过程中临时额外占用存储空间大小的度量。

# 数据结构

## 数据结构的分类

常见的数据结构包括：数组、链表、栈、队列、哈希表、树、堆、图。

## 逻辑结构：

- **线性数据结构**：数组、链表、栈、队列 元素之间是一对一
- **非线性数据结构**：树、堆、图、哈希表 元素之间是一对多或者是多对多

## 物理结构

- **连续存储**：基于数组实现的
- **非连续存储**：基于链表实现的

## 基本数据类型

> 基本数据类型是CPU直接处理的数据类型，以二进制的方式存储在计算机中。一个二进制位就是1比特，一个字节由8个比特组成。
>
> 基本数据类型主要包括：
>
> - 整型：byte、short、int、long
> - 浮点型：float、double
> - 字符型：char
> - 布尔型：true、false

## 编码知识

> 数字是以补码的形式存在计算机中

**原码**：数字二进制位的最高位为符号位，0为正数，1为负数，其余位表示数字的值。

**反码**：正数的反码和原码是一致的，负数的反码是除符号位其余位取反。

**补码**：正数的补码和原码是一致的，负数的补码是在反码的基础上加1。

> **现在的字符编码一般都用UTF-8**

# 数组

## 什么是数组

> 数组是线性结构，将相同类型的元素存储在连续的内存空间中。

## 数组的操作

- **初始化数组**

```java
// 静态初始化
int[] arr1 = {1, 2, 3, 4, 5};

// 动态初始化
int[] arr2 = new int[5];
arr2[0] = 1;
arr2[1] = 2;
```



- **查询操作**

```java
int element = arr1[2]; // 查询索引为2的元素
```



- **插入操作**

```java
//数组本身不能直接插入元素，只能通过创建新数组实现插入效果。
int[] newArr = new int[arr1.length + 1];
System.arraycopy(arr1, 0, newArr, 0, 2);
newArr[2] = 99;
System.arraycopy(arr1, 2, newArr, 3, arr1.length - 2);
```



- **删除操作**

```java
//数组本身不能直接删除元素，只能通过创建新数组实现删除效果。
int[] newArr = new int[arr1.length - 1];
System.arraycopy(arr1, 0, newArr, 0, 2);
System.arraycopy(arr1, 3, newArr, 2, arr1.length - 3);
```



- **修改操作**

```java
arr1[2] = 99; // 修改索引为2的元素
```



- **遍历操作**

```java
for (int i = 0; i < arr1.length; i++) {
    System.out.println(arr1[i]);
}
```



- **数组扩容**

```java
//数组扩容本质上是创建一个更大的数组并复制原数组的内容。
int[] newArr = new int[arr1.length * 2];
System.arraycopy(arr1, 0, newArr, 0, arr1.length);
```



# 链表

## 什么是链表

> 链表是一种线性数据结构，其中的元素通过指针连接，每个元素称为节点。

- **单链表**：每个节点包含数据和指向下一个节点的指针。

```java
class Node {
    int data;
    Node next;

    Node(int data) {
        this.data = data;
    }
}
```



- **双链表**：每个节点包含数据、指向下一个节点的指针和指向上一个节点的指针。

```java
class DoublyNode {
    int data;
    DoublyNode prev;
    DoublyNode next;

    DoublyNode(int data) {
        this.data = data;
    }
}
```



- **循环链表**：链表的最后一个节点指向第一个节点，形成一个环。

```java
class CircularNode {
    int data;
    CircularNode next;

    CircularNode(int data) {
        this.data = data;
    }
}
```



## 链表的操作

- **初始化链表**

```java
Node head = new Node(1);
head.next = new Node(2);
head.next.next = new Node(3);
```



- **查询操作**

```java
Node current = head;
while (current != null) {
    if (current.data == 2) {
        System.out.println("Found");
        break;
    }
    current = current.next;
}
```



- **插入操作**

```java
Node newNode = new Node(4);
newNode.next = head.next;
head.next = newNode;
```



- **删除操作**

```java
if (head.data == 2) {
    head = head.next;
} else {
    Node current = head;
    while (current.next != null && current.next.data != 2) {
        current = current.next;
    }
    if (current.next != null) {
        current.next = current.next.next;
    }
}
```



- **修改操作**

```java
Node current = head;
while (current != null) {
    if (current.data == 2) {
        current.data = 99;
        break;
    }
    current = current.next;
}
```



- **遍历操作**

```java
Node current = head;
while (current != null) {
    System.out.println(current.data);
    current = current.next;
}
```



# 栈

## 什么是栈

> 栈是一种线性数据结构，遵循后进先出（LIFO）的原则。

## 栈的操作

- **初始化栈**

```java
Stack<Integer> stack = new Stack<>();
```



- **入栈（Push）**

```java
stack.push(1);
stack.push(2);
stack.push(3);
```



- **出栈（Pop）**

```java
int top = stack.pop();
```



- **查看栈顶元素（Peek）**

```java
int top = stack.peek();
```



- **判断栈是否为空**

```java
boolean isEmpty = stack.isEmpty();
```



## 如何实现栈

- **基于数组实现**

```java
class ArrayStack {
    private int[] array;
    private int top;

    public ArrayStack(int size) {
        array = new int[size];
        top = -1;
    }

    public void push(int value) {
        array[++top] = value;
    }

    public int pop() {
        return array[top--];
    }

    public int peek() {
        return array[top];
    }

    public boolean isEmpty() {
        return top == -1;
    }
}
```



- **基于链表实现**

```java
class LinkedListStack {
    private Node head;

    public void push(int value) {
        Node newNode = new Node(value);
        newNode.next = head;
        head = newNode;
    }

    public int pop() {
        int value = head.data;
        head = head.next;
        return value;
    }

    public int peek() {
        return head.data;
    }

    public boolean isEmpty() {
        return head == null;
    }
}
```



# 队列

## 什么是队列

> 队列是一种线性数据结构，遵循先进先出（FIFO）的原则。

## 队列的操作

- **初始化队列**

```java
Queue<Integer> queue = new LinkedList<>();
```



- **入队（Enqueue）**

```java
queue.offer(1);
queue.offer(2);
queue.offer(3);
```



- **出队（Dequeue）**

```java
int front = queue.poll();
```



- **查看队首元素（Peek）**

```java
int front = queue.peek();
```



- **判断队列是否为空**

```java
boolean isEmpty = queue.isEmpty();
```



## 如何实现队列

- **基于数组实现**

```java
class ArrayQueue {
    private int[] array;
    private int front;
    private int rear;
    private int size;

    public ArrayQueue(int capacity) {
        array = new int[capacity];
        front = 0;
        rear = 0;
        size = 0;
    }

    public void enqueue(int value) {
        if (size == array.length) {
            throw new IllegalStateException("Queue is full");
        }
        array[rear] = value;
        rear = (rear + 1) % array.length;
        size++;
    }

    public int dequeue() {
        if (size == 0) {
            throw new IllegalStateException("Queue is empty");
        }
        int value = array[front];
        front = (front + 1) % array.length;
        size--;
        return value;
    }

    public int peek() {
        if (size == 0) {
            throw new IllegalStateException("Queue is empty");
        }
        return array[front];
    }

    public boolean isEmpty() {
        return size == 0;
    }
}
```



- **基于链表实现**

```java
class LinkedListQueue {
    private Node front;
    private Node rear;

    public void enqueue(int value) {
        Node newNode = new Node(value);
        if (rear != null) {
            rear.next = newNode;
        }
        rear = newNode;
        if (front == null) {
            front = newNode;
        }
    }

    public int dequeue() {
        if (front == null) {
            throw new IllegalStateException("Queue is empty");
        }
        int value = front.data;
        front = front.next;
        if (front == null) {
            rear = null;
        }
        return value;
    }

    public int peek() {
        if (front == null) {
            throw new IllegalStateException("Queue is empty");
        }
        return front.data;
    }

    public boolean isEmpty() {
        return front == null;
    }
}
```



## 什么是双向队列

> 双向队列是一种线性数据结构，支持从两端进行插入和删除操作。

## 如何实现双向队列

- **基于数组实现**

```java
public class ArrayDeque {
    private int[] data;
    private int front, rear, size, capacity;

    public ArrayDeque(int capacity) {
        this.capacity = capacity;
        data = new int[capacity];
        front = 0;
        rear = 0;
        size = 0;
    }

    public void addFirst(int value) {
        if (size == capacity) throw new IllegalStateException("Deque is full");
        front = (front - 1 + capacity) % capacity;
        data[front] = value;
        size++;
    }

    public void addLast(int value) {
        if (size == capacity) throw new IllegalStateException("Deque is full");
        data[rear] = value;
        rear = (rear + 1) % capacity;
        size++;
    }

    public int removeFirst() {
        if (size == 0) throw new IllegalStateException("Deque is empty");
        int value = data[front];
        front = (front + 1) % capacity;
        size--;
        return value;
    }

    public int removeLast() {
        if (size == 0) throw new IllegalStateException("Deque is empty");
        rear = (rear - 1 + capacity) % capacity;
        int value = data[rear];
        size--;
        return value;
    }
}

```



- **基于链表实现**

```java
public class LinkedListDeque {
    private class Node {
        int value;
        Node prev, next;

        Node(int value) {
            this.value = value;
        }
    }

    private Node head, tail;
    private int size;

    public LinkedListDeque() {
        head = null;
        tail = null;
        size = 0;
    }

    public void addFirst(int value) {
        Node newNode = new Node(value);
        if (size == 0) {
            head = tail = newNode;
        } else {
            newNode.next = head;
            head.prev = newNode;
            head = newNode;
        }
        size++;
    }

    public void addLast(int value) {
        Node newNode = new Node(value);
        if (size == 0) {
            head = tail = newNode;
        } else {
            newNode.prev = tail;
            tail.next = newNode;
            tail = newNode;
        }
        size++;
    }

    public int removeFirst() {
        if (size == 0) throw new IllegalStateException("Deque is empty");
        int value = head.value;
        head = head.next;
        if (head != null) head.prev = null;
        else tail = null;
        size--;
        return value;
    }

    public int removeLast() {
        if (size == 0) throw new IllegalStateException("Deque is empty");
        int value = tail.value;
        tail = tail.prev;
        if (tail != null) tail.next = null;
        else head = null;
        size--;
        return value;
    }
}

```



# 哈希表

## 什么是哈希表

> 哈希表是一种数据结构，通过哈希函数将键映射到存储位置，以实现快速查找。

## 哈希表的操作

- **插入操作**

```java
public void put(K key, V value) {
    int index = hash(key);
    if (table[index] == null) {
        table[index] = new LinkedList<>();
    }
    for (Entry<K, V> entry : table[index]) {
        if (entry.key.equals(key)) {
            entry.value = value;
            return;
        }
    }
    table[index].add(new Entry<>(key, value));
}

```



- **删除操作**

```java
public void remove(K key) {
    int index = hash(key);
    if (table[index] == null) return;
    Iterator<Entry<K, V>> iterator = table[index].iterator();
    while (iterator.hasNext()) {
        if (iterator.next().key.equals(key)) {
            iterator.remove();
            return;
        }
    }
}
```



- **查找操作**

```java
public V get(K key) {
    int index = hash(key);
    if (table[index] == null) return null;
    for (Entry<K, V> entry : table[index]) {
        if (entry.key.equals(key)) {
            return entry.value;
        }
    }
    return null;
}

```



## 哈希表的实现

- **数组加链表**

在这种实现中，每个数组槽位存储一个链表（LinkedList）。当多个键被哈希到同一个槽位时，它们被插入到这个链表中。

```java
public class HashTableWithChaining<K, V> {
    private static final int INITIAL_CAPACITY = 16;
    private LinkedList<Entry<K, V>>[] table;

    public HashTableWithChaining() {
        table = new LinkedList[INITIAL_CAPACITY];
        for (int i = 0; i < INITIAL_CAPACITY; i++) {
            table[i] = new LinkedList<>();
        }
    }

    public void put(K key, V value) {
        int index = getIndex(key);
        LinkedList<Entry<K, V>> bucket = table[index];
        for (Entry<K, V> entry : bucket) {
            if (entry.key.equals(key)) {
                entry.value = value;
                return;
            }
        }
        bucket.add(new Entry<>(key, value));
    }

    public V get(K key) {
        int index = getIndex(key);
        LinkedList<Entry<K, V>> bucket = table[index];
        for (Entry<K, V> entry : bucket) {
            if (entry.key.equals(key)) {
                return entry.value;
            }
        }
        return null;
    }

    private int getIndex(K key) {
        return key.hashCode() % table.length;
    }

    private static class Entry<K, V> {
        K key;
        V value;

        Entry(K key, V value) {
            this.key = key;
            this.value = value;
        }
    }
}
```



- **数组加红黑树**

每个数组槽位存储一个红黑树（Red-Black Tree）。当链表的长度超过一定阈值时，链表会转换为红黑树，以提高查找效率。这种方式在Java的`HashMap`中被使用。

```java
public class HashTableWithRedBlackTree<K, V> {
    private static final int INITIAL_CAPACITY = 16;
    private static final int TREEIFY_THRESHOLD = 8;
    private Node<K, V>[] table;

    public HashTableWithRedBlackTree() {
        table = new Node[INITIAL_CAPACITY];
    }

    public void put(K key, V value) {
        int index = getIndex(key);
        Node<K, V> node = table[index];
        if (node == null) {
            table[index] = new Node<>(key, value);
        } else if (node instanceof TreeNode) {
            TreeNode<K, V> treeNode = (TreeNode<K, V>) node;
            treeNode.putTreeVal(key, value);
        } else {
            ListNode<K, V> listNode = (ListNode<K, V>) node;
            while (listNode.next != null && !listNode.key.equals(key)) {
                listNode = listNode.next;
            }
            if (listNode.key.equals(key)) {
                listNode.value = value;
            } else {
                listNode.next = new ListNode<>(key, value);
                if (size(table[index]) >= TREEIFY_THRESHOLD) {
                    table[index] = treeify((ListNode<K, V>) table[index]);
                }
            }
        }
    }

    public V get(K key) {
        int index = getIndex(key);
        Node<K, V> node = table[index];
        if (node == null) {
            return null;
        } else if (node instanceof TreeNode) {
            TreeNode<K, V> treeNode = (TreeNode<K, V>) node;
            return treeNode.getTreeVal(key);
        } else {
            ListNode<K, V> listNode = (ListNode<K, V>) node;
            while (listNode != null && !listNode.key.equals(key)) {
                listNode = listNode.next;
            }
            return listNode == null ? null : listNode.value;
        }
    }

    private int getIndex(K key) {
        return key.hashCode() % table.length;
    }

    private int size(Node<K, V> node) {
        int size = 0;
        while (node != null) {
            size++;
            node = node.next;
        }
        return size;
    }

    private TreeNode<K, V> treeify(ListNode<K, V> listNode) {
        TreeNode<K, V> root = null;
        while (listNode != null) {
            root = putTreeNode(root, listNode.key, listNode.value);
            listNode = listNode.next;
        }
        return root;
    }

    private TreeNode<K, V> putTreeNode(TreeNode<K, V> root, K key, V value) {
        if (root == null) {
            return new TreeNode<>(key, value);
        } else if (key.hashCode() < root.key.hashCode()) {
            root.left = putTreeNode(root.left, key, value);
        } else if (key.hashCode() > root.key.hashCode()) {
            root.right = putTreeNode(root.right, key, value);
        } else {
            root.value = value;
        }
        return root;
    }

    private static class Node<K, V> {
        K key;
        V value;
        Node<K, V> next;

        Node(K key, V value) {
            this.key = key;
            this.value = value;
        }
    }

    private static class ListNode<K, V> extends Node<K, V> {
        ListNode<K, V> next;

        ListNode(K key, V value) {
            super(key, value);
        }
    }

    private static class TreeNode<K, V> extends Node<K, V> {
        TreeNode<K, V> left;
        TreeNode<K, V> right;

        TreeNode(K key, V value) {
            super(key, value);
        }

        void putTreeVal(K key, V value) {
            if (key.hashCode() < this.key.hashCode()) {
                if (left == null) {
                    left = new TreeNode<>(key, value);
                } else {
                    left.putTreeVal(key, value);
                }
            } else if (key.hashCode() > this.key.hashCode()) {
                if (right == null) {
                    right = new TreeNode<>(key, value);
                } else {
                    right.putTreeVal(key, value);
                }
            } else {
                this.value = value;
            }
        }

        V getTreeVal(K key) {
            if (key.hashCode() < this.key.hashCode()) {
                return left == null ? null : left.getTreeVal(key);
            } else if (key.hashCode() > this.key.hashCode()) {
                return right == null ? null : right.getTreeVal(key);
            } else {
                return this.value;
            }
        }
    }
}
```



## 哈希冲突

> 当两个不同的键通过哈希函数映射到相同的位置时，称为哈希冲突。

## 哈希算法

- **除留余数法**

```java
public int hash(K key) {
    return key.hashCode() % table.length;
}
```



- **乘法散列法**

```java
public int hash(K key) {
    double A = (Math.sqrt(5) - 1) / 2;
    return (int) (table.length * ((key.hashCode() * A) % 1));
}
```



- **平方取中法**

```java
public int hash(K key) {
    int hash = key.hashCode();
    int mid = (hash * hash) >> 16;
    return mid % table.length;
}
```



# 树

## 什么是二叉树

> 二叉树是一种树形数据结构，每个节点最多有两个子节点，分别称为左子节点和右子节点。

## 二叉树的术语

- **根节点**：树的顶端节点。
- **叶子节点**：没有子节点的节点。
- **内部节点**：有子节点的节点。
- **子树**：一个节点及其所有后代节点组成的树。
- **深度**：从根节点到某个节点的最长路径上的节点数。
- **高度**：从某个节点到叶子节点的最长路径上的节点数。

## 二叉树的基本操作

+ **初始化**

```java
public class TreeNode {
    int val;
    TreeNode leftNode;
    TreeNode rightNode;
    TreeNode(int value){ val = value; }
}
```



- **插入操作**

```java
public void insert(int value) {
    root = insertRec(root, value);
}

private Node insertRec(Node root, int value) {
    if (root == null) {
        root = new Node(value);
        return root;
    }
    if (value < root.value) {
        root.left = insertRec(root.left, value);
    } else if (value > root.value) {
        root.right = insertRec(root.right, value);
    }
    return root;
}

```



- **删除操作**

```java
public void delete(int value) {
    root = deleteRec(root, value);
}

private Node deleteRec(Node root, int value) {
    if (root == null) return root;
    if (value < root.value) {
        root.left = deleteRec(root.left, value);
    } else if (value > root.value) {
        root.right = deleteRec(root.right, value);
    } else {
        if (root.left == null) return root.right;
        else if (root.right == null) return root.left;
        root.value = minValue(root.right);
        root.right = deleteRec(root.right, root.value);
    }
    return root;
}

private int minValue(Node root) {
    int min = root.value;
    while (root.left != null) {
        root = root.left;
        min = root.value;
    }
    return min;
}

```



- **查找操作**

```java
public Node search(int value) {
    return searchRec(root, value);
}

private Node searchRec(Node root, int value) {
    if (root == null || root.value == value) return root;
    if (root.value > value) return searchRec(root.left, value);
    return searchRec(root.right, value);
}

```



- **遍历操作**

```java
//前序
public void preOrder(Node root) {
    if (root != null) {
        System.out.print(root.value + " ");
        preOrder(root.left);
        preOrder(root.right);
    }
}
//中序
public void inOrder(Node root) {
    if (root != null) {
        inOrder(root.left);
        System.out.print(root.value + " ");
        inOrder(root.right);
    }
}
//后序
public void postOrder(Node root) {
    if (root != null) {
        postOrder(root.left);
        postOrder(root.right);
        System.out.print(root.value + " ");
    }
}
//层序
public void levelOrder(Node root) {
    if (root == null) return;
    Queue<Node> queue = new LinkedList<>();
    queue.add(root);
    while (!queue.isEmpty())

```



## 二叉树的类型

- **完全二叉树**：除了最后一层，其他层的节点都被填满，最后一层的节点从左到右依次填充。
- **满二叉树**：每一层的节点数都达到最大值。
- **平衡二叉树**：每个节点的左右子树的高度差不超过1。
- **二叉搜索树（BST）**：左子树的所有节点值小于根节点值，右子树的所有节点值大于根节点值。

## 二叉树的遍历

- **前序遍历**：根节点 -> 左子树 -> 右子树
- **中序遍历**：左子树 -> 根节点 -> 右子树
- **后序遍历**：左子树 -> 右子树 -> 根节点
- **层序遍历**：按层次从上到下，从左到右遍历节点

## 如何用数组表示二叉树

> 可以使用数组来表示二叉树，数组的索引从1开始，根节点存储在索引1的位置，左子节点存储在索引2的位置，右子节点存储在索引3的位置，以此类推。

```java
// 对应关系示例：
array[1] = root.value;
array[2] = root.left.value;
array[3] = root.right.value;
array[4] = root.left.left.value;
// ...
```



## 什么是二叉搜索树

> 二叉搜索树（BST）是一种特殊的二叉树，左子树的所有节点值小于根节点值，右子树的所有节点值大于根节点值。

## 什么是AVL树

> AVL树是一种自平衡二叉搜索树，每个节点的左右子树的高度差不超过1。

# 堆

## 什么是堆

> 堆是一种特殊的树形数据结构，满足堆性质：对于最大堆，任意节点的值大于等于其子节点的值；对于最小堆，任意节点的值小于等于其子节点的值。

## 堆的操作

- **插入操作**

```java
public void insert(int value) {
    heap[++size] = value;
    swim(size);
}

private void swim(int k) {
    while (k > 1 && heap[k / 2] < heap[k]) {
        swap(k, k / 2);
        k = k / 2;
    }
}

```



- **删除操作**

```java
public int deleteMax() {
    int max = heap[1];
    swap(1, size--);
    sink(1);
    heap[size + 1] = 0;
    return max;
}

private void sink(int k) {
    while (2 * k <= size) {
        int j = 2 * k;
        if (j < size && heap[j] < heap[j + 1]) j++;
        if (heap[k] >= heap[j]) break;
        swap(k, j);
        k = j;
    }
}

```



- **查找操作**

```java
public int findMax() {
    return heap[1];
}
```



## 如何建堆

- **插入建堆**
- **删除建堆**

# 图

## 什么是图

> 图是一种非线性数据结构，由顶点和边组成，用于表示对象及其关系。

## 图的操作

- **插入操作**

```java
public void addEdge(int u, int v) {
    adjacencyList[u].add(v);
    adjacencyList[v].add(u);
}
```



- **删除操作**

```java
public void removeEdge(int u, int v) {
    adjacencyList[u].remove((Integer) v);
    adjacencyList[v].remove((Integer) u);
}
```



- **查找操作**

```java
public boolean hasEdge(int u, int v) {
    return adjacencyList[u].contains(v);
}
```



## 图的遍历

- **深度优先搜索（DFS）**

```java
public void DFS(int v) {
    boolean[] visited = new boolean[V];
    DFSUtil(v, visited);
}

private void DFSUtil(int v, boolean[] visited) {
    visited[v] = true;
    System.out.print(v + " ");
    for (int n : adjacencyList[v]) {
        if (!visited[n]) DFSUtil(n, visited);
    }
}
```



- **广度优先搜索（BFS）**

```java
public void BFS(int v) {
    boolean[] visited = new boolean[V];
    Queue<Integer> queue = new LinkedList<>();
    visited[v] = true;
    queue.add(v);
    while (!queue.isEmpty()) {
        v = queue.poll();
        System.out.print(v + " ");
        for (int n : adjacencyList[v]) {
            if (!visited[n]) {
                visited[n] = true;
                queue.add(n);
            }
        }
    }
}
```



# 搜索算法

## 深度优先搜索（DFS）

> 深度优先搜索是一种遍历或搜索树或图的算法，从根节点开始，沿着每个分支尽可能深地搜索。

- **应用**：迷宫求解、图的连通性检测等。

## 广度优先搜索（BFS）

> 广度优先搜索是一种遍历或搜索树或图的算法，从根节点开始，逐层向外搜索。

- **应用**：最短路径求解、图的连通性检测等。

# 排序算法

## 选择排序

> 选择排序是一种简单的排序算法，每次从未排序部分选择最小（或最大）的元素，放到已排序部分的末尾。

- **时间复杂度**：O(n^2)
- **空间复杂度**：O(1)
- **稳定性**：不稳定

```java
public class SelectionSort {
    public void sort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < n; j++) {
                if (arr[j] < arr[minIdx]) {
                    minIdx = j;
                }
            }
            int temp = arr[minIdx];
            arr[minIdx] = arr[i];
            arr[i] = temp;
        }
    }
}
```



## 冒泡排序

> 冒泡排序是一种简单的排序算法，通过多次遍历数组，每次比较相邻元素并交换，使得较大的元素逐渐“冒泡”到数组末尾。

- **时间复杂度**：O(n^2)
- **空间复杂度**：O(1)
- **稳定性**：稳定

```java
public class BubbleSort {
    public void sort(int[] arr) {
        int n = arr.length;
        boolean swapped;
        for (int i = 0; i < n - 1; i++) {
            swapped = false;
            for (int j = 0; j < n - 1 - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                    swapped = true;
                }
            }
            if (!swapped) break;
        }
    }
}
```



## 插入排序

> 插入排序是一种简单的排序算法，通过构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。

- **时间复杂度**：O(n^2)
- **空间复杂度**：O(1)
- **稳定性**：稳定

```java
public class InsertionSort {
    public void sort(int[] arr) {
        int n = arr.length;
        for (int i = 1; i < n; i++) {
            int key = arr[i];
            int j = i - 1;
            while (j >= 0 && arr[j] > key) {
                arr[j + 1] = arr[j];
                j = j - 1;
            }
            arr[j + 1] = key;
        }
    }
}
```



## 快速排序

> 快速排序是一种高效的排序算法，通过分治法将数组分为两个子数组，分别排序，然后合并。

- **时间复杂度**：平均O(n log n)，最坏O(n^2)
- **空间复杂度**：O(log n)
- **稳定性**：不稳定

```java
public class QuickSort {
    public void sort(int[] arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            sort(arr, low, pi - 1);
            sort(arr, pi + 1, high);
        }
    }

    private int partition(int[] arr, int low, int high) {
        int pivot = arr[high];
        int i = (low - 1);
        for (int j = low; j < high; j++) {
            if (arr[j] < pivot) {
                i++;
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        int temp = arr[i + 1];
        arr[i + 1] = arr[high];
        arr[high] = temp;
        return i + 1;
    }
}
```



## 归并排序

> 归并排序是一种稳定的排序算法，通过分治法将数组分为两个子数组，分别排序，然后合并。

- **时间复杂度**：O(n log n)
- **空间复杂度**：O(n)
- **稳定性**：稳定

```java
public class MergeSort {
    public void sort(int[] arr, int l, int r) {
        if (l < r) {
            int m = (l + r) / 2;
            sort(arr, l, m);
            sort(arr, m + 1, r);
            merge(arr, l, m, r);
        }
    }

    private void merge(int[] arr, int l, int m, int r) {
        int n1 = m - l + 1;
        int n2 = r - m;

        int[] L = new int[n1];
        int[] R = new int[n2];

        System.arraycopy(arr, l, L, 0, n1);
        System.arraycopy(arr, m + 1, R, 0, n2);

        int i = 0, j = 0;
        int k = l;
        while (i < n1 && j < n2) {
            if (L[i] <= R[j]) {
                arr[k] = L[i];
                i++;
            } else {
                arr[k] = R[j];
                j++;
            }
            k++;
        }

        while (i < n1) {
            arr[k] = L[i];
            i++;
            k++;
        }

        while (j < n2) {
            arr[k] = R[j];
            j++;
            k++;
        }
    }
}
```



## 堆排序

> 堆排序是一种基于堆的数据结构的排序算法，利用堆的性质进行排序。

- **时间复杂度**：O(n log n)
- **空间复杂度**：O(1)
- **稳定性**：不稳定

```java
public class HeapSort {
    public void sort(int[] arr) {
        int n = arr.length;

        for (int i = n / 2 - 1; i >= 0; i--)
            heapify(arr, n, i);

        for (int i = n - 1; i > 0; i--) {
            int temp = arr[0];
            arr[0] = arr[i];
            arr[i] = temp;

            heapify(arr, i, 0);
        }
    }

    private void heapify(int[] arr, int n, int i) {
        int largest = i;
        int left = 2 * i + 1;
        int right = 2 * i + 2;

        if (left < n && arr[left] > arr[largest])
            largest = left;

        if (right < n && arr[right] > arr[largest])
            largest = right;

        if (largest != i) {
            int swap = arr[i];
            arr[i] = arr[largest];
            arr[largest] = swap;

            heapify(arr, n, largest);
        }
    }
}
```



## 桶排序

> 桶排序是一种线性时间复杂度的排序算法，通过将元素分配到不同的桶中，分别排序，然后合并。

- **时间复杂度**：O(n + k)
- **空间复杂度**：O(n + k)
- **稳定性**：稳定

```java
import java.util.*;

public class BucketSort {
    public void sort(float[] arr, int n) {
        if (n <= 0)
            return;

        @SuppressWarnings("unchecked")
        List<Float>[] buckets = new ArrayList[n];

        for (int i = 0; i < n; i++) {
            buckets[i] = new ArrayList<>();
        }

        for (int i = 0; i < n; i++) {
            int bucketIndex = (int) arr[i] * n;
            buckets[bucketIndex].add(arr[i]);
        }

        for (int i = 0; i < n; i++) {
            Collections.sort(buckets[i]);
        }

        int index = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0, size = buckets[i].size(); j < size; j++) {
                arr[index++] = buckets[i].get(j);
            }
        }
    }
}
```

## 计数排序

> 计数排序是一种线性时间复杂度的排序算法，通过计数每个元素出现的次数，计算每个元素在排序后的位置。

- **时间复杂度**：O(n + k)
- **空间复杂度**：O(n + k)
- **稳定性**：稳定

```java
public class CountingSort {
    public void sort(int[] arr) {
        int n = arr.length;
        if (n == 0)
            return;

        int max = arr[0], min = arr[0];
        for (int i = 1; i < n; i++) {
            if (arr[i] > max) max = arr[i];
            if (arr[i] < min) min = arr[i];
        }

        int range = max - min + 1;
        int[] count = new int[range];
        int[] output = new int[n];

        for (int i = 0; i < n; i++)
            count[arr[i] - min]++;

        for (int i = 1; i < count.length; i++)
            count[i] += count[i - 1];

        for (int i = n - 1; i >= 0; i--) {
            output[count[arr[i] - min] - 1] = arr[i];
            count[arr[i] - min]--;
        }

        for (int i = 0; i < n; i++)
            arr[i] = output[i];
    }
}
```

## 基数排序

> 基数排序是一种线性时间复杂度的排序算法，通过逐位比较元素的各位数字进行排序。

- **时间复杂度**：O(nk)
- **空间复杂度**：O(n + k)
- **稳定性**：稳定

```java
public class RadixSort {
    public void sort(int[] arr) {
        int max = getMax(arr);

        for (int exp = 1; max / exp > 0; exp *= 10) {
            countSort(arr, exp);
        }
    }

    private int getMax(int[] arr) {
        int max = arr[0];
        for (int i = 1; i < arr.length; i++) {
            if (arr[i] > max)
                max = arr[i];
        }
        return max;
    }

    private void countSort(int[] arr, int exp) {
        int n = arr.length;
        int[] output = new int[n];
        int[] count = new int[10];

        for (int i = 0; i < n; i++) {
            count[(arr[i] / exp) % 10]++;
        }

        for (int i = 1; i < 10; i++) {
            count[i] += count[i - 1];
        }

        for (int i = n - 1; i >= 0; i--) {
            output[count[(arr[i] / exp) % 10] - 1] = arr[i];
            count[(arr[i] / exp) % 10]--;
        }

        System.arraycopy(output, 0, arr, 0, n);
    }
}
```



# 算法思想

## 分治算法

> 分治算法是一种将问题分解成更小的子问题，分别解决，然后合并结果的算法。

- **应用**：快速排序、归并排序、二分查找等。

```java
//二分查找
public class BinarySearch {
    public int binarySearch(int[] arr, int x) {
        int l = 0, r = arr.length - 1;
        while (l <= r) {
            int m = l + (r - l) / 2;
            if (arr[m] == x)
                return m;
            if (arr[m] < x)
                l = m + 1;
            else
                r = m - 1;
        }
        return -1;
    }
}
```



## 回溯算法

> 回溯算法是一种逐步构建解决方案，并在发现当前路径不通时回溯到上一步的算法。

- **应用**：八皇后问题、迷宫求解、数独等。

```java
//八皇后问题
public class NQueens {
    public List<List<String>> solveNQueens(int n) {
        List<List<String>> solutions = new ArrayList<>();
        char[][] board = new char[n][n];
        for (char[] row : board) Arrays.fill(row, '.');
        backtrack(solutions, board, 0);
        return solutions;
    }

    private void backtrack(List<List<String>> solutions, char[][] board, int row) {
        if (row == board.length) {
            solutions.add(construct(board));
            return;
        }
        for (int col = 0; col < board.length; col++) {
            if (isValid(board, row, col)) {
                board[row][col] = 'Q';
                backtrack(solutions, board, row + 1);
                board[row][col] = '.';
            }
        }
    }

    private boolean isValid(char[][] board, int row, int col) {
        for (int i = 0; i < row; i++) {
            if (board[i][col] == 'Q') return false;
        }
        for (int i = row - 1, j = col - 1; i >= 0 && j >= 0; i--, j--) {
            if (board[i][j] == 'Q') return false;
        }
        for (int i = row - 1, j = col + 1; i >= 0 && j < board.length; i--, j++) {
            if (board[i][j] == 'Q') return false;
        }
        return true;
    }

    private List<String> construct(char[][] board) {
        List<String> path = new ArrayList<>();
        for (char[] row : board) {
            path.add(new String(row));
        }
        return path;
    }
}
```



## 动态规划

> 动态规划是一种将问题分解成更小的子问题，通过保存子问题的解来避免重复计算的算法。

- **应用**：斐波那契数列、最短路径问题、背包问题等。

```java
//斐波那契数列
public class Fibonacci {
    public int fib(int n) {
        if (n <= 1) return n;
        int[] dp = new int[n + 1];
        dp[0] = 0;
        dp[1] = 1;
        for (int i = 2; i < n + 1; i++) {
            dp[i] = dp[i - 1] + dp[i - 2];
        }
        return dp[n];
    }
}
```



## 贪心算法

> 贪心算法是一种在每一步选择中都采取当前最优选择的算法，期望通过局部最优解得到全局最优解。

- **应用**：最小生成树、最短路径问题、活动选择问题等。

```java
//活动选择问题
public class ActivitySelection {
    public List<Integer> selectActivities(int[] start, int[] end) {
        int n = start.length;
        List<Integer> result = new ArrayList<>();
        int i = 0;
        result.add(i);
        for (int j = 1; j < n; j++) {
            if (start[j] >= end[i]) {
                result.add(j);
                i = j;
            }
        }
        return result;
    }
}
```



# 数据结构和算法的应用

## 数组的应用

- **动态数组**：自动扩容的数组，如Java中的ArrayList。
- **二维数组**：用于表示矩阵、图像等二维数据。

## 链表的应用

- **单链表**：用于实现栈、队列等数据结构。
- **双链表**：用于实现双向队列、LRU缓存等。

## 栈的应用

- **函数调用栈**：用于保存函数调用信息。
- **表达式求值**：用于中缀表达式转后缀表达式、计算后缀表达式等。

## 队列的应用

- **任务调度**：用于任务的先来先服务调度。
- **消息队列**：用于异步消息传递。

## 哈希表的应用

- **缓存**：用于快速查找缓存数据。
- **集合操作**：用于实现集合、字典等数据结构。

## 树的应用

- **文件系统**：用于表示文件目录结构。
- **搜索树**：用于实现高效的查找、插入、删除操作。

## 堆的应用

- **优先队列**：用于实现优先级调度。
- **排序算法**：用于堆排序。

## 图的应用

- **社交网络**：用于表示用户关系。
- **路径规划**：用于计算最短路径、最小生成树等。

