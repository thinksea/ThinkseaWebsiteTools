<%@ WebHandler Language="C#" Class="uploader" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.IO;

public class uploader : IHttpHandler
{

    /// <summary>
    /// 文件上传目录。
    /// </summary>
    protected string CurrentFolder
    {
        get
        {
            return HttpContext.Current.Server.MapPath(ReqPath);
        }
    }
    private string ReqPath
    {
        get
        {
            return HttpContext.Current.Request["path"];
        }
    }
    private string TempPath
    {
        get
        {
            return "~/WebsiteTools/tmp/";
        }
    }
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        bool ischunk = false;
        foreach (string key in context.Request.Form.AllKeys)
        {
            if (key == "chunk")
            {
                ischunk = true;
                break;
            }
        }
        //如果进行了分片
        if (ischunk)
        {
            //取得chunk和chunks
            int chunk = Convert.ToInt32(context.Request.Form["chunk"]);//当前分片在上传分片中的顺序（从0开始）
            int chunks = Convert.ToInt32(context.Request.Form["chunks"]);//总分片数


            //根据GUID创建用该GUID命名的临时文件夹
            string folder = context.Server.MapPath(TempPath + context.Request["guid"] + "/");
            string path = folder + chunk;

            //建立临时传输文件夹
            //if (!Directory.Exists(Path.GetDirectoryName(folder)))
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }

            FileStream addFile = new FileStream(path, FileMode.Append, FileAccess.Write);
            //FileStream addFile = new FileStream(folder, FileMode.Append, FileAccess.Write);
            BinaryWriter AddWriter = new BinaryWriter(addFile);
            //获得上传的分片数据流
            HttpPostedFile file = context.Request.Files[0];

            Stream stream = file.InputStream;

            BinaryReader TempReader = new BinaryReader(stream);
            //将上传的分片追加到临时文件末尾
            AddWriter.Write(TempReader.ReadBytes((int)stream.Length));
            //关闭BinaryReader文件阅读器
            TempReader.Close();
            stream.Close();
            AddWriter.Close();
            addFile.Close();

            //TempReader.Dispose();
            stream.Dispose();
            // AddWriter.Dispose();
            addFile.Dispose();

            context.Response.Write("{\"chunked\" : true, \"hasError\" : false, \"f_ext\" : \"" + Path.GetExtension(file.FileName) + "\",\"clientName\":\"" + file.FileName + "\",\"path\":\"" + this.ReqPath + "\"}");
        }
        else//没有分片直接保存
        {
            string folder = context.Server.MapPath(TempPath);

            //建立临时传输文件夹
            if (!Directory.Exists(folder))
            {
                Directory.CreateDirectory(folder);
            }
            string tmppath = context.Server.MapPath(TempPath + Guid.NewGuid().ToString("N") + Path.GetExtension(context.Request.Files[0].FileName));
            context.Request.Files[0].SaveAs(tmppath);
            MoveFile(tmppath, Path.Combine(CurrentFolder, context.Request.Files[0].FileName));
            context.Response.Write("{\"chunked\" : false, \"hasError\" : false,\"clientName\":\"" + context.Request.Files[0].FileName + "\",\"path\":\"" + this.ReqPath + "\"}");
        }
    }
    private void MoveFile(string sourceFile, string targetFile)
    {
        if (File.Exists(targetFile))
        {
            string newpath = Path.GetDirectoryName(targetFile);
            string newfilename = Path.GetFileNameWithoutExtension(targetFile);
            string ext = Path.GetExtension(targetFile);
            File.Move(targetFile, Path.Combine(newpath, newfilename + "-" + DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss") + "-" + (new Random().Next(10000, 99999).ToString()) + ext));
        }
        File.Move(sourceFile, targetFile);

    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}