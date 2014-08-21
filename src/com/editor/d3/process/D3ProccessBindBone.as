package com.editor.d3.process
{
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.editor.event.App3DEvent;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	public class D3ProccessBindBone extends D3ProccessObject
	{
		public function D3ProccessBindBone(d:D3Object)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group9;
		}

		override public function comReflash(d:ID3ComBase):void
		{
			//super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			if(d.attriId == 31){
				//选择绑定对象
				iManager.sendAppNotification(D3Event.select3DComp_event,D3ObjectBind(comp).bindObject);
			}else if(d.attriId == 29){
				//meshInfo
				D3ViewManager.getInstance().openView_meshInfo(D3ObjectBind(comp).parentObject);
			}else if(d.attriId == 34){
				//delete
				deleteObject();
			}else{
				if(d.attriId == 53 || d.attriId == 52){
					//boneName
					D3ObjectBind(comp).pre_boneName = D3ObjectBind(comp).boneName
					D3ObjectBind(comp).pre_bindObject = D3ObjectBind(comp).bindObject
				}
				
				saveAttri(d,dd);
				reflashPreview(d,dd);
								
				if(d.attriId == 53){
					D3ObjectBind(comp).checkCanBind();
				}else if(d.attriId == 52){
					D3ObjectBind(comp).checkCanBind();
				}
				
				D3ProjectCache.dataChange = true;
			}
		}
		
		override protected function reflashPreview(d:ID3ComBase,v:D3ComBaseVO):void
		{
			if(d.item.value == "button") return ;
			if(D3ObjectBind(comp).bindingTag == null) return ;
			if(D3ObjectBind(comp).bindingTag.hasOwnProperty(d.key)){
				D3ObjectBind(comp).bindingTag[d.key] = v.data;
			}
		}
		
		override public function reflashObjectAttri():void
		{
			var obj:Object = comp.configData.getAttriObj();
			for(var key:String in obj) {
				var element:* = obj[key];
				if(D3ObjectBind(comp).bindingTag.hasOwnProperty(key)){
					D3ObjectBind(comp).bindingTag[key] = obj[key];
				}
			}
		}
		
		override protected function putAttri_path():void
		{
			if(!comp.checkIsInProject()){
				D3ObjectBind(comp).readAnim2();
			}else{
				super.putAttri_path();
			}
		}
		    
		override protected function confirm_del():Boolean
		{
			var b:Boolean = super.confirm_del();
			iManager.sendAppNotification(D3Event.select3DComp_event,D3ObjectBind(comp).parentObject);
			return b;
		}
		
	}
}