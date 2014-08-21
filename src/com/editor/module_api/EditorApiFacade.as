package com.editor.module_api
{
	import com.sandy.module.ModuleFacade;
	
	public class EditorApiFacade extends ModuleFacade
	{
		private static var instance:EditorApiFacade ;
		public static function getInstance():EditorApiFacade{
			if(instance == null){
				instance =  new EditorApiFacade();
			}
			return instance;
		}
				
		
		
		
		
	}
}