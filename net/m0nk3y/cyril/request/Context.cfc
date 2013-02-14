component {

	function init() {
		return this;		
	}
	
	function onMissingMethod(missingMethodName,missingMethodArguments) {
		var action = lcase(left(missingMethodName, 3));
		if(action == "get") {
			var args = {
				key = replaceNoCase(missingMethodName, "get", "", "one")
			};
			if(structKeyExists(missingMethodArguments, "1")) {
				args.defaultValue = missingMethodArguments["1"];
			}
			if(structKeyExists(missingMethodArguments, "2")) {
				args.setDefaultInContext = missingMethodArguments["2"];
			}
			return _get(argumentCollection=args);
		}
		if(action == "set") {
			var key = (replaceNoCase(missingMethodName, "set", "", "one"));
			var val = structKeyExists(missingMethodArguments, "1") ? missingMethodArguments["1"] : "";
			return _set(key, val);
		}
		if(action == "has") {
			var key = replaceNoCase(missingMethodName, "has", "", "one");
			return _has(key);
		}
		throw(message="method #missingMethodName#() was not found, only set{Variable}(value), get{Variable}(defaultValue) or has{Variable}() are supported", type="methodNotFound");
	}
	
	function _get(string key, any defaultValue, boolean setDefaultInContext=true) {
		if(_has(arguments.key)) {
			return this[arguments.key];
		}
		if(structKeyExists(arguments, "defaultValue")) {
			if(arguments.setDefaultInContext) {
				_set(arguments.key, arguments.defaultValue);
			}
			return arguments.defaultValue;			
		}
	}
	
	function _set(string key, any value) {
		this[arguments.key] = arguments.value;
		return this;
	}
	
	function _has(string key) {
		return structKeyExists(this, key);
	}
	
	function _grab(keys, scope={}, defaults={}) {
		for(var k in listToArray(keys)) {
			scope[k] = structKeyExists(this, k) ? this[k] : structKeyExists(defaults, k) ? defaults[k] : javacast("null", 0);
		}
		return scope;
	}


	function addMessage(string message) {
		_get("__flash_message_stack", []).append(message);
		return this;
	}
	
	function getMessages(boolean clear=true) {
		var msgs = _get("__flash_message_stack", []);
		if(clear) _set("__flash_message_stack", []);
		return msgs;
	}	
	
}
