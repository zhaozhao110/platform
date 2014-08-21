package com.editor.project_pop.getLocale.tab2
{
	import com.air.io.DeleteFile;
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.air.io.queue.copy.CopyFileQueue;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.project_pop.getLocale.AppGetLocaleTab2;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class AppGetLocaleTab2Cache
	{
		private static var instance:AppGetLocaleTab2Cache ;
		public static function getInstance():AppGetLocaleTab2Cache{
			if(instance == null){
				instance =  new AppGetLocaleTab2Cache();
				//instance.init_inject();
			}
			return instance;
		}
		
		
		
		public var client_tab:AppGetLocaleTab2_tab;
		public var config_tab:AppGetLocaleTab2_tab;
		public var res_tab:AppGetLocaleTab2_tab;
		public var tab2:AppGetLocaleTab2;
		
		public var tmp_map:Array = [];
		
		public function tmp_add(file:File,tp:int):void
		{
			var a:Array = tmp_map[tp.toString()];
			if(a == null){
				a = [];
				tmp_map[tp.toString()] = a;
			}
			if(a.indexOf(file.nativePath)==-1){
				a.push(file.nativePath);
			}
		}
		
		public function tmp_remove(file:String,tp:int):void
		{
			var a:Array = tmp_map[tp.toString()];
			if(a == null) return ;
			var n:int = a.indexOf(file);
			if(n>=0){
				a.splice(n,1);
			}
		}
		
		public function check_in_tmp(file:String,tp:int):Boolean
		{
			var a:Array = tmp_map[tp.toString()];
			if(a == null) return false;
			return a.indexOf(file)!=-1
		}
		
		public function getSaveFile():File
		{
			return new File(File.applicationStorageDirectory.nativePath+File.separator+"lang.lang");
		}
		
		public function export():void
		{
			
			var s:String = "";
			s += client_tab.getConfigFile()+NEWLINE_SIGN;
			s += config_tab.getConfigFile()+NEWLINE_SIGN;
			s += res_tab.getConfigFile()+NEWLINE_SIGN;
			
			s += "-----------client---------------"+NEWLINE_SIGN;
			
			//client
			if(!StringTWLUtil.isWhitespace(client_tab.getConfigFile())){
				var client:Array = tmp_map["1"] as Array;
				if(client!=null){
					for(var i:int=0;i<client.length;i++){
						var p:String = client[i];
						if(p.indexOf(client_tab.getConfigFile())!=-1){
							p = StringTWLUtil.remove(p,client_tab.getConfigFile());
							s += p + NEWLINE_SIGN;
						}
					}
				}
			}
			
			s += "-------------config------------"+NEWLINE_SIGN;
				
			//config
			if(!StringTWLUtil.isWhitespace(config_tab.getConfigFile())){
				var config:Array = tmp_map["2"] as Array;
				if(config!=null){
					for(i=0;i<config.length;i++){
						p = config[i];
						if(p.indexOf(config_tab.getConfigFile())!=-1){
							p = StringTWLUtil.remove(p,config_tab.getConfigFile());
							s += p + NEWLINE_SIGN;
						}
					}
				}
			}
			
			s += "--------------res------------"+NEWLINE_SIGN;
				
			//res
			if(!StringTWLUtil.isWhitespace(res_tab.getConfigFile())){
				var res:Array = tmp_map["3"] as Array;
				if(res!=null){
					for(i=0;i<res.length;i++){
						p = res[i];
						if(p.indexOf(res_tab.getConfigFile())!=-1){
							p = StringTWLUtil.remove(p,res_tab.getConfigFile());
							s += p + NEWLINE_SIGN;
						}
					}
				}
			}
			
			var write:WriteFile = new WriteFile();
			write.writeCompress(getSaveFile(),s);
		}
		
		public function copy():void
		{
			SelectFile.selectDirectory("选择需要保存的目录",copy_result)				
		}
		
		private function copy_result(e:Event):void
		{
			var f:File = e.target as File;
			DeleteFile.deleteInFile(f);
			
			var time:Number = tab2.cal.selectedItem.time;
			if(!tab2.cal_cb.selected){
				time = 0;
			}
			
			var copy_ls:Array = [];
			var needCopy:Boolean = false;
			//client
			if(!StringTWLUtil.isWhitespace(client_tab.getConfigFile())){
				var client:Array = tmp_map["1"] as Array;
				if(client!=null){
					for(var i:int=0;i<client.length;i++){
						var p:String = client[i];
						var cf:File = new File(p);
						needCopy = false;
						if(time>0){
							if(cf.creationDate.time>=time||cf.modificationDate.time>=time){
								needCopy = true
							}
						}else{
							needCopy = true;
						}
						if(needCopy&&p.indexOf(client_tab.getConfigFile())!=-1){
							p = StringTWLUtil.remove(p,client_tab.getConfigFile());
							copy_ls.push({from:client[i],to:f.nativePath+File.separator+"client"+File.separator+p})						
						}
					}
				}
			}
			
			//config
			if(!StringTWLUtil.isWhitespace(config_tab.getConfigFile())){
				var config:Array = tmp_map["2"] as Array;
				if(config!=null){
					for(i=0;i<config.length;i++){
						p = config[i];
						cf = new File(p);
						needCopy = false;
						if(time>0){
							if(cf.creationDate.time>=time||cf.modificationDate.time>=time){
								needCopy = true
							}
						}else{
							needCopy = true;
						}
						if(needCopy&&p.indexOf(config_tab.getConfigFile())!=-1){
							p = StringTWLUtil.remove(p,config_tab.getConfigFile());
							copy_ls.push({from:client[i],to:f.nativePath+File.separator+"config"+File.separator+p})	
						}
					}
				}
			}
			
			//res
			if(!StringTWLUtil.isWhitespace(res_tab.getConfigFile())){
				var res:Array = tmp_map["3"] as Array;
				if(res!=null){
					for(i=0;i<res.length;i++){
						p = res[i];
						cf = new File(p);
						needCopy = false;
						if(time>0){
							if(cf.creationDate.time>=time||cf.modificationDate.time>=time){
								needCopy = true
							}
						}else{
							needCopy = true;
						}
						if(needCopy&&p.indexOf(res_tab.getConfigFile())!=-1){
							p = StringTWLUtil.remove(p,res_tab.getConfigFile());
							copy_ls.push({from:client[i],to:f.nativePath+File.separator+"res"+File.separator+p})	
						}
					}
				}
			}
			
			BackgroundThreadCommand.instance.copyFiles(copy_ls);
		}
		
		public function importc(f:File=null):void
		{
			tmp_map = null;tmp_map = [];
			
			var read:ReadFile = new ReadFile();
			var s:String;
			if(f!=null){
			 	s = read.readCompressByteArray(f.nativePath);	
			}else{
				s = read.readCompressByteArray(getSaveFile().nativePath);
			}
			
			var a:Array = StringTWLUtil.splitNewline(s);
			var b:Array = [];
			for(var i:int=0;i<a.length;i++){
				var p:String = a[i];
				if(StringTWLUtil.beginsWith(p,"-----")){
					b.push(i);
				}
			}
			b.push(a.length);
			var n1:int;
			var n2:int;
			for(i=0;i<b.length;i++){
				if(n1==0){
					_set_configAll(a.slice(n2,b[i]));
				}else if(n1==1){
					_set_client(a.slice(n2,b[i]));
				}else if(n1==2){
					_set_config(a.slice(n2,b[i]));
				}else if(n1==3){
					_set_res(a.slice(n2,b[i]));
				}
				n2 = b[i]+1;
				n1 += 1;
			}
			
			client_tab.reflashPath();
			config_tab.reflashPath();
			res_tab.reflashPath();
		}
		
		private function _set_configAll(a:Array):void
		{
			client_tab.setConfigFile(a[0])
			config_tab.setConfigFile(a[1])
			res_tab.setConfigFile(a[2])
		}
		
		private function _set_client(a:Array):void
		{
			if(StringTWLUtil.isWhitespace(client_tab.getConfigFile())) return ;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(a[i])){
					tmp_add(new File(client_tab.getConfigFile()+a[i]),1);
				}
			}
		}
		
		private function _set_config(a:Array):void
		{
			if(StringTWLUtil.isWhitespace(config_tab.getConfigFile())) return ;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(a[i])){
					tmp_add(new File(config_tab.getConfigFile()+a[i]),2);
				}
			}
		}
		
		private function _set_res(a:Array):void
		{
			if(StringTWLUtil.isWhitespace(res_tab.getConfigFile())) return ;
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(a[i])){
					tmp_add(new File(res_tab.getConfigFile()+a[i]),3);
				}
			}
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n);
		}
	}
}