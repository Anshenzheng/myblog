---
title: 常见分布式全局唯一ID生成方案
tags: ["分布式","ID"]
categories: "架构"
---
一般而言，几乎在任何系统中，我们都需要使用唯一的ID去识别以及操作应用中的对象，比如对用户管理而言需要用户ID，对订单管理而言需要订单ID。
在小的项目中，我们可以直接使用数据库的自增长特性来生成主键的ID，这样简单且易实现。但是在分库分表的分布式环境中，数据往往分布在不同的分片上，如果再通过数据库的自增长特性，势必会造成主键重复。

这就需要我们采用一些分布式全局唯一ID的生成方案，以下介绍几种常见的全局ID生成方案：

### Twitter的Snowflake算法(雪花算法)
Twitter服务器上每秒钟都会有上百万条新的Twitter消息产生，每条消息都需要分配唯一的ID，而且为了方便客户端的排序，这些ID还需要一些大致的书序，为了解决这样一个问题，Twitter创建了Snowflake算法。

#### [Snowflake](https://github.com/twitter/snowflake/tree/snowflake-2010)算法核心 
twitter生成的ID是64bits整数型，64位组成结构如下：
标记位(1位，不可用)+时间戳(41位) + 机器ID(10位) + 序列号(12位)

* 标记位
标记位一般为0， 不可以使用。

* 时间戳
时间戳有41位，可以表示的数据为0 ~ 2^41，这里的时间戳的细度是毫秒级的，那么计算可知可以使用 2^41/(365*24*60*60*1000) = 69.73年。 
具体生成代码如下:
```
uint64_t generateStamp(){
	timeval tv;
	gettimeofday(&tv, 0);
	return (uint64v_t)tv.tv_sec*1000 + (uint64v_t)tv.tv_usec/1000;
}
```


* 机器ID
机器位有10位， 2^10 = 1024, 即可以支持1024台机器。

* 序列号位
序列号分配有12位，2^12 = 4096, 即每毫秒支持产生4096个自增序列的ID。

### UUID/GUID 
UUID是一个由4个连字号(-)将32个字符长的字符串分割后生成的字符串,总共长36个字符长，它的生成主要基于以下几部分组合：
1. 当前的日期和时间
2. 时钟序列
3. 全局唯一的机器识别号(如果有网卡就从网卡的MAC地址获得,如果没有就以其它方式获得)

GUID(Globally Unique Identifier)是微软对UUID标准的实现,它是根据机器网卡的MAC地址再加上一个特定算法产生的二进制长度为128位的字符表示符。

UUID/GUID唯一的缺点是生成的结果比较长.

Java中UUID生成代码
```Java
public static void main(String[] args){

	String uuid = UUID.randomUUID().toString();
	
	//去掉"-"的UUID
	String shortUUID = str.substring(0, 8) + str.substring(9, 13) + str.substring(14, 18) + str.substring(19, 23) + str.substring(24); 
	
	System.out.println(uuid);
	System.out.println(shortUUID);
}
```

### MongoDB ObjectID
mongodb会为每条插入collection不包含"id"的记录自动生成一个24位字符长的objectId, 例如"4e7020cb7cac81af7136236b".

这个24位的字符串实际上由一组16禁止的字符构成，每个字节两位十六禁止数字，总共用了12字节的存储空间。

根据官网中ObjectId规范的描述，它的组成结构如下:
![](http://pic002.cnblogs.com/images/2011/83478/2011091823160647.png)
*  时间戳(4bytes - 32bits)

将前4位进行提取，然后按照十六进制转换成十进制，就可以得到一个时间

*  机器ID(3bytes - 24bits)

接下来3个字节是所在主机的唯一表示符，一般是主机名的散列值。

*  进程ID - PID(2bytes - 16bits)

pid是为了在同一机器下不同mongodb进程产生的objectID不冲突。

*  自增计数器 - INC(3bytes - 24bits)

确保同一秒内产生的objectId也不会冲突。

参考文章：[MongoDB深究之ObjectId](http://www.cnblogs.com/xjk15082/archive/2011/09/18/2180792.html) 

