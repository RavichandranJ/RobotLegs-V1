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
