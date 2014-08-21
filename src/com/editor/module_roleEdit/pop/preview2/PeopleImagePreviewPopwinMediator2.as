package com.editor.module_roleEdit.pop.preview2
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.manager.DataManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_map.model.MapConst;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.proxy.PeopleImageProxy;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.math.SandyPoint;
	import com.sandy.math.SandyRectangle;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.render2D.mapBase.loader.SandyMapLoaderManager;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.setTimeout;
	

	public class PeopleImagePreviewPopwinMediator2 extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "PeopleImagePreviewPopwinMediator2"
		public function PeopleImagePreviewPopwinMediator2(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get previewWin():PeopleImagePreviewPopwin2
		{
			return viewComponent as PeopleImagePreviewPopwin2
		}
		public function get topTxt():UILabel
		{
			return previewWin.topTxt;
		}
		public function get imgHBox():UIHBox
		{
			return previewWin.imgHBox;
		}
		public function get actCB():UICombobox
		{
			return previewWin.actCB;
		}
		public function get img1():PeopleImagePreviewImageContainer2
		{
			return previewWin.img1;
		}
		public function get forCB():UICombobox
		{
			return previewWin.forCB;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			SandyMapConst.__init__();
			
			var b:Array = [];
			var a:Array = SandyMapConst.all_action_ls;
			for(var i:int=0;i<a.length;i++){
				b.push({label:SandyMapConst.getActionTypeStr(a[i]),data:a[i]});
			}
			actCB.labelField = "label"
			actCB.dataProvider = b;
			actCB.addEventListener(ASEvent.CHANGE,actChange);
			
			forCB.labelField = "value"
			forCB.dataProvider = SandyMapConst.forward8_ls
			forCB.addEventListener(ASEvent.CHANGE,forChange);
			
			createComplete();
			
			SandyMapLoaderManager.enabled_showQueue = false;
			
			//setTimeout(function():void{previewWin.activate();},1000);
		}
		
		private var resItem:AppResInfoItemVO;
		private var motionItem:AppMotionItemVO;
		
		private function createComplete():void
		{
			var proxy:OpenPopwinData = previewWin.item as OpenPopwinData;
			resItem 	= proxy.data;
			motionItem	= imageProxy.motion_ls.getMotionById(resItem.id);
			
			img1.setSize(motionItem.size.width,motionItem.size.height);
						 
			var d:PeopleImaegPreviewImg2Data = new PeopleImaegPreviewImg2Data();
			d.mapItem_index = Math.random()*10000;
			d.type 				= SandyMapConst.map_item_type_Player;
			d.moveSpeed 		= 7
			d.name 				= resItem.name;
			d.id				= resItem.id.toString();
			d.loc				= new SandyPoint(450,400);
			d.motionData		= motionItem;
			d.sign 				= d.id.toString();
			d.offsetX	 		= d.motionData.originalPoint.x;
			d.offsetY 			= d.motionData.originalPoint.y;
			d.data 				= resItem;
			img1.img.data = d;
			
			previewWin.addEventListener(Event.ENTER_FRAME , onFrame)
		}
		
		private function actChange(e:ASEvent):void
		{
			img1.img.actionType = actCB.selectedItem.data;
		}
		
		private function forChange(e:ASEvent):void
		{
			img1.img.forward = forCB.selectedItem.key;
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			previewWin.removeEventListener(Event.ENTER_FRAME , onFrame)
		}
		
		private function onFrame(e:Event):void
		{
			img1.img.gotoActionForward();
		}
		
		private function get imageProxy():PeopleImageProxy
		{
			return retrieveProxy(PeopleImageProxy.NAME) as PeopleImageProxy;
		}
		
		
		
		
	}
}