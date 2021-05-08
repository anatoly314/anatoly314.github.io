## Bug which surprised me

A few days ago I encountered a bug that surprised me. After I've fixed it, I thought that not only I can fall in such trap,
so I decided to write a small article which explains what happened, why and how it could be avoided. 

Let's say that you have the following function. What it will return if you will call it as following `getUserName()`? 
It will return `undefined` too because we assigned a default empty object which will be used if a parameter will be `undefined`.

````js
function getUserName(user = {}) {
    return user.name;
}
````

But what will happen if it will receive `null`? I supposed till recently that it will receive default value as well, and on the call
`getUserName(null)` will return `undefined` as well, I was wrong. 

If we'll call `getUserName(null)` we will get:
> VM272:2 Uncaught TypeError: Cannot read property 'name' of null
    at getUserName (<anonymous>:2:17)
    at <anonymous>:1:1

But why? Why function didn't receive the default empty object as in the previous scenario?
Let's check MDN article [Default parameters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters). 

In a first sentence we see:
> Default function parameters allow named parameters to be initialized with default values if no value or undefined is passed.

Boom. only if we will call it as `getUserName()` or `getUserName(undefined)` our default value will be assigned, not `null`. So the following call `getUserName(null)` will obviously fail. I didn't know it.

So, how can we protect ourselves from `null`? Well, there're a few approaches. Most obviouse add `if` condition:

```js
function getUserName(user) {
    if (!user) {
        user = {};
    }
    return user.name;
};
```

Or to make it less verbose we can write it in the following way:
````js
function getUserName(user) {
    return (user || {}).name;
};
````

But it quickly becomes less readable when you have an object where the required property nested few levels deep, lets say: 
````js
const user = {
    personalData: {
        habits: {
            isSmoking: false
        }
    }
}
````
To check if the user is smoking and to protect ourself from error we need to write something like this:

````js
function isUserSmoking(user) {
    return (((user || {}).personalData || {}).habits || {}).isSmoking;
};
````

Agree that this code is barely readable and error prone? How to rewrite it in a more readable way?
The solution comes from well known [lodash's get method](https://lodash.com/docs/4.17.15#get):
> Gets the value at `path` of `object`. If the resolved value is `undefined`, the `defaultValue` is returned in its place. Let's rewrite our `isSmoking` function with `get` method:

````js
function isUserSmoking(user) {
    return _.get(user, 'personalData.habits.isSmoking'); //if we won't set `defaultValue` it will be `undefined` by default. 
};
````

Now invoking function `isUserSmoking(null)` will return `undefined` if any of the nested objects not exist and won't crash. 
