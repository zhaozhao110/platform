package com.editor.moudule_drama.mediator.left.attributeEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.mediator.AppMediator;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.timeline.vo.TimelineRow_BaseVO;
	import com.editor.moudule_drama.view.left.attributeEditor.DramaAttributeEditor_Row;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.Drama_RowVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;

	/**
	 * 层属性
	 * @author sun
	 * 
	 */	
	public class DramaAttributeEditor_RowMediator extends AppMediator
	{
		public static const NAME:String = "DramaAttributeEditor_RowMediator";
		
		private var vo:Drama_RowVO;
		
		public function DramaAttributeEditor_RowMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():DramaAttributeEditor_Row
		{
			return viewComponent as DramaAttributeEditor_Row;
		}
		/**容器**/
		public function get vbox():UIVBox
		{
			return mainUI.vbox;
		}
		/**属性标题**/
		public function get titleInput():UITextInputWidthLabel
		{
			return mainUI.titleInput;
		}
		/**当前未显示资源列表 container**/
		public function get canvas1():UICanvas
		{
			return mainUI.canvas1;
		}
		/**当前未显示资源列表 vbox**/
		public function get notDisplayResListVbox():UIVBox
		{
			return mainUI.notDisplayResListVbox;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		
		/**设置当前数据**/
		public function setData(pVo:TimelineRow_BaseVO):void
		{
			vo = pVo as Drama_RowVO;
			
			listenInputs(0);
			if(vo)
			{
				titleInput.text = vo.name;
				
				updataResListVbox();
			}else
			{
				if(vbox.contains(canvas1)) vbox.removeChild(canvas1);
			}
			listenInputs(1);
		}
		
		/**数据改变**/
		public function dataChange():void
		{
			if(vo)
			{
				
			}
		}
		
		/**侦听表单**/
		private function listenInputs(status:int):void
		{
			if(status > 0)
			{
				
			}else
			{
				
			}
		}
		
		/**更新当前帧隐藏的显示对象列表**/
		public function updataResListVbox():void
		{
			if(vo)
			{
				/**资源层类型**/
				if(vo.type == DramaDataManager.frameRowType2)
				{
					vbox.addChild(canvas1);
					var a:Array = DramaDataManager.getInstance().getRowNotDisplayLayoutViewList(vo.id);
					if(a)
					{
						notDisplayResListVbox.dataProvider = a;
					}
				}else
				{
					if(vbox.contains(canvas1)) vbox.removeChild(canvas1);
				}
			}
		}
		
		
	}
}