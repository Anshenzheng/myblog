---
title: MySQL中的日志文件
date: 2017-07-07 18:08:58
---
日志文件是数据库中非常重要的文件，可以用于操作查询，性能分析，事务保障以及数据恢复等。MySQL中的常见日志文件如下：

###错误日志：Error Log
错误日志记录了MySQL运行过程中所有较为严重的警告和错误信息，以及每次启动和关闭的详细信息。
默认情况下，错误记录日志功能是关闭的，错误信息会被输出到标准错误输出stderr。我们可以在启动时开启
````
--log-error
````
选项开启错入日志功能。
错误日志默认以hostname.err命名存放于数据目录下， 但是可以使用命令:
````
log-error[=file_name]
````
来修改存放的目录和文件名。

###二进制日志：Binary Log & Binary Log Index
二进制日志是MySQL中最重要的日志之一，通过：
````
--log-bin[=file_name]
````
开启，MySQL会将所有修改数据库的Query(Query语句，执行时间，消耗资源，相关事务信息等)以二进制的形式记录于该日志文件。

以下是binlog的一些附加选项参数：
--max_binlog_size - binlog的最大存储上限，当日志达到该上限时，会自动创建一个新日志。为了保证事务安全，MySQL不会将同一个事务分开记录到两个binlog中，故有时会超出最大上限。
--binlog-do-db=db_name - 指明仅对db_name数据库记录binlog，忽略其它数据库执行的Query(db_name指当前正在连接的数据库)
--binlog-ignore-db=db_name - 功能与--binlog-do-db相反 (db_name指当前正在连接的数据库)
mysql-bin.index - 记录所有Binary Log的绝对路径，保证MySQL线程可以顺利的找到所需要的log文件。

###更新日志: Update Log
更新日志是MySQL在较老版本上使用的，功能与bin-log类似，以简单的文本格式记录，MySQL5.0之后不再支持。

###查询日志: Query Log 
查询日志记录MySQL中所有的Query，可以通过
````
--log[=file_name]
````
来开启日志。
由于记录了所有的Query，包括所有的Select语句，故体积比较大，开启后对性能影响也比较大。默认文件名为数据目录下的hostname.log.

###慢查询日志：Slow Query Log
用于记录执行时间较长的Query，通过
````
--log-slow-queries[=file_name]
````
开启，默认文件名为数据目录下的hostname-slow.log。
慢查询日志采用简单文本格式，记录了语句执行的时刻，消耗的时间，执行的用户以及连接主机等相关的信息。MySQL还提供了mysqlslowdump工具程序专门用来分析慢查询日志，帮助数据库管理人员解决可能存在的性能问题。

###InnoDB在线Redo日志：InnoDB REDO Log
InnoDB是一个事务安全的存储引擎，其安全性主要是通过REDO日志和记录在表空间的UNDO信息来保证的。
REDO日志中记录了InnoDB所做的所有物理变更和事务信息，默认存放于数据目录下，可以通过innodb_log_group_home_dir来更改日志存放位置，通过innodb_log_files_in_group设置日志数量。