---
title: Javascript中的Prototype
date: 2017-07-09 22:11:25
tags: ["javascript","prototype"]
categories: '前端'
---
### Prototype 是什么
Javascript中，prototype是函数的一个属性，它本身是一个对象，而这个对象的构造函数指向函数本身。
描述比较抽象，但是通过以下代码就很容易理解：

```js
function ff(){
    return "this is function ff";
}

console.log(ff.prototype.constructor == ff);
// 打印结果：
// true
```
> 由上也不难推出以下几个特殊对象的prototype：
> - Array.prototype 是一个数组
> - String.prototype 是一个字符串
> - Object.prototype 是一个对象

需要注意的是，prototype属性只能用于函数，如果引用某个具体对象的prototye属性，则其为undefined。

例如：

```js
function ff(){
    return "this is function ff";
}

console.log(ff.prototype); 
//打印结果：
// [object Object]

console.log(JSON.stringify(ff.prototype)); 
//打印结果:
// {}

console.log(new Object().prototype)
//打印结果:
// undefined

console.log(new ff().prototype)
//打印结果:
// 猜猜看是什么 :)
```

### Prototype 有什么用
通过prototype可以为函数对象添加新的属性和方法, 所有通过 new 方法实现函数对象都会拥有新添加的方法和属性，相当于间接实现了继承。

例如：

```js
function animal(name){
    this.name = name;
    return this.name;
}

animal.prototype.type = "animal";
animal.prototype.sayHi = function(){
    console.log("Hi, I am " + this.name);
}

var cat = new animal('cat');
var dog = new animal('dog');

console.log(cat.type);
console.log(cat.name);
//打印结果:
// animal
// cat
console.log(dog.type);
console.log(dog.name);
//打印结果:
// animal
// dog

cat.sayHi();
//打印结果:
// Hi, I am cat
dog.sayHi();
//打印结果:
// Hi, I am dog
```

