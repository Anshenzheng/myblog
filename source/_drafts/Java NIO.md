---
title: Java NIO
date: 2017-07-07 17:37:40
---
### 原理
对于网络通信而言，NIO/AIO并没有改变网络通信的基本步骤，只是在ServerSocket和Socket基础上做了一个改进。

ServerSocket和Socket基于TCP建立连接，需要三次握手，性能开销比较大。NIO则是在已经建立好的TCP连接之上，对读写采用抽象的管道的概念。

### NIO中的组件：
#### Channel
Channel是在一个TCP连接之间的抽象，一个TCP连接可以对应多个管道，而不是以前的只有一个通信信道的概念， 这样减少了TCP的连接次数。UDP也是采用相似的方式。

#### Selector
Selector相当于一个管家，管理所有的IO事件，包括Connection, Accept, 客户端服务端的读写等等。
当IO事件注册给选择器的时候，选择器会给IO事件分配一个key用于标示该事件，当IO事件完成之后会通过Key找到相应的Channel，之后通过管道发送数据/接收数据等操作。
