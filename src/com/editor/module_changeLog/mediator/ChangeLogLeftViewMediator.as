package com.editor.module_changeLog.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIVlist;
	import com.editor.mediator.AppMediator;
	import com.editor.module_changeLog.manager.ChangeLogSqlConn;
	import com.editor.module_changeLog.view.ChangeLogLeftView;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.ByteArrayUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.data.SQLResult;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	public class ChangeLogLeftViewMediator extends AppMediator
	{
		public static const NAME:String = "ChangeLogLeftViewMediator";
		public function ChangeLogLeftViewMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		public function get win():ChangeLogLeftView
		{
			return viewComponent as ChangeLogLeftView;
		}
		public function get vbox():UIVlist
		{
			return win.vbox;
		}
		public function get okButton():UIButton
		{
			return win.okButton;
		}
		public function get delButton():UIButton
		{
			return win.delButton;
		}
		public function get preBtn():UIButton
		{
			return win.preBtn;
		}
		public function get nextBtn():UIButton
		{
			return win.nextBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			getTotal()
			respondToReflashChangeLogDbEvent();
			vbox.addEventListener(ASEvent.CHANGE,onVBoxChange);
			vbox.setSelectIndex(0);
		}
		
		//当前页
		private var currPage:int;
		//当前页的起始
		private var currPageStartIndex:int;
		//总数
		private var totalNum:int;
		//总页
		private var totalPage:int;
		//每页的数目
		public static const numPerPage:int = 50;
		
		public function respondToReflashChangeLogDbEvent(noti:Notification=null):void
		{
			reflashData()
			if(noti!=null){
				if(noti.getBody()!=null){
					vbox.setSelectIndex(int(noti.getBody()));
				}
			}
		}
		
		private function getTotal():void
		{
			var stat:String = "select count(*) from log";
			var b:SQLResult = ChangeLogSqlConn.getInstance().sqlHelper.executeStatement(stat);
			totalNum = int(Object(b.data[0])["count(*)"]);
			totalPage = Math.ceil(totalNum/numPerPage);
		}
		
		private function reflashData():void
		{
			var stat:String = "SELECT rowid AS rowid,* FROM log order by time desc limit "+currPageStartIndex+","+numPerPage+"";
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
			}
		}
		
		public function reactToPreBtnClick(e:MouseEvent):void
		{
			currPage -= 1;
			if(currPage < 0) currPage = 0;
			currPageStartIndex = currPage*numPerPage;
			reflashData()
			vbox.setSelectIndex(0);
		}
		
		public function reactToNextBtnClick(e:MouseEvent):void
		{
			currPage += 1;
			if(currPage >= totalPage){
				currPage = totalPage-1;
			}
			currPageStartIndex = currPage*numPerPage;
			reflashData()
			vbox.setSelectIndex(0);
		}
		
		public function reactToOkButtonClick(e:MouseEvent):void
		{
			var time:* = TimerUtils.getCurrentTime();
			var stat:String = "INSERT INTO log (time,content) VALUES (@time,@content)"
			var obj:Object = {};
			obj["@time"] = time;
			obj["@content"] = "";
			var b:SQLResult = ChangeLogSqlConn.getInstance().sqlHelper.executeStatement(stat,obj);
			respondToReflashChangeLogDbEvent();
			vbox.setSelectIndex(0);
		}
		
		public function reactToDelButtonClick(e:MouseEvent):void
		{
			if(vbox.selectedItem == null) return ;
			var m:OpenMessageData = new OpenMessageData();
			m.info = "您确定删除"+vbox.selectedItem.time+"的记录？"
			m.okFunction = confirm_del;
			showConfirm(m);
		}
		
		private function confirm_del():Boolean
		{
			var selectind:int = vbox.selectedIndex;
			var stat:String = "DELETE FROM log WHERE id = @id"
			var obj:Object = {};
			obj["@id"] = vbox.selectedItem.id;
			var b:SQLResult = ChangeLogSqlConn.getInstance().sqlHelper.executeStatement(stat,obj);
			respondToReflashChangeLogDbEvent();
			vbox.setSelectIndex(selectind-1);
			return true;
		}
		
		private function onVBoxChange(e:ASEvent):void
		{
			if(get_ChangeLogRightViewMediator() == null) return 
			if(get_ChangeLogRightViewMediator().win == null) return ;
			get_ChangeLogRightViewMediator().win.setContent(vbox.selectedItem);
		}
		
		private function get_ChangeLogRightViewMediator():ChangeLogRightViewMediator
		{
			return retrieveMediator(ChangeLogRightViewMediator.NAME) as ChangeLogRightViewMediator;
		}
		
	}
}