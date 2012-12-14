component {

	variables.helpers = {};

	public HelperFactory function init(required string helperPath) {
		structAppend(variables, arguments);
		loadHelpers();
		return this;
	}
	
	private function loadHelpers() {
		// helper cfc's must follow the simple cenvention of being names {Something}Helper.cfc'
		// where {Something} will be the key for the helper in the returned struct
		var hlprs = directoryList(variables.helperPath, false, "array", "*Helper.cfc");
		var cfcPath = listChangeDelims(replace(helperPath, expandpath("/"), ""), ".", "\/");
		for(var h in hlprs) {
			var hlpr = listFirst(getFileFromPath(h), ".");
			var key = replaceNoCase(hlpr, "Helper", "", "one");
			var obj = createobject(cfcPath & "." & hlpr);
			variables.helpers[key] = obj;
		}
	}
	

	
	public struct function getAllHelpers() {
		return variables.helpers;
	}
	
	
	public any function getHelper(string name) {
		try {
        	return variables.helpers[name];	
        }
        catch(Any e) {
        	throw(message="No helper with name '#name#' registered in the HelperFactory");
        }
	} 
	

}