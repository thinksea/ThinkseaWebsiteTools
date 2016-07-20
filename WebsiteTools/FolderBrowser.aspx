<%@ Page Language="C#" Inherits="Thinksea.WebsiteTools.FolderBrowser" CodeFile="FolderBrowser.aspx.cs" %>
<%@ Assembly Src="Define.cs" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>无标题页</title>
    <script language="javascript" type="text/javascript">
    //选中目录
    function selectedNode(n)
    {
        window.frameElement.Close(n);
    }

    </script>
</head>
<body>
    <form id="form1" runat="server">
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
    </form>
</body>
</html>
