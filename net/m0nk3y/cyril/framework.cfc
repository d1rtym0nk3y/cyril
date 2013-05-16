component extends="fw1.framework" {

	variables._renderer = new template.Renderer();

	public void function redirect( string action, string preserve = '', string append = 'none', string path = variables.magicBaseURL, string queryString = '', string statusCode = '302' ) {
		arguments.preserve = listAppend(arguments.preserve, "__flash_message_stack");
		super.redirect(argumentCollection=arguments);
	}

	private void function setupRequestDefaults( string targetPath ) {
		if(!structKeyExists(request, 'context')) {
			request.context = new request.Context();
		}
		
		if(structKeyExists(application, variables.framework.applicationKey)) {
			this.helpers = application[ variables.framework.applicationKey ].helpers;
		}
		
		super.setupRequestDefaults(argumentCollection=arguments);
	}
	
	
	public any function setupApplicationWrapper() {
		super.setupApplicationWrapper();
		setupHelpers();
	}
	
	
	private function setupHelpers() {
		var helpers = new helper.HelperFactory(variables.framework.helperDirectory).getAllHelpers();
		if(hasDefaultBeanFactory()) {
			for(var h in helpers) {
				autowire( helpers[h], getBeanFactory() );
			}
		}	
		application[ variables.framework.applicationKey ].helpers = helpers; 
	}
	
	private void function setupFrameworkDefaults() {
		super.setupFrameworkDefaults();
		if ( !structKeyExists(variables.framework, 'helperDirectory') ) {
			variables.framework.helperDirectory = getDirectoryFromPath( variables.cgiScriptName ) & "helpers";
		}
		variables.framework.version = variables.framework.version & "/Cyril-0.1";
	}
	
	public struct function getHelpers() {
		return application[ variables.framework.applicationKey ].helpers;
	}


	public string function layout( string path, string body='' ) {
		return super.layout(argumentCollection=arguments);
	}

	private string function internalLayout( string layoutPath, string body ) {
		var rc = request.context;
		var $ = { };
		// integration point with Mura:
		if ( structKeyExists( rc, '$' ) ) {
			$ = rc.$;
		}
		if ( !structKeyExists( request._fw1, 'controllerExecutionComplete' ) ) {
			raiseException( type='FW1.layoutExecutionFromController', message='Invalid to call the layout method at this point.',
				detail='The layout method should not be called prior to the completion of the controller execution phase.' );
		}
		var response = variables._renderer.render(layoutPath, {fw=this, rc=rc, $=$, body=body, helpers=getHelpers()});
		return response;
	}
	
	private string function internalView( string viewPath, struct args={} ) {
		var rc = request.context;
		var $ = { };
		// integration point with Mura:
		if ( structKeyExists( rc, '$' ) ) {
			$ = rc.$;
		}
		structAppend( args, {fw=this, rc=rc, $=$, helpers=getHelpers()} );
		if ( !structKeyExists( request._fw1, 'serviceExecutionComplete') &&
             structKeyExists( request, 'services' ) && arrayLen( request.services ) != 0 ) {
			raiseException( type='FW1.viewExecutionFromController', message='Invalid to call the view method at this point.',
				detail='The view method should not be called prior to the completion of the service execution phase.' );
		}
		var response = variables._renderer.render(viewPath, args);
		return response;
	}	
	
	
	private void function frameworkTraceRender() {
		param name="request._fw1.suppress_trace" default="false"; 
		if(!request._fw1.suppress_trace) {
			super.frameworkTraceRender();
		} 
	}

	private void function injectFramework( any cfc ) {
		var args = { };
		if ( structKeyExists( cfc, 'setFramework' ) || structKeyExists( cfc, 'onMissingMethod' ) ) {
			args.framework = this;
			// allow alternative spellings
			args.fw = this;
			args.fw1 = this;
			evaluate( 'cfc.setFramework( argumentCollection = args )' );
		}
	}	

}   