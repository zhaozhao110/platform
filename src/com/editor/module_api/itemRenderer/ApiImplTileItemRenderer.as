package com.editor.module_api.itemRenderer
{
	import com.editor.module_api.EditorApiFacade;
	import com.editor.module_api.manager.ApiSqlConn;
	import com.editor.module_api.mediator.ApiModuleLeftContMediator;
	import com.sandy.component.controls.SandyLinkButton;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;
	
	public class ApiImplTileItemRenderer extends ApiTileItemRenderer
	{
		public function ApiImplTileItemRenderer()
		{
			super();
		}
		
		override protected function __init__():void
		{
			super.__init__();
			mouseChildren = true;
			mouseEnabled= true;
			
		}
		
		override public function get color():*
		{
			return ColorUtils.green
		}
		
		override protected function renderTextField():void
		{
			if(label!="" && textfield == null){
				textfield = new SandyLinkButton();
				textfield.color = ColorUtils.green;
				textfield.multiline = false;
				textfield.addEventListener(MouseEvent.CLICK ,link_f);
				addChild(textfield);
			}
			
			super.renderTextField();
		}
		
		private var linkTxt:SandyLinkButton;
		
		private function link_f(e:MouseEvent):void
		{
			var stat:String = "SELECT * FROM class where name='"+Object(data).name+"' and pack='"+Object(data).packagePath+"';"
			var a1:Array = ApiSqlConn.getInstance().sqlHelper.executeStatement(stat).data;
			if(a1!=null){
				get_ApiModuleLeftContMediator().reflashClass(a1[0]);
			}
		}
		
		private function get_ApiModuleLeftContMediator():ApiModuleLeftContMediator
		{
			return EditorApiFacade.getInstance().moduleFacade.retrieveMediator(ApiModuleLeftContMediator.NAME) as ApiModuleLeftContMediator;
		}
		
	}
}