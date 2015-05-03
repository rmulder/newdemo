public class ChatterUploadFileController{
    public Attachment myfile;
    public Attachment getmyfile(){
        myfile = new Attachment();
        return myfile;
    }
    public PageReference uploadAttachment(){
         Attachment a = new Attachment(ParentId = 'a00o0000001PGqZ',Name = myfile.name, Body = myfile.body);
         insert a;
         return null;
     }
}