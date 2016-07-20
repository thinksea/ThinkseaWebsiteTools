
var MessageBoxImages="aspnet_client/MessageBox/";if(typeof(Array.prototype.indexOf)!="function")
{Array.prototype.indexOf=function(p_var)
{for(var i=0;i<this.length;i++)
{if(this[i]==p_var)
{return(i);}}
return(-1);}}
if(typeof(Array.prototype.remove)!="function")
{Array.prototype.remove=function(o)
{var i=this.indexOf(o);if(i>-1)this.splice(i,1);return(i>-1);}}
if(typeof(RegExp.prototype.Escape)!="function")
{RegExp.prototype.Escape=function(str)
{return str.replace(/\\/gi,"\\").replace(/\*/gi,"\\*").replace(/\+/gi,"\\+").replace(/\?/gi,"\\?").replace(/\|/gi,"\\|").replace(/\{/gi,"\\{").replace(/\[/gi,"\\[").replace(/\(/gi,"\\(").replace(/\)/gi,"\\)").replace(/\^/gi,"\\^").replace(/\$/gi,"\\$").replace(/\./gi,"\\.").replace(/\#/gi,"\\#");}}
if(typeof(String.prototype.startsWith)!="function")
{String.prototype.startsWith=function(s,ignoreCase)
{var reg;if(ignoreCase==true)
{reg=new RegExp("^"+RegExp.prototype.Escape(s),"gi");}
else
{reg=new RegExp("^"+RegExp.prototype.Escape(s),"g");}
return reg.test(this);}}
if(typeof(String.prototype.endsWith)!="function")
{String.prototype.endsWith=function(s,ignoreCase)
{var reg;if(ignoreCase==true)
{reg=new RegExp(RegExp.prototype.Escape(s)+"$","gi");}
else
{reg=new RegExp(RegExp.prototype.Escape(s)+"$","g");}
return reg.test(this);}}
function $(cId)
{return document.getElementById(cId);}
function HtmlEncode(s)
{if(s==null)return null;return s.replace(/&/gi,"&amp;").replace(/\"/gi,"&quot;").replace(/</gi,"&lt;").replace(/>/gi,"&gt;").replace(/ /gi,"&nbsp;");}
function HtmlDecode(s)
{if(s==null)return null;return s.replace(/&quot;/gi,"\"").replace(/&lt;/gi,"<").replace(/&gt;/gi,">").replace(/&nbsp;/gi," ").replace(/&amp;/gi,"&");}
function TextToHtml(Text)
{if(Text==null)return null;return Text.replace(/&/gi,"&amp;").replace(/\"/gi,"&quot;").replace(/</gi,"&lt;").replace(/>/gi,"&gt;").replace(/ /gi,"&nbsp;").replace(/\t/gi,"&nbsp;&nbsp;&nbsp;&nbsp;").replace(/\n\r|\r\n|\r|\n/gi,"<br />");}
function HtmlToText(Html)
{if(Html==null)return null;var reSpace=/(\s*)\n(\s*)/gi;var reHTML=/<HTML([^>]*)>|<\/HTML>/gi;var reContain=/<HEAD(?:[^>]*)>(?:.*?)<\/HEAD>|<STYLE(?:[^>]*)>(?:.*?)<\/STYLE>|<SCRIPT(?:[^>]*)>(?:.*?)<\/SCRIPT>/gi;var reComment=/<!--(.*?)-->/gi;var reTD=/<TD(?:[^>]*)>(.*?)<\/TD>/gi;var reBlock=/<DIV(?:[^>]*)>(.*?)<\/DIV>/gi;var reBlock2=/<TR(?:[^>]*)>(.*?)<\/TR>/gi;var reParagraph=/<P(?:[^>]*)>(.*?)<\/P>/gi;var reBR=/<br(\s*)>|<br(\s*)\/>/gi;var reLable=/<([^>]*)>/gi;var reNBSP4=/&nbsp;&nbsp;&nbsp;&nbsp;/gi;var reNBSP=/&nbsp;/gi;var reQUOT=/&quot;/gi;var reLT=/&lt;/gi;var reGT=/&gt;/gi;var reAMP=/&amp;/gi;Html=Html.replace(reSpace,"");Html=Html.replace(reHTML,"");Html=Html.replace(reContain,"");Html=Html.replace(reComment,"");Html=Html.replace(reTD,"$1\t");Html=Html.replace(reBlock,"\r\n$1");Html=Html.replace(reBlock2,"\r\n$1");Html=Html.replace(reParagraph,"\r\n$1\r\n");Html=Html.replace(reBR,"\r\n");Html=Html.replace(reLable,"");Html=Html.replace(reNBSP4,"\t");Html=Html.replace(reNBSP," ");Html=Html.replace(reQUOT,"\"");Html=Html.replace(reLT,"<");Html=Html.replace(reGT,">");Html=Html.replace(reAMP,"&");return Html;}
function XMLEncode(s)
{s=s.replace(/\&/g,"&amp;");s=s.replace(/\</g,"&lt;");s=s.replace(/\>/g,"&gt;");s=s.replace(/\'/g,"&apos;");s=s.replace(/\"/g,"&quot;");return s;}
function GetUriParameter(uri,Name)
{uri=unescape(uri);var reg=new RegExp("(\\?|&)"+Name.replace(/\$/gi,"\\$")+"=([^&]*)","gi");uri=uri.match(reg);if(uri)
{return(uri+"").replace(reg,"$2");}
return null;}
function SetUriParameter(uri,Name,Value)
{uri=uri.replace(/(\s|\?)*$/g,"");if(uri.indexOf("?")==-1)
{return uri+"?"+Name+"="+encodeURIComponent(Value);}
else
{var reg=new RegExp("(\\?|&)"+Name.replace(/\$/gi,"\\$")+"=([^&]*)","gi");if(reg.test(uri))
{return uri.replace(reg,"$1"+Name.replace(/\$/gi,"$$$$")+"="+encodeURIComponent(Value));}
else
{return uri+"&"+Name+"="+encodeURIComponent(Value);}}}
function RemoveUriParameter(uri,Name)
{Name=Name.replace(/\$/gi,"\\$");var reg=new RegExp("(\\?|&)"+Name+"=([^&]*)","gi");if(reg.test(uri))
{var reg1=new RegExp("\\?"+Name+"=([^&]*)&","gi");uri=uri.replace(reg1,"?");var reg2=new RegExp("\\?"+Name+"=([^&]*)","gi");uri=uri.replace(reg2,"");var reg3=new RegExp("&"+Name+"=([^&]*)","gi");uri=uri.replace(reg3,"");}
return uri;}
function ClearUriParameter(uri)
{var reg=/\?(.*)/gi
if(reg.test(uri))
{return uri.replace(reg,"")}
return uri;}
function GetUriPath(uri)
{var path=ClearUriParameter(uri);var filename=path.replace(/^[^\/\\]+:\/\/(([^\/]+$)|([^\/]+\/+)*)/gi,"");if(filename!=""&&/\./gi.test(filename))
{path=path.substring(0,path.length-filename.length);}
return path;}
var onWindowResize=null;var WindowOnresizeColl=new Array();function AddWindowOnResize(o)
{if(WindowOnresizeColl.indexOf(o)==-1)
{WindowOnresizeColl.push(o);}
if(!AddWindowOnResize.prototype.SetOnResize)
{if(window.onresize)
{alert("请使用 onWindowResize 替代你的 window.onresize 事件设置。");return;}
window.onresize=function()
{for(var i=0;i<WindowOnresizeColl.length;i++)
{WindowOnresizeColl[i]();}
if(onWindowResize!=null)
{onWindowResize();}}
AddWindowOnResize.prototype.SetOnResize=true;}}
AddWindowOnResize.prototype.SetOnResize=false;function RemoveWindowOnResize(o)
{WindowOnresizeColl.remove(o);}
function getScrollTop()
{var scrollPos;if(typeof(window.pageYOffset)!='undefined')
{scrollPos=window.pageYOffset;}
else if(typeof(document.compatMode)!='undefined'&&document.compatMode!='BackCompat')
{scrollPos=document.documentElement.scrollTop;}
else if(typeof(document.body)!='undefined')
{scrollPos=document.body.scrollTop;}
return scrollPos;}
function setScrollTop(v)
{window.scroll(getScrollLeft(),v);}
function getScrollLeft()
{var scrollPos;if(typeof(window.pageXOffset)!='undefined')
{scrollPos=window.pageXOffset;}
else if(typeof(document.compatMode)!='undefined'&&document.compatMode!='BackCompat')
{scrollPos=document.documentElement.scrollLeft;}
else if(typeof(document.body)!='undefined')
{scrollPos=document.body.scrollLeft;}
return scrollPos;}
function setScrollLeft(v)
{window.scroll(v,getScrollTop());}
function getScrollHeight()
{var v=0;if(document.documentElement.scrollHeight>document.body.scrollHeight)
{v=document.documentElement.scrollHeight;}
else
{v=document.body.scrollHeight;}
var p=clientHeight();if(v<p)
{return p;}
return v;}
function getScrollWidth()
{var v=0;if(document.documentElement.scrollWidth>document.body.scrollWidth)
{v=document.documentElement.scrollWidth;}
else
{v=document.body.scrollWidth;}
var p=clientWidth();if(v<p)
{return p;}
return v;}
function offsetWidth()
{return(document.documentElement.offsetWidth||document.body.offsetWidth);}
function clientWidth()
{return(document.documentElement.clientWidth||document.body.clientWidth);}
function clientHeight()
{return(self.innerHeight||document.documentElement.clientHeight||document.body.clientHeight);}
function NewGUID()
{var guid="";for(var i=1;i<=32;i++)
{var n=Math.floor(Math.random()*16.0).toString(16);guid+=n;if((i==8)||(i==12)||(i==16)||(i==20))guid+="-";}
return"{"+guid+"}";}
function RandomControlID()
{var guid="";for(var i=1;i<=32;i++)
{var n=Math.floor(Math.random()*16.0).toString(16);guid+=n;}
return guid;}
function GetBrowser()
{if(navigator.userAgent.indexOf("MSIE")>0)return"MSIE";if(isFirefox=navigator.userAgent.indexOf("Firefox")>0)return"Firefox";if(isSafari=navigator.userAgent.indexOf("Safari")>0)return"Safari";if(isCamino=navigator.userAgent.indexOf("Camino")>0)return"Camino";if(isMozilla=navigator.userAgent.indexOf("Gecko/")>0)return"Gecko";}
var MoveFormsHandle=null;var MousePosition={"x":0,"y":0}
window.document.onmousemove=function(evt){evt=(evt||window.event);MousePosition.x=evt.clientX;MousePosition.y=evt.clientY;if(MoveFormsHandle!=null){var tmp=MoveFormsHandle;var control=$(tmp.id);if(control==null||(control!=null&&GetBrowser()=="MSIE"&&event.button!=1)){StopMoveForm();return;}
try{var sLeft=getScrollLeft();var sTop=getScrollTop();var sRight=getScrollLeft()+clientWidth();var sBottom=getScrollTop()+clientHeight();switch(tmp.mode){case 0:{var left=evt.clientX-tmp.cx;if(left<sLeft)left=sLeft;var top=evt.clientY-tmp.cy;if(top<sTop)top=sTop;var right=left+control.offsetWidth;if(right>sRight)left=sRight-control.offsetWidth;var bottom=top+control.offsetHeight;if(bottom>sBottom)top=sBottom-control.offsetHeight;if(left<sLeft)left=sLeft;if(top<sTop)top=sTop;control.style.left=left+"px";control.style.top=top+"px";}
break;case 5:case 1:{var ex=evt.clientX-tmp.x;var borderWidth2=control.offsetWidth-control.clientWidth;if(control.offsetWidth==parseInt(control.style.width))borderWidth2=0;if(tmp.left+ex<sLeft)ex=sLeft-tmp.left;if(ex+borderWidth2>tmp.width)ex=tmp.width-borderWidth2;control.style.left=tmp.left+ex+"px";control.style.width=tmp.width-ex-borderWidth2+"px";}
if(tmp.mode==1)break;case 2:{var ey=evt.clientY-tmp.y;var borderHeight2=control.offsetHeight-control.clientHeight;if(control.offsetHeight==parseInt(control.style.height))borderHeight2=0;if(tmp.top+ey<sTop)ey=sTop-tmp.top;if(ey+borderHeight2>tmp.height)ey=tmp.height-borderHeight2;control.style.top=tmp.top+ey+"px";control.style.height=tmp.height-ey-borderHeight2+"px";}
break;case 6:case 3:{var width=tmp.width+(evt.clientX-tmp.x);var borderWidth2=control.offsetWidth-control.clientWidth;if(control.offsetWidth==parseInt(control.style.width))borderWidth2=0;if(tmp.left+width+borderWidth2>sRight)width=sRight-tmp.left-borderWidth2;if(width<0)width=0;control.style.width=width+"px";}
if(tmp.mode==3)break;case 4:{var height=tmp.height+(evt.clientY-tmp.y);var borderHeight2=control.offsetHeight-control.clientHeight;if(control.offsetHeight==parseInt(control.style.height))borderHeight2=0;if(tmp.top+height+borderHeight2>sBottom)height=sBottom-tmp.top-borderHeight2;if(height<0)height=0;control.style.height=height+"px";}
break;}}
catch(err){}}}
function MoveForm(id,mode)
{if(mode==null)
{mode=0;}
var c=$(id);if(c!=null)
{if(MoveFormsHandle!=null)
{if(MoveFormsHandle.id==id)
{return;}
StopMoveForm();}
if(MoveFormsHandle==null)
{if(GetBrowser()=="MSIE")c.setCapture();MoveFormsHandle={"id":id,"cx":MousePosition.x-parseInt(c.style.left),"cy":MousePosition.y-parseInt(c.style.top),"left":parseInt(c.style.left),"top":parseInt(c.style.top),"width":c.offsetWidth,"height":c.offsetHeight,"x":MousePosition.x,"y":MousePosition.y,"mode":mode};}}}
function StopMoveForm()
{if(MoveFormsHandle!=null)
{var c=$(MoveFormsHandle.id);if(c!=null&&GetBrowser()=="MSIE")c.releaseCapture();MoveFormsHandle=null;}}
function MessageBoxBase(message,title,okButton,cancelButton,icon,closingCallbak,closedCallbak,defaultButton,autoClickTime)
{var MSGID="MessageBox"+RandomControlID();var box=MSGID+"box";var btnOK=MSGID+"OK";var btnCancel=MSGID+"Cancel";var btnClose=MSGID+"Close";var ButtonClicked="Cancel";var vDefaultButton=btnOK;var bgIframe=MSGID+"bgIframe";var bgDiv=MSGID+"Div";var bg_onresize=function(){$(bgIframe).style.width=$(bgDiv).style.width=getScrollWidth()+"px";$(bgIframe).style.height=$(bgDiv).style.height=getScrollHeight()+"px";}
var br=document.createElement("DIV");br.id=MSGID;br.style.zIndex=999;document.body.appendChild(br);if(message==null||message=="")
{message="&nbsp;";}
if(title==null)
{title="系统提示";}
else
{if(title=="")
{title="&nbsp;";}}
if(defaultButton==null)
{defaultButton=1;}
if(autoClickTime==null)
{autoClickTime=-1;}
var okHtml="";var cancelHtml="";var icoHtml="";if(okButton==null&&cancelButton==null)
{vDefaultButton="";}
else
{if(okButton!=null)
{okHtml='<span style="padding-left: 20px;" ><input type="button" value="'+TextToHtml(okButton)+'" id="'+btnOK+'" style="border:none; background-image: url('+MessageBoxImages+'box.png); background-position: -80px 0px; width: 69px; height: 24px; background-repeat:no-repeat; font-size:12px;" /></span>';vDefaultButton=btnOK;}
if(cancelButton!=null)
{cancelHtml='<span style="padding-left: 20px;" ><input type="button" value="'+TextToHtml(cancelButton)+'" id="'+btnCancel+'" style="border:none; background-image: url('+MessageBoxImages+'box.png); background-position: -80px 0px; width: 69px; height: 24px; background-repeat:no-repeat; font-size:12px;"/></span>';vDefaultButton=btnCancel;}
if(okButton!=null&&cancelButton!=null)
{switch(defaultButton)
{case 1:vDefaultButton=btnOK;break;case 2:vDefaultButton=btnCancel;break;}}}
if(icon!=null&&icon!="")
{icoHtml="<IMG alt=\"\" src=\""+icon+"\" />"
message='<table cellpadding="0" cellspacing="0" border="0" style="width: 100%; color:#06559b; font-size:14px;"><tr><td style="width: 1px;">'+icoHtml+'</td><td style="padding-left: 10px; color:#06559b; font-size:14px;">'+message+'</td></tr></table>';}
var Aok="100%";var Anc="100%";if(getScrollWidth()>clientWidth())
{Aok=getScrollWidth()+"px";}
if(getScrollHeight()>clientHeight())
{Anc=getScrollHeight()+"px";}
var u='<iframe id="'+bgIframe+'" style="position:absolute;top:0;left:0;width:'+Aok+';height:'+Anc+';opacity:0.00;-moz-opacity:0.00;filter:alpha(opacity=0);background-color:#000000;DISPLAY:block" frameBorder="0" scrolling="no" src="about:blank"></iframe><div id="'+bgDiv+'" style="position:absolute;top:0;left:0;width:'+Aok+';height:'+Anc+';opacity:0.07;-moz-opacity:0.07;filter:alpha(opacity=7);background-color:#000000;DISPLAY:block;"></div>'
+'<div id="'+box+'" style="position:absolute;" onselectstart="return false;" ondrag="return false;">'
+'<table cellpadding="0" cellspacing="0" border="0" style="width:300px;">'
+'<tr><td style="background-image: url('+MessageBoxImages+'box.png); background-position: 0px 0px; width:3px; height:27px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="27"></td><td style="background-image: url('+MessageBoxImages+'tb.png); background-position: 0px 0px; height:27px; background-repeat:repeat-x;">'
+'<table style="width: 100%"><tr><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -160px 0px; width:14px; height:14px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="14" height="14"></td><td style="color:#06559b; font-size:12px; cursor:default;" onmousedown="MoveForm(\''+box+'\');" onmouseup="StopMoveForm();">'+title+'</td><td style="width:28px;"><a href="javascript:;" title="关闭" id="'+btnClose+'"><img style="background-image: url('+MessageBoxImages+'box.png); background-position: 0px -50px; width:25px; height:15px; background-repeat:no-repeat;" onmouseover="this.style.backgroundPosition=\'0px -80px\';" onmouseout="this.style.backgroundPosition=\'0px -50px\';" src="'+MessageBoxImages+'place.gif" border="0" /></a></td></tr></table>'
+'</td><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -10px 0px; width:3px; height:27px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="27"></td></tr>'
+'<tr><td style="background-image: url('+MessageBoxImages+'lr.png); background-position: 0px 0px; width:3px; background-repeat:repeat-y;"><img src="'+MessageBoxImages+'place.gif" width="3" height="1"></td>'
+'<td style="background-image: url('+MessageBoxImages+'bg.png); padding: 20px; color:#06559b; font-size:14px;">'+message+'</td>'
+'<td style="background-image: url('+MessageBoxImages+'lr.png); background-position: -10px 0px; width:3px; background-repeat:repeat-y;"><img src="'+MessageBoxImages+'place.gif" width="3" height="1"></td></tr>'
+'<tr><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -20px 0px; width:3px; height:44px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="44"></td><td style="background-image: url('+MessageBoxImages+'tb.png); background-position: 0px -50px; height:44px; background-repeat:repeat-x; text-align: right; padding-right: 20px;">'
+okHtml+cancelHtml
+'</td><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -30px 0px; width:3px; height:44px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="44"></td></tr>'
+'</table>'
+'</div>';br.innerHTML=u;var ag=br.lastChild;var h=ag.offsetHeight;var w=ag.offsetWidth;var x=(clientWidth()-w)/2+getScrollLeft();var y=(clientHeight()-h)/2+getScrollTop();if(x+w>getScrollLeft()+clientWidth())
{x=getScrollLeft()+clientWidth()-w;}
if(y+h>getScrollTop()+clientHeight())
{y=getScrollTop()+clientHeight()-h;}
if(x<getScrollLeft())
{x=getScrollLeft();}
if(y<getScrollTop())
{y=getScrollTop();}
ag.style.left=x+"px";ag.style.top=y+"px";$(btnClose).onclick=function()
{var cancelClose=false;if(closingCallbak!=null&&closingCallbak)
{cancelClose=closingCallbak(ButtonClicked);}
if(!cancelClose)
{u=null;RemoveWindowOnResize(bg_onresize);br.innerHTML="";document.body.removeChild(br);if(closedCallbak!=null&&closedCallbak)
{closedCallbak();}}
return false;};if($(btnCancel))
{$(btnCancel).onclick=function()
{ButtonClicked="Cancel";$(btnClose).onclick();}};if($(btnOK))
{$(btnOK).onclick=function()
{ButtonClicked="OK";$(btnClose).onclick();}};if($(vDefaultButton))
{$(vDefaultButton).focus();if(autoClickTime>=0)
{var defaultButtonTime=autoClickTime;var defaultButtonText=$(vDefaultButton).value;var AutoClick=function()
{var vdb=$(vDefaultButton);if(vdb)
{vdb.value=defaultButtonText+' ['+defaultButtonTime+']';if(defaultButtonTime<=0)
{vdb.onclick();}
else
{defaultButtonTime--;window.setTimeout(AutoClick,1000);}}}
AutoClick();}}
AddWindowOnResize(bg_onresize);br.Close=function()
{RemoveWindowOnResize(bg_onresize);br.innerHTML="";document.body.removeChild(br);}
return br;}
function MessageBox(message,title,buttons,icon,closingCallbak,closedCallbak,defaultButton,autoClickTime)
{if(message!=null&&message!="")
{message=TextToHtml(message);}
if(title!=null&&title!="")
{title=TextToHtml(title);}
if(buttons==null)
{buttons="OK";}
if(icon==null)
{icon="None";}
var okHtml=null;var cancelHtml=null;var icoHtml=null;switch(buttons.toLowerCase())
{case"none":break;case"ok":okHtml='确 定';break;case"okcancel":okHtml='确 定';cancelHtml='取 消';break;case"yesno":okHtml='是';cancelHtml='否';break;case"close":cancelHtml='关闭';break;}
switch(icon.toLowerCase())
{case"asterisk":icoHtml="information.png";break;case"error":icoHtml="error.png";break;case"exclamation":icoHtml="warning.png";break;case"hand":icoHtml="error.png";break;case"information":icoHtml="information.png";break;case"none":break;case"question":icoHtml="question.png";break;case"stop":icoHtml="stop.png";break;case"warning":icoHtml="warning.png";break;}
if(icoHtml!=null)
{icoHtml=MessageBoxImages+icoHtml;}
return MessageBoxBase(message,title,okHtml,cancelHtml,icoHtml,closingCallbak,closedCallbak,defaultButton,autoClickTime);}
function ClickMessageBox(control,message,title,buttons,icon,defaultButton,autoClickTime)
{var c;if(typeof(control)=="string")
{c=document.getElementById(control);}
else
{c=control;}
if(c.ClickMessageBox_ShouldSubmit==true)
{c.ClickMessageBox_ShouldSubmit=false;return true;}
MessageBox(message,title,buttons,icon,function(returnValue)
{if(returnValue=="OK"||returnValue=="Yes")
{c.ClickMessageBox_ShouldSubmit=true;c.click();}
return false;},null,defaultButton,autoClickTime);return false;}
function ProgressBar(message,title)
{var MSGID="ProgressBar"+RandomControlID();var box=MSGID+"box";var bgIframe=MSGID+"bgIframe";var bgDiv=MSGID+"Div";var bg_onresize=function(){$(bgIframe).style.width=$(bgDiv).style.width=getScrollWidth()+"px";$(bgIframe).style.height=$(bgDiv).style.height=getScrollHeight()+"px";}
var br=document.createElement("DIV");br.id=MSGID;br.style.zIndex=999;document.body.appendChild(br);if(message=="")
{message="&nbsp;";}
else
{message=TextToHtml(message);}
if(title==null)
{title="正在执行操作，请稍等……";}
else
{if(title=="")
{title="&nbsp;";}
else
{title=TextToHtml(title);}}
var Aok="100%";var Anc="100%";if(getScrollWidth()>clientWidth())
{Aok=getScrollWidth()+"px";}
if(getScrollHeight()>clientHeight())
{Anc=getScrollHeight()+"px";}
var u='<iframe id="'+bgIframe+'" style="position:absolute;top:0;left:0;width:'+Aok+';height:'+Anc+';opacity:0.00;-moz-opacity:0.00;filter:alpha(opacity=0);background-color:#000000;DISPLAY:block" frameBorder="0" scrolling="no" src="about:blank"></iframe><div id="'+bgDiv+'" style="position:absolute;top:0;left:0;width:'+Aok+';height:'+Anc+';opacity:0.07;-moz-opacity:0.07;filter:alpha(opacity=7);background-color:#000000;DISPLAY:block;"></div>'
+'<div id="'+box+'" style="position:absolute;" onselectstart="return false;" ondrag="return false;">'
+'<table cellpadding="0" cellspacing="0" border="0" style="width:300px;">'
+'<tr><td style="background-image: url('+MessageBoxImages+'box.png); background-position: 0px 0px; width:3px; height:27px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="27"></td><td style="background-image: url('+MessageBoxImages+'tb.png); background-position: 0px 0px; height:27px; background-repeat:repeat-x;">'
+'<table style="width: 100%"><tr><td style="color:#06559b; font-size:12px; cursor:default;" onmousedown="MoveForm(\''+box+'\');" onmouseup="StopMoveForm();">'+title+'</td></tr></table>'
+'</td><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -10px 0px; width:3px; height:27px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="27"></td></tr>';if(message!=null&&message!="")
{u+='<tr><td style="background-image: url('+MessageBoxImages+'lr.png); background-position: 0px 0px; width:3px; background-repeat:repeat-y;"><img src="'+MessageBoxImages+'place.gif" width="3" height="1"></td>'
+'<td style="background-image: url('+MessageBoxImages+'bg.png); padding: 20px; color:#06559b; font-size:14px;">'+message+'</td>'
+'<td style="background-image: url('+MessageBoxImages+'lr.png); background-position: -10px 0px; width:3px; background-repeat:repeat-y;"><img src="'+MessageBoxImages+'place.gif" width="3" height="1"></td></tr>';}
u+='<tr><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -20px 0px; width:3px; height:44px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="44"></td><td style="background-image: url('+MessageBoxImages+'tb.png); background-position: 0px -50px; height:44px; background-repeat:repeat-x; text-align: center;">'
+'<img src="'+MessageBoxImages+'progbar.gif" />'
+'</td><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -30px 0px; width:3px; height:44px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="44"></td></tr>'
+'</table>'
+'</div>';br.innerHTML=u;var ag=br.lastChild;var h=ag.offsetHeight;var w=ag.offsetWidth;var x=(clientWidth()-w)/2+getScrollLeft();var y=(clientHeight()-h)/2+getScrollTop();if(x+w>getScrollLeft()+clientWidth())
{x=getScrollLeft()+clientWidth()-w;}
if(y+h>getScrollTop()+clientHeight())
{y=getScrollTop()+clientHeight()-h;}
if(x<getScrollLeft())
{x=getScrollLeft();}
if(y<getScrollTop())
{y=getScrollTop();}
ag.style.left=x+"px";ag.style.top=y+"px";AddWindowOnResize(bg_onresize);br.Close=function()
{RemoveWindowOnResize(bg_onresize);br.innerHTML="";document.body.removeChild(br);}
return br;}
function PageBox(url,title,width,height,closingCallbak,closedCallbak,autoCloseTime,hasScroll,showShade)
{var MSGID="PageBox"+RandomControlID();var box=MSGID+"box";var btnClose=MSGID+"Close";var iframe=MSGID+"Iframe";var bgIframe=MSGID+"bgIframe";var bgDiv=MSGID+"Div";var bg_onresize=function(){$(bgIframe).style.width=$(bgDiv).style.width=getScrollWidth()+"px";$(bgIframe).style.height=$(bgDiv).style.height=getScrollHeight()+"px";}
var br=document.createElement("DIV");br.id=MSGID;br.style.zIndex=999;br.returnValue=null;document.body.appendChild(br);if(title==null)
{title="新窗口";}
else
{if(title=="")
{title="&nbsp;";}
else
{title=TextToHtml(title);}}
if(width==null)
{width=300;}
if(height==null)
{height=100;}
if(autoCloseTime==null)
{autoCloseTime=-1;}
if(hasScroll==null)
{hasScroll=true;}
if(showShade==null)
{showShade=true;}
var Aok="100%";var Anc="100%";if(getScrollWidth()>clientWidth())
{Aok=getScrollWidth()+"px";}
if(getScrollHeight()>clientHeight())
{Anc=getScrollHeight()+"px";}
var u='';if(showShade)
{u+='<iframe id="'+bgIframe+'" style="position:absolute;top:0;left:0;width:'+Aok+';height:'+Anc+';opacity:0.00;-moz-opacity:0.00;filter:alpha(opacity=0);background-color:#000000;DISPLAY:block" frameBorder="0" scrolling="no" src="about:blank"></iframe><div id="'+bgDiv+'" style="position:absolute;top:0;left:0;width:'+Aok+';height:'+Anc+';opacity:0.07;-moz-opacity:0.07;filter:alpha(opacity=7);background-color:#000000;DISPLAY:block;"></div>';}
u+='<div id="'+box+'" style="position:absolute;" onselectstart="return false;" ondrag="return false;">';if(!showShade)
{u+='<iframe style="position:absolute; z-index:-1; DISPLAY: block; width:100%; height:100%; left:0px; top: 0px; opacity:0.00;-moz-opacity:0.00;filter:alpha(opacity=0);background-color:#000000" frameBorder="0" scrolling="no" src="about:blank"></iframe>';}
u+='<table cellpadding="0" cellspacing="0" border="0">'
+'<tr><td style="background-image: url('+MessageBoxImages+'box.png); background-position: 0px 0px; width:3px; height:27px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="27"></td><td style="background-image: url('+MessageBoxImages+'tb.png); background-position: 0px 0px; height:27px; background-repeat:repeat-x;">'
+'<table style="width: 100%"><tr><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -160px -25px; width:14px; height:14px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="14" height="14"></td><td style="color:#06559b; font-size:12px; cursor:default;" onmousedown="MoveForm(\''+box+'\');" onmouseup="StopMoveForm();">'+title+'</td><td style="width:28px;"><a href="javascript:;" title="关闭" id="'+btnClose+'"><img style="background-image: url('+MessageBoxImages+'box.png); background-position: 0px -50px; width:25px; height:15px; background-repeat:no-repeat;" onmouseover="this.style.backgroundPosition=\'0px -80px\';" onmouseout="this.style.backgroundPosition=\'0px -50px\';" src="'+MessageBoxImages+'place.gif" border="0" /></a></td></tr></table>'
+'</td><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -10px 0px; width:3px; height:27px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="27"></td></tr>'
+'<tr><td style="background-image: url('+MessageBoxImages+'lr.png); background-position: 0px 0px; width:3px; background-repeat:repeat-y;"><img src="'+MessageBoxImages+'place.gif" width="3" height="1"></td>'
+'<td style="background-image: url('+MessageBoxImages+'bg.png); padding: 0px; color:#06559b; font-size:14px;"><iframe id="'+iframe+'" src="'+url+'" marginheight="0" marginwidth="0" frameborder="0" width="'+width+'" height="'+height+'" scrolling="'+(hasScroll?'auto':'no')+'"></iframe></td>'
+'<td style="background-image: url('+MessageBoxImages+'lr.png); background-position: -10px 0px; width:3px; background-repeat:repeat-y;"><img src="'+MessageBoxImages+'place.gif" width="3" height="1"></td></tr>'
+'<tr><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -40px 0px; width:3px; height:3px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="3"></td><td style="background-image: url('+MessageBoxImages+'tb.png); background-position: 0px -100px; height:3px; background-repeat:repeat-x;"></td><td style="background-image: url('+MessageBoxImages+'box.png); background-position: -50px 0px; width:3px; height:3px; background-repeat:no-repeat;"><img src="'+MessageBoxImages+'place.gif" width="3" height="3"></td></tr>'
+'</table>'
+'</div>';br.innerHTML=u;var ag=br.lastChild;var h=ag.offsetHeight;var w=ag.offsetWidth;var x=(clientWidth()-w)/2+getScrollLeft();var y=(clientHeight()-h)/2+getScrollTop();if(PageBox.prototype.FormHandleColl.length>0)
{var tmp=PageBox.prototype.FormHandleColl[PageBox.prototype.FormHandleColl.length-1].lastChild.style;if(parseInt(tmp.left)+10+w<=getScrollLeft()+clientWidth()&&parseInt(tmp.top)+10+h<=getScrollTop()+clientHeight())
{x=parseInt(tmp.left)+10;y=parseInt(tmp.top)+10;}}
if(x+w>getScrollLeft()+clientWidth())
{x=getScrollLeft()+clientWidth()-w;}
if(y+h>getScrollTop()+clientHeight())
{y=getScrollTop()+clientHeight()-h;}
if(x<getScrollLeft())
{x=getScrollLeft();}
if(y<getScrollTop())
{y=getScrollTop();}
ag.style.left=x+"px";ag.style.top=y+"px";$(btnClose).onclick=function()
{var cancelClose=false;if(closingCallbak!=null&&closingCallbak)
{cancelClose=closingCallbak(br.returnValue);}
if(!cancelClose)
{var rv=br.returnValue;u=null;PageBox.prototype.FormHandleColl.remove(br);if(showShade)
{RemoveWindowOnResize(bg_onresize);}
br.innerHTML="";document.body.removeChild(br);if(closedCallbak!=null&&closedCallbak)
{closedCallbak(rv);return false;}}
br.returnValue=null;return false;};if(autoCloseTime>=0)
{var defaultButtonTime=autoCloseTime;var AutoClick=function()
{if($(btnClose))
{if(defaultButtonTime<=0)
{$(btnClose).onclick();}
else
{defaultButtonTime--;window.setTimeout(AutoClick,1000);}}}
AutoClick();}
if(showShade)
{AddWindowOnResize(bg_onresize);}
br.Close=function(returnValue)
{if(returnValue!=null)
{br.returnValue=returnValue;}
var btnClose=$(br.id+"Close");if(btnClose)
{btnClose.onclick();}
else
{PageBox.prototype.FormHandleColl.remove(br);if(showShade)
{RemoveWindowOnResize(bg_onresize);}
br.innerHTML="";document.body.removeChild(br);}}
$(iframe).PageBox=br;$(iframe).Close=function(returnValue)
{br.Close(returnValue);}
br.SetSize=function(width,height)
{$(iframe).width=width;$(iframe).height=height;}
br.MoveToCenter=function()
{var ag=$(box);var h=ag.offsetHeight;var w=ag.offsetWidth;var x=(clientWidth()-w)/2+getScrollLeft();var y=(clientHeight()-h)/2+getScrollTop();ag.style.left=x+"px";ag.style.top=y+"px";}
br.ShowScroll=function(hasScroll)
{$(iframe).scrolling=hasScroll?"auto":"no";}
PageBox.prototype.FormHandleColl.push(br);return br;}
PageBox.prototype.FormHandleColl=new Array();function PreviewMessageBoxImages()
{var imgs=new Array();imgs[0]="bg.png";imgs[1]="box.png";imgs[2]="lr.png";imgs[3]="tb.png";imgs[4]="place.gif";imgs[5]="progbar.gif";imgs[6]="error.png";imgs[7]="question.png";imgs[8]="warning.png";imgs[9]="information.png";imgs[10]="stop.png";for(var i=0;i<imgs.length;i++)
{var t=document.createElement("IMG");t.style.position="absolute";t.style.left="0px";t.style.top="0px";t.style.width="0px";t.style.height="0px";t.src=MessageBoxImages+imgs[i];document.body.appendChild(t);}}
function sortColumn(e,descending){var tmp;if(typeof(e)=="string")
{tmp=$(e);}
else
{tmp=e.target?e.target:e.srcElement;}
var tHeadParent=sortColumn.prototype.getParent(tmp,"THEAD");var el=sortColumn.prototype.getHead(tmp);if(tHeadParent==null)
return;if(el!=null){if(el.getAttribute("type")=="None"||el.getAttribute("type")==null)return;var p=el.parentNode;var i;el._descending=(descending!=null?descending:!Boolean(el._descending));if(tHeadParent.arrow!=null){if(tHeadParent.arrow.parentNode!=el){tHeadParent.arrow.parentNode._descending=null;}
tHeadParent.arrow.parentNode.removeChild(tHeadParent.arrow);}
if(el._descending)
{var arrowUp=document.createElement("SPAN");arrowUp.innerHTML='<img src="'+MessageBoxImages+'up.gif" />';tHeadParent.arrow=arrowUp;}
else
{var arrowDown=document.createElement("SPAN");arrowDown.innerHTML='<img src="'+MessageBoxImages+'down.gif" />';tHeadParent.arrow=arrowDown;}
el.appendChild(tHeadParent.arrow);var cells=p.cells;var l=cells.length;for(i=0;i<l;i++){if(cells[i]==el)break;}
var table=sortColumn.prototype.getParent(el,"TABLE");sortColumn.prototype.sortTable(table,i,el._descending,el.getAttribute("type"));}}
sortColumn.prototype.sortTable=function(tableNode,nCol,bDesc,sType){var tBody=tableNode.tBodies[0];var trs=tBody.rows;var trl=trs.length;var a=new Array();for(var i=0;i<trl;i++){a[i]=trs[i];}
var start=new Date;window.status="正在排序...";a.sort(sortColumn.prototype.compareByColumn(nCol,bDesc,sType));window.status="排序完成";for(var i=0;i<trl;i++){tBody.appendChild(a[i]);window.status="更新行 "+(i+1)+" / "+trl+" (花费时间: "+(new Date-start)+"ms)";}
if(typeof tableNode.onsort=="string")
tableNode.onsort=new Function("",tableNode.onsort);if(typeof tableNode.onsort=="function")
tableNode.onsort();}
sortColumn.prototype.getInnerText=function(el){if(document.all)return el.innerText;var str="";var cs=el.childNodes;var l=cs.length;for(var i=0;i<l;i++){switch(cs[i].nodeType){case 1:str+=sortColumn.prototype.getInnerText(cs[i]);break;case 3:str+=cs[i].nodeValue;break;}}
return str;}
sortColumn.prototype.getParent=function(el,pTagName){if(el==null)return null;else if(el.nodeType==1&&el.tagName.toLowerCase()==pTagName.toLowerCase())
return el;else
return sortColumn.prototype.getParent(el.parentNode,pTagName);}
sortColumn.prototype.getHead=function(el){if(el==null)return null;else if(el.nodeType==1&&(el.tagName.toLowerCase()=="TD".toLowerCase()||el.tagName.toLowerCase()=="TH".toLowerCase()))
return el;else
return sortColumn.prototype.getHead(el.parentNode);}
sortColumn.prototype.compareByColumn=function(nCol,bDescending,sType){var c=nCol;var d=bDescending;var fTypeCast=String;if(sType=="Number")
fTypeCast=Number;else if(sType=="Date")
fTypeCast=function(s){return Date.parse(s.replace(/\-/g,'/'));};else if(sType=="CaseInsensitiveString")
fTypeCast=function(s){return String(s).toUpperCase();};else if(sType=="FileLength")
fTypeCast=function(s){var n=Number(s.replace(/[^0-9\.]/g,""));var KB=1024;var MB=KB*1024;var GB=MB*1024;var TB=GB*1024;if(s.endsWith("TB",true))
{return n*TB;}
else if(s.endsWith("GB",true))
{return n*GB;}
else if(s.endsWith("MB",true))
{return n*MB;}
else if(s.endsWith("KB",true))
{return n*KB;}
return n;};return function(n1,n2){if(fTypeCast(sortColumn.prototype.getInnerText(n1.cells[c]))<fTypeCast(sortColumn.prototype.getInnerText(n2.cells[c])))
return d?-1:+1;if(fTypeCast(sortColumn.prototype.getInnerText(n1.cells[c]))>fTypeCast(sortColumn.prototype.getInnerText(n2.cells[c])))
return d?+1:-1;return 0;};}
function FixedPosition(id,h,v,x,y)
{var obj=document.getElementById(id);var objstyle=obj.style;var posX=getScrollLeft();var posY=getScrollTop();var clientW=clientWidth();var clientH=clientHeight();if(h==null)
{h="Left";}
if(v==null)
{v="Top";}
if(x==null)
{x=0;}
if(y==null)
{y=0;}
if(objstyle.position.toLowerCase()!="absolute"&&objstyle.position.toLowerCase()!="fixed")
{objstyle.position="absolute";}
var tox=0;switch(h.toLowerCase())
{case"left":tox=posX+x;break;case"center":tox=posX+(clientW-obj.offsetWidth)/2+x;break;case"right":tox=posX+(clientW-obj.offsetWidth)+x;break;}
if(objstyle.left=="")
{objstyle.left=tox+"px";}
var cleft=parseInt(objstyle.left);if(cleft!=tox)
{if(cleft<tox)
{var step=Math.ceil((tox-cleft)/10);objstyle.left=cleft+step+"px";}
else
{var step=Math.ceil((cleft-tox)/10);objstyle.left=cleft-step+"px";}}
var toy=0;switch(v.toLowerCase())
{case"top":toy=posY+y;break;case"middle":toy=posY+(clientH-obj.offsetHeight)/2+y;break;case"bottom":toy=posY+(clientH-obj.offsetHeight)+y;break;}
if(objstyle.top=="")
{objstyle.top=toy+"px";}
var ctop=parseInt(objstyle.top);if(ctop!=toy)
{if(ctop<toy)
{var step=Math.ceil((toy-ctop)/10);objstyle.top=ctop+step+"px";}
else
{var step=Math.ceil((ctop-toy)/10);objstyle.top=ctop-step+"px";}}
window.setTimeout("FixedPosition('"+id+"', '"+h+"', '"+v+"', "+x+", "+y+")",10);}
function HtmlRotator_Marquee(id,ct1,kinds,delay)
{var cp=$(id);var cct1=$(ct1);if(cp.start==1)
{switch(kinds)
{case 1:if(cp.scrollTop<=0)
{cp.scrollTop+=cct1.offsetHeight;}
else
{cp.scrollTop--;}
break;case 2:if(cp.scrollTop>=cct1.offsetHeight)
{cp.scrollTop-=cct1.offsetHeight;}
else
{cp.scrollTop++;}
break;case 3:if(cp.scrollLeft<=0)
{cp.scrollLeft+=cct1.offsetWidth;}
else
{cp.scrollLeft--;}
break;case 4:if(cp.scrollLeft>=cct1.offsetWidth)
{cp.scrollLeft-=cct1.offsetWidth;}
else
{cp.scrollLeft++;}
break;}}
setTimeout("HtmlRotator_Marquee('"+id+"', '"+ct1+"', "+kinds+", "+delay+");",delay);}
function HtmlRotator(id,kinds,delay,stop,width,height)
{if(kinds==null)
{kinds="BottomToTop";}
if(delay==null)
{delay=50;}
var ctl=document.getElementById(id);var pctl=ctl.parentNode;var pan=document.createElement("DIV");var id0=RandomControlID();pan.id=id0;if(width==null)
{pan.style.width=ctl.offsetWidth+"px";}
else
{pan.style.width=width;}
if(height==null)
{pan.style.height=ctl.offsetHeight+"px";}
else
{pan.style.height=height;}
pan.style.borderStyle=ctl.style.borderStyle;ctl.style.borderStyle="none";pan.style.borderWidth=ctl.style.borderWidth;ctl.style.borderWidth="0px";pan.style.borderColor=ctl.style.borderColor;ctl.style.borderColor="";pan.style.borderCollapse="collapse";pan.style.overflow="hidden";pan.start="1";if(stop!=false)
{pan.onmouseover=function(){pan.start=0;}
pan.onmouseout=function(){pan.start=1;}}
var e0=document.createElement("TABLE");e0.cellspacing=0;e0.cellpadding=0;e0.border=0;e0.style.width="100%";e0.style.borderStyle="none";e0.style.borderWidth="0px";e0.style.borderCollapse="collapse";var e1=document.createElement("TBODY");var e2=document.createElement("TR");var e3=document.createElement("TD");var id1=RandomControlID();e3.id=id1;var e4=document.createElement("TR");var e5=document.createElement("TD");pan.appendChild(e0);e0.appendChild(e1);e1.appendChild(e2);e2.appendChild(e3);if(kinds=="TopToBottom"||kinds=="BottomToTop")
{e1.appendChild(e4);e4.appendChild(e5);}
else
{e2.appendChild(e5);}
pctl.replaceChild(pan,ctl)
e3.appendChild(ctl);e5.appendChild(ctl.cloneNode(true));var ikinds=2;switch(kinds)
{case"TopToBottom":ikinds=1;break;case"BottomToTop":ikinds=2;break;case"LeftToRight":ikinds=3;break;case"RightToLeft":ikinds=4;break;}
HtmlRotator_Marquee(id0,id1,ikinds,delay);}