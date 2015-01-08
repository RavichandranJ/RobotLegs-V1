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