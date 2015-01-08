package com.ravi.examples.mvc.services
{
	public interface IGalleryImageService
	{
		function loadGallery():void;
		function search(searchTerm:String):void;
		function get searchAvailable():Boolean;		
	}
}