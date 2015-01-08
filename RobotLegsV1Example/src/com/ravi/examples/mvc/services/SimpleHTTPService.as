package com.ravi.examples.mvc.services
{
	import com.ravi.examples.mvc.common.AbstractMediator;
	import com.ravi.examples.mvc.utils.getLogger;
	
	import mx.logging.ILogger;
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;
	
	public class SimpleHTTPService extends HTTPService
	{
		public function SimpleHTTPService(rootURL:String=null, destination:String=null)
		{			
			super(rootURL, destination);
		}
		
		override public function send(parameters:Object = null):AsyncToken
		{
			logger.debug("[BooksService] Sending required for service url = " + url);
			method = "GET";
			resultFormat =  "e4x";
			return super.send();
		}
		
		public function get logger():ILogger
		{
			return getLogger(this);
		}
	}
}