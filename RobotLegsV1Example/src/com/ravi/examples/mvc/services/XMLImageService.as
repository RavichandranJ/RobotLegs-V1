package com.ravi.examples.mvc.services
{
	import org.robotlegs.mvcs.Actor;

	public class XMLImageService extends Actor implements IGalleryImageService
	{
		public function XMLImageService()
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
