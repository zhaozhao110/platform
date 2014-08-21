package com.editor.module_roleEdit.pop.preview
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.manager.DataManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.math.SandyRectangle;
	import com.sandy.render2D.map.data.SandyMapConst;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	

	public class PeopleImagePreviewPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "PeopleImagePreviewPopwinMediator"
		public function PeopleImagePreviewPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get previewWin():PeopleImagePreviewPopwin
		{
			return viewComponent as PeopleImagePreviewPopwin
		}
		public function get topTxt():UILabel
		{
			return previewWin.topTxt;
		}
		public function get imgHBox():UIHBox
		{
			return previewWin.imgHBox;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			createComplete();
		}
		
		private function getPreviewImage(ind:int):PeopleImagePreviewImage
		{
			return (previewWin["img" + ind] as PeopleImagePreviewImageContainer).img;
		}
		
		
		private var bitmapdata:BitmapData;
		private var resItem:AppResInfoItemVO;
		private var action:ActionData;
		private var motionItem:AppMotionItemVO;
		private var animation_type:int;
		
		private function createComplete():void
		{
			var proxy:OpenPopwinData = previewWin.item as OpenPopwinData;
			bitmapdata 	= proxy.data.bitmapData;
			action 		= proxy.data.action;
			resItem 	= proxy.data.data;
			motionItem	= proxy.data.motion
			animation_type = proxy.data.animation_type;
			
			topTxt.text = action.type_str;
			//资源ID+动作类型
			iCacheManager.addCacheBitmapData(resItem.id+"_"+action.type+SandyMapConst.url_addSign+action.type,bitmapdata,null);
			
			var totalForward:int = resItem.totalForward
			
			/*if( resItem.type == 1){
				if(action.type == SandyMapConst.status_attackDaiji_type || action.type == SandyMapConst.status_attackPaodong_type){
					totalForward = 8;
				}
			}*/
				
			/*if(resItem.id == 1140){
				totalForward = 2;
			}*/
			
			if(totalForward <= SandyMapConst.forward_2){
				var a:Array = [{key:SandyMapConst.right,value:SandyMapConst.getForwardStr(SandyMapConst.right)}];
			}else if(totalForward == SandyMapConst.forward_4){
				a = SandyMapConst.forward4_ls;
			}else if(totalForward == SandyMapConst.forward_8){
				a = SandyMapConst.forward8_ls;
			}
			
			for(var i:int=1;i<=8;i++)
			{
				getPreviewImage(i).setSize(motionItem.size.width,motionItem.size.height);
				getPreviewImage(i).visible = false;
			}
			
			var sign:String;
			
			for(i=0;i<a.length;i++)
			{
				if(getPreviewImage(i+1)!=null){
					getPreviewImage(i+1).actionType = action.type;
					getPreviewImage(i+1).forward = Object(a[i]).key;
					getPreviewImage(i+1).reflash(bitmapdata,resItem.id+"_"+action.type,
						action.timeline,
						totalForward,
						action.actionVO,
						action.actionVO.column,
						animation_type)
					
					if(resItem.type == 4){
						//getPreviewImage(i+1).loadImage("assets/img/effect_back.png");
					}
				}
			}
			
			previewWin.addEventListener(Event.ENTER_FRAME , onFrame)
		}
		
		
		
		override public function delPopwin():void
		{
			super.delPopwin();
			previewWin.removeEventListener(Event.ENTER_FRAME , onFrame)
		}
		
		private function onFrame(e:Event):void
		{
			for(var i:int=1;i<=8;i++){
				getPreviewImage(i).play(action.type);
			}
		}
		
		
		
		
		
		
	}
}