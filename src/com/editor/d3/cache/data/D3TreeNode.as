package com.editor.d3.cache.data
{
	import away3d.arcane;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.manager.D3KeybroadManager;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.model.AppMainModel;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.vo.IASTreeData;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.error.SandyError;
	import com.sandy.math.ITreeNode;
	import com.sandy.math.TreeNode;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.UIDUtil;
	
	import flash.filesystem.File;

	public class D3TreeNode extends TreeNode
	{
		public function D3TreeNode(d:String = "")
		{
			super();
		}
		
		public function changeUID(uid:String):void
		{
			top.removeAllChild(old_path,false);
			top.addAllChild(this);
		}
		
		private var old_path:String = "";
		
		private var _path:String = "";
		public function get path():String
		{
			return _path;
		}
		public function set path(value:String):void
		{
			if(!StringTWLUtil.isWhitespace(value)) old_path = path; 
			_path = value;
		}
		
		private var _object:D3ObjectBase;
		public function get object():D3ObjectBase
		{
			return _object;
		}
		public function set object(value:D3ObjectBase):void
		{
			_object = value;
			object.node = this;
		}
		
		override public function get name():String
		{
			if(object!=null){
				return object.name;
			}
			return super.name;
		}
		
		override public function set branch(value:IASTreeData):void
		{
			super.branch = value;
			if(value!=null) path = D3TreeNode(value).path+"."+name;
		}
		
		public function reflashPath():void
		{
			if(branch == null) return ;
			path = D3TreeNode(branch).path + "." + name;
			recursion_reflashPath()
		}
		
		private function recursion_reflashPath():void
		{
			var n:int = child_ls.length;
			for(var i:int=0;i<n;i++){
				D3TreeNode(child_ls[i]).reflashPath();
			}
		}
		
		override public function get id():*
		{
			if(StringTWLUtil.isWhitespace(path)){
				SandyError.error("D3TreeNode path is null");
			}
			return path;
		}
		
		
		//////////////////////////////////// //////////////////////////
		
		override public function addItem(item:IASTreeData):void
		{
			if(StringTWLUtil.isWhitespace(item.name)){
				SandyError.error("d3treenode name is null");
			}
			var tmpName:String = path + "." + item.name;
			if(top.getAllChild(tmpName)==null){
				D3TreeNode(item).path = tmpName;
				super.addItem(item);
			}
			child_ls.sortOn("name");
		}
		
		public function reflashSort():void
		{
			child_ls.sortOn("name");
		}
		
		public function getByName(n:String):D3TreeNode
		{
			var len:int = child_ls.length;
			for(var i:int=0;i<len;i++){
				if(D3TreeNode(child_ls[i]).name == n){
					return child_ls[i]
				}
			}
			return null;
		}
		
		public function getIndexByName(n:String):int
		{
			var len:int = child_ls.length;
			for(var i:int=0;i<len;i++){
				if(D3TreeNode(child_ls[i]).name == n){
					return i
				}
			}
			return -1;
		}
		
		public function getByFile(file:File):D3TreeNode
		{
			var len:int = child_ls.length;
			for(var i:int=0;i<len;i++){
				if(D3TreeNode(child_ls[i]).object.file.nativePath == file.nativePath){
					return child_ls[i] as D3TreeNode;
				}
			}
			return null;
		}
		
		public function getNames(n:String):Array
		{
			var b:Array = [];
			for(var i:int=0;i<child_ls.length;i++){
				var fl:D3TreeNode = child_ls[i] as D3TreeNode;
				if(fl.name.indexOf(n)!=-1){
					b.push(fl);
				}
			}
			return b;
		}
		
		public function objectSave():Object
		{
			var obj:Object = {};
			//obj.uid = uid;
			if(object != null){
				obj.attri = object.objectSave();
				if(!object.configData.checkAttri("name")){
					obj.name = name;						
				}
			}else{
				obj.name = name;
			}
			obj.childs = [];
			for(var i:int=0;i<child_ls.length;i++){
				var d:D3TreeNode = D3TreeNode(child_ls[i]);
				if(d.path == "all.global"){
					
				}else{
					obj.childs.push(d.objectSave());
				}
			}
			return obj;
		}
		
		public function getGlobalSave():Object
		{
			for(var i:int=0;i<child_ls.length;i++){
				var d:D3TreeNode = D3TreeNode(child_ls[i]);
				if(d.path == "all.global"){
					return d.objectSave()
				}
			}
			return null;
		}
		
		public function cut():void
		{
			D3KeybroadManager.isCut = true
			D3KeybroadManager.parseNode = this;
			D3KeybroadManager.parseObject = objectSave();
		}
		
		public function paste():void
		{
			if(D3KeybroadManager.isCut){
				if(D3KeybroadManager.parseNode){
					D3KeybroadManager.parseNode.del();
					D3KeybroadManager.parseNode = null;
				}
			}
			D3SceneManager.getInstance().displayList.convertObjectXML(ToolUtils.originalClone(D3KeybroadManager.parseObject),this);
			D3KeybroadManager.isCut = false;
			iManager.sendAppNotification(D3Event.parse_3DObject_event,this);
		}
		
		public function copy():void
		{
			D3KeybroadManager.isCut = false
			D3KeybroadManager.parseNode = this;
			D3KeybroadManager.parseObject = objectSave();
		}
				
		public function del():void
		{
			if(object)object.dispose();
			dispose();
			iManager.sendAppNotification(D3Event.delFile_in3D_event,this);
			iManager.sendAppNotification(D3Event.select3DComp_event,null);
			AppMainModel.getInstance().applicationStorageFile.putKey_3dOutlineUID("")
		}
		
		private function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
	}
}