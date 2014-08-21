package com.editor.module_avg.popview.attri
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.manager.DataManager;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.manager.AVGProxy;
	import com.editor.module_avg.popview.attri.com.AVGComBase;
	import com.editor.module_avg.preview.AVGPreview;
	import com.editor.module_avg.vo.AVGResData;
	import com.editor.module_avg.vo.attri.AVGComAttriItemVO;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class AVGAttriCell extends UIVBox
	{
		public function AVGAttriCell()
		{
			super();
			
			enabledPercentSize = true
			backgroundColor = DataManager.def_col;
			styleName = "uicanvas"
			padding = 5;
			
			var btn:UIButton = new UIButton();
			btn.label = "关闭"
			btn.addEventListener(MouseEvent.CLICK , onBtnClick);
			addChild(btn);
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			AVGManager.currAttriView = null;
			visible=false;
		}
		
		public var resData:AVGResData;
		
		public function reflashAttri(d:AVGResData):void
		{
			if(resData!=null){
				if(resData.id == d.id){
					create(d);
				}
			}
		}
		
		public function create(dr:AVGResData):void
		{
			resData = dr;
			var a:Array = AVGProxy.instance.com_ls.getItemByType(dr.getResType()).attri.split(",");
			a = AVGProxy.instance.attri_ls.getArray(a);	
		
			for(var i:int=0;i<a.length;i++)
			{
				var _item:AVGComAttriItemVO = a[i] as AVGComAttriItemVO;
				var ds:AVGComBase = _createItemRenderer(_item);
				if(ds!=null){
					ds.compItem = resData;
					ds.item = _item;
					var key:String = ds.item.key;
					var d:AVGAttriComBaseVO = new AVGAttriComBaseVO();
					d.key = key;
					d.value = _item.defaultValue;
					ds.setValue(d);
				}
			}
			
			visible = true;
		}
		
		private var attri_ls:Array = [];
		
		private function _createItemRenderer(_item:AVGComAttriItemVO):AVGComBase
		{
			if(attri_ls[_item.key] != null) return attri_ls[_item.key] as AVGComBase;
			
			var ds:AVGComBase = AVGComTypeManager.getComByType(_item.value);
			if(ds!=null){
				ds.compItem = resData;
				ds.item = _item;
				ds.reflashFun = reflashCompAttri;
				ds.getCompValue_f = getCompValue
				addChild(ds as DisplayObject);
			}
			attri_ls[_item.key] = ds;
			return ds
		}
		
		private function getCompValue(ds:AVGComBase):*
		{
			return resData.getAttri(ds.key);
		}
		
		private function reflashCompAttri(ds:AVGComBase):void
		{
			//var d:AVGAttriComBaseVO = ds.getValue();
			AVGPreview.instance.getPreviewItem(ds.compItem.id).setDisplayObject(ds)
		}
		
		
	}
}