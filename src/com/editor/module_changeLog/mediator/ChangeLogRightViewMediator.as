package com.editor.module_changeLog.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.expand.UIEditTextToolBar;
	import com.editor.mediator.AppMediator;
	import com.editor.module_changeLog.event.ChangeLogEvent;
	import com.editor.module_changeLog.manager.ChangeLogSqlConn;
	import com.editor.module_changeLog.view.ChangeLogRightView;
	import com.sandy.utils.ByteArrayUtil;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.data.SQLResult;
	import flash.events.MouseEvent;

	public class ChangeLogRightViewMediator extends AppMediator
	{
		public static const NAME:String = "ChangeLogRightViewMediator";
		public function ChangeLogRightViewMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		public function get win():ChangeLogRightView
		{
			return viewComponent as ChangeLogRightView;
		}
		public function get toolBar():UIEditTextToolBar
		{
			return win.toolBar;
		}
		public function get txtArea():UITextArea
		{
			return win.txtArea;
		}
		public function get okButton():UIButton
		{
			return win.okButton;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			toolBar.targetTF = txtArea.getTextField().getTextField();
			win.setContent(get_ChangeLogLeftViewMediator().vbox.selectedItem);
			
		}
		
		public function reactToOkButtonClick(e:MouseEvent):void
		{
			var selectObj:Object = get_ChangeLogLeftViewMediator().vbox.selectedItem;
			if(selectObj == null) return ;
			if(StringTWLUtil.isWhitespace(StringTWLUtil.trim(txtArea.htmlText))) return ;
			var t:* = ByteArrayUtil.convertStringToByteArray(txtArea.htmlText);
			var time:String = selectObj.time;
			var stat:String = "UPDATE log SET content = @content WHERE id = @id "
			var obj:Object = {};
			obj["@id"] = selectObj.id;
			obj["@content"] = t;
			var b:SQLResult = ChangeLogSqlConn.getInstance().sqlHelper.executeStatement(stat,obj);
			if(b!=null){
				win.infoTi2.text = "保存成功"
			}
			sendAppNotification(ChangeLogEvent.reflash_changeLog_db_event,get_ChangeLogLeftViewMediator().vbox.selectedIndex.toString());
		}
		
		private function get_ChangeLogLeftViewMediator():ChangeLogLeftViewMediator
		{
			return retrieveMediator(ChangeLogLeftViewMediator.NAME) as ChangeLogLeftViewMediator;
		}
	}
}