package com.ravi.examples.mvc.services
{
	import org.robotlegs.mvcs.Actor;

	public class FlickrGalleryService extends Actor implements IGalleryImageService
	{
		public function FlickrGalleryService()
		{
			super();
		}
		
		public function loadGallery():void
		{
		}
		
		public function search(searchTerm:String):void
		{
		}
		
		public function get searchAvailable():Boolean
		{
			return false;
		}
	}
}