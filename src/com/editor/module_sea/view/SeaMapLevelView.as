package com.editor.module_sea.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIImage;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.popview.SeaMapSmallImgPopView;
	import com.editor.module_sea.vo.SeaMapItemVO;
	import com.editor.module_sea.vo.SeaMapLevelVO;

	public class SeaMapLevelView extends UICanvas
	{
		public function SeaMapLevelView()
		{
			super();
		}
		
		public var levelItem:SeaMapLevelVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			levelItem = value;
			levelItem.container = this;
									
			if(levelItem.index == 0){
				addBackImage()	
			}
			addItems();
		}
		
		private var img:UIImage;
		private function addBackImage():void
		{
			if(img == null){
				img =new UIImage();
				img.complete_fun = loadImgComplete
				addChild(img);
			}
			img.source = SeaMapModuleManager.currProject.resFold + SeaMapModuleManager.mapData.backImage_file;
		}
		
		private function loadImgComplete():void
		{
			SeaMapSmallImgPopView.instance.loadDrawImg()
		}
		
		private var loadIndex:int;
		private function addItems():void
		{
			if(levelItem.item_ls.length > 0){
				loadQueue();
			}
		}
		
		private function loadQueue():void
		{
			if(loadIndex < levelItem.item_ls.length){
				var d:SeaMapItemVO = levelItem.item_ls[loadIndex] as SeaMapItemVO
				_createItem(d);	
				loadIndex += 1;
			}
		}
		
		public function loadNext():void
		{
			loadQueue();
		}
		
		public function _createItem(d:SeaMapItemVO,nextNext:Boolean=true):SeaMapItemView
		{
			var v:SeaMapItemView = new SeaMapItemView();
			v.needNext = nextNext;
			v.poolChange(d);
			addChild(v);
			return v;
		}
		
	}
	
}