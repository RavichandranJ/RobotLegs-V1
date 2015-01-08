package com.ravi.examples.mvc.delegate
{
	import com.ravi.examples.mvc.services.SimpleHTTPService;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.http.HTTPService;

	public class CommonDelegate
	{
				
		public function getBookList():AsyncToken
		{
			var service:SimpleHTTPService = new SimpleHTTPService();
			service.url = "books.xml";			
			return service.send();
		}
		
		public function getAuthorList():AsyncToken
		{
			var service:SimpleHTTPService = new SimpleHTTPService();
			service.url = "authors.xml";			
			return service.send();
		}
	}
}