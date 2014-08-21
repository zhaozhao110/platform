package com.editor.mediator
{
	public class AppStackMediator extends AppMediator
	{
		public function AppStackMediator(name:String=null, viewComponent:Object=null)
		{
			super(name, viewComponent);
		}
		
		protected function getStackType():int
		{
			return getMediatorName().split("|")[1];
		}
		
	}
}