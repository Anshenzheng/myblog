---
title: Cassandra 概要介绍
date: 2017-08-01 12:39:57
tags: ["Cassandra","NoSQL"]
categories: "数据库"
---
Cassandra只一个开源分布式NoSQL数据库，具有高度可扩展性和高可用性，可用于管理大量的结构化和非结构化数据, 主要特性如下
1. 具有持续可用性， 线性扩展性， 易于管理大量服务器和不会有单点故障等特性
2. 支持非常方便的列索引， 高性能的日志结构数据更新，强大的非规格化和物化视图以及缓存功能
3. 采用去中心化的架构。
所有的节点都是平等的, Cassandra自动化地在环或者说数据库集群的所有节点之间进行数据分发。
开发人员或管理人员无法也没必要通过程序来控制数据分发，因为集群里所有几点的数据分区对用户是透明的
4. 提供了内建的可定制的replication机制， 在整个集群的节点上保存冗余的数据副本
5. 具有线性扩展性，也就是说可以简单的在线添加新节点从而增加集群的处理能力。
例如，如果每两个节点每秒处理100,000个事务， 4个几点就能每秒处理200,000个事务。

### Cassandra基本数据模型

#### Cluster 集群
Cassandra数据分布在不同的机器集群节点上。

#### Keyspace
Keyspace相当于关系数据库中的数据库，是一系列Column Family的集合。
创建keyspace时需指定如下几种属性：
- replication_factor 复制因子
集群中接收相同数据副本的计算机数。

- stategry class 副本放置策略
1. SimpleStrategry 简单策略
为集群指定简单的复制因子

2. 旧网络拓扑策略
单独为每个数据中心设置复制因子

3. 网络拓扑策略
单独为每个数据中心设置复制因子

 创建语法
 ``` sql
 CREATE KEYSPACE Keyspace name
 WITH replication={'class': 'SimpleStrategry', 'replication_factor': 3}
 ```
Keysspace示意图
![](http://www.web3.xin/uploads/image/2017/02/12/20170212103220_60671.jpg)
#### Column Family
Column Family相当于关系数据库中的表，是一系列Column的集合，在该集合中，每个Column都会有一个与之相关联的键：
``` Javascript
Authors = {
  "1234": {
    "name": "Harry",
    "age": 18
  },
  "5678":{
    "name": "Lucy",
    "age": 19
  }
}
```
#### Column
Column是Cassandra所支持的最基础的数据模型，可以包含一系列的键值对：
``` Javascript
{
  "name": "Author Name",
  "value": "Harry",
  "timestamp": 123456789
}
```
#### Super Column
Super Column是包含了一系列Column:
``` Javascript
{
  "name": "Cassandra Introduction",
  "value": {
    "author": {"name": "Author Name", "value": "Harry", "timestamp": "123456789"},
    "publisher": {"name":"Publisher", "value": "China Press", "timestamp": 223154878}
  }
}
```
> Cassandra官方文档不建议过多使用Super Column

#### Primary Key & Composite Key & Partition Key & Clustering Key
主键, 定义Cassandra数据表时指定，可以指定一个字段也可以指定多个字段。
``` sql
create table user(
user_id text PRIMARY KEY,
user_name text
);
```

组合主键 - Composite Key, 下例中key_one和key_two组成Composite Key.
``` sql
create table sampe(
 key_one text,
 key_two text,
 data text,
 PRIMARY KEY(key_one, key_two)
);
```
Composite key中的第一组成为Partition Key, 后面各组称为Clustering Key.

Partition Key用于决定Cassandra会使用集群中哪个结点来记录该数据， 每个PartitionKey对应着一个Parition.
Clustering Key用来在Partition内部排序。

在CQL语句中， WHERE等子句所标识的条件只能使用在Primary Key中所使用的列。

### COL - Cassandra Query Language

### Java中Cassandra数据库的操作
``` Java
Cluster cluster = null;
try{
  //创建连接到Cassandra客户端
  cluster = Cluster.builder()
                   .addContactPoint("127.0.0.1")
                   .build();
  //创建用户会话
  Session session = cluster.connect();
  
  //执行CQL语句
  ResultSet rs = session.execute("select release_version from system.local");
  
  //从返回结果中取出第一条结构
  Row row = rs.one();
  
   System.out.println(row.getString("release_version"));

  //创建并使用keyspace 
  String query = "CREATE KEYSPACE tp WITH replication = {'class':'SimpleStrategry', 'replication_factor':3}";
  session.execute(query);
  session.execute("USE tp");
  
}finally{
  if(cluster != null){
    cluster.close();
  }
}
```

### Cassandra内部存储结构
Cassandra写入数据之前，需要先记录日志(CommitLog), 然后数据开始写入到ColumnFamily对应的Memtable中,Memtable是一种按照Key排序数据的内存结构，在满足一定条件时，再把Memtable中的数据批量持久化到磁盘上，存储在SSTable中。

Cassandra数据信息分为3类：
- data目录
用户存储真正的数据文件，是SSTable文件, 可以指定多个目录
- commitlog目录
用于存储未写入SSTable中的数据
- cache目录
用户存储系统中的缓存数据，在服务重启时，从此目录加载缓存数据。

参考：
[cassandra教程](http://www.web3.xin/cassandra/174.html)


