component {

	function init() {
		return this;
	}

	function render(required string includepath, struct variables={}) {
		savecontent variable="local.out" {
			module template="render.cfm" includepath=arguments.includepath variables=arguments.variables;
		}
		return local.out;
	}

}