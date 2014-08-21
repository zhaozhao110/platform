package com.editor.module_sea.pop.createMap
{
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.mediator.MapIsoBottomContainerMediator;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.mediator.SeaMapContentMediator;
	import com.editor.module_sea.vo.SeaMapData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.StringTWLUtil;

	public class SeaMapCreateMapPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SeaMapCreateMapPopwinMediator"
		public function SeaMapCreateMapPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():SeaMapCreateMapPopwin
		{
			return viewComponent as SeaMapCreateMapPopwin
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		override protected function okButtonClick():void
		{			
			var d:SeaMapData = new SeaMapData();
			d.mapWidth 			= int(createWin.widthTI.text);
			d.mapHeight 		= int(createWin.heightTI.text);
			d.addBackImgLevel();
			
			if(d.mapWidth == 0) return ;
			if(d.mapHeight == 0) return ;
			if(StringTWLUtil.isWhitespace(d.backImage_file)) return ;
			if(int(createWin.idTI.text) ==0) return ;
			
			get_SeaMapContentMediator().createNewMap(d);
			closeWin();
		}
		
		private function get_SeaMapContentMediator():SeaMapContentMediator
		{
			return retrieveMediator(SeaMapContentMediator.NAME) as SeaMapContentMediator
		}
	}
}