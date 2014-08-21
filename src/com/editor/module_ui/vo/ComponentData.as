package com.editor.module_ui.vo
{
	import com.editor.manager.DataManager;
	import com.editor.module_ui.ui.CreateUIXML;
	import com.editor.module_ui.ui.UIEditCache;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowCompProxy;
	import com.editor.module_ui.ui.vo.CreateUIFileCompAttri;
	import com.editor.module_ui.ui.vo.InvertedGroupVO;
	import com.editor.module_ui.view.uiAttri.itemRenderer.TabNavViewBox;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.asComponent.controls.ASTabNavigator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.interfac.ICloneInterface;
	
	import flash.filesystem.File;

	/**
	 * 编辑的组件属性
	 */ 
	public class ComponentData implements ICloneInterface
	{
		public function ComponentData()
		{
		}
		
		//组件的类型名,button,canvas....	
		public var name:String;
		public var icon:String;
		public var item:ComItemVO;
		public var proxy:UIShowCompProxy;
		public var invertedGroup:InvertedGroupVO;
		public var compAttriItem:CreateUIFileCompAttri;
		
		public function set target(value:ASComponent):void{};
		public function get target():ASComponent
		{
			if(proxy == null) return null;
			return proxy.target;
		}
		
		public var tabNavsChild:Array;
		public var tabNavsLabel:Array;
		
		public function set toolTip(value:String):void{};
		public function get toolTip():String
		{
			return item.toolTip;
		}
		
		public function checkIsInvertedGroup():Boolean
		{
			if(item.groupId == DataManager.comType_4){
				return true;
			}
			return false;
		}
		
		public var attriObj:Array = [];
		
		public function setAttri(key:String,value:*):void
		{
			if(!StringTWLUtil.isWhitespace(key)){
				attriObj[key] = value;
			}
		}
		
		public function getAttri(key:String):*
		{
			return attriObj[key];
		}
		
		public function set parent(value:String):void{}
		public function get parent():String
		{
			return getAttri("parent");
		}
		
		public function set id(value:String):void{};
		public function get id():String
		{
			return getAttri("id");
		}
		
		public function set info(value:String):void{};
		public function get info():String
		{
			return getAttri("info");
		}
		
		public function set htmlText(value:String):void{};
		public function get htmlText():String
		{
			return getAttri("htmlText");
		}
		
		public function set noCheckAttri(value:Boolean):void{};
		public function get noCheckAttri():Boolean
		{
			if(StringTWLUtil.isWhitespace(getAttri("noCheckAttri"))){
				return false;
			}
			return getAttri("noCheckAttri");
		}
		
		public function getExpandCompsXML():XML
		{
			if(item.isExpandComp()){
				return item.getExpandCompsXML();
			}
			return null;
		}
		
		public function get index():int
		{
			return target.parent.getChildIndex(target)
		}
		
		public function getXML():String
		{			
			var out:String = "<item ";
			out += 'type="'+item.name+'" ';
			out += 'index="'+index+'" ';
			out += 'groupId="'+item.groupId+'" '
			var key:String;
			
			if(item.name == "CheckBox" || item.name == "RadioButton"){
				if(StringTWLUtil.isWhitespace(attriObj["id"])){
					SandyManagerBase.getInstance().showError("组件必须赋值label");
					return "error"
				}
			}
			
			if(StringTWLUtil.isWhitespace(parent)){
				attriObj["parent"] = "stage";
			}
			if(item.isExpandComp()){
				if(item.checkIsProxyComp()){
					if(StringTWLUtil.isWhitespace(attriObj["proxy"])){
						UIEditManager.currEditShowContainer.setTransToolTarget(proxy,true,false);
						UIEditManager.currEditShowContainer.cache.hideAllComp(proxy);
						UIEditManager.currEditShowContainer.setBackgroundVisible(false);
						SandyManagerBase.getInstance().showError("proxyComp必须设置file");
						return "error";
					}
				}
				attriObj["groupId"] = item.groupId;
			}
			for(key in attriObj){
				if(!StringTWLUtil.isWhitespace(key) && noSaveKeys(key)){
					if(noSaveAttri(key,attriObj)){
						if(!checkSave()){
							if(noCheckAttri){
								if(StringTWLUtil.isWhitespace(attriObj["id"])){
									UIEditManager.currEditShowContainer.setTransToolTarget(proxy,true,false);
									UIEditManager.currEditShowContainer.cache.hideAllComp(proxy);
									UIEditManager.currEditShowContainer.setBackgroundVisible(false);
									SandyManagerBase.getInstance().showError("组件必须赋值id");
									return "error"
								}
							}else{							
								UIEditManager.currEditShowContainer.setTransToolTarget(proxy,true,false);
								UIEditManager.currEditShowContainer.cache.hideAllComp(proxy);
								UIEditManager.currEditShowContainer.setBackgroundVisible(false);
								SandyManagerBase.getInstance().showError("组件必须赋值id,width,height");
								return "error";
							}
						}
						if(key == "id"){
							if(attriObj[key] == "stage"){
								SandyManagerBase.getInstance().showError("组件id不能是stage");
								return "error"
							}
						}
						if(noSaveInXML(key)){
							out += " " + key+'="'+parserValue(attriObj[key],key)+'" ';
						}
					}
				}
			}
						
			if(proxy.checkIsMultView()){ 
				tabNavsChild = null;tabNavsChild = [];
				tabNavsLabel = null;tabNavsLabel = [];
				var childs:Array = proxy.target.getChildren();
				for(var i:int=0;i<childs.length;i++){
					var box:TabNavViewBox = childs[i] as TabNavViewBox;
					if(!box.check()){
						SandyManagerBase.getInstance().showError("多视图组件里的子视图没有设置路径");
						return "error"
					}
					tabNavsLabel.push(box.label);
					tabNavsChild.push(box.fileURL);
				} 
				out +=" "+CreateUIFileCompAttri.tabNav_url+'="'+tabNavsChild.join(",")+'" ';
				out +=" "+CreateUIFileCompAttri.tabNav_label+'="'+tabNavsLabel.join(",")+'" ';
			}
			
			if(StringTWLUtil.isWhitespace(htmlText)){
				out += " />"
			}else{
				out += " ><htmlText><![CDATA["+htmlText+"]]></htmlText></item>"
			}
			return out;
		}
		
		public function getAS(cont:String,toAddCache:Boolean=false):UICreateData
		{			
			var _id:String = getAttri("id")
			var d:UICreateData = new UICreateData();

			var proxy_v:* = attriObj["proxy"]
			if(!StringTWLUtil.isWhitespace(proxy_v)){
				proxy_v = proxy_v.split(".")[0];
				d.addImport(proxy_v.split(File.separator).join("."));
				var a:Array = proxy_v.split(File.separator);
				proxy_v = a[a.length-1];
			}
			
			d.vars = "";
			if(!StringTWLUtil.isWhitespace(info)){
				d.vars += "/**"+info+"**/"+NEWLINE_SIGN;
			}
			
			if(item.isExpandComp()){
				if(item.checkIsProxyComp()){
					d.vars += createSpace(2)+"public"+" "+"var"+" "+_id+":"+proxy_v+";"+NEWLINE_SIGN;
				}else{
					d.vars += createSpace(2)+"public"+" "+"var"+" "+_id+":"+item.name+";"+NEWLINE_SIGN;
				}
			}else{
				d.vars += createSpace(2)+"public"+" "+"var"+" "+_id+":UI"+item.name+";"+NEWLINE_SIGN;
			}
			
			var out:String = createSpace(3)+_id+" = new " +"UI"+item.name+"();"+NEWLINE_SIGN;
			if(item.isExpandComp()){
				if(item.checkIsProxyComp()){
					out = createSpace(3)+_id+" = new " +proxy_v+"();"+NEWLINE_SIGN;
				}else{
					out = createSpace(3)+_id+" = new " +item.name+"();"+NEWLINE_SIGN;
				}
			}
			var key:String;
			for(key in attriObj){
				if(!StringTWLUtil.isWhitespace(key) && noSaveKeys(key)){
					if( (noSaveAttri(key,attriObj) && noSaveInAS(key)) || key == "htmlText"){
						out += createSpace(3)+_id+"."+parserKeyInAS(key)+' = '+parserValueInAS(attriObj[key],key,d)+';'+NEWLINE_SIGN;
					}
				}
			}
			
			if(parent == "stage"){
				if(cont.indexOf("delPopwin()")!=-1){
					out += createSpace(3) + "addContentChild("+_id+");"+NEWLINE_SIGN;
				}else{
					out += createSpace(3) + "addChild("+_id+");"+NEWLINE_SIGN;
				}
			}else{
				out += createSpace(3) + parent+".addChild("+_id+");"+NEWLINE_SIGN;
			}
			
			if(item.name == "TabNavigator"){ 
				var childs:Array = proxy.target.getChildren();
				for(var i:int=0;i<childs.length;i++){
					var box:TabNavViewBox = childs[i] as TabNavViewBox;
					var _id2:String = box.getClassName().toLocaleLowerCase()
					d.vars += createSpace(2)+"public"+" "+"var"+" "+_id2+":"+box.getClassName()+";"+NEWLINE_SIGN;
					if(box.fileURL.indexOf(".")!=-1){
						var imps:String = box.fileURL.split(".")[0];
						d.addImport(imps.split(File.separator).join("."));
					}
					var _out:String = createSpace(3)+_id2+" = new "+box.getClassName()+"();"+NEWLINE_SIGN;
					_out += createSpace(3)+_id2+'.label = "'+ box.label + '";'+NEWLINE_SIGN;
					_out += createSpace(3)+_id+".addChild("+_id2+");"+NEWLINE_SIGN;
					out += _out;
				}
			}else if(item.name == "ViewStack"){
				childs = proxy.target.getChildren();
				for(i=0;i<childs.length;i++){
					box = childs[i] as TabNavViewBox;
					_id2 = box.label;
					d.vars += createSpace(2)+"public"+" "+"var"+" "+_id2+":"+box.getClassName()+";"+NEWLINE_SIGN;
					if(box.fileURL.indexOf(".")!=-1){
						imps = box.fileURL.split(".")[0];
						d.addImport(imps.split(File.separator).join("."));
					}
					_out = createSpace(3)+_id2+" = new "+box.getClassName()+"();"+NEWLINE_SIGN;
					_out += createSpace(3)+_id+".addChild("+_id2+");"+NEWLINE_SIGN;
					out += _out;
				}
			}
			d.comp = out;
			if(toAddCache) CreateUIXML.cacheGetAS_ls.push(id.toString());
			return d;
		}
				
		private function parserKeyInAS(key:String):String
		{
			if(key == "_itemRenderer"){
				return "itemRenderer";
			}
			return key;
		}
		
		private function noSaveInAS(key:String):Boolean
		{
			if(key == "parent") return false;
			if(key == "proxy") return false;
			if(key == "width" && int(getAttri("width"))==0) return false;
			if(key == "height" && int(getAttri("height"))==0) return false;
			
			return true;
		}
		
		private function noSaveInXML(key:String):Boolean
		{
			if(key == "width" && int(getAttri("width"))==0) return false;
			if(key == "height" && int(getAttri("height"))==0) return false;
			return true;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
		
		private function noSaveKeys(ky:String):Boolean
		{
			if(ky == CreateUIFileCompAttri.tabNav_label) return false;
			if(ky == CreateUIFileCompAttri.tabNav_url) return false;
			return true;
		}
		
		private function checkSave():Boolean
		{
			if(StringTWLUtil.isWhitespace(attriObj["id"])) return false;
			if(int(attriObj["width"]) == 0) return false;
			if(int(attriObj["height"]) == 0) return false;
			return true;
		}
		
		private function parserValue(v:*,key:String):*
		{
			var val:String = v;
			if(key == "inventedGroup"){
				if(UIEditManager.currEditShowContainer.cache.getInvertedGroup(v)!=null){
					return v;
				}
				return "";
			}
			if(v is Array){
				val = (v as Array).join(";");
			}
			if(StringTWLUtil.beginsWith(String(v),ProjectCache.getInstance().getProjectSrcURL())){
				val = String(v).split(ProjectCache.getInstance().getProjectSrcURL()+File.separator)[1];
			}
			if(val.substring(0,1)==File.separator){
				val = val.substring(1,val.length);
			}
			return val;
		}
		
		//key:属性名
		private function parserValueInAS(v:*,key:String,d:UICreateData):*
		{
			var val:String = v;
			var key_item:ComAttriItemVO;
			key_item = AppComponentProxy.instance.attri_ls.getItem(key);
			if(key_item==null && item.isExpandComp()){
				var obj:Object = ProjectAllUserCache.getInstance().expandComp.getItem(item.name).getValue(key);
				if(obj!=null){
					key_item = new ComAttriItemVO();
					key_item.key = key;
					key_item.dataType = obj.dataType;
				}
			}
			if(v is Array){
				val = "["+(v as Array).join(",")+"]";
			}
			if(StringTWLUtil.beginsWith(String(v),ProjectCache.getInstance().getProjectSrcURL())){
				val = String(v).split(ProjectCache.getInstance().getProjectSrcURL()+File.separator)[1];
			}
			if(val.substring(0,1)==File.separator){
				val = val.substring(1,val.length);
			}
			if(key == "_itemRenderer"){
				val = val.split(".")[0];
				d.addImport(val.split(File.separator).join("."));
				var a:Array = val.split(File.separator);
				val = a[a.length-1];
			}
			if(key == "inventedGroup"){
				return val;
			}
			if(key_item!=null && key_item.dataType == "string"){
				val = '"'+val+'"';
			}
			if(key == "source"){
				val = val.split(File.separator).join("/");
			}
			if(key == "color"){
				val = "0x"+uint(val).toString(16);
			}
			return val;
		}
		
		private function noSaveAttri(key:String,elements:Array):Boolean
		{
			if(key == "info") return false;
			if(key == "htmlText") return false;
			if(key == "label" && v == "") return false;
			if(key == "_content") return false;
			if(key == "groupId") return false;
			if(key == "background_red") return false;
			if(key == "type") return false;
			if(key == "index") return false;
			if(key == "uid") return false; 
			var v:* = elements[key];
			if(String(v) == "NaN") return false;
			if(String(v) == "undefined") return false;
			if(StringTWLUtil.isWhitespace(v)) return false;
			if(key == "doubleClickEnabled" && v == "false") return false;
			if(key == "alpha" && Number(v) == 1) return false;
			if(key == "rotation" && Number(v) == 0) return false;
			if(key == "scaleX" && Number(v) == 1) return false;
			if(key == "scaleY" && Number(v) == 1) return false;
			return true;
		}
		
		public function cloneObject():*
		{
			var d:ComponentData = new ComponentData();
			ToolUtils.clone(this,d);
			return d;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}