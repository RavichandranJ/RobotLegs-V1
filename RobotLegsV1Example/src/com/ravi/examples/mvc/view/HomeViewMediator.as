package com.ravi.examples.mvc.view
{
	import com.ravi.examples.mvc.common.AbstractMediator;
	import com.ravi.examples.mvc.events.CommonEvents;

	public class HomeViewMediator extends AbstractMediator
	{
		[Bindable]
		public var message:String = "hello world";
		
		
		public function init():void
		{
			logger.debug('[HomeViewPM] init()');
			
			var event:CommonEvents = new CommonEvents(CommonEvents.GET_BOOK_LIST);
			logger.debug('dispatch Event  = {0}', event);
		}
	}
}