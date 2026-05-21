public with sharing class PdfController {

    @auraEnabled
    public static Attachment generatePDF(Id recordId, String htmlData){
    pageReference page = Page.renderAsPdf;
    page.getParameters().put('pdfText',htmlData);
    Contact con = new Contact(Id=recordId);
    Attachment objAttachment = new Attachment();
        objAttachment.Name='Invoice.pdf';
        objAttachment.ParentId=con.Id;
        objAttachment.Body=page.getContentaspdf();
        objAttachment.IsPrivate=false;
        insert objAttachment;
        return objAttachment;
    }
}