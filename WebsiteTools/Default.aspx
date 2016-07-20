<%@ Page Language="C#" Inherits="Thinksea.WebsiteTools.WebsiteTools" CodeFile="Default.aspx.cs" %>
<%@ Assembly Src="Define.cs" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>Thinksea website tools</title>
    <style type="text/css">
    body
    {
        margin: 0px;
        overflow: hidden;
        background-color: #a0c0e6;
    }
    #Files td
    {
        padding-left: 5px;
        padding-right: 5px;
    }
    th
    {
        white-space: nowrap;
    }
    .onMouseOver
    {
        background-color: #dddddd;
    }
    .onMouseOut
    {
        background-color: white;
    }
    .Name
    {
        font-size:9pt;
        width: 100%;
    }
    .Length
    {
        font-size:9pt;
        white-space: nowrap;
        text-align: right;
    }
    .Extension
    {
        font-size:9pt;
        white-space: nowrap;
    }
    .LastWriteTime
    {
        font-size:9pt;
        white-space: nowrap;
    }
    .EditOnline
    {
        font-size:9pt;
        white-space: nowrap;
        text-align: center;
    }
    .deleteCol
    {
        font-size:9pt;
        white-space: nowrap;
        text-align: center;
    }
    .moveCol
    {
        font-size:9pt;
        white-space: nowrap;
        text-align: center;
    }
    .menu
    {
        position: absolute;
        left: 4px;
        top: 36px;
        border: solid 1px gray;
        background-color: #e9effc;
        padding: 5px;
    }
    .menu table
    {
        font-size: 12px;
    }
    .menu td
    {
    }
    .menu A
    {
        text-decoration: none;
        color: Black;
        cursor: hand;
    }
    .menu A div
    {
        padding: 5px;
        width: 130px;
    }
    .menu A:Hover
    {
        text-decoration: none;
        color: Blue;
        background-color: #eeeeee;
    }
    .menu A:Hover div
    {
        padding: 4px;
        border: solid 1px #d0d0d0;
        background-color: #eeeeee;
    }
    </style>
    <script language="javascript" type="text/javascript" src="aspnet_client/MessageBox/MessageBox.js"></script>
    <script language="javascript" type="text/javascript">
    // 修复 IE6 下 PNG 图片不能透明显示的问题
    function fixPNG(myImage, imgove)
    {
        var arVersion = navigator.appVersion.split("MSIE");
        var version = parseFloat(arVersion[1]);
        if ((version >= 5.5) && (version < 7) && (document.body.filters))
        {
            var imgID = (myImage.id) ? "id='" + myImage.id + "' " : "";
            var imgClass = (myImage.className) ? "class='" + myImage.className + "' " : "";
            var imgTitle = (myImage.title) ? "title='" + myImage.title   + "' " : "title='" + myImage.alt + "' ";
            var imgStyle = "display:inline-block;" + myImage.style.cssText;
            var strNewHTML = "<span " + imgID + imgClass + imgTitle + " style=\"" + "width:" + myImage.width + "px; height:" + myImage.height
            + "px;" + imgStyle + ";filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + myImage.src + "', sizingMethod='scale');\""
            + " onmouseover=\"this.style.filter='progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\\'" + imgove + "\\', sizingMethod=\\'scale\\');';\""
            + " onmouseout=\"this.style.filter='progid:DXImageTransform.Microsoft.AlphaImageLoader(src=\\'" + myImage.src + "\\', sizingMethod=\\'scale\\');';\""
            + "></span>";
            myImage.outerHTML = strNewHTML;
        }
    }

    var TextExpandNames = [".txt", ".utf", ".asp", ".aspx", ".ascx", ".master", ".cs", ".htm", ".html", ".xml", ".xaml", ".xsl", ".xslt", ".css", ".config", ".jsp", ".js", ".c", ".cpp", ".h", ".hpp", ".vb", ".bas", ".frm", ".cls", ".vbp", ".ctl", ".vbs", ".pas", ".dpr", ".dfm", ".java", ".jav", ".py", ".ini", ".inf", ".cmd", ".bat", ".csv", ".cbl", ".cpy", ".cob", ".reg"]; //被认为是文本文件的文件扩展名。
    var aspnet_clientfolder="aspnet_client/"; //aspnet_client 目录路径。
    var Directory = "/";//当前目录。
    var tmpDirectory = null;//用于存放临时数据。
    var progressBar = null;//进度条。

    //显示进度条。
    function ShowProgressBar(text, title)
    {
        if(text == null)
        {
            text = "正在加载数据……";
        }
        if(progressBar != null)
        {
            progressBar.Close();
        }
        progressBar = ProgressBar(text, title);
    }

    //隐藏进度条。
    function HidProgressBar()
    {
        if(progressBar != null)
        {
            progressBar.Close();
            progressBar = null;
        }
    }

    //刷新文件表
    function refresh()
    {
        selectedNode(Directory);
    }

    //列表文件
    function selectedNode(n)
    {
        tmpDirectory = n;
        var argument = "";
        argument += "<root>";
        argument += "\r\n<Command>getfiles</Command>";
        argument += "\r\n<Directory>" + XMLEncode(n) + "</Directory>";
        argument += "\r\n</root>";
        var context = "getfiles"; //设置命令。
        ShowProgressBar("正在更新文件信息……");
        <%= this.ClientScript.GetCallbackEventReference(this, "argument", "Callback", "context", "CallbackError", true)%>;
    }

    //转到用户输入的路径。
    function gotoInput()
    {
        gotoDirectory(document.getElementById("editDirectory").value);
    }

    //转到指定的目录路径。
    function gotoDirectory(path)
    {
        if(path == "")
        {
            path = "/";
        }
        path = path.replace(/[\/\\]+/gi, "/");
        document.getElementById("editDirectory").value=path;
        selectedNode(path);
    }

    //获取指定的文件扩展名应该显示的标识图片
    function GetExtImg(IsFile, Extension)
    {
        if(!IsFile)
        {
            return aspnet_clientfolder + 'filebrowser/folder.gif';
        }
        var Exts=[
[".AIF", "winmedia.gif"]
,[".AIFC", "winmedia.gif"]
,[".AIFF", "winmedia.gif"]
,[".ASF", "winmedia.gif"]
,[".ASP", "asp.gif"]
,[".ASX", "winmedia.gif"]
,[".AU", "winmedia.gif"]
,[".AUDIOCD", "audiocd.gif"]
,[".AVI", "winmedia.gif"]
,[".BMP", "bmp.gif"]
,[".CDA", "winmedia.gif"]
,[".CHM", "chm.gif"]
,[".CSS", "css.gif"]
,[".DIB", "bmp.gif"]
,[".DOC", "doc.gif"]
,[".DVD", "audiocd.gif"]
,[".EMF", "emf.gif"]
,[".EML", "eml.gif"]
,[".FON", "fon.gif"]
,[".GIF", "gif.gif"]
,[".HLP", "hlp.gif"]
,[".HTM", "html.gif"]
,[".HTML", "html.gif"]
,[".HTT", "htt.gif"]
,[".JFIF", "jpeg.gif"]
,[".JPE", "jpeg.gif"]
,[".JPEG", "jpeg.gif"]
,[".JPG", "jpeg.gif"]
,[".JS", "js.gif"]
,[".JSE", "js.gif"]
,[".M1V", "winmedia.gif"]
,[".M3U", "winmedia.gif"]
,[".MDB", "mdb.gif"]
,[".MID", "winmedia.gif"]
,[".MIDI", "winmedia.gif"]
,[".MMM", "mmm.gif"]
,[".MP2", "winmedia.gif"]
,[".MP2V", "winmedia.gif"]
,[".MP3", "winmedia.gif"]
,[".MPA", "winmedia.gif"]
,[".MPE", "winmedia.gif"]
,[".MPEG", "winmedia.gif"]
,[".MPG", "winmedia.gif"]
,[".MPV2", "winmedia.gif"]
,[".MSI", "msi.gif"]
,[".MSP", "msi.gif"]
,[".MSSTYLES", "theme.gif"]
,[".MSWMM", "mswmm.gif"]
,[".PNG", "png.gif"]
,[".PPT", "ppt.gif"]
,[".REG", "reg.gif"]
,[".RMI", "winmedia.gif"]
,[".SHTML", "html.gif"]
,[".SND", "winmedia.gif"]
,[".SWF", "swf.gif"]
,[".THEME", "theme.gif"]
,[".TIF", "tif.gif"]
,[".TIFF", "tif.gif"]
,[".TXT", "txt.gif"]
,[".VBE", "vbe.gif"]
,[".VBS", "vbe.gif"]
,[".WAV", "winmedia.gif"]
,[".WAX", "winmedia.gif"]
,[".WM", "winmedia.gif"]
,[".WMA", "winmedia.gif"]
,[".WMD", "winmedia.gif"]
,[".WMF", "wmf.gif"]
,[".WMP", "winmedia.gif"]
,[".WMS", "winmedia.gif"]
,[".WMV", "winmedia.gif"]
,[".WMX", "winmedia.gif"]
,[".WMZ", "winmedia.gif"]
,[".WSF", "vbe.gif"]
,[".WSH", "wsh.gif"]
,[".WVX", "winmedia.gif"]
,[".XLS", "xls.gif"]
,[".XML", "xml.gif"]
,[".XSL", "xsl.gif"]
,[".ZIP", "zip.gif"]
,[".ace", "rar.gif"]
,[".arj", "rar.gif"]
,[".ascx", "ascx.gif"]
,[".aspx", "aspx.gif"]
,[".cs", "cs.gif"]
,[".exe", "exe.gif"]
,[".psd", "psd.gif"]
,[".pub", "pub.gif"]
,[".rar", "rar.gif"]
];
        Extension=Extension.toLowerCase();
        for(var i=0;i<Exts.length;i++)
        {
            if( Exts[i][0].toLowerCase()==Extension)
            {
                return aspnet_clientfolder + 'filebrowser/'+Exts[i][1];
            }
        }
        return aspnet_clientfolder + 'filebrowser/default.gif';
    }

    //获取指定文件的扩展名。
    function GetExtension(file)
    {
        var ex = file.match(/\.[^.\/\\]+$/gi);
        if(ex == null)
        {
            return "";
        }
        else
        {
            return ex;
        }
    }

    //从文件列表中清空所有的记录。
    function ClearFiles()
    {
        var Files = document.getElementById("Files");
        while(Files.hasChildNodes())
        {
            Files.removeChild(Files.firstChild);
        }
    }

    //创建文件信息数据行。
    function CreateFileInfoTR(file)
    {
        var url=(tmpDirectory=='/'? '/': tmpDirectory.replace(/\\/gi, '/') + '/').replace(/[\/\\]+/gi, "/");
        if(file.isFile)
        {
            url = url + file.name;
        }
        else
        {
            url = "javascript:selectedNode('" + url + file.name + "');";
        }

        var tr = document.createElement("TR");
        tr.id=file.name;
        tr.isFile=file.isFile;
        tr.onmouseover=function(){this.className='onMouseOver';}
        tr.onmouseout=function(){this.className='onMouseOut';}

        {
            var td = document.createElement("TD");
            td.innerHTML = '<input name="ck" type="checkbox" onclick="ChangedChecked();" />';
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            td.innerHTML = '<img src="' + GetExtImg(file.isFile, file.extension) + '" />';
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            td.innerHTML = '<a href="' + url + '"' + (file.isFile? ' target="_blank"':'') + '>' + file.name + '</a>';
            td.className = "Name";
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            td.innerHTML = file.length;
            td.className = "Length";
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            td.innerHTML = file.extension;
            td.className = "Extension";
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            td.innerHTML = file.lastWriteTime;
            td.className = "LastWriteTime";
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            td.innerHTML = (file.isFile? '<a href="downloadfile.aspx?filename=' + encodeURIComponent(url) + '">下载</a>': '&nbsp;');
            td.className = "EditOnline";
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            var isTextFile = false;
            for(var i =0; i < TextExpandNames.length; i++)
            {
                if(TextExpandNames[i].toLowerCase()==file.extension.toLowerCase())
                {
                    isTextFile = true;
                    break;
                }
            }
            td.innerHTML = (isTextFile? '<a href="FileEditor.aspx?filename=' + encodeURIComponent(url) + '" target="_blank">编辑</a>': '&nbsp;');
            td.className = "EditOnline";
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            td.innerHTML = '<a href="javascript:renameFile(\'' + file.name + '\');" target="_self">改名</a>';
            td.className = "EditOnline";
            tr.appendChild(td);
        }
        {
            var td = document.createElement("TD");
            td.innerHTML = file.extension.toLowerCase() == ".zip"? '<a href="javascript:uncompression(\'' + url + '\');" target="_self">解压缩</a>': "&nbsp;";
            td.className = "EditOnline";
            tr.appendChild(td);
        }
        return tr;

    }

    function Callback(o, command)
    {
        eval("var e=" + o);

        if(e.ErrorCode != undefined && e.ErrorCode != 0)
        {
            HidProgressBar();
            MessageBox(e.Message, null, "OK", "Error", null, null, null, null);
            return;
        }

        switch( command )
        {
            case "getfiles":
                {
                    Directory = document.getElementById("editDirectory").value = tmpDirectory;
                    document.title = Directory;
                    ClearFiles();
                    var Files = document.getElementById("Files");
                    for(var i=0; i < e.length; i++ )
                    {
                	    Files.appendChild(CreateFileInfoTR(e[i]));
                    }
                    SelectAllFiles(false);
                    HidProgressBar();
                }
                break;
            case "deletefile":
                {
                    for(var i=0; i < e.length; i++)
                    {
                        var tcd = document.getElementById(e[i]);
                        if(tcd.nodeName == "TR")
                        {
                            tcd.parentNode.removeChild(tcd);
                        }
                    }
                    SelectAllFiles(false);
                    HidProgressBar();
                    MessageBox("成功删除 " + e.length + " 个文件/文件夹", null, "OK", "Information", null, null, null, null);
                }
                break;
            case "movefile":
                {
                    for(var i=0; i < e.length; i++)
                    {
                        var tcd = document.getElementById(e[i]);
                        if(tcd.nodeName == "TR")
                        {
                            tcd.parentNode.removeChild(tcd);
                        }
                    }
                    SelectAllFiles(false);
                    HidProgressBar();
                    MessageBox("成功移动 " + e.length + " 个文件/文件夹", null, "OK", "Information", null, null, null, null);
                }
                break;
            case "renamefile":
                {
                    var oldFileName=e[0].tag;
                    var oldtcd = document.getElementById(oldFileName);
                    var newtcd = CreateFileInfoTR(e[0]);
	                var tb = oldtcd.parentNode;
	                tb.insertBefore(newtcd, oldtcd);
	                tb.removeChild(oldtcd);
                    SelectAllFiles(false);
                    HidProgressBar();
                    MessageBox("更改名称成功！", null, "OK", "Information", null, null, null, null);
                }
                break;
            case "createdirectory":
                {
                    var newtcd = CreateFileInfoTR(e[0]);
                    var Files = document.getElementById("Files");
	                Files.appendChild(newtcd);
                    SelectAllFiles(false);
                    HidProgressBar();
                    MessageBox("创建目录成功！", null, "OK", "Information", null, null, null, null);
                }
                break;
        }
    }

    //当执行功能操作时出现异常时执行此方法。
    function CallbackError(e,command)
    {
        HidProgressBar();
        MessageBox(e.replace("0|", ""), null, "OK", "Error", null, null, null, null);
    }

    //选中或取消选中全部的文件。
    function SelectAllFiles(checked)
    {
        document.getElementById("selectAll").checked=checked;
        var cks = document.getElementsByName("ck");
        for(var i=0; i < cks.length; i++)
        {
            cks[i].checked=checked;
        }
    }

    //当更改全部选中复选框的选中状态时，更新其他文件的复选框的选中状态。
    function ChangeAllChecked()
    {
        var selectAll=document.getElementById("selectAll");
        var cks = document.getElementsByName("ck");
        for(var i=0; i < cks.length; i++)
        {
            cks[i].checked=selectAll.checked;
        }
    }

    //当更改一个文件的选中状态时，更新全部选中复选框的选中状态。
    function ChangedChecked()
    {
        var r=true;
        var cks = document.getElementsByName("ck");
        for(var i=0; i < cks.length; i++)
        {
            if(!cks[i].checked)
            {
                r=false;
                break;
            }
        }
        document.getElementById("selectAll").checked=r;
    }

    //获取当前选中的文件。
    function GetSelectedFiles()
    {
        var ckfiles = new Array();
        var cks = document.getElementsByName("ck");
        for(var i=0; i < cks.length; i++)
        {
            if(cks[i].checked)
            {
                ckfiles.push(cks[i].parentNode.parentNode.id);
            }
        }
        return ckfiles;
    }

    //删除选中的文件。
    function deleteFiles()
    {
        var ckfiles = GetSelectedFiles();
        if( ckfiles.length == 0 )
        {
            MessageBox("没有选中要删除的目标！", null, "OK", "Error", function () {return;}, null, null, null);
        }
        else
        {
            var samplefiles = "";
            for(var i=0; i < ckfiles.length && i < 5; i++)
            {
                samplefiles += "\r\n" + (i+1) + "、" + ckfiles[i];
            }
            if(ckfiles.length > 5)
            {
                samplefiles += "\r\n6、......";
            }
            MessageBox("确认要删除选中的 " + ckfiles.length + " 个文件/文件夹吗？" + samplefiles, null, "OKCancel", "Question", function(arg){
                if( arg == "OK" )
                {
                    var argument = "";
                    argument += "<root>";
                    argument += "\r\n<Command>deletefile</Command>";
                    argument += "\r\n<Directory>" + XMLEncode(Directory) + "</Directory>";
                    for(var i=0; i < ckfiles.length; i++)
                    {
                        argument += "\r\n<Item>" + XMLEncode(ckfiles[i]) + "</Item>";
                    }
                    argument += "\r\n</root>";
                    var context = "deletefile"; //设置命令。
                    ShowProgressBar("正在删除文件……");
                    <%= this.ClientScript.GetCallbackEventReference(this, "argument", "Callback", "context", "CallbackError", true)%>;
                }
            }, null, null, null);
        }
    }

    //文件改名。
    function renameFile(sfilename)
    {
        PageBox("textbox1.htm?text=" + sfilename, "请输入新的名称", 300, 100, function(returnValue)
        {
            if(returnValue && sfilename != returnValue)
            {
                MessageBox("确认要将文件“" + sfilename + "”的名称更改为“" + returnValue + "”吗？", null, "OKCancel", "Question", function(arg){
                    if( arg == "OK" )
                    {
                        var argument = "";
                        argument += "<root>";
                        argument += "\r\n<Command>renamefile</Command>";
                        argument += "\r\n<Directory>" + XMLEncode(Directory) + "</Directory>";
                        argument += "\r\n<OldName>" + XMLEncode(sfilename) + "</OldName>";
                        argument += "\r\n<NewName>" + XMLEncode(returnValue) + "</NewName>";
                        argument += "\r\n</root>";
                        var context = "renamefile"; //设置命令。
                        ShowProgressBar("正在更改名称……");
                        <%= this.ClientScript.GetCallbackEventReference(this, "argument", "Callback", "context", "CallbackError", true)%>;
                    }
                }, null, null, null);
            }
        });
    }

    //移动选中的文件。
    function moveFiles()
    {
        var ckfiles = GetSelectedFiles();
        if( ckfiles.length == 0 )
        {
            MessageBox("没有选中要移动的目标！", null, "OK", "Error", function () {return;}, null, null, null);
        }
        else
        {
            var samplefiles = "";
            for(var i=0; i < ckfiles.length && i < 5; i++)
            {
                samplefiles += "\r\n" + (i+1) + "、" + ckfiles[i];
            }
            if(ckfiles.length > 5)
            {
                samplefiles += "\r\n6、......";
            }
            var pbFolderBrowser=PageBox("FolderBrowser.aspx", "请选择目的文件夹", 500, 400, function(arg){
                if(arg)
                {
                    MessageBox("确定要移动选中的 " + ckfiles.length + " 个文件/文件夹到“" + arg + "”文件夹吗？" + samplefiles, null, "YesNo", "Question", function(arg2){
                        if( arg2 == "OK" )
                        {
                            var newDirectory=arg;
                            if(newDirectory && newDirectory != Directory)
                            {
                                var argument = "";
                                argument += "<root>";
                                argument += "\r\n<Command>movefile</Command>";
                                argument += "\r\n<OldDirectory>" + XMLEncode(Directory) + "</OldDirectory>";
                                argument += "\r\n<NewDirectory>" + XMLEncode(newDirectory) + "</NewDirectory>";
                                for(var i=0; i < ckfiles.length; i++)
                                {
                                    argument += "\r\n<Item>" + XMLEncode(ckfiles[i]) + "</Item>";
                                }
                                argument += "\r\n</root>";
                                var context = "movefile"; //设置命令。
                                ShowProgressBar("正在移动选中的文件……");
                                <%= this.ClientScript.GetCallbackEventReference(this, "argument", "Callback", "context", "CallbackError", true)%>;
                            }
                            pbFolderBrowser.Close();
                        }
                    }, null, null, null);
                    return true;
                }
            }, null, null, true, true);
        }
    }

    //上传文件来自互联网。
    function uploadFileFromInternet()
    {
        PageBox("UpdateFileFromInternet.aspx?path=" + encodeURIComponent(Directory), "上传文件来自互联网", 400, 100, null, null, null, false, true);
    }

    //上传文件来自本地。
    function uploadFile()
    {
        PageBox("fileupload.aspx?path=" + encodeURIComponent(Directory), "上传文件来自本地", 500, 400, null, null, null, true, true);
    }

    //创建新文件
    function createNewFile()
    {
        window.open("FileEditor.aspx", "_blank", "");
    }

    //创建目录
    function createDirectory()
    {
        PageBox("textbox1.htm", "请输入文件夹名称", 300, 100, function(returnValue)
        {
            if(returnValue)
            {
                var argument = "";
                argument += "<root>";
                argument += "\r\n<Command>createdirectory</Command>";
                argument += "\r\n<Directory>" + XMLEncode(Directory) + "</Directory>";
                argument += "\r\n<Name>" + XMLEncode(returnValue) + "</Name>";
                argument += "\r\n</root>";
                var context = "createdirectory"; //设置命令。
                ShowProgressBar("正在创建目录……");
                <%= this.ClientScript.GetCallbackEventReference(this, "argument", "Callback", "context", "CallbackError", true)%>;
            }
        });
    }

    //压缩文件。
    function compression()
    {
        var ckfiles = GetSelectedFiles();
        if( ckfiles.length == 0 )
        {
            MessageBox("没有选中要压缩的目标！", null, "OK", "Error", function () {return;}, null, null, null);
        }
        else
        {
            var pbFolderBrowser=PageBox("ZIP.aspx", "新建压缩文档", 600, 500, null, null, null, null, true, true);
        }
    }

    //解压缩文件。
    function uncompression(zipfile)
    {
        var pbFolderBrowser=PageBox("UnZIP.aspx?zipfilename=" + encodeURIComponent(zipfile), "解压缩文档", 600, 500, null, null, null, null, true, true);
    }

    //转到上级目录。
    function gotoUpFolder()
    {
        var dir = Directory;
        if(dir != "/")
        {
            dir = dir.replace(/[\/\\][^\/\\]+[\/\\]?$/gi, "");
        }
        gotoDirectory(dir);
    }

    //更改登陆密码。
    function modifyPassword()
    {
        var pbFolderBrowser=PageBox("pwd.aspx", "更改登陆密码", 300, 150, null, null, null, null, true, true);
    }

    //IIS 管理。
    function iismng()
    {
        var pbFolderBrowser=PageBox("iismng.aspx", "IIS 管理", 350, 200, null, null, null, null, true, true);
    }

    //显示关于对话框。
    function about()
    {
        var b="<span style='font-size: 18px;'><strong>Thinksea website tools</strong></span> v1.4"
        + "<br /><br /><div style='white-space:nowrap;'>Copyright Thinksea 2004年10月—2016年7月</div>"
        + "<br /><div style='text-align:right;'><a href='http://www.thinksea.com' target='_blank'>http://www.thinksea.com</a></div>";

        MessageBoxBase(b, "关于……", "确 定", null, null);
        return false;
    }

    function changeMenuDisplay()
    {
        var mainMenu = document.getElementById("mainMenu");
        mainMenu.style.display = (mainMenu.style.display=="none"? "":"none");
    }

    function hiddenMenu()
    {
        var mainMenu = document.getElementById("mainMenu");
        mainMenu.style.display = "none";
    }

    //退出系统登录状态。
    function btnQuit_ClientClick()
    {
        document.getElementById("form1").setAttribute("onsubmit", "");
        return true;
    }

	function OnLoad()
	{
		selectedNode(Directory);
	}

    //隐藏左侧菜单
    function hiddenTree()
    {
        $("treemenu").style.display = "none";
        $("showMenuButton").style.display = "";
    }
     
    //显示左侧菜单
    function showMenu()
    {
        $("treemenu").style.display = "";
        $("showMenuButton").style.display = "none";
    }
    </script>
</head>
<body onload="OnLoad();">
    <form id="form1" runat="server" onsubmit="return false;">
        <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td style="height: 32px; border-bottom: solid 1px #6687BA; padding-left: 6px; padding-right: 6px; vertical-align: middle">
                    <table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr><td style="width: 40px;" onclick="changeMenuDisplay();"><a href="#"><input type="image" src="images/start.png" onmouseover="this.src='images/startmo.png';" onmouseout="this.src='images/start.png';" border="0" style="position: absolute; left: 1px; top: 1px;" onload="fixPNG(this, 'images/startmo.png');" /></a>
                            <div id="mainMenu" class="menu" style="display: none;" onclick="hiddenMenu();">
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr><td><a id="A1" href="#" onclick="createDirectory();"><div>新建文件夹</div></a></td></tr>
                                    <tr><td><a id="A7" href="#" onclick="createNewFile();"><div>新建文件</div></a></td></tr>
                                    <tr><td><a id="A2" href="#" onclick="moveFiles();"><div>移动</div></a></td></tr>
                                    <tr><td><a id="A3" href="#" onclick="deleteFiles();"><div>删除</div></a></td></tr>
                                    <tr><td><a id="A4" href="#" onclick="compression();"><div>压缩选中的文件</div></a></td></tr>
                                    <tr><td><a id="A5" href="#" onclick="return uploadFile();"><div>上传文件来自本地</div></a></td></tr>
                                    <tr><td><a id="A6" href="#" onclick="uploadFileFromInternet();" style="width: 130px;"><div>上传文件来自互联网</div></a></td></tr>
                                    <tr><td><a id="A8" href="#" onclick="return modifyPassword();"><div>更改密码</div></a></td></tr>
                                    <tr><td><a id="A9" href="ExecuteSQL.aspx" target="_blank"><div>SQL Server 代码工具</div></a></td></tr>
                                    <tr><td><a id="A11" href="detect.aspx" target="_blank"><div>服务器检测</div></a></td></tr>
                                    <tr><td><a id="A10" href="#" onclick="return iismng();"><div>IIS 管理</div></a></td></tr>
                                    <tr><td><asp:LinkButton ID="lbtnQuit" runat="server" OnClick="btnQuit_Click" OnClientClick="return btnQuit_ClientClick();" ForeColor="Red"><div>安全退出系统</div></asp:LinkButton></td></tr>
                                </table>
                            </div>
                        </td><td style="white-space: nowrap;">
                            地址：<asp:TextBox ID="editDirectory" runat="server" Width="400px" onkeydown="if(event.keyCode==13) gotoInput();">/</asp:TextBox>
                            <input id="btnGoto" type="button" value="转到" onclick="gotoInput();" /><input 
                            id="btnRefresh" type="button" value="刷新" onclick="refresh();" /><input 
                            id="Button1" type="button" value="向上" onclick="gotoUpFolder();" />
                        </td><td style="white-space: nowrap; padding-right: 10px; text-align: right;">
                            <a href="#" onclick="return about();">关于 Thinksea website tools</a>
                        </td></tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height: 100%;">
                    <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td style="width: 1px; vertical-align: top;">
                                <table id="showMenuButton" style="display: none; height: 100%;" cellpadding="0" cellspacing="0" border="0"><tr><td style="vertical-align: middle;"><img style="border: none 0px; cursor: hand;" src="images/showmenu.gif" onmouseover="this.src='images/showmenu_turn.gif';" onmouseout="this.src='images/showmenu.gif';" alt="显示目录结构" title="显示目录结构" onclick="javascript:showMenu();" /></td></tr></table>
                                <table id="treemenu" border="0" cellpadding="0" cellspacing="0" style="height: 100%">
                                    <tr><td style="text-align: right; padding-right: 7px; padding-top: 2px;" colspan="2"><a href="javascript:hiddenTree();"><img style="border: none 0px; cursor: hand;" src="images/hidmenu.gif" onmouseover="this.src='images/hidmenu_turn.gif';" onmouseout="this.src='images/hidmenu.gif';" alt="隐藏目录结构" title="隐藏目录结构" width="9" height="9" /></a></td></tr>
                                    <tr><td style="height: 100%; vertical-align: top; padding-left: 7px; padding-bottom: 7px; padding-top: 2px;">
                                        <div id="treePanel" style="width: 180px; height: 100%; overflow: auto; background-color: #e9effc; border: #7696e3 1px inset;">
                                        <asp:TreeView ID="TreeView1" runat="server" OnTreeNodePopulate="TreeView1_TreeNodePopulate" ExpandDepth="1" ImageSet="XPFileExplorer" NodeIndent="15">
                                            <ParentNodeStyle Font-Bold="False" />
                                            <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                                            <SelectedNodeStyle BackColor="#B5B5B5" Font-Underline="False" HorizontalPadding="0px"
                                                VerticalPadding="0px" />
                                            <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black" HorizontalPadding="2px"
                                                NodeSpacing="0px" VerticalPadding="2px" ImageUrl="images/folder.gif" />
                                            <RootNodeStyle ImageUrl="images/computer.gif" />
                                            <Nodes>
                                                <asp:TreeNode NavigateUrl="javascript:selectedNode('/');" Text="/" Value="/"></asp:TreeNode>
                                            </Nodes>
                                        </asp:TreeView>
                                        </div>
                                    </td>
                                    <td style="padding-right: 7px; padding-bottom: 7px; cursor: w-resize;" onmousedown="MoveForm('treePanel',3)" onmouseup="StopMoveForm()"></td>
                                    </tr>
                                </table>
                            </td>
                            <td style="vertical-align: top; width: 100%; border-left: solid 1px #6687BA; background-color: White;">
                                <div style="width: 100%; height: 100%; overflow: auto;">
                                    <table border='1' style='border-collapse: collapse; width: 100%;' onclick='sortColumn(event);'>
                                        <thead><tr><th type="None"><input id="selectAll" type="checkbox" onclick="ChangeAllChecked();" /></th><th type="None"></th><th style="width: 100%;" type="CaseInsensitiveString">名称</th><th type="FileLength">大小</th><th type="CaseInsensitiveString">类型</th><th type="Date">修改日期</th><th type="None" colspan="4">操作</th></tr></thead>
                                        <tbody id="Files"></tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
