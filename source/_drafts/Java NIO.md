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
ServerSocketChannel - 服务端
SocketChannel - 客户端
FileChannel
DatagramChannel

#### Selector
Selector相当于一个管家，管理所有的IO事件，包括Connection, Accept, 客户端服务端的读写等等。
当IO事件注册给选择器的时候，选择器会给IO事件分配一个key用于标示该事件，当IO事件完成之后会通过Key找到相应的Channel，之后通过管道发送数据/接收数据等操作。
SelectionKey - 判断IO事件是否已经就绪
key.isAcceptable: 是否可以接收客户端的连接
key.isConnectionable: 是否可以连接服务器
key.isReadable: 缓冲区是否可读
key.isWriteable: 缓冲区是否可写

操作代码：
```Java
Selector selector = Select.open(); //打开选择器
SelectionKey keys = selector.selectedKeys(); //获得事件的Keys
channel.regist(Selector.SelectornKey.OP_Write); //注册写事件
channel.regist(Selector.SelectornKey.OP_Read); //注册读事件
channel.regist(Selector.SelectornKey.OP_Connect); //注册连接事件
channel.regist(Selector.SelectornKey.OP_Accept); //注册监听
```

#### Buffer
NIO中的Buffer用于和NIO通道进行交互，数据从通道读入缓冲区，从缓冲区写入到通道。
使用Buffer读写数据的一般步骤：
1. 写入数据到Buffer
2. 调用flip()方法将Buffer从写模式切换到读模式
3. 从Buffer中读数据
4. 调用clear()方法或者compact方法清空缓冲区，以便再次写入
clear会清除整个缓冲区，compact只会清除已经读过的数据。任何未读的数据都会被移动到缓冲区的起始处，新写入的数据将放到缓冲区未读数据的后面。

Buffer的属性：
1. capacity
作为一个内存块，buffer有一个固定的capacity大小的容量，一旦Buffer满了，需要将其清空才能继续往里面写数据。

2. position
写模式时，position表示当前位置, 从0开始，一直到capacity-1.
读模式时，position表示从特定位置读。当Buffer从写模式切换到读模式时，position会被重置为0.

3. limit
写模式下表示最多可以往Buffer写多少数据, 即limit = capacity.
读模式下表示最多能读到多少数据，因此当切换到读模式时，limit会被设置为写模式下的position.

常用Buffer类型：
- ByteBuffer
- MappedByteBuffer
- CharBuffer
- DoubleBufer
- FloatBuffer
- IntBuffer
- LongBuffer
- ShortBuffer

操作代码:
```Java
ByteBuffer byteBuffer = ByteBuffer.allocate(48);
CharBuffer charBuffer = CharBuffer.allocate(1024);

int bytesRead = inChannel.read(byteBuffer); //read into buffer
byteBuffer.put(127);//通过put方法写入buffer

int bytesWritten = inChannel.write(byteBuffer); //read from buffer to channel
byte aByte = byteBuffer.get(); //read data from buffer via get method
```

### 示例
NIOServer.java
```Java
import java.nio.*;

public class NIOServer{
  private int blockSize = 4096;
  private ByteBuffer sendBuffer = ByteBuffer.allocate(blockSize);
  private ByteBuffer receiveBuffer = ByteBuffer.allocate(blockSize);
  private Selector selector;
  
  public NIOServer(int port){
    ServerSocketChannel serverSocketChannel = ServerSocketChannel.open();
    serverSocketChannel.configureBlocking(false); //设置是否阻塞
    ServerSocket serverSocket = serverSocketChannel.socket();
    serverSocket.bind(new InetSocketAddress(port));//bind 端口
    
    selector = Selector.open(); //打开选择器
    serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);
    System.out.println("Server start...");
  }
  
  public void listen(){
    while(true){
      selector.select();
      Set<SelectionKey> selectionKeys = selector.selectedKeys();
      Iterator<SelectionKey> iterator = selectionKeys.iterator();
      while(iterator.hasNext()){
        SelectionKey selectionKey = iterator.next();
        iterator.remove();
        handleKey(selectionKey);
      }
    }
  }
  
  public void handleKey(SelectionKey selectionKey) throws Exception{
    ServerSocketChannel server = null;
    SocketChannel client = null;
    String receiveText;
    String sendText;
    int count = 0;
    
    if(selectionKey.isAcceptable()){
      server = (ServerSocketChannel)selectionKey.channel();
      client = server.accept();
      client.configureBlocking(false);
      client.register(selector, selectionKey.OP_READ);
    }else if(selectionKey.isReadable()){
      client = (SocketChannel)selectionKey.channel();
      count = client.read(receiveBuffer);
      if(count > 0){
        receiveText = new String(receiveBuffer.array(), 0, count);
        System.out.println("Server receive message from client: " + receiveText);
        client.register(selector, selectionKey.OP_WRITE);
      }
    }else if(selectionKey.isWriteable()){
      sendBuffer.clear();
      client = (SocketChannel)selectionKey.channel();
      sendText = "message to client";
      sendBuffer.put(sendText.getBytes());
      sendBuffer.flip();
      
      client.write(sendBuffer);
      System.out.println("message send from server to client: " + sendBuffer);
    }
  }
  
  public static void main(String[] args){
    int port = 7080;
    NIOServer server = new NIOServer(port);
    server.listen();
  }
}
```
NIOClient.java
```Java
import java.nio.*;

public class NIOClient{
  private int flag = 1;
  private int blockSize = 4096;
  private static ByteBuffer sendBuffer = ByteBuffer.allocate(blockSize);
  private static ByteBuffer receiveBuffer = ByteBuffer.allocate(blockSize);
  private final static InetSocketAddress serverAddress = new InetSocketAddress("127.0.0.1", 7080);
  
  public static void main(String[] args) throws Exception{
    SocketChannel socketChannel = SocketChannel.open();
    socketChannel.configureBlocking(false);
    Selector selector = Selector.open();
    int count = 0;
    socketChannel.register(selector, SelectionKey.OP_CONNECT);
    socketChannel.connect(serverAddress);
    
    Set<SelectionKey> selectionKey;
    Iterator<SelectionKey> iterator;
    SelectionKey selectionKey;
    SocketChannel client;
    String recevieText;
    String sendText;
    
    while(true){
      selectionKeys = selector.selectedKeys();
      iterator = selectionKeys.iterator();
      
      while(iterator.hasNext()){
        selectionKey = iterator.next();
        if(selectionKey.isConnectable()){
          System.out.println("Client connect");
          client = (SocketChannel)selectionKey.channel();
          if(client.isConnectionPending()){
            client.finishConnect();
            System.out.println("Client Connection is done");
            sendBuffer.clear();
            sendBuffer.put("Hello Server".getBytes());
            sendBuffer.flip();
            client.write(sendBuffer);
          }
          client.register(selector, SelectionKey.OP_READ);
        }else if(selectionKey.isReadable()){
          client = (SocketChannel)selectionKey.channel();
          receiveBuffer.clear();
          count = client.read(receiveBuffer);
          if(count > 0){
            receiveText = new String(receiveBuffer.array(), 0 , count);
            System.out.println("client receive message from server: " + receiveText);
           }
           client.register(selector, SelectionKey.OP_WRITE);
        }else if(selectionKey.isWriteable()){
            client = (SocketChannel)selectionKey.channel();
            sendBuffer.clear();
            sendText = "Message send to Server";
            sendBuffer.put(sendText.getBytes());
            sendBuffer.flip();
            client.write(sendBuffer);
        }
      }
    }
    
  }
}
```
## AIO
服务端: AsynchronousServerSocketChannel
客户端: AsynchronousSocketChannel
用户处理器: CompletionHandler接口，实现应用程序向操作系统发起IO请求，当完成后处理具体逻辑，否则继续做自己该做的事。
