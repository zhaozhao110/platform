package com.editor.project_pop.flexToAS3.convert
{
	
	import com.air.component.SandyFile;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.project_pop.flexToAS3.convert.processor.ContentAreaProcessor;
	import com.editor.project_pop.flexToAS3.convert.processor.MoveProcessor;
	import com.editor.project_pop.flexToAS3.convert.processor.ScriptProcessor;
	import com.editor.project_pop.flexToAS3.convert.vo.ConvertData;
	import com.editor.project_pop.flexToAS3.convert.vo.VariableData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	/**
	 * convert flex to as3
	 */ 
	public class ConvertFlex
	{
		public function ConvertFlex()
		{
		}
		
		public var data:ConvertData = new ConvertData();
		
		public var addLog:Function;
		
				 
		public function parser(file:SandyFile):void
		{
			data.selectFile = file;
			
			var read:ReadFile = new ReadFile();
			data.originalText = read.read(file.nativePath);
			//data.originalText = StringTWLUtil.replace(data.originalText,"xmlns:","@");
			data.xml = new XML(data.originalText);
			
		}
		
		/**
		 * 转换目录
		 */ 
		public function convertDirectory():void
		{
			//删除目标目录下的所有文件
			//DeleteFile.deleteDirectory(data.targetDirectory);
			
			var file_a:Array = data.originalDirectory.getDirectoryListing();
			_convertChildDirectory(file_a);
			
			addLog("转换总数量: " + total_convert_n);
			addLog("拷贝总数量: " + total_copy_n);
		}
		
		private function _convertChildDirectory(file_a:Array):void
		{
			var n:int = file_a.length;
			for(var i:int=0;i<n;i++)
			{
				var _file:File = file_a[i] as File;
				if(!_file.isHidden)
				{
					if(_file.isDirectory)
					{
						_convertChildDirectory(_file.getDirectoryListing());	
					}
					else
					{
						_convertOneFile(_file);						
					}
				}
			}
		}
		
		//转换总数量
		private var total_convert_n:int;
		//拷贝总数量
		private var total_copy_n:int;
		
		private function _convertOneFile(_file:File):void
		{
			var selectFile:SandyFile = new SandyFile(_file);
			if(selectFile.fileName == "hunt_project") return ;
			if(selectFile.fileName == "SwfDownloadProgress") return ;
			
			var path:String = data.targetDirectory.nativePath + selectFile.nativePath.split(data.originalDirectory.nativePath)[1];
			var file:File 
			
			if(_file.extension == "mxml")
			{
				//return 
				var conv:ConvertFlex = new ConvertFlex();
				conv.data.originalDirectory = data.originalDirectory
				conv.data.targetDirectory = data.targetDirectory
				conv.parser(selectFile)	
								
				path = path.split(".")[0] + ".as";
				file = new File(path);
				
				var write:WriteFile = new WriteFile();
				write.writeAsync(file,conv.createClassString());
				
				addLog("转换:" + path)	
				
				total_convert_n += 1;
			}
			else if(_file.extension == "css")
			{
				return 
				/*var convCSS:ConvertCSS = new ConvertCSS(data);
				convCSS.parser(selectFile)*/
					
				//path = path.split(".")[0] + ".as";
				//file = new File(path); 
				
				/*write = new WriteFile();
				write.writeAsync(file,convCSS.createClassString());*/
				
				/*path = path.split(".")[0] + ".css";
				file = new File(path);
				
				_file.copyToAsync(file,true);*/
				
				addLog("转换CSS:" + path)
				total_copy_n += 1
			}
			else
			{
				//return 
				path = path.split(".")[0] + "."+_file.extension;
				file = new File(path);
				
				//copy
				_file.copyToAsync(file,true);
				addLog("拷贝:" + path)
				
				total_copy_n += 1
			}
		}
		
		/**
		 * 产生as文件的流
		 */ 
		public function createClassString():String
		{		
			data.custom_namespace = data.xml.namespaceDeclarations();
			
			var init_s:String = createInit();
			
			var head_s:String = createFileHead();
			
			var end_s:String = createFileEnd();
			
			var result_s:String = head_s + init_s + end_s;
			
			for(var i:int=0;i<ConvertData.delete_str_ls.length;i++)
			{
				result_s = StringTWLUtil.replace(result_s,ConvertData.delete_str_ls[i],"");	
			}
			
			return result_s;
		}
		
		/**
		 * create import
		 */ 
		private function createImport():String
		{
			var clsStr:String = "";
			
			var names:Array = data.custom_namespace;
			for(var i:int=0;i<names.length;i++)
			{
				var ns:Object = names[i] as Object;
				if(ConvertData.exclude_mxml_ls.indexOf(String(ns.uri))==-1){
					if(String(ns.uri).substring(0,3) == "mx."){
						if(ConvertData.mxml_ls.indexOf(ns.uri)==-1){
							clsStr += createSpace()+"import"+createSpace()+ns.uri+";"+NEWLINE_SIGN;
						}
					}else{
						clsStr += createSpace()+"import"+createSpace()+ns.uri+";"+NEWLINE_SIGN;
					}
				}
			}
			
			clsStr += createSpace()+"import"+createSpace2()+"flash.events.*;"+NEWLINE_SIGN;
			clsStr += createSpace()+"import"+createSpace2()+"flash.display.*;"+NEWLINE_SIGN;
			clsStr += createSpace()+"import"+createSpace2()+"flash.geom.*;"+NEWLINE_SIGN;
			clsStr += createSpace()+"import"+createSpace2()+"flash.utils.*;"+NEWLINE_SIGN;
			clsStr += createSpace()+"import"+createSpace2()+"com.rpg.utils.*;"+NEWLINE_SIGN; 
			
			return clsStr;
		}
		
		/**
		 * 文件的头
		 */ 
		private function createFileHead():String
		{
			data.implements_str = data.xml.attribute("implements")[0];
			
			if(data.implements_str!=null){
				var impl_a:Array = data.implements_str.split(".");
				var ns:Object = {};
				ns.prefix = impl_a[impl_a.length-1];
				ns.uri = data.implements_str;
				data.custom_namespace.push(ns);
			}
			
			var clsStr:String = "package"+createSpace2()+ createClassPath()+"{" + NEWLINE_SIGN;
			
			clsStr += createImport() + NEWLINE_SIGN;
			
			clsStr += createSpace(1)+"public"+createSpace2()+"class"+createSpace2()+data.selectFile.fileName+createSpace2()+"extends"+createSpace2()+data.xml.localName();
			if(data.implements_str != null){
				clsStr += createSpace2()+"implements"+createSpace2()+data.implements_str+NEWLINE_SIGN;
			}else{
				clsStr += NEWLINE_SIGN;
			}
			clsStr += createSpace(1)+"{" + NEWLINE_SIGN;
			
			clsStr += createSpace(2)+"public"+createSpace2()+"function"+createSpace2()+data.selectFile.fileName+"()"+NEWLINE_SIGN;
			clsStr += createSpace(2)+"{"+NEWLINE_SIGN;
			
			clsStr += createSpace(3)+"super()"+NEWLINE_SIGN;
			clsStr += createSpace(3)+"create_init()"+NEWLINE_SIGN;
			clsStr += createSpace(2)+"}"+NEWLINE_SIGN;
						
			return clsStr;
		}
		
		/**
		 * create __init__ and create variable
		 */ 
		private function createInit():String
		{
			data.init_str = createSpace(2)+"//程序生成"+NEWLINE_SIGN;
			data.init_str += createSpace(2)+"private function create_init():void"+NEWLINE_SIGN;
			data.init_str += createSpace(2)+"{"+NEWLINE_SIGN;
			//clsStr += createSpace(3)+"super();"+NEWLINE_SIGN;
			
			data.init_str += getMainXMLAttri();
			
			//创建子容器
			parserChildXML(data.xml,data,"this");
			
			var clsStr2:String = NEWLINE_SIGN;
			clsStr2 += createVariable(data.variable);
			clsStr2 += NEWLINE_SIGN;
			clsStr2 += data.init_str;
			clsStr2 += NEWLINE_SIGN;
			clsStr2 += createSpace(3)+"//dispatchEvent creationComplete"+NEWLINE_SIGN;
			clsStr2 += createSpace(3)+"initComplete();"+NEWLINE_SIGN;
			clsStr2 += createSpace(2)+"}"+NEWLINE_SIGN;
			clsStr2 += NEWLINE_SIGN;
			clsStr2 += createSpace(2)+"//原始文件里的script"
			clsStr2 += data.script+NEWLINE_SIGN;
			
			return clsStr2;
		}
		
		/**
		 * 一级一级的往下
		 */ 
		public function parserChildXML(xml:XML,dat:ConvertData,parentId:String=null):void
		{
			var child_ls:XMLList = xml.children();
			for(var i:int=0;i<child_ls.length();i++)
			{
				var child_xml:XML = XML(child_ls[i]);
				if(child_xml.localName() == ScriptProcessor.metadata)
				{
					var processor:ScriptProcessor = new ScriptProcessor(this);
					processor.parser(child_xml);
				}
				else if(ContentAreaProcessor.metadata.indexOf(child_xml.localName().toString())!=-1)
				{
					var contentProcess:ContentAreaProcessor = new ContentAreaProcessor(this);
					contentProcess.parser(child_xml,parentId);
				}
				else if(child_xml.localName().toString() == MoveProcessor.metadata)
				{
					var moveProcess:MoveProcessor = new MoveProcessor(this);
					moveProcess.parser(child_xml);
				}
				else
				{
					var childParentId:String = parserXML(child_xml,true,dat,true,parentId);
					parserChildXML(child_xml,dat,childParentId);
				}
			}
		}
		
		/**
		 *  xml
		 * @return 父级的ID
		 */ 
		public function parserXML(xml:XML,enabeld_addChild:Boolean=true,dat:ConvertData=null,addVariable:Boolean=true,parentId:String=null):String
		{
			var vari:VariableData = new VariableData();
			vari.className = xml.localName();
			vari.id = xml.attribute("id")[0];
			vari.comments = xml.comments()[0];
			if(addVariable){
				data.variable.push(vari);
			}
						
			var clsStr:String = NEWLINE_SIGN;
			if(!StringTWLUtil.isWhitespace(vari.id))
			{
				clsStr += createSpace(3)+vari.id+createSpace2()+"="+createSpace2()+"new"+createSpace2()+vari.className+"();"+NEWLINE_SIGN;
				clsStr += createAttriAndValue(xml,vari.id);
				if(enabeld_addChild){
					if(ConvertData.disabled_addChild_ls.indexOf(vari.className)==-1){
						clsStr += createSpace(3)+parentId+".addChild("+vari.id+");"+NEWLINE_SIGN;
					}
				}
			}
			else
			{
				vari = new VariableData();
				vari.className = xml.localName();
				vari.id = vari.className.toLocaleLowerCase()+createUIComponentIndex()
				clsStr += createSpace(3)+"var"+createSpace2()+vari.id+":"+vari.className+createSpace2()+"="+createSpace2()+"new"+createSpace2()+vari.className+"();"+NEWLINE_SIGN;
				clsStr += createAttriAndValue(xml,vari.id);
				if(enabeld_addChild){
					if(ConvertData.disabled_addChild_ls.indexOf(vari.className)==-1){
						clsStr += createSpace(3)+parentId+".addChild("+vari.id+");"+NEWLINE_SIGN;
					}
				}
			}
			
			dat.init_str += clsStr;
			return vari.id;
		}
		
		/**
		 * 声明变量
		 */ 
		private function createVariable(var_ls:Array):String
		{
			var clsStr:String = NEWLINE_SIGN;
			for(var i:int=0;i<var_ls.length;i++)
			{
				var vari:VariableData = var_ls[i] as VariableData;
				if(vari.id != null){
					//clsStr += createSpace(2)+"//"+vari.comments+NEWLINE_SIGN
					clsStr += createSpace(2)+"public"+createSpace2()+"var"+createSpace2()+vari.id+":"+vari.className+";"+NEWLINE_SIGN;
				}
			}
			return clsStr;
		}
		
		/**
		 * 主xml的属性
		 */ 
		private function getMainXMLAttri():String
		{
			var clsStr:String = NEWLINE_SIGN;
			clsStr += createSpace(3)+"//主文件的属性"+NEWLINE_SIGN;
			clsStr += createAttriAndValue(data.xml,"this");
			return clsStr;
		}
		
		/**
		 * 文件的尾
		 */ 
		private function createFileEnd():String
		{
			var clsStr:String = "";
			
			clsStr += createSpace()+"}" + NEWLINE_SIGN;
			clsStr += "}";
			
			return clsStr;	
		}
		
		/**
		 * 产生类的路径
		 * 
		 */ 
		private function createClassPath():String
		{
			var path:String = data.selectFile.nativePath;
			path = path.split(data.originalDirectory.nativePath)[1];
			path = path.split("\\").join(".");
			path = path.split(data.selectFile.name)[0];
			if(path.substring(0,1) == "."){
				path = path.substring(1,path.length);
			}
			if(path.substring(path.length-1,path.length)=="."){
				path = path.substring(0,path.length-1);
			}
			return path
		}
		
		
		
		private function createSpace(n:int=1):String
		{
			var out:String = "";
			for(var i:int=0;i<n;i++){
				out += "	";
				//out += " "
			}
			return out;
		}
		
		private function createSpace2(n:int=1):String
		{
			var out:String = "";
			for(var i:int=0;i<n;i++){
				//out += "	";
				out += " "
			}
			return out;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		/**
		 * 判断数值是什么类型的
		 */ 
		private function checkValueType(value:String,attri:String):String
		{
			if(value == "false" || value == "true"){
				return value;
			}
						
			var isString:Boolean;
			var isVariable:Boolean;
			if(ConvertData.string_ls.indexOf(attri)!=-1){
				isString = true;  
			}
			if(value.indexOf("{")!=-1){
				value = value.substring(1,value.length-1);
				isVariable = true;
			}
			if(ConvertData.variable_ls.indexOf(attri)!=-1){
				isVariable = true;
			}
			if(isVariable){
				if(isString){
					return value+".toString()";
				}
				return value;
			}
			
			if(attri == "color"){
				if(value.indexOf("#")!=-1){
					return "0x"+value.substring(1,value.length);
				}
				return value; 
			}
			
			var n:Number = Number(value);
			if( isNaN(n) || isString ){
				return '"'+value+'"';
			}
			return n.toString();
		}
		
		/**
		 * 创建属性数值对
		 */ 
		public function createAttriAndValue(xml:XML,vari_id:String):String
		{
			var clsStr:String = "";
			var attNamesList:XMLList = xml.attributes();
			for (var i:int = 0; i < attNamesList.length(); i++)
			{ 
				var key:String = attNamesList[i].name();
				var value:String = attNamesList[i];
				if(ConvertData.exclude_attri_ls.indexOf(key)==-1)
				{ 
					if(key=="width"&&value.indexOf("%")!=-1)
					{
						clsStr += createSpace(3)+vari_id+".percentWidth"+"="+value.substring(0,value.length-1)+NEWLINE_SIGN;	
					}
					else if(key=="height"&&value.indexOf("%")!=-1)
					{
						clsStr += createSpace(3)+vari_id+".percentHeight"+"="+value.substring(0,value.length-1)+NEWLINE_SIGN;
					}
					else if(ConvertData.event_ls.indexOf(key)!=-1)
					{
						clsStr += createEvent(attNamesList[i],vari_id)
					}
					else if(ConvertData.importClass_ls.indexOf(key)!=-1)
					{
						var tmp_a:Array = value.split(".");
						var ns:Object = {};
						ns.prefix = tmp_a[tmp_a.length-1];
						ns.uri = value;
						data.custom_namespace.push(ns);
						
						clsStr += createSpace(3)+vari_id+"."+key+"="+ns.prefix+NEWLINE_SIGN;
					}
					else
					{
						clsStr += createSpace(3)+vari_id+"."+key+"="+checkValueType(value,key)+NEWLINE_SIGN;
					}
				}
			}
			return clsStr;
		}
		
		/**
		 * 生成事件
		 */ 
		private function createEvent(xml:XML,vari_id:String):String
		{
			var key:String = xml.name();
			var value:String = xml.toString()
			var eventName:String = value.split("(")[0];
			if(value.indexOf("(event)")!=-1){
				return createSpace(3)+vari_id+".addEventListener('"+key+"',"+eventName+");"+NEWLINE_SIGN;	
			}
			return createSpace(3)+vari_id+".addEventListener('"+key+"',function(e:*):void{"+value+";});"+NEWLINE_SIGN;
		}
		
		private function createUIComponentIndex():int
		{
			return ConvertData.createUIComponentIndex();
		}
		
		
	}
}