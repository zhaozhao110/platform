package com.editor.popup.plusWin
{
	public class PlusPopWinManager
	{
		private static var instance:PlusPopWinManager ;
		public static function getInstance():PlusPopWinManager{
			if(instance == null){
				instance =  new PlusPopWinManager();
			}
			return instance;
		}
		
		
	}
}