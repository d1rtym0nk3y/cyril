component {

	function init() {
		return this;		
	}
	
	function onMissingMethod(missingMethodName,missingMethodArguments) {
		var action = lcase(left(missingMethodName, 3));
		if(action == "get") {
			var key = replaceNoCase(missingMethodName, "get", "", "one");
			if(structKeyExists(this, key)) {
				return this[key]; 
			}
			if(structKeyExists(missingMethodArguments, "1")) {
				var def = missingMethodArguments["1"];
				this[key] = def;
				return def;
			}
			return javacast("null", 0);
		}
		if(action == "set") {
			var key = (replaceNoCase(missingMethodName, "set", "", "one"));
			var val = structKeyExists(missingMethodArguments, "1") ? missingMethodArguments["1"] : "";
			this[key] = val;
			return this;
		}
		if(action == "has") {
			var key = replaceNoCase(missingMethodName, "has", "", "one");
			return structKeyExists(this, key);
		}
		throw(message="method #missingMethodName#() was not found, only set{Variable}(value), get{Variable}(defaultValue) or has{Variable}() are supported", type="methodNotFound");
	}
	
	function copyToScope(scope, keys, defaults={}) {
		for(var k in listToArray(keys)) {
			scope[k] = structKeyExists(this, k) ? this[k] : structKeyExists(defaults, k) ? defaults[k] : "";
		}
		return scope;
	}

}