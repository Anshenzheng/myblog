---
title: IntelliJ导出可运行Jar包
tags: ["Jar","IntelliJ"]
categories: "工具"
---
### Maven pom.xml中build的相关配置：
```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
          </configuration>
         </plugin>
        <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-shade-plugin</artifactId>
        <version>2.3</version>
        <executions>
          <execution>
            <phase>package</phase>
            <goals>
              <goal>shade</goal>
            </goals>
            <configuration>
              <transformers>
                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                  <mainClass>com.xxx.MainApplication</mainClass>
                </transformer>
              </transformers>
            </configuration>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
```

### IntelliJ中相关操作

1. 右键 File -> Project Structure... 
2. "+" -> JAR -> From Modules with Denpendencies
3. 设置名称，输出路径，Manifest File路径以及Main Class路径，并将右侧Available Elements中的所有内容都通过右键->"Put into Output Root"加至左边。
4. 点击OK关闭设置面板
5. Build -> Build Artifacts 单击Action中的Build去build刚刚创建的jar
6. 去之前设置的Jar输出路径去检查并测试生成的可运行Jar文件。
