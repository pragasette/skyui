﻿import gfx.events.EventDispatcher;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;

class skyui.HorizontalList extends skyui.DynamicList
{
	static var FILL_BORDER = 0;
	static var FILL_PARENT = 1;
	static var FILL_STAGE = 2;
	
	private var _bNoIcons:Boolean;
	private var _bNoText:Boolean;
	private var _xOffset:Number;
	private var _fillType:Number;
	private var _contentWidth:Number;
	private var _totalWidth:Number;
	
	// Component settings
	var buttonOption:String;
	var fillOption:String;
	var borderWidth:Number;
	// iconX holds label name for iconX
	
	// Children
	var selectorCenter:MovieClip;
	var selectorLeft:MovieClip;
	var selectorRight:MovieClip;
	

	function HorizontalList()
	{		
		super();
		
		if (borderWidth != undefined) {
			_indent = borderWidth;
		}

		if (buttonOption == "text and icons") {
			_bNoIcons = false;;
			_bNoText = false;
		} else if (buttonOption == "icons only") {
			_bNoIcons = false;
			_bNoText = true;
		} else {
			_bNoIcons = true;
			_bNoText = false;
		}
		
		if (fillOption == "parent") {
			_fillType = FILL_PARENT;
		} else if (fillOption == "stage") {
			_fillType = FILL_STAGE;
		} else {
			_fillType = FILL_BORDER;
		}
	}

	function getClipByIndex(a_index)
	{
		var entryClip = this["Entry" + a_index];

		if (entryClip != undefined)
		{
			return entryClip;
		}
		
		// Create on-demand  
		entryClip = attachMovie(_entryClassName, "Entry" + a_index, a_index);

		entryClip.clipIndex = a_index;

		entryClip.buttonArea.onRollOver = function()
		{
			if (!_parent._parent.listAnimating && !_parent._parent._bDisableInput && _parent.itemIndex != undefined)
			{
				_parent._parent.doSetSelectedIndex(_parent.itemIndex, 0);
				_parent._parent._bMouseDrivenNav = true;
			}
		};

		entryClip.buttonArea.onPress = function(aiMouseIndex, aiKeyboardOrMouse)
		{
			if (_parent.itemIndex != undefined)
			{				
				
				_parent._parent.onItemPress(aiKeyboardOrMouse);
				if (!_parent._parent._bDisableInput && _parent.onMousePress != undefined)
				{
					_parent.onMousePress();
				}
			}
		};

		entryClip.buttonArea.onPressAux = function(aiMouseIndex, aiKeyboardOrMouse, aiButtonIndex)
		{
			if (_parent.itemIndex != undefined)
			{
				_parent._parent.onItemPressAux(aiKeyboardOrMouse,aiButtonIndex);
			}
		};
		
		if (!_bNoIcons && this["icon" + a_index] != undefined) {
			entryClip.icon.gotoAndStop(this["icon" + a_index]);
					
			if (_bNoText) {
				entryClip.textField._visible = false;
			}
		} else {
			entryClip.icon._visible = false;
			entryClip.textField._x = 0;
		}

		return entryClip;
	}

	function UpdateList()
	{
		var cw = _indent * 2;
		_contentWidth = _indent * 2;
		var tw = 0;
		var xOffset = 0;
		
		if (_fillType == FILL_PARENT) {
			xOffset = _parent._x;
			tw = _parent._width;
		} else if (_fillType == FILL_STAGE) {
			xOffset = 0;
			tw = Stage.visibleRect.width;
		} else {
			xOffset = border._x;
			tw = border._width;
		}

		for (var i = 0; i < _entryList.length; i++)
		{
			var entryClip = getClipByIndex(i);

			setEntry(entryClip, _entryList[i]);
			
			_entryList[i].clipIndex = i;
			entryClip.itemIndex = i;

			entryClip.textField.autoSize = "left";
			
			var w = 5;
			if (entryClip.icon._visible) {
				w = w + entryClip.icon._width;
			}
			if (entryClip.textField._visible) {
				w = w + entryClip.textField._width;
			}
			entryClip.buttonArea._width = w;
			cw = cw + w;
		}
		
		_contentWidth = cw;
		_totalWidth = tw;
		
		var spacing = (_totalWidth - _contentWidth) / (_entryList.length + 1);
		
		var xPos = xOffset + _indent + spacing;
		
		for (var i = 0; i < _entryList.length; i++)
		{
			var entryClip = getClipByIndex(i);
			entryClip._x = xPos;

			xPos = xPos + entryClip.buttonArea._width + spacing;
			entryClip._visible = true;
		}
		

	}
	
	function doSetSelectedIndex(a_newIndex:Number, a_keyboardOrMouse:Number)
	{
		super.doSetSelectedIndex(a_newIndex, a_keyboardOrMouse);
		
		if (selectorCenter != undefined) {
			var selectedClip = getClipByIndex(_selectedIndex);			

			selectorCenter._x = selectedClip._x + selectedClip.buttonArea._width / 2 -  selectorCenter._width / 2 ;
			selectorCenter._y = selectedClip._y + selectedClip.buttonArea._height;			
			
			if (selectorLeft != undefined) {
				selectorLeft._x = 0;
				selectorLeft._y = selectorCenter._y;
				selectorLeft._width = selectorCenter._x;
			}
			
			if (selectorRight != undefined) {
				selectorRight._x = selectorCenter._x + selectorCenter._width;
				selectorRight._y = selectorCenter._y;
				selectorRight._width = _totalWidth - selectorRight._x;
			}
		}
	}
}