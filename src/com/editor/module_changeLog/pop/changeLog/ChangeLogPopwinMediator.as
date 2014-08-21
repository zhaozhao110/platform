package com.editor.module_changeLog.pop.changeLog
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UITextArea;
	import com.editor.module_changeLog.manager.ChangeLogSqlConn;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.ByteArrayUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.data.SQLResult;

	public class ChangeLogPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ChangeLogPopwinMediator"
		public function ChangeLogPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():ChangeLogPopwin
		{
			return viewComponent as ChangeLogPopwin;
		}
		public function get vbox():UIVBox
		{
			return win.vbox;	
		}
		public function get txtArea():UITextArea
		{
			return win.txtArea;
		}
		
		public static var open_times:int;
		
		override public function onRegister():void
		{
			super.onRegister();
			vbox.addEventListener(ASEvent.CHANGE,onVBoxChange);
						
			if(ChangeLogSqlConn.getInstance().connected){
				respondToChangeLogConnectEvent();
			}else{
				ChangeLogSqlConn.getInstance().connSql();
			}
		}
		
		public function respondToChangeLogConnectEvent(noti:Notification=null):void
		{
			var stat:String = "SELECT rowid AS rowid,* FROM log order by time desc limit 0,10";
			var b:SQLResult = ChangeLogSqlConn.getInstance().sqlHelper.executeStatement(stat);
			if(b!=null){
				var a:Array = b.data;
				if(a == null) return ;
				var a1:Array = [];
				for(var i:int=0;i<a.length;i++){
					var obj:Object = a[i] as Object;
					obj.time_n = obj.time;
					obj.time = TimerUtils.getFromatTime(Number(obj.time_n)/1000);
					a1.push(obj);
				}
				vbox.dataProvider = a1.sortOn("time_n",Array.NUMERIC|Array.DESCENDING);
				vbox.setSelectIndex(0)
					
				iSharedObject.put("","lastChangeLogTime",TimerUtils.getCurrentTime());
				
				open_times += 1;
			}
		}
		
		private function onVBoxChange(e:ASEvent):void
		{
			txtArea.htmlText = Object(vbox.selectedItem).content;
		}
		
	}
}