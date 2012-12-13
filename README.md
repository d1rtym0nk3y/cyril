#Cyril
Extension of Sean Corfield's excellent FW/1 

###Main Features

View rendering is isolated from the framework, and are no longer rendered directly from Application.cfc. 
The main change this brings is you now only have access to the framework's public api from within a view, 
and the framework is injected into the view as 'fw'. 

```
<a href="#fw.buildUrl('my.action')#">link</a>
```


The request context is no longer a simple struct, but can still be used as one. 
The rc scope now has a few simple methods implemented with onMissingMethod
  * boolean **hasVariable**()
  * Context **setVariable**(any value)
  * any **getVariable**( *any defaultValue* )
  
  where Variable is the name of a key in the request context

```coldfusion
if(structKeyExists(rc, "id")) {
  ...
}
// can be rewritten
if(rc.hasID()) {
  ...
}

rc.something = 1234;
// is equivalent to
rc.setSomething(1234);

value = structKeyExists(rc, "value") ? rc.value : 0;
// can be written
value = rc.getValue(0);
```
