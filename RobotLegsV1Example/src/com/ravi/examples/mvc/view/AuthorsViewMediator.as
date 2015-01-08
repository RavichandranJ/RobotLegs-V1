package com.ravi.examples.mvc.view
{
	import com.ravi.examples.mvc.common.AbstractMediator;
	import com.ravi.examples.mvc.events.CommonEvents;

	public class AuthorsViewMediator extends AbstractMediator
	{	
		
		
		[Inject]
		public var view:AuthorsView;
		
		override public function onRegister():void
		{
			// This will listen to event dispatched by other Mediator in the application
			addContextListener(CommonEvents.GET_AUTHOR_LIST, getAuthorsListHandler, CommonEvents);			
		}
		
		
		public function getAuthorsListHandler(event:CommonEvents):void
		{
			logger.debug('[AuthorsViewPM] getAuthorsListHandler()');
		}		
		
	}
}