@isTest
public class UploadFiles_tst {
    static testmethod void uploadDocument (){        
        Test.startTest();

        Lead l = new Lead ();
        l.FirstName = 'Isai';
        l.LastName = 'Desales';
        l.Company = 'GBM';

        insert l;

        List<Lead> listLeads = [select Id from Lead];
        System.assert(!listLeads.isEmpty());


        UploadFiles_cls controller = new UploadFiles_cls();
        Map<String,Object> result = UploadFiles_cls.getFileId(listLeads.get(0).Id);
        System.assert(!(Boolean)result.get('hasUploadedDocuments'));

        Test.stopTest();
    }

    static testmethod void checkDocuments (){                     
        Test.startTest();


        Lead l = new Lead ();
        l.FirstName = 'Isai';
        l.LastName = 'Desales';
        l.Company = 'GBM';

        insert l;

        List<Lead> listLeads = [select Id, DocumentsUploaded__c from Lead];
        System.assert(!listLeads.isEmpty());

        UploadFiles_cls.checkDocument(listLeads.get(0), Documents.DocumentType.OwnerOfficialId.ordinal());      
        System.assert(![select Id from Lead where DocumentsUploaded__c includes ('INE frente')].isEmpty());
        
        UploadFiles_cls.checkDocument(listLeads.get(0), Documents.DocumentType.OwnerOfficialIdBackSide.ordinal());      
        System.assert(![select Id from Lead where DocumentsUploaded__c includes ('INE reverso')].isEmpty());

        UploadFiles_cls.checkDocument(listLeads.get(0), Documents.DocumentType.Passport.ordinal());
        System.assert(![select Id from Lead where DocumentsUploaded__c includes ('Pasaporte')].isEmpty());          
      
        Test.stopTest();
    }
}