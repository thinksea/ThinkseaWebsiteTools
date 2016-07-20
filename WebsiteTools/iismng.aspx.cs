using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Security.Principal;
using System.Runtime.InteropServices;

namespace Thinksea.WebsiteTools
{
    /// <summary>
    /// pwd ��ժҪ˵����
    /// </summary>
    public partial class iismng : System.Web.UI.Page
    {

        protected void Page_Load(object sender, System.EventArgs e)
        {
            // �ڴ˴������û������Գ�ʼ��ҳ��
            if (!this.IsPostBack)
            {
                Thinksea.WebsiteTools.Define.CheckLogin();
            }
            this.RefreshIISState();

        }

        #region ASP.NET ģ�⡣
        public const int LOGON32_LOGON_INTERACTIVE = 2;
        public const int LOGON32_PROVIDER_DEFAULT = 0;

        WindowsImpersonationContext impersonationContext;

        [DllImport("advapi32.dll")]
        public static extern int LogonUserA(String lpszUserName,
            String lpszDomain,
            String lpszPassword,
            int dwLogonType,
            int dwLogonProvider,
            ref IntPtr phToken);
        [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern int DuplicateToken(IntPtr hToken,
            int impersonationLevel,
            ref IntPtr hNewToken);

        [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern bool RevertToSelf();

        [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
        public static extern bool CloseHandle(IntPtr handle);

        private bool impersonateValidUser(String userName, String password, String domain)
        {
            WindowsIdentity tempWindowsIdentity;
            IntPtr token = IntPtr.Zero;
            IntPtr tokenDuplicate = IntPtr.Zero;

            if (RevertToSelf())
            {
                if (LogonUserA(userName, domain, password, LOGON32_LOGON_INTERACTIVE,
                    LOGON32_PROVIDER_DEFAULT, ref token) != 0)
                {
                    if (DuplicateToken(token, 2, ref tokenDuplicate) != 0)
                    {
                        tempWindowsIdentity = new WindowsIdentity(tokenDuplicate);
                        impersonationContext = tempWindowsIdentity.Impersonate();
                        if (impersonationContext != null)
                        {
                            CloseHandle(token);
                            CloseHandle(tokenDuplicate);
                            return true;
                        }
                    }
                }
            }
            if (token != IntPtr.Zero)
                CloseHandle(token);
            if (tokenDuplicate != IntPtr.Zero)
                CloseHandle(tokenDuplicate);
            return false;
        }

        private void undoImpersonation()
        {
            impersonationContext.Undo();
        }
        #endregion

        protected void RefreshIISState()
        {
            string strStatus = "״̬δ֪";
            //if (impersonateValidUser("username", "password", "domain"))
            if (impersonateValidUser(this.editUserName.Text, this.editNewPassword.Text, "."))
            {
                //Insert your code that runs under the security context of a specific user here.
                System.ServiceProcess.ServiceControllerStatus iisStatus;
                try
                {
                    System.ServiceProcess.ServiceController sc = new System.ServiceProcess.ServiceController("iisadmin");
                    iisStatus = sc.Status;
                }
                finally
                {
                    undoImpersonation();
                }

                switch (iisStatus)
                {
                    case System.ServiceProcess.ServiceControllerStatus.ContinuePending:
                        strStatus = "���񼴽�����";
                        break;
                    case System.ServiceProcess.ServiceControllerStatus.Paused:
                        strStatus = "<span style='color:orange;'>��������ͣ</span>";
                        break;
                    case System.ServiceProcess.ServiceControllerStatus.PausePending:
                        strStatus = "���񼴽���ͣ";
                        break;
                    case System.ServiceProcess.ServiceControllerStatus.Running:
                        strStatus = "<span style='color:#00ff00;'>������������</span>";
                        break;
                    case System.ServiceProcess.ServiceControllerStatus.StartPending:
                        strStatus = "������������";
                        break;
                    case System.ServiceProcess.ServiceControllerStatus.Stopped:
                        strStatus = "<span style='color:red;'>����δ����</span>";
                        break;
                    case System.ServiceProcess.ServiceControllerStatus.StopPending:
                        strStatus = "��������ֹͣ";
                        break;
                }

            }
            else
            {
                strStatus = "δ�ܻ�ȡ IIS ״̬";
            }
            this.lblIISState.Text = strStatus;

        }

        protected void btnRestartIIS_Click(object sender, EventArgs e)
        {
            //if (impersonateValidUser("username", "password", "domain"))
            if (impersonateValidUser(this.editUserName.Text, this.editNewPassword.Text, "."))
            {
                //Insert your code that runs under the security context of a specific user here.
                try
                {
                    System.ServiceProcess.ServiceController sc = new System.ServiceProcess.ServiceController("w3svc");
                    if (sc.Status != System.ServiceProcess.ServiceControllerStatus.Stopped)
                    {
                        sc.Stop();//ֹͣ
                        sc.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Stopped);
                    }
                    if (sc.Status != System.ServiceProcess.ServiceControllerStatus.Running)
                    {
                        sc.Start();//����
                        sc.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Running);
                        this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.setTimeout(function(){
var pb = window.parent.MessageBox('���� IIS ��ɣ�'
	, '��Ϣ'
	, 'OK'
	, 'Information'
);
}, 0);", true);
                    }
                }
                finally
                {
                    undoImpersonation();
                }
                this.RefreshIISState();

            }
            else
            {
                //Your impersonation failed. Therefore, include a fail-safe mechanism here.
                this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.setTimeout(function(){
var pb = window.parent.MessageBox('���� IIS ʧ�ܣ�'
	, '��Ϣ'
	, 'OK'
	, 'Error'
);
}, 0);", true);

            }

            //System.Security.SecureString pass = new System.Security.SecureString();
            //foreach (char ch in this.editNewPassword.Text)
            //{
            //    pass.AppendChar(ch);
            //}
            //System.Diagnostics.ProcessStartInfo psi = new System.Diagnostics.ProcessStartInfo(this.MapPath("iismgr.exe"));
            //psi.UseShellExecute = false;
            //psi.WorkingDirectory = this.MapPath(".");
            ////psi.LoadUserProfile = true;
            ////psi.Domain = ".";
            //psi.UserName = this.editUserName.Text;
            //psi.Password = pass;
            //System.Diagnostics.Process.Start(psi);

        }

        protected void btnStartIIS_Click(object sender, EventArgs e)
        {
            //if (impersonateValidUser("username", "password", "domain"))
            if (impersonateValidUser(this.editUserName.Text, this.editNewPassword.Text, "."))
            {
                //Insert your code that runs under the security context of a specific user here.
                try
                {
                    System.ServiceProcess.ServiceController sc = new System.ServiceProcess.ServiceController("w3svc");
                    if (sc.Status != System.ServiceProcess.ServiceControllerStatus.Running)
                    {
                        sc.Start();//����
                        sc.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Running);
                        this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.setTimeout(function(){
var pb = window.parent.MessageBox('���� IIS ��ɣ�'
	, '��Ϣ'
	, 'OK'
	, 'Information'
);
}, 0);", true);

                    }
                }
                finally
                {
                    undoImpersonation();
                }
                this.RefreshIISState();
            }
            else
            {
                //Your impersonation failed. Therefore, include a fail-safe mechanism here.
                this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.setTimeout(function(){
var pb = window.parent.MessageBox('���� IIS ʧ�ܣ�'
	, '��Ϣ'
	, 'OK'
	, 'Error'
);
}, 0);", true);

            }

        }

        protected void btnStopIIS_Click(object sender, EventArgs e)
        {
            //if (impersonateValidUser("username", "password", "domain"))
            if (impersonateValidUser(this.editUserName.Text, this.editNewPassword.Text, "."))
            {
                //Insert your code that runs under the security context of a specific user here.
                try
                {
                    System.ServiceProcess.ServiceController sc = new System.ServiceProcess.ServiceController("iisadmin");
                    if (sc.Status != System.ServiceProcess.ServiceControllerStatus.Stopped)
                    {
                        sc.Stop();//ֹͣ
                        sc.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Stopped);
                        this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.setTimeout(function(){
var pb = window.parent.MessageBox('ֹͣ IIS ��ɣ�'
	, '��Ϣ'
	, 'OK'
	, 'Information'
);
}, 0);", true);
                    }
                }
                finally
                {
                    undoImpersonation();
                }
                this.RefreshIISState();
            }
            else
            {
                //Your impersonation failed. Therefore, include a fail-safe mechanism here.
                this.ClientScript.RegisterStartupScript(this.GetType(), "", @"window.setTimeout(function(){
var pb = window.parent.MessageBox('ֹͣ IIS ʧ�ܣ�'
	, '��Ϣ'
	, 'OK'
	, 'Error'
);
}, 0);", true);

            }

        }

        protected void btnRefreshIISState_Click(object sender, EventArgs e)
        {
            this.RefreshIISState();

        }
}

}
