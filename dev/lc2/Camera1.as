﻿package{	//import flash.net.registerClassAlias;	//import VideoPackage;	import flash.display.Sprite;	import flash.media.Video;	import flash.media.Camera;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.utils.ByteArray;	import flash.net.LocalConnection;	//import flash.net.SharedObject;	import flash.utils.Timer;    import flash.events.ActivityEvent;	import flash.events.StatusEvent;	import flash.events.TimerEvent;	import flash.geom.Rectangle;		//import flash.geom.Matrix;		public class Camera1 extends Sprite	{		private const NAMED_CHANNEL:String = "_kidtv";		private var video:Video;				private var timer:Timer = new Timer(250);		private var sender:LocalConnection = new LocalConnection();		//private var so:SharedObject;		private var cntr:int;		public var objVideoPackage:VideoPackage = new VideoPackage();		private var bitmap:BitmapData;		private var image:Bitmap;		//private var image:Bitmap;		private var byteArray:ByteArray;				public function Camera1():void		{			//registerClassAlias("VideoPackage", VideoPackage);			//registerClassAlias("BitmapData", BitmapData);			//so  = SharedObject.getLocal("kidtv", "/", false);			//so.clear();			var cntr:int = 0;			//var objVideoPackage = 			//registerClassAlias("ByteArray", ByteArray);			sender.addEventListener(StatusEvent.STATUS, statusHandler);			//bitmap = new BitmapData(100, 100, true, 0x66fff000);			//image = new Bitmap(bitmap);			//addChild(image);			//rect = new Rectangle(image.x, image.y, image.height, image.height);			//byteArray = jpgEncoder.encode(bitmap);			var camera:Camera = Camera.getCamera();			timer.addEventListener(TimerEvent.TIMER, onTimer);			if (camera != null) 			{				//trace("got camera: ", camera);				camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);				video = new Video(640, 480);				video.attachCamera(camera);				//video.x = 200;				//video.y = 50;				addChild(video);								timer.start();			} 			else 			{				trace("You need a camera.");			}					}		private function onTimer(evt:TimerEvent):void		{			const SLICE_MAX = 64;			const SLICE_X_MAX:int = 640;			const SLICE_Y_MAX:int = 480;			const SLICE_X_INC:int = 80;			const SLICE_Y_INC:int = 60;						var sliceNum:int = 1;			var sliceX:int = 0;			var sliceY:int = 0;			var colX:int = 0;			var colY:int = 0;						while(sliceNum <= SLICE_MAX)			{				bitmap = new BitmapData(video.width / 8, video.height / 8);				var rect:Rectangle = new Rectangle(sliceX,sliceY,bitmap.width,bitmap.height);				bitmap.draw(video,null,null,null,rect);				//bitmap.draw(video,,,,rect)				var byteArray = new ByteArray();				byteArray = toByteArray(bitmap);				sender.send(NAMED_CHANNEL, "TestConnection", colX, colY, byteArray);				sliceNum++;				colX++;				sliceX += SLICE_X_INC;				if(sliceX >= SLICE_X_MAX)				{					sliceX = 0;					colX = 0;					colY++;					sliceY+= SLICE_Y_INC;					if(sliceY >= SLICE_Y_MAX)					{						colY = 0;						sliceY = 0;					}				}			}			//trace("byteArray: " + byteArray.toString());			//so.data.width = bitmap.width;			//so.data.height = bitmap.height;			//so.data.byteArray = byteArray;			//byteArray = jpgEncoder.encode(bitmap);			//objVideoPackage.PackBitmap(bitmap);			//objVideoPackage.cntr = cntr;						//so.data.videoPackage = objVideoPackage;			//so.data. = cntr;			//so.data.videoPackage.test_str = "changed from Camera1";			//so.flush();			//trace("Camera1: " + so.data.byteArray);			//trace("Camera1 videoPackage: " + so.data.videoPackage.cntr);//			if(image != null)//			{//				removeChild(image);//			}			//bitmap = toBitmapData(so.data.width, so.data.height, so.data.byteArray);			//image = new Bitmap(bitmap);			//image.x = 670;			//addChild(image);			//sender.send(NAMED_CHANNEL, "TestConnection", "frame package " + cntr, objVideoPackage);					}		public static function toByteArray( bd : BitmapData ) : ByteArray        {			//trace("toByteArray");                var pixels : ByteArray = new ByteArray();                                for( var i:uint=0; i<bd.width ; i++ )                {					                  for( var j:uint=0; j<bd.height; j++ )                  {					// trace("bd.getPixel: ", bd.getPixel(i,j));                    pixels.writeUnsignedInt( bd.getPixel( i, j ) );                  }				}				//trace(pixels);                return pixels;            }					public static function toBitmapData( width : Number, height : Number, ba : ByteArray ) : BitmapData		{			var bd : BitmapData = new BitmapData( width, height );						ba.position = 0;						for( var i:uint=0; i<bd.width ; i++ )			{			  for( var j:uint=0; j<bd.height; j++ )			  {				bd.setPixel( i, j, ba.readUnsignedInt() );			  }			}    						return bd;		}			private function activityHandler(event:ActivityEvent):void 		{			//trace("activityHandler: " + event);		}		private function statusHandler(event:StatusEvent):void		{			//trace("status event: ", event);		}			}}