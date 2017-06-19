public class Documents {
    public String label {get;set;}
    public Boolean uploaded {get;set;}    
    public DocumentByFolio documentByFolio {get;set;}
    public String Id {get;set;}
    public String Status {get;set;}
    public Integer documentType;
        
    public enum DocumentType{
        None,
        OwnerOfficialId, 
        Passport, 
        ProfessionalIdCard, 
        ProofOfAddress, 
        BankStatement,
        OfficialId, 
        OwnerOfficialIdBackSide,
        GoalPhoto,
        CoOwnerOfficialId,
        CoOwnerProofOfAddress,
        Contract,
        BankStatementBack,
        CoOwnerOfficialIdBack
    }
    
    public class DocumentByFolio {
        public String documentId;   
        public Integer userId;  
        public Integer documentType;    
        public String folioId;  
        public String idCotitular;  
        public Integer idCotitularNoetic;   
        public String idCuenta; 
        public String idCuentaBanco;    
        public String documentName; 
        public String documentPath; 
        public String documentExtension;
        public String documentContent;  
        public boolean isActive;
        public String creationDate;         
    }
}
