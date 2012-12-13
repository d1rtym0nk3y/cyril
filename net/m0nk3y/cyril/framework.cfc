component extends="org.corfield.framework" {

	variables._renderer = new template.Renderer();

	private void function setupRequestDefaults( string targetPath ) {
		if(!structKeyExists(request, 'context')) {
			request.context = new request.Context();
		}
		super.setupRequestDefaults(argumentCollection=arguments);
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
		var response = variables._renderer.render(layoutPath, {fw=this, rc=rc, $=$, body=body});
		return response;
	}
	
	private string function internalView( string viewPath, struct args = { } ) {
		var rc = request.context;
		var $ = { };
		// integration point with Mura:
		if ( structKeyExists( rc, '$' ) ) {
			$ = rc.$;
		}
		structAppend( args, {fw=this, rc=rc, $=$} );
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

}   