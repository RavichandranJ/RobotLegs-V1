package com.ravi.examples.mvc.events
{
	import flash.events.Event;
	
	public class CommonEvents extends Event
	{
		public static const START_UP:String = "startUp";
		public static const GET_BOOK_LIST:String = "getBookList";
		public static const GET_AUTHOR_LIST:String = "getAuthorsList";
		public static const RESET_GRID_INDEX:String = "resetGirdIndex";
		
		
		public function CommonEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new CommonEvents(type);
		}
	}
}