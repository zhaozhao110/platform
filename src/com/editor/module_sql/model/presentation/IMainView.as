package com.editor.module_sql.model.presentation
{
	public interface IMainView
	{
		function promptCreateDBDialog():void;
		function promptOpenFileDialog(pClosable:Boolean=false):void;
		function promptAboutDialog():void;
		function promptReencryptDialog():void;
		function promptCommercialDialog():void;
		function promptUpgradeEncryptionDialog():void;
		function promptCreateNewTable():void;
		
	}
}