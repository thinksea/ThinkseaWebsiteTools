using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Thinksea.WebsiteTools
{
    public partial class ExecuteSQL : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                Thinksea.WebsiteTools.Define.CheckLogin();

                this.RebindDatabaseSettingFromWebconfig();
            }

        }

        /// <summary>
        /// 从 Web.Config 配置文件提取并绑定数据库连接设置。
        /// </summary>
        protected void RebindDatabaseSettingFromWebconfig()
        {
            this.ddlConnections.Items.Clear();
            this.ddlConnections.Items.Add(new ListItem("[选择现有的可用的数据库连接]", ""));
            //ConnectionStringSettings sqlCon = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["SQLDataBaseConnectionString"];
            ConnectionStringSettingsCollection cons = System.Web.Configuration.WebConfigurationManager.ConnectionStrings;
            if (cons.Count == 0)
            {
                return;
            }
            foreach (ConnectionStringSettings tmp in cons)
            {
                string sqlDataBaseConnectionString = tmp.ConnectionString;
                if (sqlDataBaseConnectionString != null && sqlDataBaseConnectionString != "")
                {
                    System.Text.RegularExpressions.RegexOptions regOpts = System.Text.RegularExpressions.RegexOptions.IgnoreCase | System.Text.RegularExpressions.RegexOptions.Singleline | System.Text.RegularExpressions.RegexOptions.ExplicitCapture;

                    System.Text.RegularExpressions.Match mDataSource = System.Text.RegularExpressions.Regex.Match(sqlDataBaseConnectionString, @"Data\s+Source\s*=\s*(?:""(?<DataSource>[^""]+)""|(?<DataSource>[^;]+))", regOpts);
                    if (mDataSource.Success)
                    {
                        System.Text.RegularExpressions.Match mDataBase = System.Text.RegularExpressions.Regex.Match(sqlDataBaseConnectionString, @"Initial\s+Catalog\s*=\s*(?:""(?<DataBase>[^""]+)""|(?<DataBase>[^;]+))", regOpts);
                        System.Text.RegularExpressions.Match mUserName = System.Text.RegularExpressions.Regex.Match(sqlDataBaseConnectionString, @"User\s+ID\s*=\s*(?:""(?<UserName>[^""]+)""|(?<UserName>[^;]+))", regOpts);
                        System.Text.RegularExpressions.Match mPassword = System.Text.RegularExpressions.Regex.Match(sqlDataBaseConnectionString, @"Password\s*=\s*(?:""(?<Password>[^""]+)""|(?<Password>[^;]+))", regOpts);

                        this.ddlConnections.Items.Add(new ListItem(
                            string.Format("{0} [{1}]"
                            , mDataSource.Groups["DataSource"].Value
                            , mDataBase.Groups["DataBase"].Value
                            )
                            , string.Format(@"Type=""MSSQLServer"";DataSource=""{0}"";DataBase=""{1}"";UserName=""{2}"";Password=""{3}"""
                            , mDataSource.Groups["DataSource"].Value
                            , mDataBase.Groups["DataBase"].Value
                            , mUserName.Groups["UserName"].Value
                            , mPassword.Groups["Password"].Value
                            )
                            ));
                    }
                }
            }

        }

        protected void ddlConnections_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.ddlConnections.SelectedValue))
            {
                string sv = this.ddlConnections.SelectedValue;
                System.Text.RegularExpressions.RegexOptions regOpts = System.Text.RegularExpressions.RegexOptions.IgnoreCase | System.Text.RegularExpressions.RegexOptions.Singleline | System.Text.RegularExpressions.RegexOptions.ExplicitCapture;
                System.Text.RegularExpressions.Match mType = System.Text.RegularExpressions.Regex.Match(sv, @"Type\s*=\s*""(?<Type>[^""]+)""", regOpts);
                System.Text.RegularExpressions.Match mDataSource = System.Text.RegularExpressions.Regex.Match(sv, @"DataSource\s*=\s*""(?<DataSource>[^""]+)""", regOpts);
                System.Text.RegularExpressions.Match mDataBase = System.Text.RegularExpressions.Regex.Match(sv, @"DataBase\s*=\s*""(?<DataBase>[^""]+)""", regOpts);
                System.Text.RegularExpressions.Match mUserName = System.Text.RegularExpressions.Regex.Match(sv, @"UserName\s*=\s*""(?<UserName>[^""]+)""", regOpts);
                System.Text.RegularExpressions.Match mPassword = System.Text.RegularExpressions.Regex.Match(sv, @"Password\s*=\s*""(?<Password>[^""]+)""", regOpts);

                this.ddlDataBaseType.SelectedValue = mType.Groups["Type"].Value;
                this.tbDataSource.Text = mDataSource.Groups["DataSource"].Value;
                this.tbDatabase.Text = mDataBase.Groups["DataBase"].Value;
                this.tbUser.Text = mUserName.Groups["UserName"].Value;
                this.tbPassword.Text = mPassword.Groups["Password"].Value;
                this.ddlConnections.SelectedIndex = -1;
            }
        }

        /// <summary>
        /// 创建数据库连接。
        /// </summary>
        /// <returns></returns>
        System.Data.SqlClient.SqlConnection CreateConnection()
        {
            switch (this.ddlDataBaseType.SelectedValue)
            {
                case "MSSQLServer":
                    if (string.IsNullOrEmpty(this.tbDataSource.Text))
                    {
                        System.Web.UI.WebControls.Literal li = new System.Web.UI.WebControls.Literal();
                        li.Text = "必须输入数据源。<br /><br />";
                        panelSQLResult.Controls.Add(li);
                        return null;
                    }
                    if (string.IsNullOrEmpty(this.tbDatabase.Text))
                    {
                        System.Web.UI.WebControls.Literal li = new System.Web.UI.WebControls.Literal();
                        li.Text = "必须输入数据库名称。<br /><br />";
                        panelSQLResult.Controls.Add(li);
                        return null;
                    }
                    if (string.IsNullOrEmpty(this.tbUser.Text))
                    {
                        System.Web.UI.WebControls.Literal li = new System.Web.UI.WebControls.Literal();
                        li.Text = "必须输入登陆用户名。<br /><br />";
                        panelSQLResult.Controls.Add(li);
                        return null;
                    }
                    if (string.IsNullOrEmpty(this.tbPassword.Text))
                    {
                        System.Web.UI.WebControls.Literal li = new System.Web.UI.WebControls.Literal();
                        li.Text = "必须输入登陆密码。<br /><br />";
                        panelSQLResult.Controls.Add(li);
                        return null;
                    }
                    break;
            }
            return new System.Data.SqlClient.SqlConnection(string.Format(@"Data Source={0}; Initial Catalog = {1}; User ID={2}; Password={3};"
                , this.tbDataSource.Text
                , this.tbDatabase.Text
                , this.tbUser.Text
                , this.tbPassword.Text
                ));
        }

        protected void btnAccept_Click(object sender, System.EventArgs e)
        {
            if (!this.IsValid) return;
            this.panelSQLResult.Controls.Clear();
            System.DateTime BeginTime = System.DateTime.Now;//计时器起始时间。

            System.Data.SqlClient.SqlConnection Connection = this.CreateConnection();
            if (Connection == null)
            {
                return;
            }

            System.Data.SqlClient.SqlCommand sqlCommand = new System.Data.SqlClient.SqlCommand();
            sqlCommand.Connection = Connection;
            System.Data.SqlClient.SqlDataReader sdr = null;

            Connection.Open();
            try
            {
                System.Collections.Generic.List<string> al = new System.Collections.Generic.List<string>();
                System.Text.RegularExpressions.Regex reg = new System.Text.RegularExpressions.Regex(@"^(\s*)go(\s*)$", System.Text.RegularExpressions.RegexOptions.IgnoreCase | System.Text.RegularExpressions.RegexOptions.Multiline | System.Text.RegularExpressions.RegexOptions.Compiled | System.Text.RegularExpressions.RegexOptions.ExplicitCapture);
                al.AddRange(reg.Split(this.editSQLText.Text));
                foreach (string tmp in al)
                {
                    sqlCommand.CommandText = tmp.Trim();
                    if (sqlCommand.CommandText.Length > 0)
                    {
                        sdr = sqlCommand.ExecuteReader();
                        try
                        {
                            do
                            {
                                System.Web.UI.WebControls.Table table = new System.Web.UI.WebControls.Table();
                                table.Attributes["border"] = "1";
                                table.CellPadding = 3;
                                table.CellSpacing = 0;
                                #region 生成表格标题。
                                System.Web.UI.WebControls.TableRow titleRow = new System.Web.UI.WebControls.TableRow();
                                table.Rows.Add(titleRow);
                                if (sdr.FieldCount > 0)
                                {
                                    for (int i = 0; i < sdr.FieldCount; i++)
                                    {
                                        System.Web.UI.WebControls.TableCell tableCell = new System.Web.UI.WebControls.TableCell();
                                        tableCell.Font.Bold = true;
                                        tableCell.Style["text-align"] = "center";
                                        tableCell.Style["white-space"] = "nowrap";
                                        tableCell.Text = this.Server.HtmlEncode(sdr.GetName(i));
                                        titleRow.Cells.Add(tableCell);
                                    }
                                }
                                #endregion

                                #region 生成表格数据集合。
                                while (sdr.Read())
                                {
                                    System.Web.UI.WebControls.TableRow tableRow = new System.Web.UI.WebControls.TableRow();
                                    table.Rows.Add(tableRow);
                                    for (int i = 0; i < sdr.FieldCount; i++)
                                    {
                                        System.Web.UI.WebControls.TableCell tableCell = new System.Web.UI.WebControls.TableCell();
                                        tableCell.Text = this.Server.HtmlEncode(sdr[i].ToString());
                                        tableRow.Cells.Add(tableCell);
                                    }
                                }
                                #endregion

                                if (sdr.FieldCount > 0)
                                {
                                    panelSQLResult.Controls.Add(table);
                                    #region 插入水平分割线。
                                    System.Web.UI.WebControls.Literal li = new System.Web.UI.WebControls.Literal();
                                    li.Text = "<br /><hr color='red' /><br />";
                                    panelSQLResult.Controls.Add(li);
                                    #endregion
                                }
                            } while (sdr.NextResult());
                        }
                        finally
                        {
                            sdr.Close();
                        }
                    }
                }

            }
            catch (System.Exception ex)
            {
                System.Web.UI.WebControls.Literal li = new System.Web.UI.WebControls.Literal();
                li.Text = string.Format("执行 SQL 代码时出现错误，具体信息如下：{0}<br /><br />", this.Server.HtmlEncode(ex.Message));
                panelSQLResult.Controls.Add(li);
                return;
            }
            finally
            {
                Connection.Close();
            }

            #region SQL 代码执行完成
            System.DateTime EndTime = System.DateTime.Now;//计时器结束时间。
            {
                System.Web.UI.WebControls.Literal li = new System.Web.UI.WebControls.Literal();
                li.Text = "SQL 代码执行完成。报文如下：<br /><br />" + "起始时间：" + BeginTime.ToLongTimeString() + "<br />完成时间：" + EndTime.ToLongTimeString() + "<br />花费时长：" + (EndTime - BeginTime).ToString() + "<br /><br />";
                panelSQLResult.Controls.Add(li);
            }
            #endregion

        }
    }
}
