package com.editor.module_map2.createMap
{
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_map2.mediator.MapEditor2BottomContainerMediator;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.StringTWLUtil;

	public class CreateMap2PopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "CreateMap2PopwinMediator"
		public function CreateMap2PopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():CreateMap2Popwin
		{
			return viewComponent as CreateMap2Popwin
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		override protected function okButtonClick():void
		{			
			var d:MapIsoMapData = new MapIsoMapData();
			d.cellWidth 		= int(createWin.tileWidthTI.text);
			d.cellHeight 		= int(createWin.tileHeightTI.text);
			d.mapWidth 			= int(createWin.widthTI.text);
			d.mapHeight 		= int(createWin.heightTI.text);
			d.backImage_file 	= createWin.fileTI.text;
			
			if(d.cellHeight == 0) return ;
			if(d.cellWidth == 0) return ;
			if(d.mapWidth == 0) return ;
			if(d.mapHeight == 0) return ;
			if(StringTWLUtil.isWhitespace(d.backImage_file)) return ;
			if(int(createWin.idTI.text) ==0) return ;
			
			var m:AppMapDefineItemVO = new AppMapDefineItemVO();
			m.id = int(createWin.idTI.text);
			
			MapEditor2Manager.currentSelectedSceneItem = m; 
			
			get_MapIsoBottomContainerMediator().createNewMap(d);
			closeWin();
		}
		
		private function get_MapIsoBottomContainerMediator():MapEditor2BottomContainerMediator
		{
			return retrieveMediator(MapEditor2BottomContainerMediator.NAME) as MapEditor2BottomContainerMediator;
		}
	}
}