---
title: JMS
date: 2016-06-08 12:39:57
tags: ["JMS","中间件"]
categories: "中间件"
---
### 什么是JMS
- JMS是Java Message Servie的缩写
- 它是一个用于在不同的客户端之间传递消息的Java消息的中间件应用接口
- 它是处理生产者消费者问题的一种实现
- 它也是一种消息标准，允许应用组件在J2EE平台创建，发送，接受和读取消息

JMS和JDBC很像，Java只是提供了一个访问JMS服务器以及进行消息处理的API标准，它完全独立于中间件消息服务器，就像JDBC独立于Oracle/Mysql之类的数据库一样。

### JMS的消息模型

- P2P 端到端模型
P2P模型的target是队列(Queue), 消息首先发送到队列中, 之后在从队列中发送给监听队列的客户端中。一个队列可以连接多个消息发送方和多个消息接收方, 但是一个消息只能发送给一个接受者。如果有多个接收方都在监听队列中的消息, 那么JMS消息的发送将基于FCFS(First Come, First Server)原则。如果没有接收方监听队列, 那么消息将一直保存在队列中, 直到有接收方连接到队列。
![](https://github.com/Anshenzheng/ImageStore/blob/master/JMS%20P2P.PNG?raw=true)

- Pub/Sub 发布订阅模型
Pub/Sub模型中，一个消息可以从一个应用发送给多个接收者, 此时的target是topic。消息首先被发送至topic中, 之后会发送给所有订阅了该topic的接收者。
![](https://github.com/Anshenzheng/ImageStore/blob/master/JMS%20P2S.PNG?raw=true)

### JMS的使用

#### JMS API模块
![](https://github.com/Anshenzheng/ImageStore/blob/master/JMS%20API%20Modules.PNG?raw=true)
- Administered Objects
Administered Objects是预配置的JMS对象, 它有系统管理员创建, 用于管理Connection Factory和Destination。

- Connection Factories
客户端通过Connection Factory创建通JMS服务器之间的连接。JMS客户端会在JNDI命名空间中查找并创建连接, 通target之间建立连接之后, 就可以发送或者接收消息。

代码示例
``` Java
QueueConnectionFactory factory = (QueueConnectionFactory)initialCxt.lookup("primaryQCF");
Queue puchaseQueue = (Queue)initialCxt.lookup("Purchase_Queue");
Queue returnQueue = (Queue)initialCtx.lookup("Return_Queue");
```
- Destination
Destination指明消息发送的目标, 或者消息的来源, 可以是Queue也可以是Topic。

创建Queue代码示例:
``` Java
QueueSession session = con.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);
Queue queue = (Queue)ctx.lookup("myQueue");
QueueReceiver receiver = session.createReceiver(queue);
```
创建Topic代码示例:
``` Java
TopicSession session = con.createTopicSession(false, Session.AUTO_ACKNOWLEDGE);
Topic topic = (Topic)ctx.lookup("myTopic");
TopicSubscriber receiver = session.createSubscriber(topic);
```
- Connection
Connection用于连接JMS服务器。
``` Java
//创建连接
Connection connection = connectionFactory.createConnection();
//关闭连接
connection.close();
```
- Sessions
Session是一个单线程上下文对象, 用于创建生产者或者消费者。
``` Java
//创建Session
Session session = connection.createSession(false,Session.AUTO_ACKNOWLEDGE);
```
- Message Producer
消息生产者由Session创建，用于发送消息到Destination。
``` Java
MessageProducer producer = session.createProducer(dest);
MessageProducer producer2 = session.createProducer(queue);
MessageProducer producer3 = session.createProducer(topic);

producer.send(message);
```
- Message Consumers
消息消费者也是由Session创建, 用于从Destination接收消息。
``` Java
MessageConsummer consummer = session.createConsummer(dest);
MessageConsummer consummer2 = session.createConsummer(queue);
MessageConsummer consummer3 = session.createConsummer(topic);

consummer.send(message);
```
- Message Listeners
消息监听器是默认的事件处理器, 它是MessageListener接口的实现, 该接口中包含的onMessage方法用于处理消息发送成功之后的处理逻辑。
``` Java
Listener myListener = new Listener();
Consummer.setMessageListener(myListener);
```
### JMS消息结构
JMS客户端通过JMS消息同JMS服务器进行交互, JMS消息包括以下3部分:
#### Message Header 消息头
消息头中预定义了一些字段用于JMS客户端和JMS服务器之间的识别和消息传送。

消息头：
- JMSDestination
- JMSDeliveryMode
- JMSMessageID
- JMSTimestamp
- JMSCorrelationID
- JMSReplyTo
- JMSRedelivered
- JMSType
- JMSExpiration
- JMSPriority

#### Message Property 消息属性
消息属性可以由用户自定义，主要是提供给应用程序使用, 可以用于消息过滤。
JMS API提供的也有一些标准的属性信息。

#### Message Body 消息体
JMS提供的消息体有以下5种：
- Text Message
javax.jms.TextMessage

- Object Message
javax.jms.ObjectMessage

- Bytes Message
javax.jms.BytesMessage

- Stream Message
javax.jms.streamMessage

- Map Message
javax.jms.MapMessage

#### JMS的使用示例

[Tomcat + JNDI + ActiveMQ P2P](http://www.cnblogs.com/chenpi/p/5565618.html)

[Tomcat + JNDI + ActiveMQ Pub/Sub](http://www.cnblogs.com/chenpi/p/5566983.html)
