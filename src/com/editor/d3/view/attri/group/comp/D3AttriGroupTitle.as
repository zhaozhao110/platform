package com.editor.d3.view.attri.group.comp
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIText;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.view.attri.group.D3AttriGroupViewBase;
	import com.editor.d3.view.outline.D3OutlinePopViewMediator;
	import com.editor.d3.view.project.D3ProjectPopViewMediator;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.sandy.asComponent.controls.ASHRule;
	import com.sandy.asComponent.controls.ASPopupImage;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.gameTool.groupSelect.GroupSelectEvent;
	import com.sandy.utils.ColorUtils;
	
	import flash.geom.Vector3D;
	
	public class D3AttriGroupTitle extends UICanvas
	{
		public function D3AttriGroupTitle()
		{
			super();
			create_init();				
		}
		
		public var target:D3AttriGroupViewBase;
		private var setBtn:ASPopupImage;
		
		public function create_init():void
		{
			height = 25;
			percentWidth = 100;
								
			setBtn = new ASPopupImage();
			setBtn.source = "set1_a";
			setBtn.width = 23;
			setBtn.height = 16;
			setBtn.labelField = "label"
			setBtn.right = 30;
			setBtn.dropDownWidth = 110
			addChild(setBtn);
			setBtn.rowSelectChange_proxy = onAddHandle2;
		}
		
		public function relfashMenu():void
		{
			var a:Array = [];
			if(target.comp.group == D3ComponentConst.comp_group8 || 
				target.comp.group == D3ComponentConst.comp_group9 ||
				target.comp.isMethod){
				a.push({label:"返回",data:"1"});
			}else{
				a.push({label:"删除",data:"34"});
				if(target.comp.group == D3ComponentConst.comp_group1 ||
					target.comp.group == D3ComponentConst.comp_group7 ||
					target.comp.group == D3ComponentConst.comp_group10 ||
					target.comp.group == D3ComponentConst.comp_group11){
					a.push({label:"对齐地形高度",data:"113"});
				}
			}
			setBtn.dataProvider = a;
		}
		
		private function onAddHandle2(e:ASEvent):void
		{
			var obj:Object = setBtn.selectedItem;
			if(obj.data == "1"){
				iManager.sendAppNotification(D3Event.select3DComp_event,target.comp.parentObject);
			}else if(obj.data == "34"){
				if(target.comp.checkIsInProject()){
					get_D3ProjectPopViewMediator().delFile(target.comp.file);
				}else{
					get_D3OutlinePopViewMediator().delFile(target.comp.node);
				}
			}else if(obj.data == "113"){
				var obj_loc:Vector3D = target.comp.proccess.mapItem.getObject().position;
				var obj_y:Number = D3SceneManager.getInstance().displayList.terrain.getElevation().getHeightAt(obj_loc.x,obj_loc.z);
				target.comp.proccess.setAttri("y",obj_y);
			}
		}
		
		private function get_D3OutlinePopViewMediator():D3OutlinePopViewMediator
		{
			return iManager.retrieveMediator(D3OutlinePopViewMediator.NAME) as D3OutlinePopViewMediator;
		}
		
		private function get_D3ProjectPopViewMediator():D3ProjectPopViewMediator
		{
			return iManager.retrieveMediator(D3ProjectPopViewMediator.NAME) as D3ProjectPopViewMediator;
		}
		
	}
}