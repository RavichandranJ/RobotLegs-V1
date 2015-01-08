package com.ravi.examples.mvc.context
{
	import com.ravi.examples.mvc.commands.GetAppConfigCommand;
	import com.ravi.examples.mvc.commands.GetAuthorListCommand;
	import com.ravi.examples.mvc.commands.GetBookListCommand;
	import com.ravi.examples.mvc.delegate.CommonDelegate;
	import com.ravi.examples.mvc.events.CommonEvents;
	import com.ravi.examples.mvc.model.AppModuleLocator;
	import com.ravi.examples.mvc.services.FlickrGalleryService;
	import com.ravi.examples.mvc.services.IGalleryImageService;
	import com.ravi.examples.mvc.view.AuthorsView;
	import com.ravi.examples.mvc.view.AuthorsViewMediator;
	import com.ravi.examples.mvc.view.BooksView;
	import com.ravi.examples.mvc.view.BooksViewMediator;
	import com.ravi.examples.mvc.view.HomeView;
	import com.ravi.examples.mvc.view.HomeViewMediator;
	
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	/**
	 * @url https://github.com/robotlegs/robotlegs-framework/wiki/Best-Practices#mappingwithinjector 
	 * @author Ravi
	 * 
	 */
	public class ContextMain extends Context
	{

		override public function startup():void
		{
			// Inject
			mapActors();
			mapMediators();
			mapCommands();						
			mapViews();		
			
			// dispatch events on APP
			loadServices();
		}
		
		/**
		 * 	Injection Mapping with the Injector Class
		 *	The mapSingleton() method is very common for mapping a simple class for injection. 
		 * 	In this case, mapSingleton() means that the injector will create and supply one single instance of the AppModuleLocator whenever it is asked to do so
		 */		
		private function mapActors():void
		{
			injector.mapSingleton(AppModuleLocator);
			injector.mapSingleton(CommonDelegate);	
		}
		
		/**
		 * Injection Mapping with the MediatorMap Class
		 * View components and mediators will be registered and mapped here.
		 * Mediators manage communication between your application's view components and other objects within your application.
		 */
		private function mapMediators():void
		{
			mediatorMap.mapView(AuthorsView, AuthorsViewMediator);
			mediatorMap.mapView(BooksView, BooksViewMediator);
		}


		/**
		 *	Injection Mapping with the CommandMap Class
		 *	You will provide the commandMap with a class to execute, the type of event that executes it, and 
		 *	optionally a strong typing for the event and a boolean switch if the command should be executed only a single time and then be unmapped. 
		 */		
		private function mapCommands():void
		{
			
			commandMap.mapEvent(ContextEvent.STARTUP, GetAppConfigCommand, ContextEvent, true);
			commandMap.mapEvent(CommonEvents.GET_BOOK_LIST, GetBookListCommand, CommonEvents);
			commandMap.mapEvent(CommonEvents.GET_AUTHOR_LIST, GetAuthorListCommand, CommonEvents);
		}
		
		
		/**
		 * 	Injection Mapping with the Injector Class
		 *	The mapType() method is requried for mapping common model from views.
		 * 	In this case, single insatnce of AppModuleLocator is injected to view.
		 */		
		private function mapViews():void
		{
			viewMap.mapType(AuthorsView);
		//	viewMap.mapType(BooksView);
		}
		
		/**
		 *	This Context is mapping a single command to the ContextEvent.STARTUP
		 * 	The StartupCommand will map additional commands, mediators, services,
		 *  and models for use in the application. 
		 * 
		 */		
		private function loadServices():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			dispatchEvent(new CommonEvents(CommonEvents.GET_BOOK_LIST));
		}

	}
}
