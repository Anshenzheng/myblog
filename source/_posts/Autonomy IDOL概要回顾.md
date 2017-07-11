---
title: Autonomy IDOL
tags: ["搜索","Autonomy"]
categories: "大数据"
---
几年前在HP曾做过几个Autonomy IDOL(现在的HPE IDOL)相关的项目, IDOL的功能相当强大, 而我们只主要用到了的相关性查询, 情感分析, Logo识别, 人脸识别等功能, 有点杀鸡用牛刀的味道。

当时为了这个项目, 项目组还特意给我们申请了价值几百美金的Autonomy内部系列培训课程, 后来经过做项目过程中的层层实践和磨练, 一度成为项目组内部Autonomy专家, 安装、配置、接口使用，甚至于新功能的自我摸索和学习也不在话下。

但是Autonomy毕竟是一个大块头超昂贵的系统, 功能很强大, 卖的License自然也很贵, 所以一般可能只有某些大公司在使用, 大部分的中小公司是用不起的, 这也就决定了这门技术在需要的地方很吃香，但是很多地方都不需要。

几年过去了,由于之前的疏忽没有做过总结,大部分的知识都快忘光了,不过鉴于[官网](https://my.vertica.com/documentation/idol/11-0/)还是有比较详细的教程,这里只概要回顾一下:

Autonomy提供了一种能够理解任何文件格式的全面软件基础架构解决方案。无论数据是文字还是语音，是结构化还是非结构化，采用何种创建和存储手段，Autonomy都可以进行处理。Autonomy的技术使企业应用系统独立于数据类型而运作，同时借助将手工操作自动化而提升了效率。

## IDOL的工作流
![](https://my.vertica.com/docs/IDOL/Servers/IDOLServer/11.0/Guides/html/English/expert/Content/IDOLExpert/Images/IDOLArchitecture.png)


## IDOL中的一些常用组件：
### License Server
Autonomy的使用时基于license的，每一个license对应一个MAC地址。IDOL提供的大部分服务都必须有license才能正常工作。

### Connectors
Connectors是IDOL平台的一个核心组件，它可以灵活而精准的把不同格式(结构化，半结构化，上千种文件格式)不同来源的数据摄入到IDOL数据库中。常用的Connectors有如下几种：
* ODBC Connector
通过配置可以直接连接所有支持ODBC的数据库，通过配置的SQL语句，直接从数据库中抽取数据。

* File Connector
可以从指定的本地或网络文件目录抽取文件内容到IDOL中。

* Http Connector
可以从指定的网站抓取内容。

### CFS (Connector Framework Server)
Connectors实现了如何从不同的数据源抽取数据，CFS则负责抽取的实施以及从抽取的文件中提取出元数据(metadata)和文件内容，并把它们加载的CFS的document中。这样IDOL Server可以直接搜索分析数据，而不需要再从原文件格式中提取数据。
在数据进入IDOL数据库之前，还可以做一些增强操作，比如文字的情感分析， 文档归类， 概要生成等。
增加了CFS这一层，是将所需要的数据提供了一个统一的入口，相当于从各种管道接来了水，放置在水池中，供IDOL来用。

### IDOL Server
IDOL - 智能数据操作层(Intelligent Data Operating Layer)是Autonomy的核心，它可以收集来自各种连接器(Connectors)的数据, 并以其能够实现快速处理和检索的独特结构存储这些数据。在处理信息的时候，IDOL能够联系概念和语境来理解数据中的内容，可以对超过一千种不同格式的信息进行自动分析。

IDOL允许对数据源进行超过500多种操作，包括超链接、代理、摘要、分类、聚类、结构化信息抽取、档案建立、个性化信息提醒及检索。

### Image Server
用于图片内容的存储分析查询等，可以从图片中提取文字，通过图片训练还可以提供Logo识别，人脸识别等功能。

### DAH (Distributed Action Handler)
用于分布式查询和结果集的整理。

### DIH (Distributed Action Handler)
用于分布式索引, 将即将入库的文档分散为子集发送到集群中的各个server。


### Query Manipulation Server
查询管理。

### Eduction Server
为自己感兴趣的实体增加tag以便于查询和过滤。

### Media Server
分析处理视频数据，可以将视频分解为音频和图片，将音频转换为文字等。

### IDOL Speech Server
分析处理音频文件， 可以实现音频转换为文字，语音识别及语音搜索等功能。

## IDOL中支持的功能：
![](https://my.vertica.com/docs/IDOL/Servers/IDOLServer/11.0/Guides/html/English/expert/Content/FunctionalityView.png)

## IDOL的应用架构
![](http://blogs.forrester.com/f/b/users/LOWENS/autonomy.jpg)

参考文档： https://my.vertica.com/documentation/idol/11-0/
[应用接口使用文档](https://my.vertica.com/docs/IDOL/Interfaces/ACIAPI/11.0/Guides/pdf/English/ACIAPI_11.0_Programming_en.pdf)


