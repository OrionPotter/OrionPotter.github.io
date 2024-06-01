---
title: Redis的数据结构的实际应用
tag:
- redis
---

# String（字符串）

## 原理

字符串是Redis中最简单的类型，可以存储任何形式的字符串值，包括数字、字节数组等。字符串值最多可以达到512MB。

## 应用场景

- **缓存**：网页内容缓存，提高访问速度。
- **计数器**：记录网站访问次数。
- **会话管理**：存储用户会话信息。
- **简单的键值存储**：存储用户信息。

## 常用命令及参数

- `SET key value`：设置指定key的值。
- `GET key`：获取指定key的值。
- `INCR key`：将指定key的值加1。

## 示例代码

```java
import redis.clients.jedis.Jedis;

public class RedisStringExample {
    public static void main(String[] args) {
        // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 缓存网页内容
        jedis.set("page:home", "<html>...</html>");

        // 计数器
        jedis.incr("page_views");
        String pageViews = jedis.get("page_views");
        System.out.println("Page views: " + pageViews);  // 输出：1

        // 会话管理
        jedis.set("session:user123", "session_data");

        // 简单的键值存储
        jedis.set("user:1001:username", "john_doe");
        String username = jedis.get("user:1001:username");
        System.out.println(username);  // 输出：john_doe

        jedis.close();
    }
}
```

# Hash（哈希）

## 原理

哈希是一个键值对集合，特别适用于存储对象。哈希可以高效地存储和访问对象的多个字段。

## 应用场景

- **存储对象**：例如用户信息。
- **配置项**：存储应用程序配置。

## 常用命令及参数

- `HSET key field value`：设置哈希表中指定字段的值。
- `HGET key field`：获取哈希表中指定字段的值。
- `HGETALL key`：获取哈希表中所有字段的值。

## 示例代码

```java
import redis.clients.jedis.Jedis;

public class RedisHashExample {
    public static void main(String[] args) {
        // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 存储用户信息
        jedis.hset("user:1000", "name", "Alice");
        jedis.hset("user:1000", "email", "alice@example.com");

        // 获取用户信息
        String userName = jedis.hget("user:1000", "name");
        String userEmail = jedis.hget("user:1000", "email");
        System.out.println(userName);  // 输出：Alice
        System.out.println(userEmail);  // 输出：alice@example.com

        // 存储配置项
        jedis.hset("config", "theme", "dark");
        jedis.hset("config", "version", "1.2.3");

        // 获取配置项
        String theme = jedis.hget("config", "theme");
        String version = jedis.hget("config", "version");
        System.out.println("Theme: " + theme);  // 输出：dark
        System.out.println("Version: " + version);  // 输出：1.2.3

        jedis.close();
    }
}
```

# List（列表）

## 原理

列表是一个链表，可以从两端进行高效操作。适用于需要按顺序访问元素的场景。

## 应用场景

- **消息队列**：实现简单的消息队列系统。
- **任务列表**：存储待处理的任务。
- **最新消息**：存储按时间顺序的消息。

## 常用命令及参数

- `LPUSH key value`：将一个值插入到列表头部。
- `RPUSH key value`：将一个值插入到列表尾部。
- `RPOP key`：移除并返回列表的最后一个元素。
- `LRANGE key start stop`：获取列表在指定范围内的元素。

## 示例代码

```java
import redis.clients.jedis.Jedis;

public class RedisListExample {
    public static void main(String[] args) {
        // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 实现消息队列
        jedis.lpush("message_queue", "message1");
        jedis.lpush("message_queue", "message2");

        // 从队列中取出消息
        String message = jedis.rpop("message_queue");
        System.out.println("Message: " + message);  // 输出：message1

        // 存储待处理的任务
        jedis.lpush("task_list", "task1");
        jedis.lpush("task_list", "task2");

        // 获取待处理的任务
        String task = jedis.rpop("task_list");
        System.out.println("Task: " + task);  // 输出：task1

        // 存储最新消息
        jedis.lpush("news_feed", "news1");
        jedis.lpush("news_feed", "news2");

        // 获取最新消息
        List<String> newsFeed = jedis.lrange("news_feed", 0, 1);
        for (String news : newsFeed) {
            System.out.println("News: " + news);
        }
        // 输出：news2, news1

        jedis.close();
    }
}
```

# Set（集合）

## 原理

集合是无序的唯一元素集合，提供高效的成员检查和去重功能。

## 应用场景

- **标签**：存储用户的兴趣标签。
- **唯一性检查**：检查某个元素是否存在。
- **共同好友**：找出共同好友。
- **去重**：去除重复数据。

## 常用命令及参数

- `SADD key member`：向集合添加一个或多个成员。
- `SISMEMBER key member`：判断成员是否是集合的成员。
- `SMEMBERS key`：返回集合中的所有成员。

## 示例代码

```java
import redis.clients.jedis.Jedis;

public class RedisSetExample {
    public static void main(String[] args) {
        // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 存储用户的兴趣标签
        jedis.sadd("user:1000:tags", "music", "sports", "travel");

        // 检查标签是否存在
        boolean isTagExist = jedis.sismember("user:1000:tags", "music");
        System.out.println("Is tag 'music' exist: " + isTagExist);  // 输出：true

        // 获取所有标签
        Set<String> tags = jedis.smembers("user:1000:tags");
        for (String tag : tags) {
            System.out.println("Tag: " + tag);
        }
        // 输出：music, sports, travel

        // 存储用户1和用户2的朋友列表
        jedis.sadd("user:1:friends", "user2", "user3", "user4");
        jedis.sadd("user:2:friends", "user3", "user4", "user5");

        // 找出共同好友
        Set<String> commonFriends = jedis.sinter("user:1:friends", "user:2:friends");
        for (String friend : commonFriends) {
            System.out.println("Common friend: " + friend);
        }
        // 输出：user3, user4

        // 去除重复数据
        jedis.sadd("duplicates", "1", "2", "3", "3", "4", "4");
        Set<String> uniqueElements = jedis.smembers("duplicates");
        for (String element : uniqueElements) {
            System.out.println("Unique element: " + element);
        }
        // 输出：1, 2, 3, 4

        jedis.close();
    }
}
```

# Sorted Set（有序集合）

## 原理

有序集合是带有分数的集合，集合中的元素是有序的。适用于需要按权重排序的场景。

## 应用场景

- **排行榜**：实现游戏的排行榜。
- **延迟队列**：存储带有时间戳的任务。
- **按评分排序**：存储商品列表。

## 常用命令及参数

- `ZADD key score member`：向有序集合添加一个成员，或者更新已存在成员的分数。
- `ZREM key member`：移除有序集合中的一个成员。
- `ZRANGE key start stop [WITHSCORES]`：返回有序集中指定区间内的成员。

## 示例代码

```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Tuple;

import java.util.Set;

public class RedisSortedSetExample {
    public static void main(String[] args) {
       

 // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 实现游戏的排行榜
        jedis.zadd("leaderboard", 100, "Alice");
        jedis.zadd("leaderboard", 200, "Bob");

        // 获取排行榜
        Set<Tuple> leaderboard = jedis.zrevrangeWithScores("leaderboard", 0, -1);
        for (Tuple tuple : leaderboard) {
            System.out.println(tuple.getElement() + ": " + tuple.getScore());
        }
        // 输出：Bob: 200.0, Alice: 100.0

        // 存储带有时间戳的任务
        jedis.zadd("task_queue", System.currentTimeMillis() / 1000, "task1");
        jedis.zadd("task_queue", System.currentTimeMillis() / 1000 + 10, "task2");

        // 获取任务列表
        Set<String> tasks = jedis.zrange("task_queue", 0, -1);
        for (String task : tasks) {
            System.out.println("Task: " + task);
        }
        // 输出：task1, task2

        // 存储按评分排序的商品列表
        jedis.zadd("products", 9.8, "ProductA");
        jedis.zadd("products", 8.6, "ProductB");

        // 获取商品列表
        Set<Tuple> products = jedis.zrangeWithScores("products", 0, -1);
        for (Tuple product : products) {
            System.out.println(product.getElement() + ": " + product.getScore());
        }
        // 输出：ProductB: 8.6, ProductA: 9.8

        jedis.close();
    }
}
```

# Bitmap（位图）

## 原理

位图是对字符串类型的进一步扩展，提供按位操作，适用于大规模数据的快速统计。

## 应用场景

- **用户签到**：记录用户每天的签到情况。
- **统计**：统计某个时间段内的活跃用户。
- **布隆过滤器**：用于快速判断某个元素是否存在。

## 常用命令及参数

- `SETBIT key offset value`：对key指定偏移量上的位进行设置。
- `GETBIT key offset`：对key指定偏移量上的位进行获取。
- `BITCOUNT key [start end]`：统计字符串被设置为1的bit数。

## 示例代码

```java
import redis.clients.jedis.Jedis;

public class RedisBitmapExample {
    public static void main(String[] args) {
        // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 记录用户签到
        jedis.setbit("user:1000:checkin", 1, true);
        jedis.setbit("user:1000:checkin", 2, true);

        // 检查用户是否签到
        boolean isCheckedInDay1 = jedis.getbit("user:1000:checkin", 1);
        boolean isCheckedInDay2 = jedis.getbit("user:1000:checkin", 2);
        System.out.println("Day 1 check-in: " + isCheckedInDay1);  // 输出：true
        System.out.println("Day 2 check-in: " + isCheckedInDay2);  // 输出：true

        // 统计签到次数
        long checkinCount = jedis.bitcount("user:1000:checkin");
        System.out.println("Check-in count: " + checkinCount);  // 输出：2

        jedis.close();
    }
}
```

# HyperLogLog

## 原理

HyperLogLog是基数估计算法，可以在低内存消耗下进行大规模基数统计，适用于去重统计。

## 应用场景

- **基数统计**：统计网站的独立访问用户数（UV）。

## 常用命令及参数

- `PFADD key element [element ...]`：将元素添加到HyperLogLog中。
- `PFCOUNT key`：返回HyperLogLog的基数估算值。

## 示例代码

```java
import redis.clients.jedis.Jedis;

public class RedisHyperLogLogExample {
    public static void main(String[] args) {
        // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 添加独立访问用户
        jedis.pfadd("unique_visitors", "user1", "user2", "user3");

        // 获取独立访问用户数
        long uvCount = jedis.pfcount("unique_visitors");
        System.out.println("Unique visitors: " + uvCount);  // 输出：3

        jedis.close();
    }
}
```

# Geo（地理空间）

## 原理

地理空间类型允许存储地理位置数据，并提供半径查询功能，适用于地理位置存储与查询。

## 应用场景

- **存储地理位置**：存储用户或商家的地理位置。
- **查询附近的用户或商家**：实现“附近的人”或“附近的商家”功能。

## 常用命令及参数

- `GEOADD key longitude latitude member`：将地理空间位置（纬度、经度、名称）添加到指定的key中。
- `GEORADIUS key longitude latitude radius unit`：以给定的经纬度为中心，返回指定半径范围内的地理位置。

## 示例代码

```java
import redis.clients.jedis.Jedis;

import java.util.List;

public class RedisGeoExample {
    public static void main(String[] args) {
        // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 添加地理位置
        jedis.geoadd("locations", 13.361389, 38.115556, "Palermo");
        jedis.geoadd("locations", 15.087269, 37.502669, "Catania");

        // 查询附近位置
        List<String> nearby = jedis.georadius("locations", 15, 37, 200, "km");
        for (String location : nearby) {
            System.out.println("Nearby location: " + location);
        }
        // 输出：Catania, Palermo

        jedis.close();
    }
}
```

# Stream（流）

## 原理

流是一种日志结构数据类型，可以添加和读取数据项，适用于实时数据流处理。

## 应用场景

- **实时数据流处理**：处理传感器数据。
- **日志收集**：收集和处理日志数据。
- **消息队列**：实现复杂的消息队列系统。

## 常用命令及参数

- `XADD key ID field value [field value ...]`：向流中添加一个消息。
- `XRANGE key start end [COUNT count]`：返回指定区间内的流消息。

## 示例代码

```java
import redis.clients.jedis.Jedis;
import redis.clients.jedis.StreamEntry;
import redis.clients.jedis.StreamEntryID;

import java.util.List;
import java.util.Map;

public class RedisStreamExample {
    public static void main(String[] args) {
        // 连接到Redis
        Jedis jedis = new Jedis("localhost", 6379);

        // 添加消息到流
        jedis.xadd("mystream", StreamEntryID.NEW_ENTRY, Map.of("sensor_id", "sensor1", "temperature", "20"));

        // 读取消息
        List<StreamEntry> messages = jedis.xrange("mystream", null, null, 10);
        for (StreamEntry message : messages) {
            System.out.println(message.getFields());
        }
        // 输出：[{sensor_id=sensor1, temperature=20}]

        jedis.close();
    }
}
```

