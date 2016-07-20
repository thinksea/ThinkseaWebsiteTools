<%@ Page Language="C#" %>
<%@ Assembly Src="Define.cs" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head runat="server">
		<title>�ϴ��ļ�</title>
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
                <div id="picker">ѡ���ļ�</div>
                <div  id="btnupload"  class="webuploader-pick" />�ϴ��ļ�</div>
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
                            alert('�ϴ��ļ��ɹ������ϲ��ļ�ʧ�ܣ�');
                        }
                        else
                            parent.refresh();
                    });
                }
            }

        });
        //�ļ��ϴ�
        $("#btnupload").click(function () {
            CKWebUploader.Upload(uploader);
        });
        //�������
        $("#btnclear").click(function () {
            CKWebUploader.Clear(uploader);
        });
 

    </script>

<%--			<table id="Table1" style="width: 100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td style="PADDING: 5px; BORDER: solid 1px #6687BA; width: 100%; background-color: #c8ddf4;">�����ϴ����ļ����ͣ�<br />
						<asp:literal id="lUploadTypes" runat="server"></asp:literal></td>
				</tr>
				<tr>
					<td style="PADDING: 3px">�ϴ��ļ��б�</td>
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
                                <asp:ListItem value="AllowNewFileName">��������ϴ��ļ������Ա����������</asp:ListItem>
                                <asp:ListItem Value="AutoBack" Selected="True">���������ļ����ȱ���ԭ�ļ�</asp:ListItem>
                                <asp:ListItem Value="Overwrite">���������ļ���������ԭ�ļ������ô�ѡ�</asp:ListItem>
                            </asp:RadioButtonList>
                        </td><td>
                            <asp:button id="btn_upload" Text="��ʼ�ϴ�" Runat="server" onclick="btn_upload_Click" onload="btn_upload_Load" CssClass="Button"></asp:button>
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
