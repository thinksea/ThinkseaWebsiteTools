<%@ Page Language="C#" %>
<%@ Assembly Src="Define.cs" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head runat="server">
		<title>上传文件</title>
		<meta http-equiv="expires" content="0" />
 <link href="js/webuploader.css" rel="stylesheet" />
    <script src="js/jquery1.9.1.js"></script>
    <script src="js/webuploader.min.js"></script>
    <script src="js/CKWebUploader.min.js"></script>
	</head>
	<body oncontextmenu="return false;" onselectstart="return false;" ondrag="return false;">
		<form id="Form1"   runat="server">
             <div class="webuploader-container">
            <div id="fileList" class="uploader-filelist">
            </div>
            <div class="buttuns">
                <div id="picker">选择文件</div>
                <div  id="btnupload"  class="webuploader-pick" />上传文件</div>
            </div>
    
    </form>
    <script>
        var uploader = CKWebUploader({
            type: 'file',
            container: 'fileList',
            swf: "/webuploader/Uploader.swf",
            server: "uploader.ashx",
            pick: { id: "#picker", multiple: true },
            chunked: true,
            formData: { path: "<%=Request["path"] %>" },
            uploadSuccess: function (file, response) {
                if (file.size < uploader.options.chunkSize)
                {
                    parent.refresh();
                    return false;
                }

                if (uploader.options.chunked) {
                    $.post(uploader.options.mergeServer, { guid: uploader.options.formData.guid, fileExt: response.f_ext, formData: uploader.options.formData.mid, clientName: response.clientName,path:response.path },
                    function (data) {
                        data = $.parseJSON(data);
                        if (data.hasError) {
                            alert('上传文件成功，但合并文件失败！');
                        }
                        else
                            parent.refresh();
                    });
                }
            }

        });
        //文件上传
        $("#btnupload").click(function () {
            CKWebUploader.Upload(uploader);
        });
        //清除队列
        $("#btnclear").click(function () {
            CKWebUploader.Clear(uploader);
        });
 

    </script>

<%--			<table id="Table1" style="width: 100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td style="PADDING: 5px; BORDER: solid 1px #6687BA; width: 100%; background-color: #c8ddf4;">允许上传的文件类型：<br />
						<asp:literal id="lUploadTypes" runat="server"></asp:literal></td>
				</tr>
				<tr>
					<td style="PADDING: 3px">上传文件列表：</td>
				</tr>
				<tr>
					<td>
						<div id="files" style="BORDER: gray 1px dashed; PADDING: 5px; WIDTH: 100%; HEIGHT: 50px; background-color: #c8ddf4;"><input contenteditable="false" style="WIDTH: 100%" onpropertychange="addUploadBox();" type="file" class="file"
								name="m_file" /><br />
						</div>
					</td>
				</tr>
				<tr>
					<td style="PADDING-RIGHT: 3px; PADDING-LEFT: 3px; PADDING-BOTTOM: 3px; PADDING-TOP: 3px" align="right">
					    <table><tr><td>
					        <asp:RadioButtonList ID="rblOption" runat="server" RepeatLayout="Flow">
                                <asp:ListItem value="AllowNewFileName">允许更改上传文件名称以避免产生覆盖</asp:ListItem>
                                <asp:ListItem Value="AutoBack" Selected="True">覆盖重名文件，先备份原文件</asp:ListItem>
                                <asp:ListItem Value="Overwrite">覆盖重名文件，不备份原文件（慎用此选项）</asp:ListItem>
                            </asp:RadioButtonList>
                        </td><td>
                            <asp:button id="btn_upload" Text="开始上传" Runat="server" onclick="btn_upload_Click" onload="btn_upload_Load" CssClass="Button"></asp:button>
                        </td></tr></table>
					</td>
				</tr>
				<tr>
					<td>
						<hr />
					</td>
				</tr>
				<tr>
					<td><asp:literal id="lResultsMessage" Runat="server"></asp:literal></td>
				</tr>
			</table>
		</form>--%>
	</body>
</html>
