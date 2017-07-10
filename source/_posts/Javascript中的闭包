---
title: Javascript中的闭包
tags: ["javascript","闭包"]
categories: "前端"
---
### 什么是闭包
闭包(closure)是指在JavaScript中，将外部函数中的局部变量封闭起来的(内部)函数。 
(被封闭起来的变量与封闭它的函数具有相同的生命周期。)

示例如下：

```js
function func(){
	var local = "local variable";
	
	var inner = function(){
		console.log(local);
	}
	
	return inner;
}
```

示例中内部函数inner持有外部函数func的局部变量local，这样就构成了一个作用域(闭包)，通过该作用域我们可以访问及修改外部访问不到的内部变量。

### 闭包的作用
管理私有变量和私有方法，将对变量的管理封装在安全环境之中。
外层函数执行之后，它的局部变量本来应该全部销毁，但是由于闭包的存在，之后执行内部函数，通过它仍然可以访问到外层函数的变量。

```js
function func(){
	var name = "Charlie";
	
	return {
		setName: function(new_name){
			name = new_name;
		},
		getName: function(){
			return name;
		}
	};
}

var f = func();

console.log(f.name);
// 打印结果：
// undefined

console.log(f.getName())
// 打印结果：
// Charlie

f.setName("Teddy");
console.log(f.getName())
// 打印结果：
// Teddy

```
