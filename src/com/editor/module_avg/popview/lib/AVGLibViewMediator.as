package com.editor.module_avg.popview.lib
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.mediator.AppMediator;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.vo.AVGConfigVO;
	import com.editor.module_avg.vo.AVGResData;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.core.SandyEngineConst;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	public class AVGLibViewMediator extends AppMediator
	{
		public static const NAME:String = "AVGLibViewMediator";
		public function AVGLibViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():AVGLibView
		{
			return viewComponent as AVGLibView;
		}
		public function get pathTi():UITextInput
		{
			return mainUI.pathTi;
		}
		public function get fileBox():UIVlist
		{
			return mainUI.fileBox;
		}
		public function get preBtn():UIButton
		{
			return mainUI.preBtn;
		}
				
		override public function onRegister():void
		{
			super.onRegister();
			
			fileBox.addEventListener(ASEvent.CHANGE,onBoxChange);
			mainUI.sdBtn.addEventListener(MouseEvent.CLICK , onSoundHandle);
		}
		
		public var http:AS3HTTPServiceLocator;
		
		public function respondToSelectProjectInavgEvent(noti:Notification):void
		{
			pathTi.text = AVGManager.currProject.topFold;
			
			if(http == null){
				http = new AS3HTTPServiceLocator();
				http.sucResult_f = confirmSuc;
			}
			
			//http://192.168.0.9:82/gdps/sub/fileData.do?m=getRes&srt=2&project=Palace4_cn_cn&path=res/res
			var httpObj:URLVariables = new URLVariables();
			httpObj.m = "getRes"
			httpObj.srt = 2;
			httpObj.project = AVGManager.currProject.data;
			httpObj.path = pathTi.text;
			trace("get file list, " + httpObj.toString());
			http.args = httpObj;
			http.conn(AVGConfigVO.instance.resDomain, SandyEngineConst.HTTP_POST);
		}
		
		public function getFileList(d:*):void
		{
			if(d is AVGResData){
				if(!d.directory) return ;
			}
			
			var httpObj:URLVariables = new URLVariables();
			httpObj.m = "getRes"
			httpObj.srt = 2;
			httpObj.project = AVGManager.currProject.data;
			if(d is AVGResData){
				httpObj.path = d.fullPath;
			}else{
				httpObj.path = d;
			}
			http.args = httpObj;
			http.conn(AVGConfigVO.instance.resDomain, SandyEngineConst.HTTP_POST);
		}
				
		private function confirmSuc(ds:*=null):void
		{
			var obj:Object = JSON.parse(String(ds));
			if(!StringTWLUtil.isWhitespace(obj.msg)){
				showError(obj.msg);
				return ;
			}
			pathTi.text = obj.obj.path;
			var da:Array = obj.obj.directory;
			var fa:Array = obj.obj.file;
			var a:Array = da.concat(fa);
			var out:Array = [];
			for(var i:int=0;i<a.length;i++){
				var d:AVGResData = new AVGResData(a[i],obj.obj.path);
				out.push(d);
			}
			fileBox.dataProvider = out;
		}
		
		public function reactToPreBtnClick(e:MouseEvent):void
		{
			var s:String = pathTi.text;
			if(s == AVGManager.currProject.topFold) return ;
			var s1:String = s.substring(s.length-1,s.length);
			var a:Array ;
			var out:String ;
			if(s1 == "/"){
				a = s.split("/");
				a.splice(a.length-1,1);
				a.splice(a.length-1,1);
				out = a.join("/");
			}else{
				a = s.split("/");
				a.splice(a.length-1,1);
				out = a.join("/");
			}
			out += "/"
			getFileList(out);
		}
		
		private function onBoxChange(e:ASEvent):void
		{
			
		}
		
		private function onSoundHandle(e:MouseEvent):void
		{
			AVGManager.getInstance().stopSound();
		}
		
	}
}