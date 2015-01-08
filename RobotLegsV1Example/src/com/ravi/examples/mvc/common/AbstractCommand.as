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