package com.editor.module_code.view.search
{
	import com.asparser.Field;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.mediator.AppMediator;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.filesystem.File;

	public class CodeSearchViewMediator extends AppMediator
	{
		public static const NAME:String = "CodeSearchViewMediator"
		public function CodeSearchViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get searchView():CodeSearchView
		{
			return viewComponent as CodeSearchView;
		}
		public function get comList():UIVlist
		{
			return searchView.comList;
		}
		public function get infoLb():UILabel
		{
			return searchView.infoLb;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			comList.addEventListener(ASEvent.CHANGE,onComListChange);
		}
		
		private function onComListChange(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var d:OpenFileData = new OpenFileData();
				var f:Field = e.addData as Field;
				var a:Array = f.search_ls;
				var b:Array = [];
				var fist:int = -1;
				for(var i:int=0;i<a.length;i++){
					var child_f:Field = a[i] as Field;
					var sign:Field = new Field();
					sign.index = child_f.index;
					if(fist==-1){
						fist = child_f.index;
					}
					b.push(sign);
				}
				d.rowIndex = fist;
				d.rowSign_ls = b;
				d.file = new File(f.filePath);
				sendAppNotification(AppModulesEvent.openEditFile_event,d);
			}
		}
		
		public function respondToGlobalSearchCompleteEvent(noti:Notification):void
		{
			var a:Array = noti.getBody() as Array;
			comList.dataProvider = a
			infoLb.text = "一共搜索到"+a.length+"条数据";
		}
		
	}
}