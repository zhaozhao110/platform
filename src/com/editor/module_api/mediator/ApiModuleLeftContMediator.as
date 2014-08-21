package com.editor.module_api.mediator
{
	import com.asparser.Field;
	import com.editor.module_api.manager.ApiSqlConn;
	import com.editor.module_api.view.ApiModuleLeftCont;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.controls.SandyVList;
	import com.sandy.fabrication.SandyMediator;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	public class ApiModuleLeftContMediator extends SandyMediator
	{
		public static const NAME:String = "ApiModuleLeftContMediator"
		public function ApiModuleLeftContMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get api():ApiModuleLeftCont
		{
			return viewComponent as ApiModuleLeftCont;
		}
		public function get pack_box():SandyVList
		{
			return api.pack_box;
		}
		public function get cls_box():SandyVList
		{
			return api.cls_box;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			pack_box.labelField = "name";
			pack_box.addEventListener(ASEvent.CHANGE,onPackBoxChange)
				
			cls_box.addEventListener(ASEvent.CHANGE,onClsBoxChange)
		}
		
		public function respondToApiConnectEvent(noti:Notification):void
		{
			var a:Array = ApiSqlConn.getInstance().sqlHelper.getTableRecordsByName("package");
			pack_box.dataProvider = a;
			pack_box.setSelectIndex(0);
		}
		
		private function onPackBoxChange(e:ASEvent):void
		{
			var obj:Object = pack_box.getSelectItem();
			if(obj == null) return ;
			var stat:String = "SELECT * FROM class where pack='"+obj.name+"'"
			var a:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			cls_box.dataProvider = a;
			cls_box.setSelectIndex(0);
		}
		
		private function onClsBoxChange(e:ASEvent):void
		{
			var obj:Object = cls_box.getSelectItem();
			reflashClass(obj);
		}
		
		public function reflashClass(obj:Object):void
		{
			if(obj == null){
				get_ApiModuleRightContMediator().api.clear();
				return ;
			}
			get_ApiModuleRightContMediator().api.reflashClassInfo(obj);
		}
		
		public function search(c:String):void
		{
			var stat:String = "select * from class where name like '%"+c+"%'"
			var a1:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			if(a1!=null){
				cls_box.dataProvider = a1;
			}
		}
		
		private function get_ApiModuleRightContMediator():ApiModuleRightContMediator
		{
			return retrieveMediator(ApiModuleRightContMediator.NAME) as ApiModuleRightContMediator;
		}
	}
}