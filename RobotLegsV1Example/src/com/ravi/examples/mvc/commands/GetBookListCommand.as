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
