global class UploadFiles_cls {

    public static String API = 'GBM QA Piggo';  
    public List<Documents> listDocuments {get;set;}
    public static final String ERROR_1141 = 'El tipo de archivo ya no es permitido para esta cuenta.';

    public class Image{
        public String fileId {get;set;}
        public Integer applicationId {get;set;}
        public Integer documentType {get;set;}
        public String crmId {get;set;}
        public String processDate {get;set;}
        public String fileName {get;set;}

    }   
    public UploadFiles_cls (){          
        listDocuments = UploadFiles_cls.loadDocuments();        
    }   

    private static Documents addDocument (String label, String Id, Boolean uploaded, Integer documentType, Documents.DocumentByFolio documentByFolio){
        Documents document = new Documents();       
        document.label = label;
        document.Id = Id;
        document.uploaded = uploaded;
        document.documentType = documentType;   
        document.documentByFolio = documentByFolio;
        return document;
    }

    private static List<Documents> loadDocuments (){
        List<Documents> listDocuments = new List<Documents>();
        Documents document;     
        document = addDocument('IFE Frente','radiobutton-document-owner-official-id',false,Documents.DocumentType.OwnerOfficialId.ordinal(),null);      
        listDocuments.add(document);

        document = addDocument('IFE Reverso','radiobutton-document-owner-official-id-backside',false,Documents.DocumentType.OwnerOfficialIdBackSide.ordinal(),null);
        listDocuments.add(document);

        document = addDocument('Pasaporte','radiobutton-document-official-id',false,Documents.DocumentType.Passport.ordinal(),null);
        listDocuments.add(document);

        return listDocuments;
    }

    private static sObject getType (Id objectId){
        sObject documentSource;
        
        if (objectId.getSobjectType() == Lead.sObjectType){
            List<Lead> listLead = [select Folio__c, DocumentsUploaded__c from Lead where Id=:objectId];
            documentSource =    listLead.get(0);
        }else{
            List<Account> listAccount = [select Folio__c, DocumentsUploaded__c from Account where Id=:objectId];
            documentSource =    listAccount.get(0);
        }

        return documentSource;

    }

    @RemoteAction
    global static Map<String,Object> getFileId (Id objectId){   
        String folioId = '';
        Map<String,Object> result = new Map<String,Object>();
        List<Documents> listDocuments = new List<Documents>();
        
        sObject documentSource = getType (objectId);    
                
        result.put('success',true);                     

        Map<String,Object> request = new Map<String,Object>();
        request.put('downloadContent',true);
        request.put('folioId',(String)documentSource.get('Folio__c'));

        String sJSON = System.JSON.serialize(request);      

            
        List<Documents.DocumentByFolio> documentsUploaded = new List<Documents.DocumentByFolio>();


        if (documentsUploaded.isEmpty()){
            listDocuments = UploadFiles_cls.loadDocuments();
            result.put('documents',listDocuments);
            result.put('hasUploadedDocuments',false);           
        }           

        return result;
    }       

    public static void checkDocument (sObject document, Integer documentType){

        String newValues = '';
        String oldValues = (String)document.get('DocumentsUploaded__c');
        Set<String> options = oldValues == null?    new Set<String>() : new Set<String>(oldValues.split(';'));  

        if (documentType == Documents.DocumentType.OwnerOfficialId.ordinal()){
            options.add('INE frente');
        }
        
        if (documentType == Documents.DocumentType.OwnerOfficialIdBackSide.ordinal()){
            options.add('INE reverso');
        }

        if (documentType == Documents.DocumentType.Passport.ordinal()){
            options.add('Pasaporte');
        }       

        System.debug('options selected= '+options);
        for (String value : options){
            newValues += value+';';
        }

        document.put('DocumentsUploaded__c',newValues);


        update document;
    }

    public static String getGUID (){

        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.convertToHex(b);
        String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);

        return guid;
    }
}