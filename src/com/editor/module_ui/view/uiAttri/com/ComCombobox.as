package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.component.controls.UICombobox;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.module_ui.view.uiAttri.vo.ComBaseVO;
	import com.editor.module_ui.view.uiAttri.vo.ComComboboxVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;

	public class ComCombobox extends ComBase
	{
		public function ComCombobox()
		{
			super();
		}
		
		private var cb:UICombobox;
		
		override protected function create_init():void
		{
			super.create_init();
			
			cb = new UICombobox();
			cb.width = 120;
			cb.height = 23;
			cb.addEventListener(ASEvent.CHANGE,onChangeHandle);
			addChild(cb);
		}
		
		private function onChangeHandle(e:ASEvent):void
		{
			if(StackManager.checkIsEditUI()){
				callUIRender();
			}
		}
		
		override public function getValue():IComBaseVO
		{
			if(cb.selectedItem == null) return null;
			var d:ComBaseVO = new ComBaseVO();
			initVO(d);
			if(StringTWLUtil.isWhitespace(cb.selectedItem)){
				d.value = null;
			}else{
				if(Object(cb.selectedItem).hasOwnProperty("data")){
					d.value = cb.selectedItem.data;
				}else{
					d.value = cb.selectedItem;
				}
			}
			return d;
		}
		
		override protected function reflash_init():void
		{
			super.reflash_init();
			if(StringTWLUtil.isWhitespace(item.expand)) return ;
			
			var b:Array = [];
			b.push("");
			b = b.concat(item.expand.split(","));
			cb.dataProvider = b;
			toolTip = item.toolTip;
		}
				
		override public function setValue(obj:IComBaseVO):void
		{
			super.setValue(obj);
			
			cb.setSelectIndex(0,false,true);
			
			if(key == "changeDirection"){
				cb.labelField = "";
			}else{
				cb.labelField = "name"
			}
			
			if(StackManager.checkIsEditCSS()){
				if(css_data.paser.getValue(item.key)!=null){
					cb.setSelectedItem(css_data.paser.getValue(item.key).getVO().value,false);
				}
				return ;
			}
			
			if(obj!=null){
				if(compItem!=null){
					if(compItem.item.groupId == DataManager.comType_4){
						if(obj is ComComboboxVO){
							if(ComComboboxVO(obj).combobox_dataProvider!=null){
								cb.dataProvider = ComComboboxVO(obj).combobox_dataProvider;
							}
						}
					}
				}
				cb.setSelectedItem(obj.value,false);
			}
			
		}
		
		
	}
}