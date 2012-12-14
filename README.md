#Cyril
Extension of Sean Corfield's excellent FW/1 

####Views

View rendering is isolated from the framework, and are no longer rendered directly from Application.cfc. 
The main change this brings is you now only have access to the framework's public api from within a view, 
and the framework is injected into the view as 'fw'. 

```
<a href="#fw.buildUrl('my.action')#">link</a>
```

####Request Context (rc scope)

The request context struct has been replaced with a cfc with a few simple methods implemented with onMissingMethod, 
however it can still be used as a simple struct if desired.
  * boolean **hasVariable**()
  * Context **setVariable**(any value)
  * any **getVariable**( *any defaultValue=null* )
  
  where Variable is the name of a key in the request context

```
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


####Helpers

Cyril will read a directory of helper cfcs, load, autowire if a beanfactory is present and cache them. 
They will then be injected into views as a 'helpers' scope.

The default location for helpers is `{your-app-directory}/helpers`, 
but this can be overridden by setting `variables.framework.helperDirectory` 
in your Application.cfc

Helper cfcs should match the pattern `*Helper.cfc`, for example `ExampleHelper.cfc`, any other cfcs in the
helper directory will be ignored.

So a helper called `ExampleHelper.cfc` containing a function `echo()` would be used in a view like this

```
<cfoutput>#helpers.example.echo('hello')#</cfoutput>
```
