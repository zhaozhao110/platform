package com.editor.module_roleEdit.mediator
{
	import com.air.component.SandyFile;
	import com.air.component.SandyTextInputWithLabelWithSelectFile;
	import com.air.io.CreatePngImage;
	import com.air.io.FileUtils;
	import com.air.io.WriteFile;
	import com.air.resource.AirLoadImageProxy;
	import com.air.utils.AIRUtils;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UISelectFileButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel; 
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_roleEdit.event.RoleEditEvent;
	import com.editor.module_roleEdit.facade.PeopleImageBindingData;
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.editor.module_roleEdit.proxy.PeopleImageProxy;
	import com.editor.module_roleEdit.view.PeopleImageDataGrid;
	import com.editor.module_roleEdit.vo.action.ActionData;
	import com.editor.module_roleEdit.vo.motion.AppMotionActionVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionForwardVO;
	import com.editor.module_roleEdit.vo.motion.AppMotionItemVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.fabrication.IModuleFacade;
	import com.sandy.math.SandyRectangle;
	import com.sandy.net.SandySocketReceiveDataProxy;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.render2D.map.data.SandyMapConst;
	import com.sandy.utils.BitmapDataUtil;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	

	public class PeopleImageDataGridMediator extends AppMediator
	{
		public static const NAME:String = "PeopleImageDataGridMediator"
		public function PeopleImageDataGridMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get dataGridContainer():PeopleImageDataGrid
		{
			return viewComponent as PeopleImageDataGrid
		}
		public function get selectFileBtn():SandyTextInputWithLabelWithSelectFile
		{
			return dataGridContainer.selectFileBtn;
		}
		public function get grid():UIVBox
		{
			return dataGridContainer.grid
		}
		public function get spContainer():ASComponent
		{
			return dataGridContainer.spContainer;
		}
		public function get openFoldBtn():UIButton
		{
			return dataGridContainer.openFoldBtn;
		}
		public function get logTxt():UITextArea
		{
			return dataGridContainer.logTxt;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var roleEdit_recentOpenFile:String = AppMainModel.getInstance().applicationStorageFile.roleEdit_recentOpenFileURL;
			if(!StringTWLUtil.isWhitespace(roleEdit_recentOpenFile)){
				selectFileBtn.directory = roleEdit_recentOpenFile;
			}
			
			selectFileBtn.addEventListener(ASEvent.CHANGE , selectFile);
		}
		
		
		private var cache_logTxt:String="";
		private var directory:File;
		private var total_png:int = 0;
		private var png_ls:Array = [];
		public var action_ls:Array = [];
		private var max_w:int=0;
		private var max_h:int=0
		//当前是否是合成阴影
		private var animation_type:int;
		
			
		public var resItem:AppResInfoItemVO
		public var motionItem:AppMotionItemVO;
		public var curr_actionData:ActionData;
				
		[InjectProxy(name="PeopleImageProxy")]
		public var imageProxy:PeopleImageProxy;
				
		private function checkDirectory():Boolean
		{
			if(directory == null){
				showError("请先选择动画资源的目录");
				return false 
			}
			return true
		}
		
		public function reactToOpenFoldBtnClick(e:MouseEvent):void
		{
			if(checkDirectory()){
				FileUtils.openFold(directory.nativePath);
			}
		}
		
		/**编辑动画 */ 
		public function editMotion(it:AppResInfoItemVO):void
		{
			curr_actionData = null;
						
			resItem = it;
			motionItem = imageProxy.motion_ls.getMotionById(it.id);
			
			reflashTopInfoTxt()
			sendAppNotification(RoleEditEvent.roleEdit_reflash_topInfo_event);
				
			addLog2("--------------------------------------------");
			addLog2("开始编辑: " + it.name);
			
			var openData:OpenPopwinData = new OpenPopwinData();
			openData.popupwinSign = PopupwinSign.PeopleImageSavePopwin_sign;
			if(motionItem == null){
				motionItem = new AppMotionItemVO();
				motionItem.id = resItem.id;
			}
			openData.data = motionItem;
			openData.addData = resItem;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			openData.openByAirData = opt;
			openPopupwin(openData);
		}
		
		public function afterSave():void
		{
			showError("请选择该动画所在的目录,然后开始编辑");
			reflashTopInfoTxt()
			sendAppNotification(RoleEditEvent.roleEdit_reflash_topInfo_event);
		}
		
		private function reflashTopInfoTxt():void
		{
			if(resItem != null){
				PeopleImageBindingData.getInstance().topInfoTxt = " 编辑动画: id:" + resItem.id + 
					"  ,  名字:" + resItem.name+
					"  ,   方向面:" + resItem.totalForward + "面 " ;
			}
			if(motionItem!=null){
				PeopleImageBindingData.getInstance().topInfoTxt +=  " , 偏移量: " + motionItem.originalPoint.print();
			}
		}
		
		/**选择动画所在的目录 */ 
		private function selectFile(evt:ASEvent):void
		{
			directory = evt.data as File;
			addLog2("选择" + directory.nativePath);
			AppMainModel.getInstance().applicationStorageFile.putKey_roleEdit_recentOpenFile(directory.nativePath)
			reflashDataGrid();
		}
		
		private function reflashDataGrid():void
		{
			action_ls = PeopleImageBindingData.getInstance().createManyActionList(motionItem.action_ls,resItem);
			for(var i:int=0;i<action_ls.length;i++){
				var it:ActionData = action_ls[i] as ActionData;
				if(motionItem!=null){
					it.timeline = motionItem.getTimelineByType(it.type);
				}
			}
			grid.dataProvider = action_ls;
		}
		
		private function reset():void
		{
			UIComponentUtil.removeAllChild(spContainer);
			spContainer.width = 0;
			spContainer.height = 0;
			max_w = 0;
			max_h = 0
			animation_type = 0			
			total_png = 0;
		}
				
		/**合成并预览 */ 
		public function compose(it:ActionData):void
		{	
			if(resItem == null){
				showError("请先选择要编辑的动画");
				return 
			}
			
			if(it.timeline == "" || it.timeline.indexOf("/") == -1){
				showError("请输入时间轴数据");
				return 
			}
			
			reset();
						
			png_ls = null;
			png_ls = [];
			
			animation_type = SandyMapConst.animation_body;
			
			curr_actionData = it;
			curr_actionData.actionVO = motionItem.getActionByType(curr_actionData.type);
			if(curr_actionData.actionVO == null){
				var action:AppMotionActionVO = new AppMotionActionVO();
				action.type = curr_actionData.type;
				motionItem.setActionItem(curr_actionData.type,action);
				curr_actionData.actionVO = action;
			}
			
			var totalForward:int = resItem.totalForward;
			
			/*if(resItem.id == 1140){
				totalForward = 2;
			}*/
			
			if(totalForward <= SandyMapConst.forward_2){
				//没有方向目录
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str,SandyMapConst.right)) return 
			}else if(totalForward == SandyMapConst.forward_4){
				//4方向
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\上",SandyMapConst.top)) return; 
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\下",SandyMapConst.bottom)) return;
				//if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右",SandyMapConst.right)) return;
				//翻转
				/*if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右上",SandyMapConst.left_top,true)) return;
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右下",SandyMapConst.left_bot,true)) return;*/
			}else if(totalForward == SandyMapConst.forward_8){
				//8方向	
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\上",SandyMapConst.top)) return ;
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\下",SandyMapConst.bottom)) return ;
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右上",SandyMapConst.right_top)) return ;
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右",SandyMapConst.right)) return ;
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右下",SandyMapConst.right_bot)) return ;
				//翻转
				/*if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右上",SandyMapConst.left_top,true)) return ;
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右下",SandyMapConst.left_bot,true)) return
				if(!loadImage(directory.nativePath+"\\"+curr_actionData.type_str+"\\右",SandyMapConst.left,true)) return ;*/
			}
			
			//datagrid样式修饰
			for(var i:int=0;i<action_ls.length;i++){
				var ad:ActionData = action_ls[i] as ActionData;
				if(it.type == ad.type){
					it.isupdate = "false";
				}
			}
			grid.dataProvider = action_ls;
		}
		
		/**
		 * 加载方向目录下的所有图片
		 * @url: 目录
		 * @forward: 某个方向
		 * @isShadow: 是阴影图片
		 * @isFlip: 是翻转
		 */ 
		private function loadImage(url:String,forward:int,isFlip:Boolean=false):Boolean
		{
			var file:File = new File(url);
			if(!file.exists){
				addLog2("***有错误: 目录不存在***" + url,true);
				return false
			}
			
			var a:Array = FileUtils.getDirectoryListing(file,"png");
			total_png += a.length;
			
			if(isFlip){
				//是翻转的话，生成目录，生成图片
				var toForard_str:String = SandyMapConst.getForwardStr(forward);
				//生成目录
				if(animation_type == SandyMapConst.animation_shadow){
					//WriteFile.createDirectory(directory.nativePath+"\\阴影\\"+curr_actionData.type_str+"\\"+toForard_str);
				}else{
					WriteFile.createDirectory(directory.nativePath+"\\"+curr_actionData.type_str+"\\"+toForard_str);
				}
			}
						
			var b:Array = [];
			for(var i:int=0;i<a.length;i++){
				var sfile:SandyFile = new SandyFile(a[i] as File);
				if(isNaN(Number(sfile.fileName))){
					b.push({index:i,file:sfile});
				}else{
					b.push({index:int(sfile.fileName),file:sfile});
				}
			}
			//目录里的图片排序
			b = b.sortOn("index",Array.NUMERIC);
						
			for(i=0;i<b.length;i++){	
				sfile = Object(b[i]).file as SandyFile;
				//备份
				WriteFile.copyIsSameFold(sfile.file,"bak");
				//改名
				file = WriteFile.changeName(sfile.file,(i+1)+".png");
				
				//加载
				var proxy:AirLoadImageProxy = new AirLoadImageProxy();
				
				if(isFlip){
					//翻转
					proxy.data = forward+"@";
				}else{
					proxy.data = forward;
				}
				
				proxy.complete_f = loadImageComplete;
				proxy.load(file);
				addLog2("load image: " + file.nativePath);
			}
			return true
		}
		
		private function createShadownImg(bitmapData:BitmapData):Bitmap
		{
			var bitmap:Bitmap = new Bitmap(bitmapData)
			bitmap.alpha = .5
			bitmap.filters = [new BlurFilter(4,4)];
			var sp:ASComponent = new ASComponent();
			sp.addChild(bitmap);
			dataGridContainer.addChild(sp);
			
			var bit:BitmapData = BitmapDataUtil.getBitmapData(bitmapData.width,bitmapData.height);
			bit.draw(sp,null,null,null,null,true);
			
			dataGridContainer.removeChild(sp);
			
			return new Bitmap(bit)
		}
		
		private function loadImageComplete(bit:Bitmap,fl:File,forward:*):void
		{
			var _bitmapData:BitmapData = bit.bitmapData;
			motionItem.size = new SandyRectangle(0,0,bit.width,bit.height);
	
			if(animation_type == SandyMapConst.animation_shadow){
				//阴影
			}else{
				if(String(forward).indexOf("@")!=-1){
					//翻转
					forward = int(String(forward).substring(0,1));
					
					//翻转图片 , 按照原点
					if(motionItem.originalPoint.x >= _bitmapData.width/2){
						_bitmapData = BitmapDataUtil.flipBitmapDataHorizontal(_bitmapData,motionItem.originalPoint.x-_bitmapData.width/2)
					}else{
						_bitmapData = BitmapDataUtil.flipBitmapDataHorizontal(_bitmapData,-(motionItem.originalPoint.x-_bitmapData.width/2))
					}
					
					//生成翻转后的图片
					var create:CreatePngImage = new CreatePngImage();
					create.create(_bitmapData,directory.nativePath+"\\"+curr_actionData.type_str+"\\"+SandyMapConst.getForwardStr(forward)+"\\"+fl.name)
										
					if(png_ls["$"+forward] == null){
						png_ls["$"+forward] = [];
					}
					
					(png_ls["$"+forward] as Array).push( {index:int(fl.name.substring(0,fl.name.lastIndexOf("."))),bitmap:new Bitmap(_bitmapData),file:fl })
				}else{
					if(png_ls["$"+forward] == null){
						png_ls["$"+forward] = [];
					}
					
					(png_ls["$"+forward] as Array).push( {index:int(fl.name.substring(0,fl.name.lastIndexOf("."))),bitmap:bit,file:fl })
				}
			}
			
			var a:Array = [];
			total_png -= 1;
			
			if(total_png == 0){
				//加载全部图片完成
				var totalForward:int = resItem.totalForward;
					
				/*if(resItem.id == 1140){
					totalForward = 2;
				}*/
					
				if(totalForward <= SandyMapConst.forward_2){		
					a = getPngArray("$"+SandyMapConst.right)
					addBitmap(a,SandyMapConst.right);	
				}else if(totalForward == SandyMapConst.forward_4){	
					//第一行：上
					a = getPngArray("$"+SandyMapConst.top)
					addBitmap(a,SandyMapConst.top);
					
					//第二行：下
					a = getPngArray("$"+SandyMapConst.bottom)
					addBitmap(a,SandyMapConst.bottom);
					
					//右
					/*a = getPngArray("$"+SandyMapConst.right)
					addBitmap(a,SandyMapConst.right);*/
					
				}else if(totalForward == SandyMapConst.forward_8){	
					//第一行：上
					a = getPngArray("$"+SandyMapConst.top)
					addBitmap(a,SandyMapConst.top);
					
					//第二行：下
					a = getPngArray("$"+SandyMapConst.bottom)
					addBitmap(a,SandyMapConst.bottom);
					
					//第三行：右
					a = getPngArray("$"+SandyMapConst.right)
					addBitmap(a,SandyMapConst.right);
					
					//第四行：右上
					a = getPngArray("$"+SandyMapConst.right_top)
					addBitmap(a,SandyMapConst.right_top);
					
					//第物行：右下
					a = getPngArray("$"+SandyMapConst.right_bot)
					addBitmap(a,SandyMapConst.right_bot);
					
					//左上
					/*a = getPngArray("$"+SandyMapConst.left_top)
					addBitmap(a,SandyMapConst.left_top);*/
					
					//左下
					/*a = getPngArray("$"+SandyMapConst.left_bot)
					addBitmap(a,SandyMapConst.left_bot);*/
					
					//左
					/*a = getPngArray("$"+SandyMapConst.left)
					addBitmap(a,SandyMapConst.left);*/
				}
				createPng();	
			}
		}
		
		private function getPngArray(forward:String):Array
		{
			return png_ls[forward] as Array;
		}
		
		/** 添加一行上的图片 */ 
		private function addBitmap(a:Array,forward:int):void
		{
			a = a.sortOn("index",Array.NUMERIC);
			
			var forwardItem:AppMotionForwardVO = curr_actionData.actionVO.createForward(forward);
			forwardItem.removeFrame();
			
			var _bitmap:Bitmap;
			var _bitmapData:BitmapData;
			
			var sp_w:int=0;
			var sp_h:int=0;
			
			for(var i:int=0;i<a.length;i++){
				_bitmap = Object(a[i]).bitmap;
				
				var rec:Rectangle = BitmapDataUtil.getObjectRect(_bitmap.bitmapData);
				if(animation_type == SandyMapConst.animation_shadow){
					//forwardItem.addShadowRectangle(i,rec);
				}else{
					forwardItem.addRectangle(i,rec);
				}
				
				_bitmapData = BitmapDataUtil.getBitmapData(rec.width,rec.height);
				_bitmapData.copyPixels(_bitmap.bitmapData,rec,new Point(0,0));
				
				_bitmap = new Bitmap(_bitmapData);
				_bitmap.x = sp_w;
				_bitmap.y = max_h;
				spContainer.addChild(_bitmap);
				
				sp_w += rec.width;
				
				if(sp_h<rec.height){
					sp_h = rec.height;
				}
			}
			if(max_w < sp_w){
				max_w = sp_w;
			}
			max_h += sp_h;
			curr_actionData.actionVO.column = a.length;
		}
		
		private function createPng():void
		{
			spContainer.width = max_w;
			spContainer.height = max_h;
			
			var _bitmap:Bitmap;
			var _bitmapData:BitmapData;
			var create:CreatePngImage;
			var rec:Rectangle
			
			//生成单方向的
			_bitmapData= BitmapDataUtil.getBitmapData(spContainer.width,spContainer.height);
			_bitmapData.draw(spContainer,null,null,null,null,true);
			
			create = new CreatePngImage();
			if(animation_type == SandyMapConst.animation_shadow){
				//create.create(_bitmapData,"d:\\sandyEngine角色动作编辑器生成\\"+resItem.id+"\\PNG24\\"+resItem.id+"_"+curr_actionData.type+"_s.png");
			}else{
				create.create(_bitmapData,"d:\\sandyEngine角色动作编辑器生成\\"+RoleEditManager.currProject.name+"\\"+resItem.id+"\\PNG24\\"+resItem.id+"_"+curr_actionData.type+".png");
			}
			
			//预览
			var openData:OpenPopwinData = new OpenPopwinData();
			openData.popupwinSign = PopupwinSign.PeopleImagePreviewPopwin_sign;
			openData.data = {bitmapData:_bitmapData,data:resItem,action:curr_actionData,motion:motionItem,animation_type:animation_type};
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			openData.openByAirData = opt;
			openPopupwin(openData);
		}
		
		public function respondToRoleEditAddLogEvent(noti:Notification):void
		{
			addLog2(noti.getBody().toString())
		}
		
		public function addLog2(s:String,isError:Boolean=false):void
		{
			if(isError){
				cache_logTxt += TimerUtils.getSec_hour(":",NaN,true) + " --- " + ColorUtils.addColorTool(s,0xcc0000) + "<br>";
			}else{
				cache_logTxt += TimerUtils.getSec_hour(":",NaN,true) + " --- " + s + "<br>";
			}
			logTxt.setHtmlText(cache_logTxt);
		}
		
	}
}