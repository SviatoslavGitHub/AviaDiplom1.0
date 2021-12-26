public class RegistrattionController {
    
    public RegistrattionController(){
        userInfo = new ExternalUser__c();
    }
    
    public ExternalUser__c userInfo {get; set;}
    public String userEmail {get; set;}
    public String userPassword {get; set;}
    
    public PageReference doRegistration(){
        if(!String.isBlank(userEmail)){
            if(UserInfo.Password__c == userPassword){
                List<ExternalUser__c> userList = new List<ExternalUser__c>([SELECT Id,Name 
                                                                            FROM ExternalUser__c 
                                                                            WHERE Email__c =: userEmail 
                                                                            Limit 1]);
                if(userList.isEmpty()){
                    userInfo.Email__c = userEmail;
                    Database.SaveResult insertResult = Database.insert(userInfo);
                    
                    if(insertResult.isSuccess()){
                        List<String> tokens = TokenRandomGenerete.generateRandomToken();
                        SecurityToken__c saveUserTokens = new SecurityToken__c();
                        saveUserTokens.Accesstoken__c = tokens[0];
                        saveUserTokens.Refreshtoken__c = tokens[1];
                        saveUserTokens.Externaluser__c = userInfo.Id;
                        Database.SaveResult insertTokens = Database.insert(saveUserTokens);
                        if(insertTokens.isSuccess()){
                            String data = saveUserTokens.RefreshToken__c;
                            HashTokenForCookie token = new HashTokenForCookie(data);
                            if(String.isNotBlank(token.signature)){
                                Cookie cookie = new Cookie('refreshCookie',token.signature+' '+userInfo.Id,null,600,true);
                                ApexPages.currentPage().setCookies(new Cookie[]{cookie});  
                            }
                            data = saveUserTokens.Accesstoken__c;
                            token = new HashTokenForCookie(data);
                            if(String.isNotBlank(token.signature)){
                                Cookie cookie = new Cookie('accessCookie',token.signature+' '+userInfo.Id,null,1440,true);
                                ApexPages.currentPage().setCookies(new Cookie[]{cookie});  
                                return null;//new PageReference('/apex/ExternalUserForm');
                            }
                        }
                    }
                }else{ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'User with this Email alredy exist'));}
            }else{ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Passwords doesnt match'));}
        }else{ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'All fields are required'));}
        return null;
    }
    
}