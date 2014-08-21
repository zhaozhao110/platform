package com.editor.module_ui.vo.component
{
	import com.editor.manager.DataManager;
	import com.editor.manager.LogManager;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.module_ui.vo.attri.ComAttriListVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.services.Services;
	import com.sandy.component.controls.SandyLoader;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.interfac.ICloneInterface;
	
	import flash.geom.Rectangle;

	public class ComItemVO implements ICloneInterface
	{
		public function ComItemVO(obj:Object=null)
		{
			if(obj == null) return ;
			name = String(obj.label);
			id = obj.id;
			//haveStyle = obj.haveStyle; 
			groupId = obj.group_id;
			
			attri_ls = String(obj.attri).split(",");
			attriList = AppComponentProxy.instance.attri_ls.getArray(attri_ls);
			if(groupId != DataManager.comType_7 && groupId != DataManager.comType_5){
				var a:Array = attri_ls;
				var b:Array = DataManager.default_attri_ls;
				for(var i:int=0;i<b.length;i++){
					if(a.indexOf(String(b[i]))==-1){
						a.push(b[i]);
					}
				}
				attriList = AppComponentProxy.instance.attri_ls.getArray(a);
			}
			if(checkIsProxyComp() && getAttriBykey("proxy")==null ){
				attriList.push(AppComponentProxy.instance.attri_ls.getItem("proxy"));
			}
			
			if(!StringTWLUtil.isWhitespace(obj.style)){
				haveStyle = true;
			}
				
			style_ls = String(obj.style).split(",");
			a = style_ls;
			if(name!="css_global"){
				b = DataManager.default_style_ls;
			}else{
				b = [];
			}
			for(i=0;i<b.length;i++){
				if(a.indexOf(String(b[i]))==-1){
					a.push(b[i]);
				}
			}
			styleList = AppComponentProxy.instance.style_ls.getArray2(a);
						
			var _size:String = String(obj.defaultSize);
			if(!StringTWLUtil.isWhitespace(_size)){
				size = new Rectangle();
				size.width = _size.split(",")[0];
				size.height = _size.split(",")[1];
			}
			toolTip = obj.toolTip;
		}
		
		public function checkIsProxyComp():Boolean
		{
			return name == "ProxyComp";
		}
		
		public var attriList:Array=[];
		public var styleList:Array=[];
		public var toolTip:String;
		private var attri_ls:Array = [];
		private var style_ls:Array = [];
		public var size:Rectangle;
		public var groupId:int;
		public var haveStyle:Boolean;
		public var id:int;
		/**组件名*/
		public var name:String;
		
		public function isExpandComp():Boolean
		{
			return groupId == DataManager.comType_6;
		}
		
		public function isVirtualComp():Boolean
		{
			return groupId == DataManager.comType_5;
		}
		
		public function cloneObject():*
		{
			var d:ComItemVO = new ComItemVO();
			ToolUtils.clone(this,d);
			return d;
		}
		
		public function addAttri(d:ComAttriItemVO):void
		{
			if(getAttriBykey(d.key)==null){
				attriList.push(d);
			}
		}
		
		public function removeAttri(key:String):void
		{
			for(var i:int=0;i<attriList.length;i++){
				if(ComAttriItemVO(attriList[i]).key == key){
					attriList.splice(i,1);
				}
			}
		}
		
		public function getAttriBykey(key:String):ComAttriItemVO
		{
			if(attriList == null) return null;
			for(var i:int=0;i<attriList.length;i++){
				if(attriList[i]!=null&&ComAttriItemVO(attriList[i]).key == key){
					return attriList[i] as ComAttriItemVO;
				}
			}
			return null;
		}
		
		public function getExpandCompsXML():XML
		{
			var out:String = "<item ";
			out += 'type="'+name+'" ';
			for(var i:int=0;i<attriList.length;i++){
				var ite:ComAttriItemVO = attriList[i] as ComAttriItemVO;
				if(noSaveAttri(ite.key)){
					out += ite.key+'="'+ite.value+"*"+ite.dataType+'" ';
				}
			}
			out += " />"
			return XML(out);
		}
		
		private function noSaveAttri(key:String):Boolean
		{
			if(key == "_content") return false;
			if(key == "background_red") return false;
			if(key == "type") return false;
			if(key == "index") return false;
			if(key == "uid") return false; 
			return true;
		}
		
		public function initExpandCompAttri():void
		{
			var prp:UIShowCompProxy = UIEditManager.currEditShowContainer.cache.getTreeNodeByType(name);
			if(prp!=null){
				attriList = prp.data.item.attriList;
			}else{
				attriList = AppComponentProxy.instance.attri_ls.getDefaultArray();
			}
			if(checkIsProxyComp() && getAttriBykey("proxy")==null ){
				attriList.push(AppComponentProxy.instance.attri_ls.getItem("proxy"));
			}
		}
		
	}
}