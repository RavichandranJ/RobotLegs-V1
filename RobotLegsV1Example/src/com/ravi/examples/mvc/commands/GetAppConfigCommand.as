package com.ravi.examples.mvc.commands
{
	import com.ravi.examples.mvc.common.AbstractCommand;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Command;

	public class GetAppConfigCommand extends AbstractCommand
	{
		[Inject]
		private var event:ContextEvent;

		override public function execute():void
		{
			logger.debug('[GetAppConfigCommand] execute()');
		}

	}
}
