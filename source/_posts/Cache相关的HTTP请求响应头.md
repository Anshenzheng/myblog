---
title: Cache相关的HTTP请求/响应头
tags: ["cache","http","web"]
categories: "前端"
---

常见的HTTP请求/响应头有很多，以下介绍几种cache相关的：

* Pragma
* Cache-Control
* Expires
* Last-Modified
* Etag

### Pragma & Cache-Control
用于指定所有缓存机制在整个请求/响应链中必须服从的命令，如果知道该页面是否为缓存，不仅可以控制浏览器，还可以控制HTTP协议相关的缓存或者代理服务器。

Cache-Control请求字段优先级比较高，如果和其它一些相冲突的字段(比如Expires)同时出现，则Cache-Control会覆盖其它字段。
Pragma的作用和Cache-Control类似，也是在HTTP头中包含一个特殊指令，使相关的服务器来遵守，Pragma:no-cache 和 Cache-Control:no-cache的作用是一样的。

> 浏览器中的强制刷新(Ctrl + F5)就是通过发起请求时加上请求头 Pragma:no-cache 和 Cache-Control:no-cache 实现的。

### Expires 
通常格式为Expires:Sat,25Feb201712:22:17GMT,后面跟着日期和时间，超过这个时间值后，缓存内容将失效，也就是浏览器在发出请求之前会检查这个页面的字段，如果页面已经过期，就重新向服务器发起请求。

### Last-Modified & Etag
Last-Modified一般用于表示一个服务器上的资源的最后修改时间，资源可以是静态或者是动态的。
一般服务端在响应头中返回一个Last-Modified字段，告诉浏览器这个页面的最后修改时间，浏览器再次请求时在请求头中增加一个If-Modified-Since:Sat,25Feb201712:22:17GMT,询问当前缓存的页面是否是最新的，如果是最新的就返回304，告诉浏览器是最新的，服务器也不会传输新的数据。

Etag与Last-Modified功能类似，作用是让服务器给每个页面分配一个唯一的编号，然后通过编号来区分当前页面是否为最新。这种方式比Last-Modified更灵活，但是在后端的Web服务器有多台时就比较难处理，因为每个web服务器都要记住网站的所有资源，否则这个编号就没有意义了。
