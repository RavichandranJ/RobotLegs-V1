# Robotlegs V 1.3.0

The example applciation will help you to development flex application using Robotlegs V 1.3.0.

Please refer to http://www.robotlegs.org/ for downloading and to know more features.

## Adding Context to Main App page.



AppMain.mxml

```xml

<?xml version="1.0" encoding="utf-8"?>
<s:WindowedApplication xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:s="library://ns.adobe.com/flex/spark"
    xmlns:mx="library://ns.adobe.com/flex/mx"
    xmlns:parsley="http://www.spicefactory.org/parsley"
    xmlns:view="com.ravi.examples.mvc.view.*"
    xmlns:utils="com.ravi.examples.mvc.utils.*" xmlns:context="com.ravi.examples.mvc.context.*">
	<fx:Style source="styles.css" />
    <fx:Script>
        <![CDATA[
            import mx.logging.Log;
            import mx.logging.LogEventLevel;
        ]]>
    </fx:Script>

    <fx:Declarations> 
		<context:ContextMain contextView="{this}" />
		
        <utils:EncriptApplicationLog filters="com.ravi.*"
            includeDate="true"
            includeTime="true"
            includeLevel="true"
            includeCategory="true"
            level="{LogEventLevel.ALL}"/>
    </fx:Declarations>
    <s:Label 
        x="10" y="30"
        fontSize="36"
        text="RobotLegs - MVC Framework"/>
    <view:HomeView y="80"/>
</s:WindowedApplication>


```

## Configuration

All the classes like Commonds, Mediators, Singletons etc will be registered here for depency injection and event mapping.

ContextMain.as

```as3
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


```



## Abstract Actor

This is helper class which is extended by other classes like commands abd model classes for dispatching events and log.

AbstractActor.as

```as3

package com.ravi.examples.mvc.common
{
	import com.ravi.examples.mvc.utils.getLogger;
	
	import mx.logging.ILogger;
	
	import org.robotlegs.mvcs.Actor;
	
	public class AbstractActor extends Actor
	{
		
		public function get logger():ILogger
		{
			return getLogger(this);
		}
	}
}

```


## Mediators

Mediators plays major roles by seperating the logics from view classes. This will be responsible to registering all the events and dispatching events in the application life cycle.

BooksViewMediator.as

```as3

package com.ravi.examples.mvc.view
{
	import com.ravi.examples.mvc.commands.GetBookListCommand;
	import com.ravi.examples.mvc.common.AbstractMediator;
	import com.ravi.examples.mvc.events.CommonEvents;
	import com.ravi.examples.mvc.model.AppModuleLocator;
	
	import flash.events.MouseEvent;
	
	import spark.events.GridEvent;

	public class BooksViewMediator extends AbstractMediator
	{

		//-------------------------------------------------------------------------
		//
		// Properties
		//
		//-------------------------------------------------------------------------

		
		[Inject]
		public var model:AppModuleLocator;

		[Inject]
		public var view:BooksView;


		//-------------------------------------------------------------------------
		//
		// Functions
		//
		//-------------------------------------------------------------------------

		override public function onRegister():void
		{
			// addEventListener - Listening for mouse click evnts
			view.datagrid.addEventListener(GridEvent.GRID_CLICK, gridClickHandler);
			view.btnGetAuthors.addEventListener(MouseEvent.CLICK, getAuthorsList);
			view.btnGetBooks.addEventListener(MouseEvent.CLICK, getBookList);
			
			// addContextListener - Listening for Custom Events dispatched by other views
			addContextListener(CommonEvents.RESET_GRID_INDEX, resetHandler);

			// add dataProvider
			view.datagrid.dataProvider=model.bookList;
		}

		public function gridClickHandler(event:GridEvent):void
		{
			logger.debug('[BooksViewPM] gridClickHandler() rowIndex = {0}', event.rowIndex);
			if (event.rowIndex != -1)
				model.setAuthors(model.bookList[event.rowIndex].authors);
		}

		public function getAuthorsList(event:MouseEvent):void
		{
			logger.debug('[BooksViewPM] getAuthorsList()');
			dispatch(new CommonEvents(CommonEvents.GET_AUTHOR_LIST));
		}
		
		private function getBookList(event:MouseEvent):void
		{
			logger.debug('[BooksViewPM] getBookList()');
			dispatch(new CommonEvents(CommonEvents.GET_BOOK_LIST));
		}
		
		private function resetHandler(event:CommonEvents):void
		{
			logger.debug('[BooksViewPM] resetHandler()');
			view.datagrid.selectedIndex = 0;
		}		

	}
}


```

## AbstractMediator

AbstractMediator.as

```as3

package com.ravi.examples.mvc.common
{
	import com.ravi.examples.mvc.utils.getLogger;	
	import mx.logging.ILogger;	
	import org.robotlegs.mvcs.Mediator;
	
	public class AbstractMediator extends Mediator
	{
		
		public function get logger():ILogger
		{
			return getLogger(this);
		}
	}
}


```

BooksView.mxml:

No script tags in mxml views. The will be registered to mediator in config file. Each view will have one mediator associated with view.

```xml

<?xml version="1.0" encoding="utf-8"?>
<s:Panel xmlns:fx="http://ns.adobe.com/mxml/2009"
		 xmlns:s="library://ns.adobe.com/flex/spark"
		 xmlns:mx="library://ns.adobe.com/flex/mx"
		 xmlns:parsley="http://www.spicefactory.org/parsley">
	<s:DataGrid id="datagrid"
				left="10"
				right="10"
				top="10"
				bottom="10"/>

	<s:controlBarContent>
		<s:Button id="btnGetAuthors"
				  label="Get Authors"/>
		<s:Button id="btnGetBooks"
				  label="Get Books"/>		
	</s:controlBarContent>
</s:Panel>


```

## Command



GetBookListCommand.as

```as3

package com.ravi.examples.mvc.commands
{
	import com.ravi.examples.mvc.common.AbstractCommand;
	import com.ravi.examples.mvc.delegate.CommonDelegate;
	import com.ravi.examples.mvc.events.CommonEvents;
	import com.ravi.examples.mvc.model.AppModuleLocator;
	import com.ravi.examples.mvc.vo.BookVO;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.base.ContextEvent;
	
	
	public class GetBookListCommand extends AbstractCommand
	{
		
		[Inject]
		public var delegate:CommonDelegate;
		
		[Inject]
		public var model:AppModuleLocator;
		
		[Inject]
		public var event:CommonEvents;
		
		override public function execute():void
		{
			logger.debug('[GetBookListCommand] execute()');
			delegate.getBookList().addResponder(this);
		}
		
		override public function result(event:Object):void
		{
			model.bookList.source = [];
			
			var result:XML = event.result as XML;
			logger.debug('[GetBookListCommand] result() = {0}', result);
			
			var xmlList:XMLList = result..book as XMLList;
			
			for each (var item:XML in xmlList)
			{
				var vo:BookVO = new BookVO();
				vo.authors = getAuthorsList(item..author as XMLList);
				vo.category = item.@category;
				vo.price = item.price;
				vo.title = item.title;
				vo.year = item.year;
				model.bookList.addItem(vo);
			}
			
			model.setAuthors(model.bookList[0].authors);
			dispatch(new CommonEvents(CommonEvents.RESET_GRID_INDEX));
		}
		
		private function getAuthorsList(authorList:XMLList):Array
		{
			var array:Array = [];			
			for each (var item:Object in authorList) 
			{
				array.push(item);
			}
			return array;
		}		
	}
}


```

## Abstract Command

AbstractCommand.as

```as3

package com.ravi.examples.mvc.common
{
	import com.ravi.examples.mvc.utils.getLogger;
	
	import mx.logging.ILogger;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import org.robotlegs.mvcs.Command;

	public class AbstractCommand extends Command implements IResponder
	{
		
		override public function execute():void
		{
			logger.debug('execute()');
		}
		
		public function get logger():ILogger
		{
			return getLogger(this);
		}
		
		public function result(event:Object):void
		{
			logger.debug('result()');			
		}
		
		public function fault(event:Object):void
		{
			logger.error("fault() faultString = {0}, faultDetail = {1}", event.fault.faultString, event.fault.faultDetail);
		}
	}
}

```


## Services

CommonDelegate.as

```as3

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

```

