using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thinksea.WebsiteTools
{
    public partial class FolderBrowser : System.Web.UI.Page
    {
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

    }

}
