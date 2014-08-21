package com.editor.d3.view.particle.prop.geometry.model
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.view.particle.comp.three.ThreeConstComponent;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ToolUtils;
	
	import flash.events.MouseEvent;

	public class PropModelEditor extends ParticleAttriCellBase
	{
		public function PropModelEditor()
		{
			super();
			
		}
		
		public var vb:UIVBox;
		public var cb:UICombobox;
		public var addBtn:UIButton;
		public var delBtn:UIButton;
		public var threeConstCom:ThreeConstComponent
		
		override protected function create_init():void
		{
			percentWidth = 100;
			height = 500;
			
			var lb:UILabel = new UILabel();
			lb.text = "transforms："
			lb.height = 22;
			addChild(lb);
			
			var h:UIHBox = new UIHBox();
			h.verticalAlignMiddle = true;
			h.height = 25;
			h.percentWidth = 100;
			addChild(h);
			
			cb = new UICombobox();
			cb.width = 100;
			cb.height = 22;
			h.addChild(cb);
			cb.labelField = "label"
			cb.dataProvider = [{label:"scale",data:model_scale},
								{label:"rotation",data:model_rotation},
								{label:"translation",data:model_trans}]
			cb.selectedIndex = 0;
			
			addBtn = new UIButton();
			addBtn.label = "添加"
			h.addChild(addBtn);
			addBtn.addEventListener(MouseEvent.CLICK , onAddClick);
			
			delBtn = new UIButton();
			delBtn.label = "删除"
			h.addChild(delBtn);
			delBtn.addEventListener(MouseEvent.CLICK , onDelClick)
			
			vb = new UIVBox();
			vb.height = 100;
			vb.width = 200;
			vb.styleName = "list"
			vb.labelField = "name"
			vb.enabeldSelect = true;
			vb.addEventListener(ASEvent.CHANGE,onVBChange);
			addChild(vb);
			
			lb = new UILabel();
			lb.text = "value："
			lb.height = 22;
			addChild(lb);
			
			threeConstCom = new ThreeConstComponent();
			threeConstCom.reflash_f = reflashCache;
			addChild(threeConstCom);
		}
		
		private function onVBChange(e:ASEvent):void
		{
			if(vb.selectedItem!=null){
				threeConstCom.setValue(vb.selectedItem.data);
			}
		}
		
		public static const model_scale:int = 2;
		public static const model_rotation:int = 1;
		public static const model_trans:int = 0;
		
		private function get vertex_obj_ls():Array
		{
			return currAnimationData.data.geometry.vertex_obj_ls;
		}
		
		private function onAddClick(e:MouseEvent):void
		{
			var obj:SubPropObj = new SubPropObj();
			obj.type = cb.selectedItem.data;
			obj.name = cb.selectedItem.label;
			obj.index = vertex_obj_ls.length;
			obj.putAttri("id","ThreeDConstValueSubParser");
			vertex_obj_ls.push(obj);
			vb.dataProvider = currAnimationData.data.geometry.vertex_obj_ls;
			vb.setSelectIndex(currAnimationData.data.geometry.vertex_obj_ls.length-1,true,true);
			reflashCache();
		}
		
		public function reflashCache(obj:Object=null):void
		{
			if(obj!=null){
				if(vb.selectedItem!=null){
					vb.selectedItem.data = obj;
				}
			}
			currAnimationData.data.geometry.createVertex(vertex_obj_ls);
		}
		
		private function onDelClick(e:MouseEvent):void
		{
			if(vb.selectedIndex == -1) return ;
			vertex_obj_ls.splice(vb.selectedIndex,1);
			vb.dataProvider = vertex_obj_ls;
			vb.setSelectIndex(0,true,true);
			reflashCache();
		}
		
		override public function changeAnim():void
		{
			super.changeAnim()
			if(currAnimationData.data.geometry.vertexTransform!=null){
				var a:Array = vertex_obj_ls
				vb.dataProvider = a;
				vb.selectedIndex = 0;
			}else{
				vb.dataProvider = null
			}
			if(vb.selectedItem == null){
				threeConstCom.reset();
			}else{
				threeConstCom.setValue(vb.selectedItem.data);
			}
		}
	}
}