public class LoginController {
    
    public String email {get; set;}
    public String password {get; set;}
    
    public PageReference redirectToSignUp(){
        return new PageReference('/apex/RegistrattionForm');
    }
    
    public PageReference doLogin(){  
        if(!String.isBlank(email) && !String.isBlank(password)){
            List<String> tokens = TokenRandomGenerete.generateRandomToken();
            ExternalUser__c externalUser = new ExternalUser__c();
            try{
                
            }catch(Exception e){
                System.debug(e);
            }
            system.debug(externalUser);
            if(externalUser != null){
                return null;//loginForExternalUser(externalUser,tokens);   
            }
        }else{ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Both fields are required'));}
        return null;
    }
    
    public PageReference loginForExternalUser(ExternalUser__c externalUser,List<String> tokens){
        if(externalUser.Password__c == password){
            SecurityToken__c userTokens = [Select Id 
                                           FROM SecurityToken__c 
                                           Where ExternalUser__c =: externalUser.Id];
            userTokens.AccessToken__c = tokens[0];
            userTokens.RefreshToken__c = tokens[1];
            update userTokens;
            setNewCookie(userTokens,externalUser.id);
            return null;//new PageReference('/apex/ExternalUserForm');
        }else{ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Sorry login or password is incorect'));} 
        return null;
    }
    
    public void setNewCookie(SecurityToken__c userTokens,Id userId){
        String data = userTokens.Refreshtoken__c;
        HashTokenForCookie token = new HashTokenForCookie(data);
        if(String.isNotBlank(token.signature)){
            Cookie cookie = new Cookie('refreshCookie',token.signature + ' ' + userId,null,7200,true);
            ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        }
        data = userTokens.Accesstoken__c;
        token = new HashTokenForCookie(data);
        if(String.isNotBlank(token.signature)){
            Cookie cookie = new Cookie('accessCookie',token.signature+' '+userId,null,604800,true);
            ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        } 
    }
    
}