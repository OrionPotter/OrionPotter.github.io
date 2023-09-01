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
    <!--集群配置-->
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
    <!--keeper配置-->
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
CREATE TABLE tutorial.hits_v1
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
CREATE TABLE tutorial.hits_all on cluster perftest_3shards_1replicas AS tutorial.hits_local
ENGINE = Distributed(perftest_3shards_1replicas, tutorial, hits_local, rand());
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
