////////////////////////////////////////////////////////////////////////////////
//  Copyright 2012 GP Strategies
//  All Rights Reserved.
////////////////////////////////////////////////////////////////////////////////
package {
	/**
	 * :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 * class description: RectangleSpecs
	 * language version: ActionScript 3.0
	 * author: cworley
	 * created: Apr 10, 2012
	 * TODO:
	 * :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	 */
	import com.cw.control.loaders.fontSWFLoader.FontSWFLoader;
	import com.cw.control.observer.ISubject;
	import com.cw.control.observer.InvokedObserver;
	import com.cw.view.forms.FileInput;
	import com.cw.view.text.CDynamicTextField;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.CSSLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.text.TextField;

	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// SWF characteristics
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	[SWF(width = 1000, height = 800, backgroundColor = 0x666666, frameRate = 60)]
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	// Class characteristics
	//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	/**
	 *
	 * @author cworley
	 */
	public class XYGeneratorAIR extends Sprite implements ISubject {
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private Variables
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private var observer:ISubject;
		private var startX:Number;
		private var startY:Number;
		private var moveX:Number;
		private var moveY:Number;
		private var endX:Number;
		private var endY:Number;
		private var imageHolder:Sprite;
		private var labelHolder:Sprite;
		private var rectangle:Sprite;
		private var animeRectangle:Sprite;
		private var lineColor:Number = 0xfca702;
		private var fillColor:Number = 0x666699;
		private var theCDynamicTextField:CDynamicTextField;
		private var loadSWFFonts:FontSWFLoader = new FontSWFLoader();
		private var fontLoadObserver:ISubject = new InvokedObserver();
		private var imageLoadObserver:ISubject = new InvokedObserver();
		private var theLabel:Sprite;
		private var itemReference:Array = new Array();
		private var registrationMark:Sprite;
		private var theClearButton:Sprite;
		private var theBrowseButton:Sprite;
		private var theFileInput:FileInput;
		private var imageFile:String;
		private var stageWidth:int;
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Constructor
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		/**
		 *
		 */
		public function XYGeneratorAIR () {
			stageWidth = stage.width;
			this.stage.nativeWindow.visible = true;
			loadCSS();
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Public Interfaces
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		/**
		 * InvokedObserver interface, reference update, and subscription with
		 * updated observer and adding subscription with addObserver(this).
		 */
		public function addObserver (observer:ISubject):void {
			this.observer = observer;
			observer.addObserver(this);
		}
		/**
		 * InvokedObserver notification
		 */
		public function notifyObservers (infoObject:String):void {
			observer.notifyObservers(infoObject);
		}
		/**
		 * remove an observer refrence from InvokedObserver
		 */
		public function removeObserver (observer:ISubject):void {}
		/**
		 * update from observer @param infoObject
		 */
		public function update (infoObject:String):void {
			loadImageHandler(infoObject);
		}
		/**
		 * @param infoObject
		 */
		public function loadImageHandler (infoObject:String):void {
			this.imageFile = infoObject;
			loadImage();
		}
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		// Private Methods
		//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		/**
		 * Load external fonts. Must match font used in CSS doc.
		 */
		private function loadFont ():void {
			loadSWFFonts.fontSWFLoaderInterface('./fonts/fontENTrebuchetMS.swf');
			loadSWFFonts.observableInstanceRef(fontLoadObserver);
		}
		private function loadCSS ():void {
			var queue:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:initLoadHandler, onError:errorHandler});
			queue.append(new CSSLoader("./css/flashSiteStyles.css", {name:"flashStyleSheet", alternateURL:"http://worleydev.com/css/flashSiteStyles.css"}));
			queue.load();
		}
		private function initLoadHandler (loaderEvent:LoaderEvent):void {
			theCDynamicTextField = new CDynamicTextField();
			addObserver(imageLoadObserver);
			clearRectangles();
			browseButton();
			theFileInputForm();
		}
		private function loadImage ():void {
			var queue:LoaderMax = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:handleImage, onError:errorHandler});
			queue.append(new ImageLoader(imageFile, {name:"photo1", estimatedBytes:2400, container:this, alpha:0, centerRegistration:false}));
			queue.load();
		}
		private function progressHandler (progressEvent:LoaderEvent):void {
			//			trace(" ::::::::::: RectangleSpecs.progressHandler(progressEvent) ", progressEvent);
		}
		private function errorHandler (loadEvent:LoaderEvent):void {
			trace(" ::::::::::: RectangleSpecs.errorHandler(loadEvent) ", loadEvent);
		}
		private function fileBrowser (buttonEvents:MouseEvent):void {
			var fileToOpen:File = new File();
			var txtFilter:FileFilter = new FileFilter("Text", "*.gif;*.jpg;*.jpeg;*.png");
//::::::::::: maybe in the future switch the file type filter to an array ::::::::::: 
//			[
//				new FileFilter("JPG Images", "*.jpg;*.jpeg"),
//				new FileFilter("GIF Images", "*.gif"),
//				new FileFilter("PNG Images", "*.png"),
//				new FileFilter("All Images", "*.jpg;*.jpeg;*.gif;*.png")]
			try {
				fileToOpen.browseForOpen("Open selected file", [txtFilter]);
				fileToOpen.addEventListener(Event.SELECT, fileSelected);
//				fileToOpen.addEventListener(Event., fileSelected);
			} catch(error:Error) {
				trace("Failed:", error.message);
			}
		}
		private function fileSelected (selectEvent:Event):void {
			var stream:FileStream = new FileStream();
			stream.open(selectEvent.target as File, FileMode.READ);
			var fileData:String = stream.readUTFBytes(stream.bytesAvailable);
			this.imageFile = selectEvent.target.nativePath;
			trace(" ::::::::::: XYGeneratorAIR.fileSelected(selectEvent) ", fileData, selectEvent.target.nativePath);
			loadImage();
		}
		private function handleImage (loaderEvent:LoaderEvent):void {
			var imageReference:DisplayObject;
			if(imageHolder) {
				this.removeChildAt(0);
			}
			imageHolder = new Sprite();
			labelHolder = new Sprite();
			imageHolder = LoaderMax.getContent("photo1");
			this.addChildAt(imageHolder, 0);
			this.addChild(labelHolder);
			var stageWidth:int = stage.stageWidth;
			var stageHeight:int = stage.stageHeight;
			if(imageHolder.width < stageWidth) {
				imageHolder.x = (stageWidth - imageHolder.width) * .5;
			}
			if(imageHolder.height < stageHeight) {
				imageHolder.y = (stageHeight - imageHolder.height) * .5;
			} else {
				imageHolder.y = 24;
			}
			labelHolder.x = imageHolder.x;
			labelHolder.y = imageHolder.y;
			TweenMax.to(imageHolder, 1, {alpha:1, ease:Sine.easeOut});
			addEventListeners();
			handleClearRectangles(null);
		}
		private function addEventListeners ():void {
			imageHolder.addEventListener(MouseEvent.MOUSE_DOWN, getMouseStartXY);
			imageHolder.addEventListener(MouseEvent.MOUSE_UP, getMouseEndXY);
		}
		private function getMouseStartXY (mouseEvent:MouseEvent):void {
			startX = mouseEvent.localX
			startY = mouseEvent.localY
			startDraw()
		}
		private function getMouseMoveXY (mouseEvent:MouseEvent):void {
			moveX = mouseEvent.localX;
			moveY = mouseEvent.localY;
			moveDraw();
		}
		private function getMouseEndXY (mouseEvent:MouseEvent):void {
			endX = mouseEvent.localX;
			endY = mouseEvent.localY;
			endDraw();
		}
		/**
		 * define the line style
		 * define the fill
		 * set the starting point for the line
		 */
		private function startDraw ():void {
			imageHolder.addEventListener(MouseEvent.MOUSE_MOVE, getMouseMoveXY);
			animeRectangle = new Sprite();
			animeRectangle.mouseChildren = false;
			animeRectangle.mouseEnabled = false;
			animeRectangle.alpha = 0;
			imageHolder.addChild(animeRectangle);
			TweenMax.to(animeRectangle, .25, {alpha:.5, ease:Sine.easeOut});
			rectangle = new Sprite();
			rectangle.graphics.lineStyle(.5, lineColor);
			rectangle.graphics.beginFill(fillColor)
			rectangle.graphics.moveTo(startX, startY);
		}
		/**
		 * update the line through a series of coordinates updated on MOUSE_MOVE event
		 */
		private function moveDraw ():void {
			if((!isNaN(startX)) && (startX < moveX) && (startY < moveY)) {
				animeRectangle.graphics.clear();
				animeRectangle.graphics.lineStyle(.5, lineColor);
				animeRectangle.graphics.beginFill(fillColor)
				animeRectangle.graphics.moveTo(startX, startY);
				animeRectangle.graphics.lineTo(startX, moveY);
				animeRectangle.graphics.lineTo(moveX, moveY);
				animeRectangle.graphics.lineTo(moveX, startY);
			}
		}
		/**
		 * update the line end coordinates through a an update on MOUSE_UP event
		 */
		private function endDraw ():void {
			imageHolder.removeEventListener(MouseEvent.MOUSE_MOVE, getMouseMoveXY);
			if((startX != endX) && (startX < moveX) && (startY < moveY)) {
				imageHolder.removeChild(animeRectangle);
				rectangle.graphics.lineTo(startX, endY);
				rectangle.graphics.lineTo(endX, endY);
				rectangle.graphics.lineTo(endX, startY);
				rectangle.alpha = 0;
				imageHolder.addChild(rectangle);
				TweenMax.to(rectangle, .5, {alpha:.75, ease:Sine.easeOut});
				itemReference.push(rectangle);
				addCornerButton();
				rectangleLabel();
			} else if(startX == endX) {
				registrationMark = new Sprite();
				registrationMark.graphics.lineStyle(.5, lineColor);
				registrationMark.graphics.moveTo(startX - 4, startY);
				registrationMark.graphics.lineTo(startX + 5, startY);
				registrationMark.graphics.moveTo(startX, startY - 4);
				registrationMark.graphics.lineTo(startX, startY + 5);
				imageHolder.addChild(registrationMark);
				itemReference.push(registrationMark);
				registrationLabel();
			}
		}
		private function addCornerButton ():void {
			var cornerButton:CornerButton = new CornerButton();
			var cornerButtonHolder:Sprite = new Sprite();
			cornerButtonHolder.addChild(cornerButton);
			TweenMax.to(cornerButton, .5, {alpha:1, x:endX - 10, y:endY - 10, visible:true, ease:Sine.easeOut});
			trace(" ::::::::::: XYGeneratorAIR.addCornerButton() ", cornerButton);
		}
		private function rectangleLabel ():void {
			theLabel = new Sprite();
			var labelContents:String = '<label><b>x=</b>"' + startX + '" <b>y=</b>"' + startY + '" <b>width=</b>"' + (endX - startX) + '" <b>height=</b>"' + (endY - startY) + '" </label>';
			theCDynamicTextField.textFieldInterface(labelContents, 245, 19, false, 0xFFFFFF, false, false, false);
			var theTextField:Sprite = theCDynamicTextField.getTheTextField();
			theTextField.addEventListener(MouseEvent.CLICK, copyToClipBoard);
			theLabel.addChild(theTextField);
			var labelMaxX:int = (stage.stageWidth - imageHolder.x) - (theTextField.width + 5);
			if(startX >= labelMaxX) {
				TweenMax.to(theTextField, 0, {alpha:0, x:labelMaxX});
			} else {
				TweenMax.to(theTextField, 0, {alpha:0, x:startX});
			}
			if(startY <= 20) {
				TweenMax.to(theTextField, 0, {alpha:0, y:startY + 4});
			} else {
				TweenMax.to(theTextField, 0, {alpha:0, y:startY - 24});
			}
			theLabel.alpha = 0;
			labelHolder.addChild(theLabel);
			itemReference.push(theLabel);
			TweenMax.to(theLabel, .5, {delay:.15, alpha:.75, ease:Sine.easeOut});
			TweenMax.to(theTextField, .5, {delay:.25, alpha:.75, ease:Sine.easeOut});
			labelBG(theTextField);
		}
		private function registrationLabel ():void {
			theLabel = new Sprite();
			var labelContents:String = '<label><b>x=</b>"' + startX + '" <b>y=</b>"' + startY + '"</label>';
			theCDynamicTextField.textFieldInterface(labelContents, 105, 19, false, 0xFFFFFF, false, false, false);
			var theTextField:Sprite = theCDynamicTextField.getTheTextField();
			theTextField.addEventListener(MouseEvent.CLICK, copyToClipBoard);
			theLabel.addChild(theTextField);
			var labelMaxX:int = (stage.stageWidth - imageHolder.x) - (theTextField.width + 5);
			if(startX >= labelMaxX) {
				TweenMax.to(theTextField, 0, {alpha:0, x:labelMaxX});
			} else {
				TweenMax.to(theTextField, 0, {alpha:0, x:startX});
			}
			if(startY <= 20) {
				TweenMax.to(theTextField, 0, {alpha:0, y:startY + 4});
			} else {
				TweenMax.to(theTextField, 0, {alpha:0, y:startY - 24});
			}
			theLabel.alpha = 0;
			labelHolder.addChild(theLabel);
			itemReference.push(theLabel);
			TweenMax.to(theLabel, .5, {delay:.15, alpha:.75, ease:Sine.easeOut});
			TweenMax.to(theTextField, .5, {delay:.25, alpha:.75, ease:Sine.easeOut});
			labelBG(theTextField);
		}
		private function labelBG (theTextField:Sprite):void {
			var labelStartX:Number = theTextField.x;
			var labelStartY:Number = theTextField.y;
			var labelEndX:Number = labelStartX + theTextField.width;
			var labelEndY:Number = labelStartY + theTextField.height;
			theLabel.graphics.lineStyle(.5, lineColor);
			theLabel.graphics.beginFill(fillColor)
			theLabel.graphics.moveTo(labelStartX, labelStartY);
			theLabel.graphics.lineTo(labelStartX, labelEndY);
			theLabel.graphics.lineTo(labelEndX, labelEndY);
			theLabel.graphics.lineTo(labelEndX, labelStartY);
		}
		private function clearRectangles ():void {
			var labelContents:String = "<button>clear hotspots</button>";
			theCDynamicTextField.textFieldInterface(labelContents, 100, 20, true, 0x000000, false, true, false);
			var theTextField:Sprite = theCDynamicTextField.getTheTextField();
			theClearButton = new Sprite();
			theClearButton.addEventListener(MouseEvent.MOUSE_UP, handleClearRectangles);
			theClearButton.addChild(theTextField);
			theClearButton.alpha = 0;
//			theClearButton.y = 21;
			theClearButton.y = (stage.stageHeight - theClearButton.height) - 1;
			theClearButton.x = (stage.stageWidth - theClearButton.width) * .5;
			addChild(theClearButton);
			theClearButton.buttonMode = true;
			theClearButton.mouseChildren = false;
			TweenMax.to(theClearButton, .5, {delay:.15, alpha:1, ease:Sine.easeOut});
			TweenMax.to(theTextField, .5, {delay:.25, alpha:1, ease:Sine.easeOut});
		}
		private function browseButton ():void {
			var labelContents:String = "<button>browse</button>";
			theCDynamicTextField.textFieldInterface(labelContents, 100, 20, true, 0x000000, false, true, false);
			var theTextField:Sprite = theCDynamicTextField.getTheTextField();
			theBrowseButton = new Sprite();
			theBrowseButton.addEventListener(MouseEvent.MOUSE_UP, fileBrowser);
			theBrowseButton.addChild(theTextField);
			theBrowseButton.alpha = 0;
			theBrowseButton.y = 1;
			theBrowseButton.x = 1;
			addChild(theBrowseButton);
			theBrowseButton.buttonMode = true;
			theBrowseButton.mouseChildren = false;
			TweenMax.to(theBrowseButton, .5, {delay:.15, alpha:1, ease:Sine.easeOut});
			TweenMax.to(theTextField, .5, {delay:.25, alpha:1, ease:Sine.easeOut});
		}
		private function theFileInputForm ():void {
			theFileInput = new FileInput();
			theFileInput.addObserver(imageLoadObserver);
			theFileInput.setInputForm();
			var theURLForm:Sprite = theFileInput.getInputForm();
			addChild(theURLForm);
			TweenMax.to(theURLForm, 0, {alpha:1, x:theBrowseButton.x + theBrowseButton.width + 10, y:theBrowseButton.y});
		}
		private function handleClearRectangles (buttonEvents:MouseEvent):void {
			for each(var theSprites:Sprite in itemReference) {
				theSprites.parent.removeChild(theSprites);
			}
			itemReference = [];
		}
		private function copyToClipBoard (mouseEvent:MouseEvent):void {
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, mouseEvent.target.text, false);
		}
	}
}