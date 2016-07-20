<%@ Page Language="C#" Inherits="Thinksea.WebsiteTools.UpdateFileFromInternet" CodeFile="UpdateFileFromInternet.aspx.cs" %>
<%@ Assembly Src="Define.cs" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>无标题页</title>
	<meta http-equiv="expires" content="0" />
	<link href="css/css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .ColumnTitle
        {
            white-space: nowrap;
            width: 1%;
        }
    </style>
    <script language="javascript" type="text/javascript">
    function btnUpdate_onclick()
    {
        document.getElementById("btnUpdate").disabled = true;
        var wp = window.parent;

        var argument = "";
        argument += "<root>";
        argument += "\r\n<Command>download</Command>";
        argument += "\r\n<URL>" + wp.XMLEncode(document.getElementById("editURL").value) + "</URL>";
        argument += "\r\n<SaveFileName>" + wp.XMLEncode(document.getElementById("editSaveFileName").value) + "</SaveFileName>";
        argument += "\r\n</root>";
        var context = "download"; //设置命令。
        if(window.parent != null && window.parent.ShowProgressBar) window.parent.ShowProgressBar();
        <%= this.ClientScript.GetCallbackEventReference(this, "argument", "Callback", "context", "CallbackError", false)%>;
	    return true;
    }

    function Callback(result, context)
    {
        eval("var CallbackResult = " + result);
        window.parent.refresh();
        if(window.parent != null && window.parent.HidProgressBar) window.parent.HidProgressBar();
        window.parent.MessageBox(CallbackResult.Message, null, "OK", "Information", null, function(){
            window.frameElement.Close();
	        }, null, -1);
    }

    function CallbackError(err, context)
    {
        if(window.parent != null && window.parent.HidProgressBar) window.parent.HidProgressBar();
	    window.parent.MessageBox(err.replace("0|", ""), null, "OK", "Error", null, function(){
            document.getElementById("btnUpdate").disabled = false;
	        }, null, -1);
    }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <table style="width: 100%; height: 100%;" cellpadding="0" cellspacing="0" border="0"><tr><td style="text-align: center; vertical-align: middle;">
    <table style="width: 90%;">
        <tr>
            <td class="ColumnTitle">URL：</td>
            <td><input id="editURL" type="text" style="width: 260px" /></td>
        </tr>
        <tr>
            <td class="ColumnTitle">存盘文件名：</td>
            <td><input id="editSaveFileName" type="text" style="width: 260px" /></td>
        </tr>
        <tr>
            <td align="center" colspan="2"><input id="btnUpdate" type="button" value=" 保 存 " onclick="return btnUpdate_onclick()" /></td>
        </tr>
    </table>
    </td></tr></table>
    </form>
</body>
</html>
