<%@ Page Language="C#" Inherits="Thinksea.WebsiteTools.ExecuteSQL" CodeFile="ExecuteSQL.aspx.cs" ValidateRequest="false" %>
<%@ Assembly Src="Define.cs" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>MS SQL Server 代码执行工具</title>
	<meta http-equiv="expires" content="0" />
    <link href="css/css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .lab
    {
        white-space: nowrap;
    }
    </style>
    <script language="javascript" type="text/javascript" src="aspnet_client/MessageBox/MessageBox.js"></script>
	<script language="javascript" type="text/javascript">
<!--
function checkedInput()
{
	var re = /^\s*$/;
    var ddlDataBaseType = document.getElementById("ddlDataBaseType");
    switch (ddlDataBaseType.value)
    {
        case "MSSQLServer":
            var tbDataSource = document.getElementById("tbDataSource");
            var tbDatabase = document.getElementById("tbDatabase");
            var tbUser = document.getElementById("tbUser");
            var tbPassword = document.getElementById("tbPassword");
	        if( re.test(tbDataSource.value) )
	        {
	            MessageBox('必须输入数据源。', null, 'OK', 'Error', null, function(){
		            tbDataSource.focus();
		            tbDataSource.select();
	                }, null, -1);
	            return false;
	        }
	        if( re.test(tbDatabase.value) )
	        {
	            MessageBox('必须输入数据库名称。', null, 'OK', 'Error', null, function(){
		            tbDatabase.focus();
		            tbDatabase.select();
	                }, null, -1);
	            return false;
	        }
	        if( re.test(tbUser.value) )
	        {
	            MessageBox('必须输入登陆用户名。', null, 'OK', 'Error', null, function(){
		            tbUser.focus();
		            tbUser.select();
	                }, null, -1);
	            return false;
	        }
	        if( re.test(tbPassword.value) )
	        {
	            MessageBox('必须输入登陆密码。', null, 'OK', 'Error', null, function(){
		            tbPassword.focus();
		            tbPassword.select();
	                }, null, -1);
	            return false;
	        }
            break;
    }

	var editSQLText = document.getElementById("editSQLText");
	if( re.test(editSQLText.value) )
	{
	    MessageBox('您没有输入“MS SQL 操作指令”', null, 'OK', 'Error', null, function(){
		    editSQLText.focus();
		    editSQLText.select();
	        }, null, -1);
		return false;
	}
	var v = window.confirm('确定操作前请再次检查并核实 MS SQL 操作指令正确无误，您确定要执行上面的 SQL 操作指令吗？');
	if(!v)
	{
	    return false;
	}
	return true;
}

function magnifier(cid)
{
	var mssql=document.getElementById("mssql");
	var sqlresult=document.getElementById("sqlresult");
	switch(cid)
	{
		case "mssql":
			mssql.style.height="100%";
			sqlresult.style.height="30px";
			break;
		case "sqlresult":
			mssql.style.height="30px";
			sqlresult.style.height="100%";
			break;
	}
}

//处理窗体尺寸更改事件。
function onwindowresize() {
    var sqlresult = document.getElementById("sqlresult");
    var panelSQLResult = document.getElementById("panelSQLResult");
    panelSQLResult.style.width = "0px";
    panelSQLResult.style.width = (sqlresult.clientWidth || sqlresult.clientWidth) - 2;
}

function onPageLoad()
{
    onwindowresize();
    AddWindowOnResize(onwindowresize);
}

//插入 SQL 指令。
function ddlSQLCommandsSelected(sel)
{
    var re = /^\s*$/;
    if (!re.test(sel.value))
    {
        var editSQLText = document.getElementById("editSQLText");
        editSQLText.focus();
        document.execCommand("paste", null, "\r\n" + sel.value + "\r\n");
    }
    sel.value = "";
}

//选择字体大小。
function ddlSetFont(sel)
{
    var re = /^\s*$/;
    if (!re.test(sel.value))
    {
        var editSQLText = document.getElementById("editSQLText");
        editSQLText.style.fontSize = sel.value;
    }
    sel.value = "";
}
//-->
    </script>
</head>
<body style="overflow: auto;" onload="onPageLoad();">
    <form id="form1" runat="server">
        <table id="Table1" style="width: 100%; height: 100%;" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <div>
                        <asp:DropDownList ID="ddlConnections" runat="server" AutoPostBack="True" 
                            onselectedindexchanged="ddlConnections_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                    <table id="Table3" border="0" cellpadding="0" cellspacing="0" height="20">
                        <tr>
                            <td><asp:DropDownList ID="ddlDataBaseType" runat="server">
                                <asp:ListItem Value="MSSQLServer">MS SQL Server</asp:ListItem>
                                <asp:ListItem Value="Access">Access</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="lab">数据源：</td>
                            <td>
                                <asp:TextBox ID="tbDataSource" runat="server" Width="100px"></asp:TextBox>
                            </td>
                            <td class="lab">数据库名称：</td>
                            <td>
                                <asp:TextBox ID="tbDatabase" runat="server" Width="100px"></asp:TextBox>
                            </td>
                            <td class="lab">登陆用户名：</td>
                            <td>
                                <asp:TextBox ID="tbUser" runat="server" Width="100px"></asp:TextBox>
                            </td>
                            <td class="lab">登陆密码：</td>
                            <td>
                                <asp:TextBox ID="tbPassword" runat="server" Width="100px"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td style="white-space: nowrap">
                                MS SQL 操作指令：</td>
                            <td>
                                <img alt="" src="images/magnifier.gif" style="cursor: hand" title="点击放大窗格" onclick="magnifier('mssql');" /></td>
                            <td>
                                <select onchange="ddlSQLCommandsSelected(this)">
                                    <option value="">---------[插入 SQL 指令模板]------------</option>
                                    <option value="select * from [数据表]">select * from [数据表]</option>
                                    <option value="insert into [数据表] ([字段1], [字段2]) values ('值 1', '值 2')">insert into [数据表] ([字段1], [字段2]) values ('值 1', '值 2')</option>
                                    <option value="update [数据表] set [字段1]='值 1', [字段2]='值 2'">update [数据表] set [字段1]='值 1', [字段2]='值 2'</option>
                                    <option value="delete from [数据表]">delete from [数据表]</option>
                                    <option value="">-------------------------------------------</option>
                                    <option value="select case when b.[colorder]=1 then cast(a.[id] as varchar) else '' end as [表 ID], 
	case when b.[colorder]=1 then a.[name] else '' end as [表名], 
	b.[colorder] as [字段排序], 
	b.[name] as [字段名], d.[name] as [数据类型], b.[length] as [长度], case when b.[isnullable]=1 then '是' else ''end as [是否允许为 null],
	isnull(c.[name],'') as [约束名] 
from 
(
	select * from sysobjects where [xtype]='U' and [parent_obj]=0
) a
left join syscolumns b on a.[id]=b.[id]
left join sysobjects c on b.[cdefault]=c.[id] and a.[id]=c.[parent_obj] and c.[xtype]='D'
left join systypes d on b.xusertype=d.xusertype
">列出所有表的架构</option>
                                    <option value="select [id], [name]
from sysobjects where [xtype]='U' and [parent_obj] = 0
">列出所有表的名称</option>
                                    <option value="select case when b.[colorder]=1 then cast(a.[id] as varchar) else '' end as [表 ID], 
	case when b.[colorder]=1 then a.[name] else '' end as [表名], 
	b.[colorder] as [字段排序], 
	b.[name] as [字段名], d.[name] as [数据类型], b.[length] as [长度], case when b.[isnullable]=1 then '是' else ''end as [是否允许为 null],
	isnull(c.[name],'') as [约束名] 
from 
(
	select * from sysobjects where [xtype]='U' and [parent_obj]=0 and [name]='数据表'
) a
left join syscolumns b on a.[id]=b.[id]
left join sysobjects c on b.[cdefault]=c.[id] and a.[id]=c.[parent_obj] and c.[xtype]='D'
left join systypes d on b.xusertype=d.xusertype
">查询指定表的架构</option>
                                    <option value="create table [数据表]
(
    [字段1] 数据类型(长度)
        not null
        default('默认值'),
    [字段2] 数据类型
        not null
        default(默认值)
)">创建表</option>
                                    <option value="drop table [数据表]">删除表</option>
                                    <option value="alter table [数据表]
    add [字段] 数据类型(长度) not null default('默认值')
go
alter table [数据表]
    add [字段] 数据类型 not null default(默认值)">添加字段</option>
                                    <option value="alter table [数据表]
    alter column [字段] 数据类型(长度) not null
go
alter table [数据表]
    alter column [字段] 数据类型 not null">修改字段</option>
                                    <option value="alter table [数据表]
    drop column [字段]">删除字段</option>
                                    <option value="alter table [数据表]
add constraint [约束] default('默认值') for [字段]">创建唯一约束</option>
                                    <option value="alter table [数据表]
    drop [约束]">删除约束</option>
                                    <option value="">-------------------------------------------</option>
                                    <option value="exec sp_helpdb [数据库]">查询数据库状态</option>
                                    <option value="backup log [数据库] with no_log">截断事务日志</option>
                                    <option value="DBCC SHRINKDATABASE([数据库])">收缩数据库</option>
                                    <option value="BACKUP DATABASE [数据库] TO DISK='备份文件名（包含路径）'">备份数据库</option>
                                </select>
                                <select onchange="ddlSetFont(this)">
                                    <option value="">[放大文字大小]</option>
                                    <option value="10px">10 px</option>
                                    <option value="11px">11 px</option>
                                    <option value="12px">12 px</option>
                                    <option value="13px">13 px</option>
                                    <option value="14px">14 px</option>
                                    <option value="16px">16 px</option>
                                    <option value="18px">18 px</option>
                                    <option value="20px">20 px</option>
                                    <option value="22px">22 px</option>
                                    <option value="24px">24 px</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td id="mssql" style="padding-right: 1px; padding-left: 1px; padding-bottom: 1px;
                    padding-top: 1px; height: 50%">
                    <asp:TextBox ID="editSQLText" runat="server" Height="100%" TextMode="MultiLine"
                        Width="100%" style="font-family: 微软雅黑;"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td style="white-space: nowrap">
                                执行结果：</td>
                            <td>
                                <img alt="" src="images/magnifier.gif" style="cursor: hand" title="点击放大窗格" onclick="magnifier('sqlresult');" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td id="sqlresult" style="padding-right: 1px; padding-left: 1px; padding-bottom: 1px;
                    padding-top: 1px; height: 50%">
                    <asp:Panel ID="panelSQLResult" runat="server" Style="border-right: black 1px solid;
                        padding-right: 3px; border-top: black 1px solid; padding-left: 3px; padding-bottom: 3px;
                        overflow: auto; border-left: black 1px solid; padding-top: 3px;
                        border-bottom: black 1px solid; width: 100%; height: 100%">
                    </asp:Panel>
                </td>
            </tr>
            <tr>
                <td>
                    <span style="color: Red">警告：</span>此工具主要用于维护数据库。由于此工具直接在服务器端执行 MS SQL 数据库操作指令，如果使用不当将会造成数据丢失甚至数据库损毁的严重后果，所以请您谨慎使用此工具，并且一定在使用此工具前对数据库进行备份。在使用此工具过程中，因操作不当造成损失后果自负。</td>
            </tr>
            <tr>
                <td style="text-align: center">
                    <asp:Button ID="btnAccept" runat="server" Text="开始执行 SQL 代码" OnClick="btnAccept_Click" OnClientClick="if(!checkedInput()){return false;}" /></td>
            </tr>
        </table>
    </form>
</body>
</html>
