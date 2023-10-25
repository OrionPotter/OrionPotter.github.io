# ClickHouse

## 一、什么是ClickHouse？

ClickHouse是一个用于联机分析(OLAP【online analytical processing】)的列式数据库管理系统(DBMS)

### 1.什么是列式数据库？

列式数据库是先将一列中的数据值连在一起存储起来，然后再存储下一列的数据，并以此类推的数据库。列阵式数据库完全为分析数据而存在，采用密集贮存数据的方式，不考虑少量数据的更新问题，是大数据环境下，针对仓储式数据存储而产生的数据库。

### 2.列式数据库的优点

自动索引：由于将列作为存储形式，每一列本身就可以作为索引，所以不需要多余的数据结构来为此列创建额外索引。

利于数据压缩：由于大多数列数据基数是重复的，因此在列的存储上其实不需要巨大的数据量。其次相同的列数据属性一致，这为数据结构的优化和压缩提供了便利，并且对于数字列可以采取更有效率的算法进行压缩储存。

延迟物化：列式数据库具有特殊的执行引擎，在数据运算的过程中一般无需解压，而是以指针替代运算，直到最后输出完整的数据。这种方式能够有效削减对CPU的耗损，并减少对其内存与网络传输消耗，最终降低储存所需的空间。

### 3.列式数据库与行式数据库的区别

#### 3.1 存储数据方式不同

行式数据库是以行为单位进行数据存储。将一整行的数据在物理位置连续堆叠，再进行连接存储。列式数据库是先将一列中的数据值连在一起存储起来，然后再存储下一列的数据，它的每一列都是相同的属性。

#### 3.2 查询方式不同

行式数据库在查询数据时，会对数据的每一行进行扫描，从而得到我们需要的数据。即使我们只需要其中某一行的数据，也需要对其余的数据进行全面检索。列式数据库仅对我们需要的列进行查询即可，避免建立过多冗杂的索引内容，有效减少了数据量。尤其是在面对海量数据的时候，查询速度快于行式数据库。

#### 3.3 应用场景不同

行式数据库主要应用于传统的业务场景中，比如联机事务处理。列式数据库由于具有查询速度方面的优势，可适用于大数据分析、联机分析处理。

### 4.OLAP场景的关键特征

- 绝大多数是读请求
- 数据以相当大的批次(> 1000行)更新，而不是单行更新;或者根本没有更新。
- 已添加到数据库的数据不能修改。
- 对于读取，从数据库中提取相当多的行，但只提取列的一小部分。
- 宽表，即每个表包含着大量的列
- 查询相对较少(通常每台服务器每秒查询数百次或更少)
- 对于简单查询，允许延迟大约50毫秒
- 列中的数据相对较小：数字和短字符串(例如，每个URL 60个字节)
- 处理单个查询时需要高吞吐量(每台服务器每秒可达数十亿行)
- 事务不是必须的
- 对数据一致性要求低
- 每个查询有一个大表。除了他以外，其他的都很小。
- 查询结果明显小于源数据。换句话说，数据经过过滤或聚合，因此结果适合于单个服务器的RAM中

### 5.列式数据库更适合OLAP场景的原因

#### 5.1 输入/输出

1. 针对分析类查询，通常只需要读取表的一小部分列。在列式数据库中你可以只读取你需要的数据。例如，如果只需要读取100列中的5列，这将帮助你最少减少20倍的I/O消耗。
2. 由于数据总是打包成批量读取的，所以压缩是非常容易的。同时数据按列分别存储这也更容易压缩。这进一步降低了I/O的体积。
3. 由于I/O的降低，这将帮助更多的数据被系统缓存。

例如，查询«统计每个广告平台的记录数量»需要读取«广告平台ID»这一列，它在未压缩的情况下需要1个字节进行存储。如果大部分流量不是来自广告平台，那么这一列至少可以以十倍的压缩率被压缩。当采用快速压缩算法，它的解压速度最少在十亿字节(未压缩数据)每秒。换句话说，这个查询可以在单个服务器上以每秒大约几十亿行的速度进行处理。这实际上是当前实现的速度。

#### 5.2 CPU

由于执行一个查询需要处理大量的行，因此在整个向量上执行所有操作将比在每一行上执行所有操作更加高效。同时这将有助于实现一个几乎没有调用成本的查询引擎。如果你不这样做，使用任何一个机械硬盘，查询引擎都不可避免的停止CPU进行等待。所以，在数据按列存储并且按列执行是很有意义的。

有两种方法可以做到这一点：

1. 向量引擎：所有的操作都是为向量而不是为单个值编写的。这意味着多个操作之间的不再需要频繁的调用，并且调用的成本基本可以忽略不计。操作代码包含一个优化的内部循环。
2. 代码生成：生成一段代码，包含查询中的所有操作。

这是不应该在一个通用数据库中实现的，因为这在运行简单查询时是没有意义的。但是也有例外，例如，MemSQL使用代码生成来减少处理SQL查询的延迟(只是为了比较，分析型数据库通常需要优化的是吞吐而不是延迟)。

请注意，为了提高CPU效率，查询语言必须是声明型的(SQL或MDX)， 或者至少一个向量(J，K)。 查询应该只包含隐式循环，允许进行优化。

## 二、ClickHouse特性

### 1.真正的列式数据库管理系统

在一个真正的列式数据库管理系统中，除了数据本身外不应该存在其他额外的数据。这意味着为了避免在值旁边存储它们的长度«number»，你必须支持固定长度数值类型。例如，10亿个UInt8类型的数据在未压缩的情况下大约消耗1GB左右的空间，如果不是这样的话，这将对CPU的使用产生强烈影响。即使是在未压缩的情况下，紧凑的存储数据也是非常重要的，因为解压缩的速度主要取决于未压缩数据的大小。

这是非常值得注意的，因为在一些其他系统中也可以将不同的列分别进行存储，但由于对其他场景进行的优化，使其无法有效的处理分析查询。例如： HBase，BigTable，Cassandra，HyperTable。在这些系统中，你可以得到每秒数十万的吞吐能力，但是无法得到每秒几亿行的吞吐能力。

需要说明的是，ClickHouse不单单是一个数据库， 它是一个数据库管理系统。因为它允许在运行时创建表和数据库、加载数据和运行查询，而无需重新配置或重启服务。

### 2.数据压缩

在一些列式数据库管理系统中(例如：InfiniDB CE 和 MonetDB) 并没有使用数据压缩。但是, 若想达到比较优异的性能，数据压缩确实起到了至关重要的作用。

除了在磁盘空间和CPU消耗之间进行不同权衡的高效通用压缩编解码器之外，ClickHouse还提供针对特定类型数据的专用编解码器，这使得ClickHouse能够与更小的数据库(如时间序列数据库)竞争并超越它们。

### 3.数据的磁盘存储

许多的列式数据库(如 SAP HANA, Google PowerDrill)只能在内存中工作，这种方式会造成比实际更多的设备预算。

ClickHouse被设计用于工作在传统磁盘上的系统，它提供每GB更低的存储成本，但如果可以使用SSD和内存，它也会合理的利用这些资源。

### 4.多核心并行处理

ClickHouse会使用服务器上一切可用的资源，从而以最自然的方式并行处理大型查询。

### 5.多服务器分布式处理

上面提到的列式数据库管理系统中，几乎没有一个支持分布式的查询处理。 在ClickHouse中，数据可以保存在不同的shard上，每一个shard都由一组用于容错的replica组成，查询可以并行地在所有shard上进行处理。这些对用户来说是透明的

### 6.支持SQL

ClickHouse支持一种基于SQL的声明式查询语言，它在许多情况下与ANSI SQL标准相同。

支持的查询GROUP BY, ORDER BY, FROM, JOIN, IN以及非相关子查询。

相关(依赖性)子查询和窗口函数暂不受支持，但将来会被实现。

### 7.向量引擎

为了高效的使用CPU，数据不仅仅按列存储，同时还按向量(列的一部分)进行处理，这样可以更加高效地使用CPU。

### 8.实时的数据更新

ClickHouse支持在表中定义主键。为了使查询能够快速在主键中进行范围查找，数据总是以增量的方式有序的存储在MergeTree中。因此，数据可以持续不断地高效的写入到表中，并且写入的过程中不会存在任何加锁的行为。

### 9.索引

按照主键对数据进行排序，这将帮助ClickHouse在几十毫秒以内完成对数据特定值或范围的查找。

### 10.适合在线查询

在线查询意味着在没有对数据做任何预处理的情况下以极低的延迟处理查询并将结果加载到用户的页面中。

### 11.支持近似计算

ClickHouse提供各种各样在允许牺牲数据精度的情况下对查询进行加速的方法：

1. 用于近似计算的各类聚合函数，如：distinct values, medians, quantiles
2. 基于数据的部分样本进行近似查询。这时，仅会从磁盘检索少部分比例的数据。
3. 不使用全部的聚合条件，通过随机选择有限个数据聚合条件进行聚合。这在数据聚合条件满足某些分布条件下，在提供相当准确的聚合结果的同时降低了计算资源的使用。

### 12.自适应连接算法

ClickHouse支持自定义JOIN多个表，它更倾向于散列连接算法，如果有多个大表，则使用合并-连接算法

### 13.支持数据复制和数据完整性

ClickHouse使用异步的多主复制技术。当数据被写入任何一个可用副本后，系统会在后台将数据分发给其他副本，以保证系统在不同副本上保持相同的数据。在大多数情况下ClickHouse能在故障后自动恢复，在一些少数的复杂情况下需要手动恢复。

### 14.角色的访问控制

ClickHouse使用SQL查询实现用户帐户管理，并允许角色的访问控制，类似于ANSI SQL标准和流行的关系数据库管理系统。

15.限制

1. 没有完整的事务支持。
2. 缺少高频率，低延迟的修改或删除已存在数据的能力。仅能用于批量删除或修改数据，但这符合 GDPR。
3. 稀疏索引使得ClickHouse不适合通过其键检索单行的点查询。

## 三、clickHouse性能

### 1.单个大查询的吞吐量

吞吐量可以使用每秒处理的行数或每秒处理的字节数来衡量。如果数据被放置在page cache中，则一个不太复杂的查询在单个服务器上大约能够以2-10GB／s（未压缩）的速度进行处理（对于简单的查询，速度可以达到30GB／s）。如果数据没有在page cache中的话，那么速度将取决于你的磁盘系统和数据的压缩率。例如，如果一个磁盘允许以400MB／s的速度读取数据，并且数据压缩率是3，则数据的处理速度为1.2GB/s。这意味着，如果你是在提取一个10字节的列，那么它的处理速度大约是1-2亿行每秒。

对于分布式处理，处理速度几乎是线性扩展的，但这受限于聚合或排序的结果不是那么大的情况下。

### 2.处理短查询的延迟时间

如果一个查询使用主键并且没有太多行(几十万)进行处理，并且没有查询太多的列，那么在数据被page cache缓存的情况下，它的延迟应该小于50毫秒(在最佳的情况下应该小于10毫秒)。 否则，延迟取决于数据的查找次数。如果你当前使用的是HDD，在数据没有加载的情况下，查询所需要的延迟可以通过以下公式计算得知： 查找时间（10 ms） * 查询的列的数量 * 查询的数据块的数量。

### 3.处理大量短查询的吞吐量

在相同的情况下，ClickHouse可以在单个服务器上每秒处理数百个查询（在最佳的情况下最多可以处理数千个）。但是由于这不适用于分析型场景。因此我们建议每秒最多查询100次。

### 4.数据的写入性能

我们建议每次写入不少于1000行的批量写入，或每秒不超过一个写入请求。当使用tab-separated格式将一份数据写入到MergeTree表中时，写入速度大约为50到200MB/s。如果您写入的数据每行为1Kb，那么写入的速度为50，000到200，000行每秒。如果您的行更小，那么写入速度将更高。为了提高写入性能，您可以使用多个INSERT进行并行写入，这将带来线性的性能提升。

## 四、clickHouse单机安装

### 1.系统要求

ClickHouse可以在任何具有x86_64，AArch64或PowerPC64LE CPU架构的Linux，FreeBSD或Mac OS X上运行。

官方预构建的二进制文件通常针对x86_64进行编译，并利用`SSE 4.2`指令集，因此，除非另有说明，支持它的CPU使用将成为额外的系统需求。下面是检查当前CPU是否支持SSE 4.2的命令:

```bash
grep -q sse4_2 /proc/cpuinfo && echo "SSE 4.2 supported" || echo "SSE 4.2 not supported"
```

### 2.RPM安装CK服务端

#### 2.1 设置RPM repository

```shell
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
```

#### 2.2 安装ClickHouse server和client

```shell
sudo yum install -y clickhouse-server clickhouse-client
```

#### 2.3 修改配置文件，允许通过IPV4访问

```shell
#配置文件位置
cd /etc/clickhouse-server/
- config.d 配置文件夹，主配置文件自动加载.xml结尾的配置文件
- config.xml 主配置文件
- users.d 管理用户配置文件夹，主配置文件自动加载.xml结尾的配置文件
- users.xml 用户配置文件，主配置文件自动加载
#备份原始配置文件
cp  /etc/clickhouse-server/config.xml  /etc/clickhouse-server/config.xml.bak
#修改配置文件里面允许IPV4访问，约212行，取消注释
<listen_host>0.0.0.0</listen_host>
```

#### 2.4 开启ClickHouse server

```shell
sudo systemctl enable clickhouse-server
sudo systemctl start clickhouse-server
sudo systemctl status clickhouse-server
```

### 3.测试是否安装成功

```shell
#已经安装了客户端，直接使用客户端访问即可
clickhouse-client 
#此时登录进来，即可使用sql语法，默认用户为default，无密码
#如果在配置文件中配置了密码，请指定密码登录
clickhouse-client --password
```

## 五、clickhouse集群搭建

> 集群架构三台clickhouse-server和三台clickhouse-keeper
>
> 搭建流程：
>
> 1. 在群集的所有机器上安装ClickHouse服务端
> 2. 在配置文件中设置集群配置及Kepper配置
> 3. 在**每个**实例上创建本地表
> 4. 创建一个分布式表

### 1.集群节点信息

#### 1.1 server和kepper所在服务器信息

| 名称  | hosts  | ip             | clickhouse-server | clickhouse-keeper |
| ----- | ------ | -------------- | ----------------- | ----------------- |
| 节点1 | slave1 | 192.168.67.111 | 192.168.67.111    | 192.168.67.111    |
| 节点2 | slave2 | 192.168.67.112 | 192.168.67.112    | 192.168.67.112    |
| 节点3 | slave3 | 192.168.67.113 | 192.168.67.113    | 192.168.67.113    |

#### 1.2 hosts配置

```shell
echo "192.168.67.111  slave1" >>/etc/hosts
echo "192.168.67.112  slave2" >>/etc/hosts
echo "192.168.67.113  slave3" >>/etc/hosts
```

### 2.安装ClickHouse-Server

>按照单机版安装即可，需要打开IPV4访问

### 3.安装ClickHouse-Keeper

>新版本clickhouse-server中自带clickhouse-keeper,无需单独安装

### 4.配置ClickHouse-Keeper配置文件

>1.在集群的每个节点创建配置文件：vim /etc/clickhouse-server/config.d/metrika.xml
>
>2.添加如下配置，其中<server_id>1</server_id>代表唯一的服务器ID, ClickHouse Keeper 集群的每个节点都必须有一个唯一的编号(1, 2, 3, ……)
>
>3.执行`chown -R clickhouse:cliclhouse /var/lib/clickhouse/`和`chown -R clickhouse:cliclhouse /var/lib/clickhouse/` 授权给clickhouse用户和用户组
>
>4.ClickHouse Keeper被绑定到ClickHouse服务器包中，只需添加配置' <keeper_server> '，并像往常一样启动ClickHouse服务器。

```xml
<keeper_server>
    <tcp_port>9181</tcp_port>
    <server_id>1</server_id>
    <log_storage_path>/var/lib/clickhouse/coordination/log</log_storage_path>
  <snapshot_storage_path>/var/lib/clickhouse/coordination/snapshots</snapshot_storage_path>
    <coordination_settings>
        <operation_timeout_ms>10000</operation_timeout_ms>
        <session_timeout_ms>30000</session_timeout_ms>
        <raft_logs_level>warning</raft_logs_level>
    </coordination_settings>

    <raft_configuration>
        <server>
            <id>1</id>
            <hostname>slave1</hostname>
            <port>9444</port>
        </server>
        <server>
            <id>2</id>
            <hostname>slave2</hostname>
            <port>9444</port>
        </server>
        <server>
            <id>3</id>
            <hostname>slave3</hostname>
            <port>9444</port>
        </server>
    </raft_configuration>
</keeper_server>
```

- `tcp_port` — 客户端连接的端口(默认是`2181`和ZooKeeper保持一致).
- `tcp_port_secure` — client 和 keeper-server之间的SSL连接的安全端口.
- `server_id` — 唯一的服务器ID, ClickHouse Keeper 集群的每个参与组件都必须有一个唯一的编号(1, 2, 3, 等等).
- `log_storage_path` — 协调日志的路径, 最好存放在不繁忙的机器上 (和ZooKeeper一样).
- `snapshot_storage_path` — 协调快照的路径.

每个`<server>`的主要参数是:

- `id` — 仲裁中的服务器标识符。
- `hostname` — 放置该服务器的主机名。
- `port` — 服务器监听连接的端口。

### 5.配置ClickHouse-Server配置文件

>1.在集群的每个节点创建配置文件：vim /etc/clickhouse-server/config.d/metrika.xml
>
>2.添加如下配置，按照集群模式三个分片，一个副本进行配置,分片是指包含部分数据的服务器，要读取所有的数据，必须访问所有的分片。副本是指存储分片备份数据的服务器，要读取所有的数据，访问任意副本上的数据即可。
>
>3.常见的集群模式
>
> - 单分片多副本模式
> - 多分片单副本模式
>	- 多分片多副本模式

```xml
<remote_servers>
    <perftest_3shards_1replicas>
        <shard>
            <replica>
                <host>slave1</host>
                <port>8000</port>
            </replica>
        </shard>
        <shard>
            <replica>
                <host>slave2</host>
                <port>8000</port>
            </replica>
        </shard>
        <shard>
            <replica>
                <host>slave3</host>
                <port>8000</port>
            </replica>
        </shard>
    </perftest_3shards_1replicas>
</remote_servers>
```

### 6.宏配置

>区分每台ClickHouse节点的宏配置，macros中标签<shard>代表当前节点的分片号，标签<replica>代表当前节点的副本号，这两个名称可以随意取，后期在创建副本表时可以动态读取这两个宏变量。注意：每台ClickHouse节点需要配置不同名称。

```xml
<macros>
    <replica>slave1</replica>
</macros>
```

7.附完整的配置文件

```xml
<yandex>

<remote_servers>
    <perftest_3shards_1replicas>
        <shard>
            <replica>
                <host>slave1</host>
                <port>8000</port>
            </replica>
        </shard>
        <shard>
            <replica>
                <host>slave2</host>
                <port>8000</port>
            </replica>
        </shard>
        <shard>
            <replica>
                <host>slave3</host>
                <port>8000</port>
            </replica>
        </shard>
    </perftest_3shards_1replicas>
</remote_servers>
<!--zookeeper集群的连接信息-->
<keeper_server>
    <tcp_port>9181</tcp_port>
    <server_id>1</server_id>
    <log_storage_path>/var/lib/clickhouse/coordination/log</log_storage_path>
  <snapshot_storage_path>/var/lib/clickhouse/coordination/snapshots</snapshot_storage_path>
    <coordination_settings>
        <operation_timeout_ms>10000</operation_timeout_ms>
        <session_timeout_ms>30000</session_timeout_ms>
        <raft_logs_level>warning</raft_logs_level>
    </coordination_settings>

    <raft_configuration>
        <server>
            <id>1</id>
            <hostname>slave1</hostname>
            <port>9444</port>
        </server>
        <server>
            <id>2</id>
            <hostname>slave2</hostname>
            <port>9444</port>
        </server>
        <server>
            <id>3</id>
            <hostname>slave3</hostname>
            <port>9444</port>
        </server>
    </raft_configuration>
</keeper_server>

<!--定义宏变量，后面需要用-->
<macros>
    <replica>slave1</replica>
</macros>
<!--不限制访问来源ip地址-->
<networks>
   <ip>::/0</ip>
</networks>

<!--数据压缩方式，默认为lz4-->
<clickhouse_compression>
<case>
  <min_part_size>10000000000</min_part_size>
                                             
  <min_part_size_ratio>0.01</min_part_size_ratio>                                                                                                                                       
  <method>lz4</method>
</case>
</clickhouse_compression>
</yandex>
```

### 7.启动并查看

```shell
#start
systemct start clickhouse-server
#login clickServer,此处我更改了config.xml的server的tcp_port
clickhouse-client --port 8000
#execute sql
select * from system.clusters;
#如果显示cluster信息则集群搭建成功
```

### 8.验证Keeper是否搭建成功

```shell
echo ruok | nc localhost 9181
```

- `ruok`: 测试服务器运行时是否处于无错误状态。如果服务器正在运行，它将用imok响应。否则它将完全不响应。“imok”的响应并不一定表明服务器已加入仲裁，只是表明服务器进程处于活动状态并绑定到指定的客户端端口。使用“stat”获取状态wrt仲裁和客户端连接信息的详细信息。

```text
imok
```

- `mntr`: 输出可用于监视集群运行状况的变量列表。
- `stat`: 列出服务器和连接客户机的简要详细信息。

### 9.创建本地表和分布式表

#### 9.1 本地表和分布式表区别

| 类型                          | 说明                                                         | 区别                                                         |
| :---------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| 本地表（Local Table）         | 数据只会存储在当前写入的节点上，不会被分散到多台服务器上。   | 本地表的写入和查询，受限于单台服务器的存储、计算资源，不具备横向拓展能力。 |
| 分布式表（Distributed Table） | 本地表的集合，它将多个本地表抽象为一张统一的表，对外提供写入、查询功能。当写入分布式表时，数据会被自动分发到集合中的各个本地表中；当查询分布式表时，集合中的各个本地表都会被分别查询，并且把最终结果汇总后返回。 | 分布式表的写入和查询，可以利用多台服务器的存储、计算资源，具有较好的横向拓展能力。 |

#### 9.2 下载表数据

```shell
curl https://datasets.clickhouse.com/hits/tsv/hits_v1.tsv.xz | unxz --threads=`nproc` > hits_v1.tsv
```

#### 9.3 创建数据库

```shell
clickhouse-client --port 8000 --query "CREATE DATABASE IF NOT EXISTS tutorial"
```

#### 9.4 创建数据表

```sql
CREATE TABLE tutorial.hits_v1_local on cluster perftest_3shards_1replicas
(
    `WatchID` UInt64,
    `JavaEnable` UInt8,
    `Title` String,
    `GoodEvent` Int16,
    `EventTime` DateTime,
    `EventDate` Date,
    `CounterID` UInt32,
    `ClientIP` UInt32,
    `ClientIP6` FixedString(16),
    `RegionID` UInt32,
    `UserID` UInt64,
    `CounterClass` Int8,
    `OS` UInt8,
    `UserAgent` UInt8,
    `URL` String,
    `Referer` String,
    `URLDomain` String,
    `RefererDomain` String,
    `Refresh` UInt8,
    `IsRobot` UInt8,
    `RefererCategories` Array(UInt16),
    `URLCategories` Array(UInt16),
    `URLRegions` Array(UInt32),
    `RefererRegions` Array(UInt32),
    `ResolutionWidth` UInt16,
    `ResolutionHeight` UInt16,
    `ResolutionDepth` UInt8,
    `FlashMajor` UInt8,
    `FlashMinor` UInt8,
    `FlashMinor2` String,
    `NetMajor` UInt8,
    `NetMinor` UInt8,
    `UserAgentMajor` UInt16,
    `UserAgentMinor` FixedString(2),
    `CookieEnable` UInt8,
    `JavascriptEnable` UInt8,
    `IsMobile` UInt8,
    `MobilePhone` UInt8,
    `MobilePhoneModel` String,
    `Params` String,
    `IPNetworkID` UInt32,
    `TraficSourceID` Int8,
    `SearchEngineID` UInt16,
    `SearchPhrase` String,
    `AdvEngineID` UInt8,
    `IsArtifical` UInt8,
    `WindowClientWidth` UInt16,
    `WindowClientHeight` UInt16,
    `ClientTimeZone` Int16,
    `ClientEventTime` DateTime,
    `SilverlightVersion1` UInt8,
    `SilverlightVersion2` UInt8,
    `SilverlightVersion3` UInt32,
    `SilverlightVersion4` UInt16,
    `PageCharset` String,
    `CodeVersion` UInt32,
    `IsLink` UInt8,
    `IsDownload` UInt8,
    `IsNotBounce` UInt8,
    `FUniqID` UInt64,
    `HID` UInt32,
    `IsOldCounter` UInt8,
    `IsEvent` UInt8,
    `IsParameter` UInt8,
    `DontCountHits` UInt8,
    `WithHash` UInt8,
    `HitColor` FixedString(1),
    `UTCEventTime` DateTime,
    `Age` UInt8,
    `Sex` UInt8,
    `Income` UInt8,
    `Interests` UInt16,
    `Robotness` UInt8,
    `GeneralInterests` Array(UInt16),
    `RemoteIP` UInt32,
    `RemoteIP6` FixedString(16),
    `WindowName` Int32,
    `OpenerName` Int32,
    `HistoryLength` Int16,
    `BrowserLanguage` FixedString(2),
    `BrowserCountry` FixedString(2),
    `SocialNetwork` String,
    `SocialAction` String,
    `HTTPError` UInt16,
    `SendTiming` Int32,
    `DNSTiming` Int32,
    `ConnectTiming` Int32,
    `ResponseStartTiming` Int32,
    `ResponseEndTiming` Int32,
    `FetchTiming` Int32,
    `RedirectTiming` Int32,
    `DOMInteractiveTiming` Int32,
    `DOMContentLoadedTiming` Int32,
    `DOMCompleteTiming` Int32,
    `LoadEventStartTiming` Int32,
    `LoadEventEndTiming` Int32,
    `NSToDOMContentLoadedTiming` Int32,
    `FirstPaintTiming` Int32,
    `RedirectCount` Int8,
    `SocialSourceNetworkID` UInt8,
    `SocialSourcePage` String,
    `ParamPrice` Int64,
    `ParamOrderID` String,
    `ParamCurrency` FixedString(3),
    `ParamCurrencyID` UInt16,
    `GoalsReached` Array(UInt32),
    `OpenstatServiceName` String,
    `OpenstatCampaignID` String,
    `OpenstatAdID` String,
    `OpenstatSourceID` String,
    `UTMSource` String,
    `UTMMedium` String,
    `UTMCampaign` String,
    `UTMContent` String,
    `UTMTerm` String,
    `FromTag` String,
    `HasGCLID` UInt8,
    `RefererHash` UInt64,
    `URLHash` UInt64,
    `CLID` UInt32,
    `YCLID` UInt64,
    `ShareService` String,
    `ShareURL` String,
    `ShareTitle` String,
    `ParsedParams` Nested(
        Key1 String,
        Key2 String,
        Key3 String,
        Key4 String,
        Key5 String,
        ValueDouble Float64),
    `IslandID` FixedString(16),
    `RequestNum` UInt32,
    `RequestTry` UInt8
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(EventDate)
ORDER BY (CounterID, EventDate, intHash32(UserID))
SAMPLE BY intHash32(UserID)
```

#### 9.5 导入数据

```shell
clickhouse-client --query "INSERT INTO tutorial.hits_v1 FORMAT TSV" --max_insert_block_size=100000 < hits_v1.tsv
```

#### 9.6 创建本地表

```sql
#根据tutorial.hits的建表语句创建一个集权表只是表名不一致，其他节点也会看到该表
CREATE TABLE tutorial.hits_local (...) on cluster perftest_3shards_1replicas ENGINE = MergeTree() ...
```

#### 9.7 创建分布式表

```sql
CREATE TABLE tutorial.hits_all on cluster perftest_3shards_1replicas AS tutorial.hits_v1_local
ENGINE = Distributed(perftest_3shards_1replicas, tutorial, hits_v1_local, rand());
```

#### 9.8 分布式表插入数据

```sql
INSERT INTO tutorial.hits_all SELECT * FROM tutorial.hits_v1;
```

#### 9.9 验证

>另外两台节点能够看到本地表和分布式表说明集群部署并同步成功

#### 9.10 其他表概念

| 类型                           | 说明                                                         | 区别                                                   |
| :----------------------------- | :----------------------------------------------------------- | :----------------------------------------------------- |
| 单机表（Non-Replicated Table） | 数据只会存储在当前服务器上，不会被复制到其他服务器，即只有一个副本。 | 单机表在异常情况下无法保证服务高可用。                 |
| 复制表（Replicated Table）     | 数据会被自动复制到多台服务器上，形成多个副本。               | 复制表在至少有一个正常副本的情况下，能够对外提供服务。 |

## 六、接口

### 1.命令行客户端

ClickHouse提供了一个原生命令行客户端`clickhouse-client`客户端支持命令行

#### 1.1 使用方式

客户端可以在交互和非交互(批处理)模式下使用。要使用批处理模式，请指定`query`参数，或将数据发送到`stdin`(它会验证`stdin`是否是终端)，或两者同时进行。

```shell
#插入数据
cat file.csv | clickhouse-client --database=test --query="INSERT INTO test FORMAT CSV";
```

在批量模式中，默认的数据格式是`TabSeparated`分隔的。您可以根据查询来灵活设置FORMAT格式。

默认情况下，在批量模式中只能执行单个查询。为了从一个Script中执行多个查询，可以使用`--multiquery`参数。

#### 1.2 查询参数

您可以创建带有参数的查询，并将值从客户端传递给服务器。这允许避免在客户端使用特定的动态值格式化查询。

```shell
$ clickhouse-client --param_parName="[1, 2]"  -q "SELECT * FROM table WHERE a = {parName:Array(UInt16)}"
```

**1.2.1 查询语法**

像平常一样格式化一个查询，然后把你想要从app参数传递到查询的值用大括号格式化，格式如下:

```sql
{<name>:<data type>}
```

- `name` — 占位符标识符。在控制台客户端，使用`--param_<name> = value`来指定
- `data type` — 数据类型参数值。例如，一个数据结构`(integer, ('string', integer))`拥有`Tuple(UInt8, Tuple(String, UInt8))`数据类型(你也可以用另一个integer类型)。

**1.2.2 示例**

```bash
$ clickhouse-client --param_tuple_in_tuple="(10, ('dt', 10))" -q "SELECT * FROM table WHERE val = {tuple_in_tuple:Tuple(UInt8, Tuple(String, UInt8))}"
```

#### 1.3 配置

#### 1.3.1 通过命令行

命令行参数会覆盖默认值和配置文件的配置。

- `--host, -h` -– 服务端的host名称, 默认是`localhost`。您可以选择使用host名称或者IPv4或IPv6地址。
- `--port` – 连接的端口，默认值：9000。注意HTTP接口以及TCP原生接口使用的是不同端口。
- `--user, -u` – 用户名。 默认值：`default`。
- `--password` – 密码。 默认值：空字符串。
- `--query, -q` – 使用非交互模式查询。
- `--database, -d` – 默认当前操作的数据库. 默认值：服务端默认的配置（默认是`default`）。
- `--multiline, -m` – 如果指定，允许多行语句查询（Enter仅代表换行，不代表查询语句完结）。
- `--multiquery, -n` – 如果指定, 允许处理用`;`号分隔的多个查询，只在非交互模式下生效。
- `--format, -f` – 使用指定的默认格式输出结果。
- `--vertical, -E` – 如果指定，默认情况下使用垂直格式输出结果。这与`–format=Vertical`相同。在这种格式中，每个值都在单独的行上打印，这种方式对显示宽表很有帮助。
- `--time, -t` – 如果指定，非交互模式下会打印查询执行的时间到`stderr`中。
- `--stacktrace` – 如果指定，如果出现异常，会打印堆栈跟踪信息。
- `--config-file` – 配置文件的名称。
- `--secure` – 如果指定，将通过安全连接连接到服务器。
- `--history_file` — 存放命令历史的文件的路径。
- `--param_<name>` — 查询参数配置查询参数

#### 1.3.2 配置文件

配置文件的配置会覆盖默认值

`clickhouse-client`使用以下第一个配置文件：

- 通过`--config-file`参数指定。
- `./clickhouse-client.xml`
- `~/.clickhouse-client/config.xml`
- `/etc/clickhouse-client/config.xml`

**配置文件示例**:

```xml
<config>
    <user>username</user>
    <password>password</password>
    <secure>False</secure>
</config>
```

### 2.JDBC驱动

#### 2.1官方驱动

```xml
<dependency>
    <groupId>ru.yandex.clickhouse</groupId>
    <artifactId>clickhouse-jdbc</artifactId>
    <version>{version}</version>
</dependency>
```

#### 2.2第三方驱动

```xml
<dependency>
    <groupId>com.github.housepower</groupId>
    <artifactId>clickhouse-native-jdbc</artifactId>
    <version>{version}</version>
</dependency>
```

两者间的主要区别如下：

a.驱动类加载路径不同，分别为 ru.yandex.clickhouse.ClickHouseDriver和 com.github.housepower.jdbc.ClickHouseDriver
b.默认连接端口不同，分别为 8123 和 9000
C.连接协议不同，官方驱动使用 HTTP 协议，而三方驱动使用 TCP 协议

#### 2.3 mybatis-plus整合ClickHouse

**建表示例：**

```sql
-- 建表
CREATE TABLE IF NOT EXISTS tb_stat ( id String, region String, group String, yesterday INT, today INT, stat_date DateTime ) ENGINE = SummingMergeTree PARTITION BY ( toYYYYMM ( stat_date ), region )  ORDER BY ( toStartOfHour ( stat_date ), region, group );

-- 数据
INSERT INTO tb_stat VALUES( '1','1232364', '111', 32, 2, '2021-07-09 12:56:00' );
INSERT INTO tb_stat VALUES( '2','1232364', '111', 34, 44, '2021-07-09 12:21:00' );
INSERT INTO tb_stat VALUES( '3','1232364', '111', 54, 12, '2021-07-09 12:20:00' );
INSERT INTO tb_stat VALUES( '4','1232364', '222', 45, 11, '2021-07-09 12:13:00' );
INSERT INTO tb_stat VALUES( '5','1232364', '222', 32, 33, '2021-07-09 12:44:00' );
INSERT INTO tb_stat VALUES( '6','1232364', '222', 12, 23, '2021-07-09 12:22:00' );
INSERT INTO tb_stat VALUES( '7','1232364', '333', 54, 54, '2021-07-09 12:11:00' );
INSERT INTO tb_stat VALUES( '8','1232364', '333', 22, 74, '2021-07-09 12:55:00' );
INSERT INTO tb_stat VALUES( '9','1232364', '333', 12, 15, '2021-07-09 12:34:00' );
```

**依赖相关：**

```xml
 <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <optional>true</optional>
        </dependency>

        <dependency>
            <groupId>ru.yandex.clickhouse</groupId>
            <artifactId>clickhouse-jdbc</artifactId>
            <version>0.3.2</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/com.alibaba/druid -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
            <version>1.1.21</version>
        </dependency>
        <!-- https://mvnrepository.com/artifact/com.baomidou/mybatis-plus-boot-starter -->
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-boot-starter</artifactId>
            <version>3.3.2</version>
        </dependency>

        
        <!--Spring Boot 测试-->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
        </dependency>

    </dependencies>
```

##### 2.3.1 配置SpringBoot配置文件

```xml
server:
  port: 8080
spring:
#clickhouse配置
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driverClassName: ru.yandex.clickhouse.ClickHouseDirver
    click:
      url: jdbc:clickhouse://192.168.67.111:8123/tutorial
      username: default
      password:
      initialSize: 10
      maxActive: 100
      minIdle: 10
      maxWait: 6000
```

##### 2.3.2 配置DruidConfig

```java
@Configuration
public class DruidConfig {
    @Bean
    @ConfigurationProperties(prefix = "spring.datasource.click")
    public DataSource druidDataSource() {
        return new DruidDataSource();
    }
}
```

##### 2.3.3 Mapper配置

```java
public interface StatMapper extends BaseMapper<Stat> {
}
```

##### 2.3.4 Entity配置

```java
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName(value = "tb_stat")
public class Stat implements Serializable {
    private static final long serialVersionUID = 1L;
    private String id;
    private String region;
    private String group;
    private Integer yesterday;
    private Integer today;
    @JsonFormat(locale="zh", timezone="GMT+8", pattern="yyyy-MM-dd HH:mm:ss")
    private Date statDate;
}
```

##### 2.3.5 测试类

```java
@SpringBootTest
public class AppArgTest {
    @Autowired
    private StatMapper statMapper;
    @Test
    public void testClickHouse(){
        Integer integer = statMapper.selectCount(null);
        System.out.println(integer);
    }
}
```

#### 2.4 注意事项

>clickhouse 数据库的语法有一些不同,删除和修改的SQL要自己在xml文件内写。

```sql
-- clickHouse语法
-- 删除语法
alter table tb_stat delete WHERE id='10';
-- 修改语法
alter table tb_stat update today=222 WHERE id='4';
```

### 3.输入输出格式

ClickHouse可以接受输入和输出各种格式的数据，如TSV(TabSeparated)、CSV、CSVWhithNames、JSON、XML等。

#### 3.1 TabSeparated

在TabSeparated分隔格式中，数据按行写入。每行包含由制表符分隔的值，每个值后跟一个制表符，除了行中最后一个值，最后的值后面是一个换行符。在任何地方都采用严格的Unix换行(\n)。最后一行结束后必须再插入一个换行符。值以文本格式编写，不包含引号，并使用转义的特殊字符，这种格式也被称为`TSV`。

`TabSeparated`格式便于其他的程序和脚本处理数据。默认情况下，HTTP接口和命令行客户端的批处理模式中会使用这个格式。这种格式还允许在不同dbms之间传输数据。例如，您可以从MySQL获取转储并将其上传到ClickHouse，反之亦然。

#### 3.2 数据格式化

整数是用十进制形式写的。数字可以在开头包含一个额外的`+`字符(解析时忽略该符号，格式化时不记录该符号)。非负数不能包含负号。在读取时，允许将空字符串解析为零，或者(对于有符号类型)将'-'(仅有减号的字符串)解析为零。不符合相应数据类型的数字可能被解析为数值，而不会出现错误消息。

浮点数以十进制形式书写。用`.`作为小数点的符号。支持指数符号，如`inf`、`+inf`、`-inf`和`nan`。小数点前或后可以不出现数字(如123.或.123)。 在格式化期间，浮点数精度可能会丢失。 在解析期间，并不严格要求读取与机器可以表示的最接近的数值。

日期以`YYYY-MM-DD`格式编写，并以相同的格式解析，但允许使用任何字符作为分隔符。 日期和时间以`YYYY-MM-DD hh:mm:ss`的格式书写，并以相同的格式解析，但允许使用任何字符作为分隔符。 时区采用客户端或服务器端时区(取决于谁对数据进行格式化)。对于带有时间的日期，没有是哦用夏时制时间。因此，如果导出的数据采用了夏时制，则实际入库的时间不一定与预期的时间对应，解析将根据解析动作发起方选择时间。 在读取操作期间，不正确的日期和具有时间的日期可以自然溢出(如2021-01-32)或设置成空日期和时间，而不会出现错误消息。

有个例外情况，时间解析也支持Unix时间戳(如果它恰好由10个十进制数字组成)。其结果与时区无关。格式`YYYY-MM-DD hh:mm:ss`和`NNNNNNNNNN`这两种格式会自动转换。

字符串输出时，特殊字符会自动转义。以下转义序列用于输出:`\b`, `\f`, `\r`, `\n`, `\t`, `\0`, `\'`, `\\`。解析还支持`\a`、`\v`和`\xHH`(HH代表十六进制编码)和`\c`，其中`c`是任何字符(这些序列被转换为`c`)。因此，读取数据时，换行符可以写成`\n`或`\`。

NULL将输出为`\N`。

Nested结构的每个元素都表示为数组。

## 七、引擎

### 1.数据库引擎

数据库引擎允许您处理数据表。默认情况下，ClickHouse使用Atomic数据库引擎。它提供了可配置的table engines和SQL dialect。

ClickHouse以下数据库引擎：

- MySQL
- Lazy
- Atomic
- PostgreSQL
- MaterializedPostgreSQL
- Replicated
- SQLite

#### 1.1 mysql引擎

MySQL引擎用于将远程的MySQL服务器中的表映射到ClickHouse中，并允许您对表进行`INSERT`和`SELECT`查询，以方便您在ClickHouse与MySQL之间进行数据交`MySQL`数据库引擎会将对其的查询转换为MySQL语法并发送到MySQL服务器中，因此您可以执行诸如`SHOW TABLES`或`SHOW CREATE TABLE`之类的操作。但不支持以下操作：

- `RENAME`
- `CREATE TABLE`
- `ALTER`

##### 1.1.1 创建mysql引擎的数据库

```sql
CREATE DATABASE [IF NOT EXISTS] db_name [ON CLUSTER cluster]
ENGINE = MySQL('host:port', ['database' | database], 'user', 'password')
```

**引擎参数**

- `host:port` — MySQL服务地址
- `database` — MySQL数据库名称
- `user` — MySQL用户名
- `password` — MySQL用户密码

##### 1.1.2 mysql数据库示例

**1.创建数据库为test库，创建数据库表为mysql_table**

```sql
mysql> USE test;
Database changed

mysql> CREATE TABLE `mysql_table` (
    ->   `int_id` INT NOT NULL AUTO_INCREMENT,
    ->   `float` FLOAT NOT NULL,
    ->   PRIMARY KEY (`int_id`));
Query OK, 0 rows affected (0,09 sec)

mysql> insert into mysql_table (`int_id`, `float`) VALUES (1,2);
Query OK, 1 row affected (0,00 sec)

mysql> select * from mysql_table;
+------+-----+
| int_id | value |
+------+-----+
|      1 |     2 |
+------+-----+
1 row in set (0,00 sec)
```

**2.clickhouse中按照mysql引擎创建数据库**

>与MySQL服务器交换数据,在clockhouse创建数据库mysql_db

```sql
CREATE DATABASE mysql_db ENGINE = MySQL('localhost:3306', 'test', 'my_user', 'user_password')
```

**3.在clickhouse里面查看数据库**

```sql
SHOW DATABASES
```

```sql
┌─name─────┐
│ default  │
│ mysql_db │
│ system   │
└──────────┘
```

**4.在clickhouse查看数据库表**

```sql
SHOW TABLES FROM mysql_db
```

```sql
┌─name─────────┐
│  mysql_table │
└──────────────┘
```

**5.在clickhouse执行插入语句**

```sql
INSERT INTO mysql_db.mysql_table VALUES (3,4)
```

**6.在clickhouse执行查询**

```sql
┌─int_id─┬─value─┐
│      1 │     2 │
│      3 │     4 │
└────────┴───────┘
```

### 2.索引

- 联合主键
- 联合排序键 

>- 如果我们只指定了排序键，那么主键将隐式定义为排序键。
>- 为了提高内存效率，我们显式地指定了一个主键，只包含查询过滤的列。基于主键的主索引被完全加载到主内存中。
>- 为了上下文的一致性和最大的压缩比例，我们单独定义了排序键，排序键包含当前表所有的列（和压缩算法有关，一般排序之后又更好的压缩率）。
>- 如果同时指定了主键和排序键，则主键必须是排序键的前缀。

### 3.表引擎

表引擎（即表的类型）决定了：

- 数据的存储方式和位置，写到哪里以及从哪里读取数据
- 支持哪些查询以及如何支持。
- 并发数据访问。
- 索引的使用（如果存在）。
- 是否可以执行多线程请求。
- 数据复制参数。

#### 3.1 引擎分类

+ MergeTree:适用于高负载任务的最通用和功能最强大的表引擎
+ 日志:具有最小功能的轻量级引擎。当您需要快速写入许多小表（最多约100万行）并在以后整体读取它们时，该类型的引擎是最有效的。
+ 集成的表引擎:用于与其他的数据存储与处理系统集成的引擎。
+ special:用于其他特定功能的引擎

#### 3.2 MergeTree引擎

>MergeTree引擎的共同特点是可以快速插入数据并进行后续的后台数据处理。MergeTree系列引擎支持**数据复制**（使用Replicated* 的引擎版本），分区和一些其他引擎不支持的其他功能。

##### 3.2.1 VersionedCollapsingMergeTree

特点：

- 允许快速写入不断变化的对象状态。
- 删除后台中的旧对象状态。 这显著降低了存储体积。

>引擎继承自 MergeTree并将折叠行的逻辑添加到合并数据部分的算法中。 `VersionedCollapsingMergeTree` 用于相同的目的,折叠树但使用不同的折叠算法，允许以多个线程的任何顺序插入数据。 特别是`Version` 列有助于正确折叠行，即使它们以错误的顺序插入。 相比之下, `CollapsingMergeTree` 只允许严格连续插入。

引擎参数

```sql
VersionedCollapsingMergeTree(sign, version)
```

- `sign` — 指定行类型的列名: `1` 是一个 “state” 行, `-1` 是一个 “cancel” 行

  列数据类型应为 `Int8`.

- `version` — 指定对象状态版本的列名。

  列数据类型应为 `UInt*`.

##### 3.2.2 GraphiteMergeTree

>该引擎用来对 [Graphite](http://graphite.readthedocs.io/en/latest/index.html)数据进行瘦身及汇总。对于想使用CH来存储Graphite数据的开发者来说可能有用。

##### 3.2.3 AggregatingMergeTree

>该引擎继承自MergeTree，并改变了数据片段的合并逻辑。 ClickHouse 会将一个数据片段内所有具有相同主键（准确的说是 [排序键](https://clickhouse.com/docs/zh/engines/table-engines/mergetree-family/mergetree)）的行替换成一行，这一行会存储一系列聚合函数的状态。可以使用 `AggregatingMergeTree` 表来做增量数据的聚合统计，包括物化视图的数据聚合。

##### 3.2.4 CollapsingMergeTree

>该引擎继承于 [MergeTree](https://clickhouse.com/docs/zh/engines/table-engines/mergetree-family/mergetree)，并在数据块合并算法中添加了折叠行的逻辑。`CollapsingMergeTree` 会异步的删除（折叠）这些除了特定列 `Sign` 有 `1` 和 `-1` 的值以外，其余所有字段的值都相等的成对的行。没有成对的行会被保留。因此，该引擎可以显著的降低存储量并提高 `SELECT` 查询效率。

引擎参数

```sql
CollapsingMergeTree(sign)
```

##### 3.2.5 自定义分区键

>MergeTree 系列的表（包括可复制表）可以使用分区。基于 MergeTree 表的物化视图也支持分区。
>
>分区是在一个表中通过指定的规则划分而成的逻辑数据集。可以按任意标准进行分区，如按月，按日或按事件类型。为了减少需要操作的数据，每个分区都是分开存储的。访问数据时，ClickHouse 尽量使用这些分区的最小子集。
>
>分区是在建表时通过 `PARTITION BY expr` 子句指定的。分区键可以是表中列的任意表达式。例如，指定按月分区，表达式为 `toYYYYMM(date_column)`：

##### 3.2.6 MergeTree

>clickhouse 中最强大的表引擎当属 `MergeTree` （合并树）引擎及该系列（`*MergeTree`）中的其他引擎。
>
>`MergeTree` 系列的引擎被设计用于插入极大量的数据到一张表当中。数据可以以数据片段的形式一个接着一个的快速写入，数据片段在后台按照一定的规则进行合并。相比在插入时不断修改（重写）已存储的数据，这种策略会高效很多。
>
>主要特点:
>
>- 存储的数据按主键排序。能够创建一个小型的稀疏索引来加快数据检索。
>- 如果指定了分区键的话，可以使用分区。在相同数据集和相同结果集的情况下 ClickHouse 中某些带分区的操作会比普通操作更快。查询中指定了分区键时 ClickHouse 会自动截取分区数据。这也有效增加了查询性能。
>- 支持数据副本。`ReplicatedMergeTree` 系列的表提供了数据副本功能。
>- 支持数据采样。可以给表设置一个采样方法。

**建表**

```sql
CREATE TABLE [IF NOT EXISTS] [db.]table_name [ON CLUSTER cluster]
(
    name1 [type1] [DEFAULT|MATERIALIZED|ALIAS expr1] [TTL expr1],
    name2 [type2] [DEFAULT|MATERIALIZED|ALIAS expr2] [TTL expr2],
    ...
    INDEX index_name1 expr1 TYPE type1(...) GRANULARITY value1,
    INDEX index_name2 expr2 TYPE type2(...) GRANULARITY value2
) ENGINE = MergeTree()
ORDER BY expr
[PARTITION BY expr]
[PRIMARY KEY expr]
[SAMPLE BY expr]
[TTL expr [DELETE|TO DISK 'xxx'|TO VOLUME 'xxx'], ...]
[SETTINGS name=value, ...]
```

- `ENGINE` - 引擎名和参数。`ENGINE = MergeTree()`. `MergeTree` 引擎没有参数。

- `ORDER BY` — 排序键。可以是一组列的元组或任意的表达式。 例如: `ORDER BY (CounterID, EventDate)`,如果没有使用 `PRIMARY KEY` 显式指定的主键，ClickHouse 会使用排序键作为主键。如果不需要排序，可以使用 `ORDER BY tuple()`. 参考 [选择主键](https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/mergetree/#selecting-the-primary-key)

- `PARTITION BY` — [分区键](https://clickhouse.com/docs/zh/engines/table-engines/mergetree-family/custom-partitioning-key) ，可选项。大多数情况下，不需要分使用区键。即使需要使用，也不需要使用比月更细粒度的分区键。分区不会加快查询（这与 ORDER BY 表达式不同）。永远也别使用过细粒度的分区键。不要使用客户端指定分区标识符或分区字段名称来对数据进行分区（而是将分区字段标识或名称作为 ORDER BY 表达式的第一列来指定分区）。要按月分区，可以使用表达式 `toYYYYMM(date_column)`，这里的 `date_column`是一个Date类型的列。分区名的格式会是`"YYYYMM"`。

- `PRIMARY KEY` - 如果要 [选择与排序键不同的主键](https://clickhouse.com/docs/zh/engines/table-engines/mergetree-family/mergetree#choosing-a-primary-key-that-differs-from-the-sorting-key)，在这里指定，可选项。默认情况下主键跟排序键（由 `ORDER BY` 子句指定）相同。大部分情况下不需要再专门指定一个 `PRIMARY KEY` 子句。

- `SAMPLE BY` - 用于抽样的表达式，可选项。如果要用抽样表达式，主键中必须包含这个表达式。例如： `SAMPLE BY intHash32(UserID) ORDER BY (CounterID, EventDate, intHash32(UserID))` 。

- `TTL` - 指定行存储的持续时间并定义数据片段在硬盘和卷上的移动逻辑的规则列表，可选项。表达式中必须存在至少一个 `Date` 或 `DateTime` 类型的列，比如：

  `TTL date + INTERVAl 1 DAY`

TTL测试建表

```sql
//创建5分钟后删除行的表
CREATE TABLE table_with_where
(
    d DateTime,
    a Int
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(d)
ORDER BY d
TTL d + INTERVAL 5 MINUTE;
//插入多条数据
insert into table_with_where values (now(),1);
//查询
select * from table_with_where;
┌───────────────────d─┬─a─┐
│ 2023-09-07 16:20:42 │ 1 │
│ 2023-09-07 16:21:04 │ 2 │
│ 2023-09-07 16:21:07 │ 3 │
│ 2023-09-07 16:21:09 │ 4 │
│ 2023-09-07 16:21:14 │ 5 │
└─────────────────────┴───┘
//5分钟后数据自动删除
//设置一个过期时间
SECOND
MINUTE
HOUR
DAY
WEEK
YEAR
```

##### 3.2.7 ReplacingMergeTree

>该引擎和MergeTree的不同之处在于它会删除排序键值相同的重复项。数据的去重只会在数据合并期间进行。合并会在后台一个不确定的时间进行，因此你无法预先作出计划。有一些数据可能仍未被处理。尽管你可以调用 `OPTIMIZE` 语句发起计划外的合并，但请不要依靠它，因为 `OPTIMIZE` 语句会引发对数据的大量读写。`ReplacingMergeTree` 适用于在后台清除重复的数据以节省空间，但是它不保证没有重复的数据出现。

**建表**

```sql
ENGINE = ReplacingMergeTree([ver])
```

- `ver` — 版本列。类型为 `UInt*`, `Date` 或 `DateTime`。可选参数。

  在数据合并的时候，`ReplacingMergeTree` 从所有具有相同排序键的行中选择一行留下：

  - 如果 `ver` 列未指定，保留最后一条。
  - 如果 `ver` 列已指定，保留 `ver` 值最大的版本。

##### 3.2.8 数据副本

>只有MergeTree系列里的表可支持副本：
>
>- ReplicatedMergeTree
>- ReplicatedSummingMergeTree
>- ReplicatedReplacingMergeTree
>- ReplicatedAggregatingMergeTree
>- ReplicatedCollapsingMergeTree
>- ReplicatedVersionedCollapsingMergeTree
>- ReplicatedGraphiteMergeTree
>
>副本是表级别的，不是整个服务器级的。所以，服务器里可以同时有复制表和非复制表。副本不依赖分片。每个分片有它自己的独立副本。
>
>对于 `INSERT` 和 `ALTER` 语句操作数据的会在压缩的情况下被复制,而 `CREATE`，`DROP`，`ATTACH`，`DETACH` 和 `RENAME` 语句只会在单个服务器上执行，不会被复制。
>
>- `CREATE TABLE` 在运行此语句的服务器上创建一个新的可复制表。如果此表已存在其他服务器上，则给该表添加新副本。
>- `DROP TABLE` 删除运行此查询的服务器上的副本。
>- `RENAME` 重命名一个副本。换句话说，可复制表不同的副本可以有不同的名称
>
>**如果配置文件中没有设置 ZooKeeper ，则无法创建复制表，并且任何现有的复制表都将变为只读。**
>
>**`SELECT` 查询并不需要借助 ZooKeeper ，副本并不影响 `SELECT` 的性能，查询复制表与非复制表速度是一样的。**

**建表**

```sql
CREATE TABLE table_name (
    x UInt32
) ENGINE = ReplicatedMergeTree
ORDER BY x;
等价于
CREATE TABLE table_name (
    x UInt32
) ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/{database}/table_name', '{replica}')
ORDER BY x;
```

- `zoo_path` — ZooKeeper 中该表的路径。
- `replica_name` — ZooKeeper 中的该表的副本名称。
- `other_parameters` — 关于引擎的一系列参数，这个引擎即是用来创建复制的引擎，例如，`ReplacingMergeTree` 。

##### 3.2.9 SharedMergeTree

>仅在ClickHouse Cloud（以及第一方合作伙伴云服务）中提供,SharedMergeTree表引擎系列是ReplicatedMergeTree引擎的云原生替代方案，经过优化，适用于共享对象存储（例如Amazon S3、Google Cloud Storage、MinIO、Azure Blob Storage）。每个特定的MergeTree引擎类型都有对应的SharedMergeTree引擎，例如ReplacingSharedMergeTree替代ReplacingReplicatedMergeTree。

##### 3.2.10 SummingMergeTree

>该引擎继承自 [MergeTree](https://clickhouse.com/docs/zh/engines/table-engines/mergetree-family/mergetree)。区别在于，当合并 `SummingMergeTree` 表的数据片段时，ClickHouse 会把所有具有相同主键的行合并为一行，该行包含了被合并的行中具有数值数据类型的列的汇总值。如果主键的组合方式使得单个键值对应于大量的行，则可以显著的减少存储空间并加快数据查询的速度。

#### 3.3 日志引擎系列

>目的：为了需要写入许多小数据量（少于一百万行）的表的场景而开发的。
>
>分类：
>
>- StripeLog
>- Log
>- TinyLog
>
>共性：
>
>- 数据存储在磁盘上。
>- 写入时将数据追加在文件末尾。
>- 不支持[突变](https://clickhouse.com/docs/zh/engines/table-engines/log-family#alter-mutations)操作。
>- 不支持索引。
>- 非原子地写入数据。
>
>区别：
>
>+ 并发访问数据的锁。
>
>+ 并行读取数据。

##### 3.3.1 Log

>`Log` 与 `TinyLog` 的不同之处在于，«标记» 的小文件与列文件存在一起。这些标记写在每个数据块上，并且包含偏移量，这些偏移量指示从哪里开始读取文件以便跳过指定的行数。这使得可以在多个线程中读取表数据。对于并发数据访问，可以同时执行读取操作，而写入操作则阻塞读取和其它写入。`Log`引擎不支持索引。同样，如果写入表失败，则该表将被破坏，并且从该表读取将返回错误。`Log`引擎适用于临时数据，write-once 表以及测试或演示目的。Log
>
>`Log` 与 `TinyLog` 的不同之处在于，«标记» 的小文件与列文件存在一起。这些标记写在每个数据块上，并且包含偏移量，这些偏移量指示从哪里开始读取文件以便跳过指定的行数。这使得可以在多个线程中读取表数据。对于并发数据访问，可以同时执行读取操作，而写入操作则阻塞读取和其它写入。`Log`引擎不支持索引。同样，如果写入表失败，则该表将被破坏，并且从该表读取将返回错误。`Log`引擎适用于临时数据，write-once 表以及测试或演示目的。

##### 3.3.2 StripeLog

>在你需要写入许多小数据量（小于一百万行）的表的场景下使用这个引擎。

**建表**

```sql
CREATE TABLE [IF NOT EXISTS] [db.]table_name [ON CLUSTER cluster]
(
    column1_name [type1] [DEFAULT|MATERIALIZED|ALIAS expr1],
    column2_name [type2] [DEFAULT|MATERIALIZED|ALIAS expr2],
    ...
) ENGINE = StripeLog
```

**写数据**

`StripeLog` 引擎将所有列存储在一个文件中。对每一次 `Insert` 请求，ClickHouse 将数据块追加在表文件的末尾，逐列写入。

ClickHouse 为每张表写入以下文件：

- `data.bin` — 数据文件。
- `index.mrk` — 带标记的文件。标记包含了已插入的每个数据块中每列的偏移量。

`StripeLog` 引擎不支持 `ALTER UPDATE` 和 `ALTER DELETE` 操作。

**读数据**

> 带标记的文件使得 ClickHouse 可以并行的读取数据。这意味着 `SELECT` 请求返回行的顺序是不可预测的。使用 `ORDER BY` 子句对行进行排序。

##### 3.3.3 TinyLog

>最简单的表引擎，用于将数据存储在磁盘上。每列都存储在单独的压缩文件中。写入时，数据将附加到文件末尾。
>并发数据访问不受任何限制：
>如果同时从表中读取并在不同的查询中写入，则读取操作将抛出异常
>如果同时写入多个查询中的表，则数据将被破坏。
>这种表引擎的典型用法是 write-once：首先只写入一次数据，然后根据需要多次读取。查询在单个流中执行。换句话说，此引擎适用于相对较小的表（建议最多1,000,000行）。如果您有许多小表，则使用此表引擎是适合的，因为它比Log引擎更简单（需要打开的文件更少）。当您拥有大量小表时，可能会导致性能低下，但在可能已经在其它 DBMS 时使用过，则您可能会发现切换使用 TinyLog 类型的表更容易。不支持索引。在 Yandex.Metrica 中，TinyLog 表用于小批量处理的中间数据。

#### 3.4 集成的表引擎

>ClickHouse 提供了多种方式来与外部系统集成，包括表引擎。像所有其他的表引擎一样，使用`CREATE TABLE`或`ALTER TABLE`查询语句来完成配置。然后从用户的角度来看，配置的集成看起来像查询一个正常的表，但对它的查询是代理给外部系统的。这种透明的查询是这种方法相对于其他集成方法的主要优势之一，比如外部字典或表函数，它们需要在每次使用时使用自定义查询方法。

支持集成的方式：

+ JDBC
+ MYSQL
+ HDFS
+ KAFKA
+ RABBITMQ
+ HIVE
+ ……

##### 3.4.1 Mysql引擎

MySQL 引擎可以对存储在远程 MySQL 服务器上的数据执行 `SELECT` 查询。

调用格式：

```sql
MySQL('host:port', 'database', 'table', 'user', 'password'[, replace_query, 'on_duplicate_clause']);
```

**调用参数**

- `host:port` — MySQL 服务器地址。
- `database` — 数据库的名称。
- `table` — 表名称。
- `user` — 数据库用户。
- `password` — 用户密码。
- `replace_query` — 将 `INSERT INTO` 查询是否替换为 `REPLACE INTO` 的标志。如果 `replace_query=1`，则替换查询
- `'on_duplicate_clause'` — 将 `ON DUPLICATE KEY UPDATE 'on_duplicate_clause'` 表达式添加到 `INSERT` 查询语句中。例如：`impression = VALUES(impression) + impression`。如果需要指定 `'on_duplicate_clause'`，则需要设置 `replace_query=0`。如果同时设置 `replace_query = 1` 和 `'on_duplicate_clause'`，则会抛出异常。

此时，简单的 `WHERE` 子句（例如 `=, !=, >, >=, <, <=`）是在 MySQL 服务器上执行。

其余条件以及 `LIMIT` 采样约束语句仅在对MySQL的查询完成后才在ClickHouse中执行。

`MySQL` 引擎不支持可为空数据类型，因此，当从MySQL表中读取数据时，`NULL` 将转换为指定列类型的默认值（通常为0或空字符串）。

##### 3.4.2 JDBC

允许CH通过 [JDBC](https://en.wikipedia.org/wiki/Java_Database_Connectivity) 连接到外部数据库。

要实现JDBC连接，CH需要使用以后台进程运行的程序 [clickhouse-jdbc-bridge](https://github.com/ClickHouse/clickhouse-jdbc-bridge)。

该引擎支持 [Nullable](https://clickhouse.com/docs/zh/sql-reference/data-types/nullable) 数据类型。

**建表**

```sql
CREATE TABLE [IF NOT EXISTS] [db.]table_name
(
    columns list...
)
ENGINE = JDBC(datasource_uri, external_database, external_table)
```



**引擎参数**

- `datasource_uri` — 外部DBMS的URI或名字.

  URI格式: `jdbc:<driver_name>://<host_name>:<port>/?user=<username>&password=<password>`. MySQL示例: `jdbc:mysql://localhost:3306/?user=root&password=root`.

- `external_database` — 外部DBMS的数据库名.

- `external_table` — `external_database`中的外部表名或类似`select * from table1 where column1=1`的查询语句.

**用法示例**

通过mysql控制台客户端来创建表

```text
mysql> CREATE TABLE `test`.`test` (
    ->   `int_id` INT NOT NULL AUTO_INCREMENT,
    ->   `int_nullable` INT NULL DEFAULT NULL,
    ->   `float` FLOAT NOT NULL,
    ->   `float_nullable` FLOAT NULL DEFAULT NULL,
    ->   PRIMARY KEY (`int_id`));
Query OK, 0 rows affected (0,09 sec)

mysql> insert into test (`int_id`, `float`) VALUES (1,2);
Query OK, 1 row affected (0,00 sec)

mysql> select * from test;
+------+----------+-----+----------+
| int_id | int_nullable | float | float_nullable |
+------+----------+-----+----------+
|      1 |         NULL |     2 |           NULL |
+------+----------+-----+----------+
1 row in set (0,00 sec)
```

在CH服务端创建表，并从中查询数据：

```sql
CREATE TABLE jdbc_table
(
    `int_id` Int32,
    `int_nullable` Nullable(Int32),
    `float` Float32,
    `float_nullable` Nullable(Float32)
)
ENGINE JDBC('jdbc:mysql://localhost:3306/?user=root&password=root', 'test', 'test')
```

#### 3.5 Special引擎

#### 3.5.1 物化视图MaterializedView

>创建一个视图。它存在两种可选择的类型：普通视图与物化视图。
>
>普通视图不存储任何数据，只是执行从另一个表中的读取。换句话说，普通视图只是保存了视图的查询，当从视图中查询时，此查询被作为子查询用于替换FROM子句。
>
>SELECT a, b, c FROM view 等价于 SELECT a, b, c FROM (SELECT ...)
>
>物化视图存储的数据是由相应的SELECT查询转换得来的。在创建物化视图时，你还必须指定表的引擎 - 将会使用这个表引擎存储数据。目前物化视图的工作原理：当将数据写入到物化视图中SELECT子句所指定的表时，插入的数据会通过SELECT子句查询进行转换并将最终结果插入到视图中。
>
>如果创建物化视图时指定了**POPULATE子句**，则在创建时将该表的数据插入到物化视图中。就像使用`CREATE TABLE ... AS SELECT ...`一样。否则，物化视图只会包含在物化视图创建后的新写入的数据。我们不推荐使用POPULATE，因为在视图创建期间写入的数据将不会写入其中。
>
>当一个`SELECT`子句包含`DISTINCT`, `GROUP BY`, `ORDER BY`, `LIMIT`时，请注意，这些仅会在插入数据时在每个单独的数据块上执行。例如，如果你在其中包含了`GROUP BY`，则只会在查询期间进行聚合，但聚合范围仅限于单个批的写入数据。数据不会进一步被聚合。但是当你使用一些其他数据聚合引擎时这是例外的，如：`SummingMergeTree`。因此常用的引擎是`SummingMergeTree`
>
>目前对物化视图执行`ALTER`是不支持的，因此这可能是不方便的。如果物化视图是使用的`TO [db.]name`的方式进行构建的，你可以使用`DETACH`语句先将视图剥离，然后使用`ALTER`运行在目标表上，然后使用`ATTACH`将之前剥离的表重新加载进来。视图看起来和普通的表相同。例如，你可以通过`SHOW TABLES`查看到它们。没有单独的删除视图的语法。如果要删除视图，请使用`DROP TABLE`。

简单来说：

视图保存的是一个select语句的查询结果

物化视图保存的是一个select语句的查询结果+数据

**物化视图注意事项**

1.创建物化视图的时候必须指定物化视图的engine 用于数据存储

2.POPULATE可以在创建视图的时候就开始导入数据，如果不加，只能在创建视图后添加数据。但是官方不推荐使用。

3.TO [db].[table]语法的时候，不得使用POPULATE。to一个目标表，可以将视图表原表信息根据视图规则将数据发送到目标表。
3.查询语句(select）可以包含下面的子句： DISTINCT, GROUP BY, ORDER BY, LIMIT…
4.物化视图的alter操作有些限制，操作起来不大方便。
5.物化视图是种特殊的数据表，可以用show tables 查看

**物化视图查询如此之快？**
空间换时间,因为物化视图这些规则已经全部写好并且条件所过滤后的数据已经存储在了本地表中，所以它比原数据查询快了很多，总的行数少了，因为都预计算好了。
缺点：它的本质是一个流式数据的使用场景，是累加式的技术，所以要用历史数据做去重、去核这样的分析，在物化视图里面是不太好用的。在某些场景的使用也是有限的。而且如果一张表加了好多物化视图，在写这张表的时候，就会消耗很多机器的资源，比如数据带宽占满、存储一下子增加了很多。

**示例：**

1.创建一个数据表

```sql
create table order_detail 
(
   id String,
   sku_id  String,
   pay_number Int32,
   pay_amount Int32, 
   order_date Date 
)
ENGINE = MergeTree()
partition by toYYYYMMDD(order_date)
order by (id,sku_id);
```

2.插入数据

```sql
insert into order_detail values
('001','a',2,20,'2021-08-13'),
('002','a',3,30,'2021-08-16'),
('002','b',2,40,'2021-08-16');
```

3.创建物化视图

>选用SummingMergeTree引擎，支持以主键分组，对数值型指标做自动累加。每当表的parts做后台merge的时候，主键相同记录合并成一行记录，节省空间。
>
>**不指定POPULATE**

```sql
CREATE MATERIALIZED VIEW order_mv1
ENGINE=SummingMergeTree
PARTITION BY toYYYYMMDD(order_date) ORDER BY (id,order_date)
[是否指定 populate] AS SELECT
id,
order_date,
sum(pay_number) as number,
sum(pay_amount) as amount
FROM order_detail
WHERE order_date > '2021-08-14'
GROUP BY id,order_date;
```

4.查看表信息与视图信息

>查看当前表
>
>show tables;
>
>#视图表
>
>order_mv1
>
>#源表
>
>order_detail
>
>#持久化表
>
>.join开头的表
>
>我们查看视图并无表信息，这是因为我们并为只用populate导致，未指定populate时，只有当原表进行了数据的插入操作，视图才能监听到后续插入进表的数据，如果之前有数据，则无法监听到。

5.再次插入数据

```sql
insert into order_detail values
('003','b',2,40,'2021-08-12'),
('003','a',2,20,'2021-08-16'),
('003','c',1,30,'2021-08-16'),
('004','a',2,20,'2021-08-16'),
('004','d',5,200,'2021-08-16'),
('005','a',5,50,'2021-08-17'),
('006','d',3,120,'2021-08-18');
```

>此时查看视图发现数据已经存在

6.创建目标表

```sql
create table order_des
(
   id String,
   sku_id  String,
   pay_number Int32,
   pay_amount Int32, 
   order_date Date 
)
ENGINE = MergeTree()
partition by toYYYYMMDD(order_date)
order by (id,sku_id);
```

7.创建将数据传输到表中物化视图

```sql
CREATE MATERIALIZED VIEW order_mv3
to order_des
AS SELECT
id,
order_date,
sum(pay_number) as number,
sum(pay_amount) as amount
FROM order_detail
WHERE order_date > '2021-08-14'
GROUP BY id,order_date;
```



## 性能测试

1.下载1亿数据

> curl https://datasets.clickhouse.com/hits/tsv/hits_100m_obfuscated_v1.tsv.xz | unxz --threads=`nproc` > hits_v1.tsv
>
> 

2.Validate the checksum

> md5sum hits_v1.tsv
>
> Checksum should be equal to: f3631b6295bf06989c1437491f7592cb

3.创建数据表

```shell
clickhouse-client --query="CREATE TABLE tutorial.hits_100m_obfuscated (WatchID UInt64, JavaEnable UInt8, Title String, GoodEvent Int16, EventTime DateTime, EventDate Date, CounterID UInt32, ClientIP UInt32, RegionID UInt32, UserID UInt64, CounterClass Int8, OS UInt8, UserAgent UInt8, URL String, Referer String, Refresh UInt8, RefererCategoryID UInt16, RefererRegionID UInt32, URLCategoryID UInt16, URLRegionID UInt32, ResolutionWidth UInt16, ResolutionHeight UInt16, ResolutionDepth UInt8, FlashMajor UInt8, FlashMinor UInt8, FlashMinor2 String, NetMajor UInt8, NetMinor UInt8, UserAgentMajor UInt16, UserAgentMinor FixedString(2), CookieEnable UInt8, JavascriptEnable UInt8, IsMobile UInt8, MobilePhone UInt8, MobilePhoneModel String, Params String, IPNetworkID UInt32, TraficSourceID Int8, SearchEngineID UInt16, SearchPhrase String, AdvEngineID UInt8, IsArtifical UInt8, WindowClientWidth UInt16, WindowClientHeight UInt16, ClientTimeZone Int16, ClientEventTime DateTime, SilverlightVersion1 UInt8, SilverlightVersion2 UInt8, SilverlightVersion3 UInt32, SilverlightVersion4 UInt16, PageCharset String, CodeVersion UInt32, IsLink UInt8, IsDownload UInt8, IsNotBounce UInt8, FUniqID UInt64, OriginalURL String, HID UInt32, IsOldCounter UInt8, IsEvent UInt8, IsParameter UInt8, DontCountHits UInt8, WithHash UInt8, HitColor FixedString(1), LocalEventTime DateTime, Age UInt8, Sex UInt8, Income UInt8, Interests UInt16, Robotness UInt8, RemoteIP UInt32, WindowName Int32, OpenerName Int32, HistoryLength Int16, BrowserLanguage FixedString(2), BrowserCountry FixedString(2), SocialNetwork String, SocialAction String, HTTPError UInt16, SendTiming UInt32, DNSTiming UInt32, ConnectTiming UInt32, ResponseStartTiming UInt32, ResponseEndTiming UInt32, FetchTiming UInt32, SocialSourceNetworkID UInt8, SocialSourcePage String, ParamPrice Int64, ParamOrderID String, ParamCurrency FixedString(3), ParamCurrencyID UInt16, OpenstatServiceName String, OpenstatCampaignID String, OpenstatAdID String, OpenstatSourceID String, UTMSource String, UTMMedium String, UTMCampaign String, UTMContent String, UTMTerm String, FromTag String, HasGCLID UInt8, RefererHash UInt64, URLHash UInt64, CLID UInt32) ENGINE = MergeTree() PARTITION BY toYYYYMM(EventDate) ORDER  BY (CounterID, EventDate, intHash32(UserID)) SAMPLE BY intHash32(UserID) SETTINGS index_granularity = 8192"
```



