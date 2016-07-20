using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Thinksea.WebsiteTools
{
    public partial class UpdateFileFromInternet : System.Web.UI.Page, System.Web.UI.ICallbackEventHandler
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack && !this.IsCallback)
            {
                Thinksea.WebsiteTools.Define.CheckLogin();

            }

        }


        #region ICallbackEventHandler Members
        private string CallbackResult = null;
        public string GetCallbackResult()
        {
            return this.CallbackResult;

        }

        public void RaiseCallbackEvent(string eventArgument)
        {
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
            doc.LoadXml(eventArgument);
            System.Xml.XmlElement root = doc.DocumentElement;
            string Command = root.SelectSingleNode("Command").InnerText.ToLower();
            switch (Command)
            {
                case "download":
                    string URL = root.SelectSingleNode("URL").InnerText;
                    string SaveFileName = root.SelectSingleNode("SaveFileName").InnerText;
                    string File = this.MapPath(System.IO.Path.Combine(this.Request["path"], SaveFileName));
                    System.Net.WebClient wc = new System.Net.WebClient();
                    wc.DownloadFile(new System.Uri(URL), File);
                    this.CallbackResult = "{\"ErrorCode\":0, \"Message\":\"保存完成。\"}";
                    break;
            }
        }

        #endregion
    }

}
