package com.editor.module_sql.model.presentation
{
	import flash.data.SQLIndexSchema;
	
	public class IndicesPM extends AbstractPM
	{
		
		public var mainPM:MainPM;
		public var dbIndices:Array;
		
		public function IndicesPM(pMainPM:MainPM)
		{
			mainPM = pMainPM;
		}
		
		public function removeIndex(pINdex:SQLIndexSchema):void
		{
			mainPM.removeIndex( pINdex);
		}		
		
	}
}