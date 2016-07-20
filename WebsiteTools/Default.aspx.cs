using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thinksea.WebsiteTools
{
    public partial class WebsiteTools : System.Web.UI.Page, System.Web.UI.ICallbackEventHandler
    {
        /// <summary>
        /// 判断指定的文件或目录是否受保护的系统文件。
        /// </summary>
        /// <param name="File">文件或目录的完整名称。</param>
        /// <returns></returns>
        protected bool IsSystemFile(string File)
        {
            File = File.ToLower();
            if (System.IO.File.Exists(File))
            {
                if (this.Server.MapPath("/Web.config").ToLower() == File)
                {
                    return true;
                }
            }
            else
            {
                if (!File.EndsWith("\\"))
                {
                    File += "\\";
                }
                if ((File == System.Web.HttpRuntime.BinDirectory.ToLower() || File == this.Server.MapPath(".").ToLower() + "\\") && System.IO.Directory.GetFileSystemEntries(File).Length > 0)
                {
                    return true;
                }
            }
            return false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack && !this.IsCallback)
            {
                Thinksea.WebsiteTools.Define.CheckLogin();

                this.Rebind(this.TreeView1.Nodes[0].ChildNodes, "/");
            }

        }

        private void Rebind(System.Web.UI.WebControls.TreeNodeCollection tnc, string Path)
        {
            System.IO.DirectoryInfo di = new System.IO.DirectoryInfo(this.MapPath(Path));
            if (di.Exists)
            {
                System.IO.DirectoryInfo[] dis = di.GetDirectories();
                foreach (System.IO.DirectoryInfo tmp in dis)
                {
                    TreeNode tn = new TreeNode(tmp.Name);
                    tn.Value = tmp.FullName.Replace(this.MapPath("/"), @"/").Replace(@"\", @"/");
                    if (tmp.GetDirectories().Length > 0)
                    {
                        tn.SelectAction = TreeNodeSelectAction.SelectExpand;
                        tn.PopulateOnDemand = true;
                    }
                    tn.NavigateUrl = "javascript:selectedNode('" + tn.Value + "');";
                    tnc.Add(tn);
                }
            }
        }

        protected void TreeView1_TreeNodePopulate(object sender, TreeNodeEventArgs e)
        {
            if (e.Node.ChildNodes.Count == 0)
            {
                this.Rebind(e.Node.ChildNodes, e.Node.Value);
            }

        }

        #region ICallbackEventHandler 成员
        private string CallbackResult = null;
        public string GetCallbackResult()
        {
            return this.CallbackResult;

        }

        public void RaiseCallbackEvent(string eventArgument)
        {
            try
            {
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(eventArgument);
                System.Xml.XmlElement root = doc.DocumentElement;
                string Command = root.SelectSingleNode("Command").InnerText.ToLower();

                switch (Command)
                {
                    case "getfiles":
                        {
                            string Directory = root.SelectSingleNode("Directory").InnerText;
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            System.IO.DirectoryInfo di = new System.IO.DirectoryInfo(this.MapPath(Directory));
                            System.IO.DirectoryInfo[] dis = di.GetDirectories();
                            System.IO.FileInfo[] fis = di.GetFiles();
                            foreach (System.IO.DirectoryInfo tmp in dis)
                            {
                                if (sb.Length > 0)
                                {
                                    sb.Append(", ");
                                }
                                sb.AppendFormat("{{\"clientID\":\"{0}\", \"name\":\"{1}\", \"length\":\"{2}\", \"extension\":\"{3}\", \"lastWriteTime\":\"{4}\", \"isFile\":{5}, \"tag\":\"{6}\"}}"
                                    , ""
                                    , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(tmp.Name)
                                    , ""
                                    , "文件夹"
                                    , tmp.LastWriteTime.ToString()
                                    , "false"
                                    , ""
                                    );
                            }
                            foreach (System.IO.FileInfo fi in fis)
                            {
                                if (sb.Length > 0)
                                {
                                    sb.Append(", ");
                                }
                                sb.AppendFormat("{{\"clientID\":\"{0}\", \"name\":\"{1}\", \"length\":\"{2}\", \"extension\":\"{3}\", \"lastWriteTime\":\"{4}\", \"isFile\":{5}, \"tag\":\"{6}\"}}"
                                     , ""
                                     , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(fi.Name)
                                     , Thinksea.WebsiteTools.Define.ConvertToFileSize(fi.Length)
                                     , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(fi.Extension)
                                     , fi.LastWriteTime.ToString()
                                     , "true"
                                     , ""
                                     );
                            }
                            this.CallbackResult = "[" + sb.ToString() + "]";
                        }
                        break;
                    case "deletefile":
                        {
                            string Directory = root.SelectSingleNode("Directory").InnerText;
                            System.Xml.XmlNodeList Items = root.SelectNodes("Item");
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();
                            for (int i = 0; i < Items.Count; i++)
                            {
                                string File = this.MapPath(System.IO.Path.Combine(Directory, Items[i].InnerText));
                                if (this.IsSystemFile(File))
                                {
                                    throw new System.Exception("不能直接删除系统文件或非空的系统目录。\r\n\r\n您可以尝试通过下面的可选方法执行这类文件的删除操作：\r\n1、先清除其下的文件和子目录后再执行删除操作。\r\n2、将待删除目标改名后再执行删除操作");
                                }
                                else
                                {
                                    if (System.IO.File.Exists(File))
                                    {
                                        System.IO.File.Delete(File);
                                    }
                                    else
                                    {
                                        System.IO.Directory.Delete(File, true);
                                    }
                                    if (sb.Length > 0)
                                    {
                                        sb.Append(", ");
                                    }
                                    sb.Append("\"" + Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(Items[i].InnerText) + "\"");
                                }
                            }
                            this.CallbackResult = "[" + sb.ToString() + "]";
                        }
                        break;
                    case "movefile":
                        {
                            string OldDirectory = root.SelectSingleNode("OldDirectory").InnerText;
                            string NewDirectory = root.SelectSingleNode("NewDirectory").InnerText;
                            System.Xml.XmlNodeList Items = root.SelectNodes("Item");
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();

                            for (int i = 0; i < Items.Count; i++)
                            {
                                string sFile = this.MapPath(System.IO.Path.Combine(OldDirectory, Items[i].InnerText));
                                string tFile = this.MapPath(System.IO.Path.Combine(NewDirectory, Items[i].InnerText));
                                if (sFile != tFile)
                                {
                                    if (System.IO.File.Exists(sFile))
                                    {
                                        System.IO.File.Move(sFile, tFile);
                                    }
                                    else
                                    {
                                        System.IO.Directory.Move(sFile, tFile);
                                    }
                                }
                                if (sb.Length > 0)
                                {
                                    sb.Append(", ");
                                }
                                sb.Append("\"" + Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(Items[i].InnerText) + "\"");
                            }
                            this.CallbackResult = "[" + sb.ToString() + "]";
                        }
                        break;
                    case "renamefile":
                        {
                            string Directory = root.SelectSingleNode("Directory").InnerText;
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();

                            {
                                string sFile = this.MapPath(System.IO.Path.Combine(Directory, root.SelectSingleNode("OldName").InnerText));
                                string tFile = this.MapPath(System.IO.Path.Combine(Directory, root.SelectSingleNode("NewName").InnerText));
                                if (sFile != tFile)
                                {
                                    if (System.IO.File.Exists(sFile))
                                    {
                                        System.IO.File.Move(sFile, tFile);
                                        System.IO.FileInfo fi = new System.IO.FileInfo(tFile);
                                        sb.AppendFormat("{{\"clientID\":\"{0}\", \"name\":\"{1}\", \"length\":\"{2}\", \"extension\":\"{3}\", \"lastWriteTime\":\"{4}\", \"isFile\":{5}, \"tag\":\"{6}\"}}"
                                             , ""
                                             , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(fi.Name)
                                             , Thinksea.WebsiteTools.Define.ConvertToFileSize(fi.Length)
                                             , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(fi.Extension)
                                             , fi.LastWriteTime.ToString()
                                             , "true"
                                             , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(root.SelectSingleNode("OldName").InnerText)
                                             );
                                    }
                                    else
                                    {
                                        System.IO.Directory.Move(sFile, tFile);
                                        System.IO.DirectoryInfo di = new System.IO.DirectoryInfo(tFile);
                                        sb.AppendFormat("{{\"clientID\":\"{0}\", \"name\":\"{1}\", \"length\":\"{2}\", \"extension\":\"{3}\", \"lastWriteTime\":\"{4}\", \"isFile\":{5}, \"tag\":\"{6}\"}}"
                                             , ""
                                             , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(di.Name)
                                             , ""
                                             , "文件夹"
                                             , di.LastWriteTime.ToString()
                                             , "false"
                                             , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(root.SelectSingleNode("OldName").InnerText)
                                             );
                                    }
                                }
                            }
                            this.CallbackResult = "[" + sb.ToString() + "]";
                        }
                        break;
                    case "createdirectory":
                        {
                            string Directory = root.SelectSingleNode("Directory").InnerText;
                            string Name = root.SelectSingleNode("Name").InnerText;
                            System.Text.StringBuilder sb = new System.Text.StringBuilder();

                            {
                                string sDir = this.MapPath(System.IO.Path.Combine(Directory, Name));
                                if (!System.IO.Directory.Exists(sDir))
                                {
                                    System.IO.Directory.CreateDirectory(sDir);
                                }
                                else
                                {
                                    throw new System.Exception("创建目录失败，原因是已经存在同名目录。");
                                }
                                string[] ds = Name.Split(new char[] { '/', '\\' }, StringSplitOptions.RemoveEmptyEntries);
                                System.IO.DirectoryInfo di = new System.IO.DirectoryInfo(this.MapPath(System.IO.Path.Combine(Directory, ds[0])));
                                sb.AppendFormat("{{\"clientID\":\"{0}\", \"name\":\"{1}\", \"length\":\"{2}\", \"extension\":\"{3}\", \"lastWriteTime\":\"{4}\", \"isFile\":{5}, \"tag\":\"{6}\"}}"
                                     , ""
                                     , Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(di.Name)
                                     , ""
                                     , "文件夹"
                                     , di.LastWriteTime.ToString()
                                     , "false"
                                     , ""
                                     );
                            }
                            this.CallbackResult = "[" + sb.ToString() + "]";
                        }
                        break;
                }
            }
            catch(System.Exception ex)
            {
                this.CallbackResult = "{\"ErrorCode\":1, \"Message\":\"" + Thinksea.WebsiteTools.Define.ConvertToJavaScriptString(ex.Message) + "\"}";
                return;
            }

        }

        #endregion

        protected void btnQuit_Click(object sender, System.EventArgs e)
        {
            Thinksea.WebsiteTools.Define.SetLogout();
        }

    }

}
