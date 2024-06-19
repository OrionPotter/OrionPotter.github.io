---
title: zookeeper实践
tag:
- zookeeper
---

# 基础知识

## 基本概念

### Zookeeper简介

>Zookeeper是一个开源的分布式协调服务，主要用于分布式应用中的数据管理。它提供了高性能、可用性和严格的顺序访问控制。Zookeeper通过一个简单的树形数据结构来存储数据，每个节点称为znode。

### 架构

Zookeeper采用主从架构，由一个Leader和多个Follower组成。Leader负责处理写请求和协调数据的同步，而Follower则处理读请求并将写请求转发给Leader。Zookeeper通过Zab协议（Zookeeper Atomic Broadcast）来实现数据的一致性。

### 应用场景

1. **配置管理**：在分布式系统中，配置文件的管理和同步非常重要。Zookeeper可以存储配置信息，并在配置变化时通知各个节点。
2. **命名服务**：Zookeeper可以用作分布式系统中的命名服务，提供唯一的命名空间。
3. **分布式锁**：Zookeeper可以实现分布式锁，确保在分布式环境中只有一个节点在某一时刻可以访问共享资源。
4. **集群管理**：Zookeeper可以监控分布式系统中节点的状态，帮助实现节点的动态增减和故障恢复。

## 分布式系统基础

### 一致性（Consistency）

一致性指的是在分布式系统中，所有节点在同一时间看到的数据是一致的。换句话说，当一个节点完成写操作后，所有节点都能立即看到更新的数据。

**实现原理**：

- **强一致性**：每次写操作都必须等待所有副本节点确认写入成功后，才会返回成功响应。通过分布式事务或两阶段提交协议（2PC）来实现。
- **最终一致性**：系统允许暂时的不一致，但保证在一定时间内所有节点的数据最终会达到一致。通过异步复制和背景同步来实现。

### 可用性(Availability)

可用性指的是系统在任何时候都能响应用户的请求，即使某些节点出现故障，系统仍然能够提供服务。

**实现原理**：

- **冗余**：通过在多个节点上复制数据，确保即使某些节点出现故障，其他节点仍然可以提供服务。
- **故障转移**：当检测到某个节点故障时，系统能够自动负载均衡将请求转发到其他正常节点。

### 分区容错性

分区容错性指的是系统能够在网络分区的情况下继续运行。网络分区是指系统的不同部分无法相互通信。

**实现原理**：

- **数据复制**：通过在多个数据中心复制数据，确保即使某个数据中心与其他数据中心失去通信，系统仍然能够继续提供服务。
- **一致性协议**：使用一致性协议（如Paxos或Raft）在网络分区恢复后，确保数据的一致性。
- **故障检测**：系统能够检测到网络分区，并采取相应的措施，如将请求转发到其他正常节点。

### CAP定理

CAP定理指出，在分布式系统中，不可能同时满足一致性（Consistency）、可用性（Availability）和分区容错性（Partition Tolerance）这三个特性。只能在其中选择两个。

- **一致性（Consistency）**：所有节点在同一时间看到的数据是一致的。
- **可用性（Availability）**：系统在任何时候都能响应用户的请求。
- **分区容错性（Partition Tolerance）**：系统能够在网络分区的情况下继续运行。

**CAP定理的选择**：

- **CA（一致性 + 可用性）**：系统在网络分区时无法继续运行。例如，关系型数据库通常在网络分区时会停止服务，以确保数据一致性。
- **CP（一致性 + 分区容错性）**：系统在网络分区时仍然保持数据一致性，但可能无法响应所有请求。例如，分布式数据库如HBase在网络分区时会优先保证数据一致性，但可能会拒绝部分请求。
- **AP（可用性 + 分区容错性）**：系统在网络分区时仍然能够响应请求，但可能会出现数据不一致。例如，NoSQL数据库如Cassandra在网络分区时会优先保证可用性，但可能会出现暂时的数据不一致。



# Zookeeper核心概念

## 节点（ZNode）

Zookeeper的数据节点称为ZNode，每个ZNode都可以存储数据和子节点。ZNode分为两种类型：

1. **持久节点（Persistent ZNode）**：
   - **定义**：持久节点在创建后会一直存在，直到显式删除。
   - **用途**：通常用于存储配置信息或元数据。
2. **临时节点（Ephemeral ZNode）**：
   - **定义**：临时节点与客户端会话绑定，当客户端会话结束或超时时，临时节点会自动删除。
   - **用途**：通常用于实现分布式锁或临时状态信息。

## 数据模型

Zookeeper的数据模型是一个层次化的树结构，类似于文件系统。每个节点（ZNode）都可以存储数据和子节点。

- **根节点**：树的顶层节点，表示为“/”。
- **子节点**：每个节点可以有多个子节点，形成树状结构。

## 会话（Session）

会话是客户端与Zookeeper服务器之间的连接。每个会话都有一个唯一的会话ID和会话超时机制。

- **会话ID**：唯一标识客户端会话。
- **会话超时**：如果客户端在指定时间内没有与服务器通信，会话将超时，服务器会清理与该会话相关的临时节点。

## 版本（Version)

每个ZNode都有一个数据版本号（version），用于实现乐观锁和数据一致性。

- **数据版本号**：每次对节点数据进行更新时，版本号会递增。
- **乐观锁**：在更新节点数据时，客户端可以指定预期的版本号，如果版本号匹配，则更新成功；否则更新失败。

# Zookeeper架构

## Zookeeper集群概述

Zookeeper通常以集群模式运行，以确保高可用性和数据一致性。集群中的每个节点称为服务器（Server）。一个典型的Zookeeper集群由3到5个服务器组成，以便在某些服务器出现故障时仍能继续提供服务。

## Leader和Follower

Zookeeper集群采用主从架构，其中包括一个Leader和多个Follower。

- **Leader**：
  - 负责处理所有的写请求。
  - 负责协调事务并确保数据的一致性。
  - 通过ZAB协议（Zookeeper Atomic Broadcast）与Follower进行通信。
- **Follower**：
  - 负责处理读请求。
  - 将写请求转发给Leader。
  - 参与选举过程，当Leader失效时，Follower可以成为新的Leader。

## ZAB协议

ZAB（Zookeeper Atomic Broadcast）协议是Zookeeper用来保证集群中的数据一致性和高可用性的核心协议。ZAB协议主要包括以下两个阶段：

1. **领导选举（Leader Election）**：
   - 当Zookeeper集群启动或当前Leader失效时，集群会进行领导选举。
   - 所有服务器会投票选举一个新的Leader。
   - 新的Leader被选举后，会通知所有Follower，并进入同步阶段。
2. **同步阶段（Synchronization Phase）**：
   - Leader与Follower同步数据，确保所有节点的数据一致。
   - 同步完成后，集群进入广播阶段。
3. **广播阶段（Broadcast Phase）**：
   - Leader接收客户端的写请求，并将请求转发给所有Follower。
   - Follower接收到请求后，会进行投票并返回确认。
   - 当Leader收到大多数Follower的确认后，会提交事务并通知所有Follower。

# Zookeeper操作

## 安装Zookeeper

1. **下载Zookeeper**：
   - 从Apache Zookeeper官方网站下载最新的Zookeeper版本。
   - 解压下载的文件到指定目录。
2. **配置Zookeeper**：
   - 进入解压后的Zookeeper目录，找到`conf`文件夹。
   - 复制`zoo_sample.cfg`并重命名为`zoo.cfg`。
3. **编辑zoo.cfg**：
   - 打开`zoo.cfg`文件，进行基本配置。
   - 主要配置项包括：

```properties
# 数据存储目录
dataDir=/path/to/zookeeper/data

# 客户端连接端口
clientPort=2181

# 集群中的服务器列表（如果是集群模式）
server.1=server1:2888:3888
server.2=server2:2888:3888
server.3=server3:2888:3888
```

4. **启动Zookeeper**：

- 进入Zookeeper的`bin`目录，运行命令：

```bash
./zkServer.sh start
```

### 基本配置项的含义和调优

1. **dataDir**：存储Zookeeper数据的目录。建议设置为高性能磁盘路径。
2. **clientPort**：客户端连接Zookeeper的端口，默认为2181。
3. **tickTime**：Zookeeper的基本时间单位（以毫秒为单位），用于心跳和会话超时计算。默认值为2000（2秒）。
4. **initLimit**：Follower与Leader同步的初始化时间限制（tickTime的倍数）。默认值为10。
5. **syncLimit**：Follower与Leader之间的同步时间限制（tickTime的倍数）。默认值为5。
6. **maxClientCnxns**：每个客户端的最大连接数。默认值为60。

## 基本操作

### 创建节点

```java
public class ZookeeperExample {
    public static void main(String[] args) throws Exception {
        ZooKeeper zk = new ZooKeeper("localhost:2181", 3000, null);
        String path = "/example";
        byte[] data = "Hello Zookeeper".getBytes();
        // 创建持久节点
        zk.create(path, data, Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
        zk.close();
    }
}
```

### 删除节点

```java
zk.delete("/example", -1); // -1表示忽略版本号
```

### 读取节点数据

```java
byte[] data = zk.getData("/example", false, null);
String result = new String(data);
System.out.println(result);
```

### 设置节点数据

```java
byte[] newData = "Updated Data".getBytes();
zk.setData("/example", newData, -1); // -1表示忽略版本号
```

## 监视器（Watcher）

Zookeeper的监视机制允许客户端监听节点的变化。一旦节点发生变化，客户端会收到通知。

### Watcher示例

```java
public class MyWatcher implements Watcher {
    @Override
    public void process(WatchedEvent event) {
        System.out.println("Event received: " + event);
    }
}
```

### 使用Watcher

```java
public class ZookeeperExample {
    public static void main(String[] args) throws Exception {
        ZooKeeper zk = new ZooKeeper("localhost:2181", 3000, new MyWatcher());
        String path = "/example";
        // 设置监视器
        zk.getData(path, true, null);
        // 模拟数据变化
        byte[] newData = "Updated Data".getBytes();
        zk.setData(path, newData, -1);
        zk.close();
    }
}
```



# Zookeeper高级特性

## ACL（Access Control List）

### 概述

Zookeeper的ACL（Access Control List）是用于控制对节点的访问权限的机制。ACL定义了哪些用户或实体可以对节点执行哪些操作。每个ZNode都可以有一个或多个ACL条目，每个条目定义了一个权限集和一个授权实体。

### 权限类型

Zookeeper支持以下几种权限类型：

- **CREATE**：创建子节点的权限。
- **READ**：读取节点数据和子节点列表的权限。
- **WRITE**：设置节点数据的权限。
- **DELETE**：删除子节点的权限。
- **ADMIN**：设置ACL的权限。

### 授权模式

Zookeeper支持以下几种授权模式：

- **world**：全世界都可以访问，只有一个用户`anyone`。
- **auth**：所有已认证的用户。
- **digest**：使用用户名和密码进行认证。
- **ip**：基于IP地址的认证。
- **super**：超级用户，具有所有权限。

### 示例代码

```java
public class ZookeeperACLExample {
    public static void main(String[] args) throws Exception {
        ZooKeeper zk = new ZooKeeper("localhost:2181", 3000, null);
        String path = "/example_acl";
        byte[] data = "Hello Zookeeper with ACL".getBytes();

        // 创建带有ACL的节点
        List<ACL> acls = new ArrayList<>();
        Id userId = new Id("digest", "user:password");
        acls.add(new ACL(ZooDefs.Perms.ALL, userId));

        zk.create(path, data, acls, CreateMode.PERSISTENT);

        zk.close();
    }
}
```

## 四字命令

### 概述

Zookeeper提供了一组四字命令，用于管理和监控Zookeeper服务器。这些命令可以通过telnet或nc工具发送到Zookeeper服务器的端口。

### 常用四字命令

- **stat**：打印服务器状态信息，包括客户端连接数、节点数等。
- **srvr**：打印服务器详细信息，包括版本、模式、节点数等。
- **mntr**：打印服务器监控信息，包括请求数、延迟等。
- **ruok**：检查服务器是否运行正常，返回`imok`表示正常。
- **conf**：打印服务器的配置信息。
- **envi**：打印服务器的环境变量信息。
- **cons**：打印客户端连接信息。
- **dump**：打印会话和临时节点信息。

### 使用示例

```bash
echo "stat" | nc localhost 2181
```

## 事务操作（Multi）

### 概述

Zookeeper的事务操作（Multi）允许客户端在一个事务中执行多个操作。Multi操作是原子的，要么全部成功，要么全部失败。

### 支持的操作

- **create**：创建节点。
- **delete**：删除节点。
- **setData**：设置节点数据。
- **check**：检查节点是否存在。

### 示例代码

```java
public class ZookeeperMultiExample {
    public static void main(String[] args) throws Exception {
        ZooKeeper zk = new ZooKeeper("localhost:2181", 3000, null);
        
        // 创建事务操作
        List<Op> ops = List.of(
            Op.create("/multi_node1", "data1".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT),
            Op.create("/multi_node2", "data2".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT),
            Op.setData("/multi_node1", "new_data1".getBytes(), -1)
        );

        try {
            List<OpResult> results = zk.multi(ops);
            for (OpResult result : results) {
                System.out.println("Operation result: " + result.getType());
            }
        } catch (KeeperException | InterruptedException e) {
            e.printStackTrace();
        } finally {
            zk.close();
        }
    }
}
```

# 实践与应用

## 实际项目中的应用

### 分布式锁

Zookeeper可以用于实现分布式锁，确保在分布式环境中只有一个节点在某一时刻可以访问共享资源。

**实现原理**：

- 使用Zookeeper的临时节点（Ephemeral ZNode）来实现锁。
- 当一个节点需要获取锁时，它尝试创建一个临时节点。如果创建成功，则表示获取锁成功；否则，表示锁已被其他节点占用。
- 当节点完成任务后，删除临时节点，释放锁。
- 如果节点崩溃或会话超时，临时节点会自动删除，锁自动释放。

**示例代码**：

```java
public class DistributedLock {
    private ZooKeeper zk;
    private String lockPath;

    public DistributedLock(ZooKeeper zk, String lockPath) {
        this.zk = zk;
        this.lockPath = lockPath;
    }

    public boolean acquireLock() throws KeeperException, InterruptedException {
        try {
            zk.create(lockPath, new byte[0], ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.EPHEMERAL);
            return true;
        } catch (KeeperException.NodeExistsException e) {
            return false;
        }
    }

    public void releaseLock() throws KeeperException, InterruptedException {
        zk.delete(lockPath, -1);
    }
}
```

### 配置管理

Zookeeper可以用于分布式系统的配置管理，确保所有节点使用一致的配置。

**实现原理**：

- 将配置信息存储在Zookeeper的持久节点（Persistent ZNode）中。
- 各个节点启动时，从Zookeeper读取配置信息。
- 当配置发生变化时，使用Watcher机制通知所有节点更新配置。

**示例代码**：

```java
public class ConfigManager {
    private ZooKeeper zk;
    private String configPath;

    public ConfigManager(ZooKeeper zk, String configPath) {
        this.zk = zk;
        this.configPath = configPath;
    }

    public String getConfig() throws Exception {
        byte[] data = zk.getData(configPath, new Watcher() {
            @Override
            public void process(WatchedEvent event) {
                if (event.getType() == Event.EventType.NodeDataChanged) {
                    // 配置发生变化，重新加载配置
                    try {
                        getConfig();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }, null);
        return new String(data);
    }
}
```

### 服务发现

Zookeeper可以用于服务发现，确保客户端能够找到可用的服务实例。

**实现原理**：

- 服务提供者在Zookeeper中注册服务，创建临时节点（Ephemeral ZNode）。
- 服务消费者从Zookeeper中获取服务列表，并使用Watcher机制监听服务变化。
- 当服务提供者下线或崩溃时，临时节点会自动删除，通知消费者更新服务列表。

**示例代码**：

```java
public class ServiceRegistry {
    private ZooKeeper zk;
    private String registryPath;

    public ServiceRegistry(ZooKeeper zk, String registryPath) {
        this.zk = zk;
        this.registryPath = registryPath;
    }

    public void registerService(String serviceName, String serviceAddress) throws Exception {
        String servicePath = registryPath + "/" + serviceName;
        zk.create(servicePath, serviceAddress.getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.EPHEMERAL);
    }
}
```

## 性能调优

### 内存配置

1. JVM内存设置：增加JVM堆内存大小，确保Zookeeper有足够的内存处理请求。 
2. 缓存设置：调整Zookeeper的缓存大小，确保缓存能够容纳足够的数据。

```properties
export JVMFLAGS="-Xms2g -Xmx2g"     
zookeeper.preAllocSize=65536
```

### 磁盘配置

1. 数据目录：将Zookeeper的数据目录和事务日志目录配置在不同的磁盘上，减少I/O冲突。

```properties
dataDir=/path/to/data
dataLogDir=/path/to/log
```

2. 磁盘性能：使用高性能的SSD磁盘，提高读写性能。

### 网络配置

1. **网络带宽**：确保Zookeeper服务器之间有足够的网络带宽，减少网络延迟。
2. **网络分区**：使用可靠的网络设备和配置，减少网络分区的可能性。

## 故障处理

### 节点故障

1. 自动重启：配置Zookeeper服务器在故障时自动重启，减少服务中断时间。

```bash
zkServer.sh start
```

2. 监控和报警：使用监控工具监控Zookeeper服务器的状态，及时发现故障并报警。

### 网络分区

1. **领导选举**：当网络分区导致Leader失效时，Zookeeper会自动进行领导选举，选出新的Leader。
2. **数据同步**：网络分区恢复后，Zookeeper会自动进行数据同步，确保所有节点的数据一致。