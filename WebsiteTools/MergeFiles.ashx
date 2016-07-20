<%@ WebHandler Language="C#" Class="MergeFiles" %>

using System;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class MergeFiles : IHttpHandler
{
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

        string guid = context.Request["guid"];
        string fileExt = context.Request["fileExt"];
        string root = context.Server.MapPath(TempPath);
        string sourcePath = Path.Combine(root, guid + "/");//源数据文件夹
        string targetPath = Path.Combine(root, Guid.NewGuid() + fileExt);//合并后的文件
        string clientName = context.Request.Form["clientName"];
        string path = context.Request.Form["path"];

        if (Directory.Exists(Path.GetDirectoryName(sourcePath)))
        {
            FileInfo[] files = new MyClass().GetFiles(sourcePath);

            foreach (FileInfo file in files)
            {
                FileStream addFile = new FileStream(targetPath, FileMode.Append, FileAccess.Write);
                BinaryWriter AddWriter = new BinaryWriter(addFile);

                //获得上传的分片数据流
                Stream stream = file.Open(FileMode.Open);
                BinaryReader TempReader = new BinaryReader(stream);
                //将上传的分片追加到临时文件末尾
                AddWriter.Write(TempReader.ReadBytes((int)stream.Length));
                //关闭BinaryReader文件阅读器
                TempReader.Close();
                stream.Close();
                AddWriter.Close();
                addFile.Close();

               // TempReader.Dispose();
                stream.Dispose();
               // AddWriter.Dispose();
                addFile.Dispose();
            }
            DeleteFolder(sourcePath);
            MoveFile(targetPath, Path.Combine(context.Server.MapPath(path), clientName));

            context.Response.Write("{\"chunked\" : true,\"clientName\":\"" + clientName + "\", \"hasError\" : false, \"savePath\" :\"" + System.Web.HttpUtility.UrlEncode(targetPath) + "\"}");
            //context.Response.Write("{\"hasError\" : false}");
        }
        else
            context.Response.Write("{\"hasError\" : true}");
    }
    /// <summary>
    /// 删除文件夹及其内容
    /// </summary>
    /// <param name="dir"></param>
    private static void DeleteFolder(string strPath)
    {
        //删除这个目录下的所有子目录
        if (Directory.GetDirectories(strPath).Length > 0)
        {
            foreach (string fl in Directory.GetDirectories(strPath))
            {
                Directory.Delete(fl, true);
            }
        }
        //删除这个目录下的所有文件
        if (Directory.GetFiles(strPath).Length > 0)
        {
            foreach (string f in Directory.GetFiles(strPath))
            {
                System.IO.File.Delete(f);
            }
        }
        Directory.Delete(strPath, true);
    }
    /// <summary>
    /// 移动文件
    /// </summary>
    /// <param name="sourceFile">源文件</param>
    /// <param name="targetFile">目标文件</param>
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
public class FileComparer : IComparer
{
  public  int Compare(Object o1, Object o2)
    {
        FileInfo fi1 = o1 as FileInfo;
        FileInfo fi2 = o2 as FileInfo;
        return int.Parse(fi1.Name).CompareTo(int.Parse(fi2.Name));
    }
}

public class MyClass
{
    public FileInfo[] GetFiles(string path)
    {
        DirectoryInfo di = new DirectoryInfo(path);
        FileInfo[] files = di.GetFiles();
        FileComparer fc = new FileComparer();
        Array.Sort(files, fc);
        return files;
    }
} 
