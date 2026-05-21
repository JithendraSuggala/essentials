public with sharing class DatatableWithAllContactsController {
   @AuraEnabled
   public static List<Contact> getContacts(){
    return [Select Name,Phone,Account.Name,Email,MailingAddress from contact with security_enforced order by createdDate ASC];
   }
}