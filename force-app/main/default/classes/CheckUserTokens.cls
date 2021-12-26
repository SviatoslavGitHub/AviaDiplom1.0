public class CheckUserTokens {
    
    public String checkRefreshToken(){
        Cookie refreshCookie = ApexPages.currentPage().getCookies().get('refreshCookie');
        if(refreshCookie != null){
            String cookieData = refreshCookie.getValue();
            List<String> refreshCookieValues = cookieData.split(' ');
            SecurityToken__c userTokens = new SecurityToken__c();
            userTokens = [SELECT Refreshtoken__c 
                          FROM SecurityToken__c 
                          WHERE Externaluser__c =: refreshCookieValues[1]];   
            HashTokenForCookie signed = new HashTokenForCookie(userTokens.Refreshtoken__c);
            if(signed.verifySignature(refreshCookieValues[0])){
                return refreshCookieValues[1]; 
            }
        }
        return null;
    }
    
    public Boolean setNewTokens(){
        Boolean newTokensCreated = false;
        Cookie accessCookie = ApexPages.currentPage().getCookies().get('accessCookie');
        if(accessCookie != null){
            String cookieData = accessCookie.getValue();
            List<String> AccesscookieValues = cookieData.split(' ');
            SecurityToken__c userTokens;
            userTokens = [Select Accesstoken__c,Id,Externaluser__c 
                          From SecurityToken__c 
                          Where Externaluser__c =: AccesscookieValues[1]];
            
            if(userTokens != null){
                HashTokenForCookie signed = new HashTokenForCookie(userTokens.Accesstoken__c);
                if(signed.verifySignature(AccesscookieValues[0])){
                    List<String> tokens = TokenRandomGenerete.generateRandomToken();
                    userTokens.Accesstoken__c = tokens[0];
                    userTokens.Refreshtoken__c = tokens[1];
                    Database.SaveResult updateTokens;
                    try{
                        updateTokens = Database.update(userTokens);
                    }catch(Exception e){System.debug('Exeption='+e);    }
                    if(updateTokens.isSuccess()){
                        newTokensCreated = true;
                        String data = tokens[1];
                        HashTokenForCookie token = new HashTokenForCookie(data);
                        Cookie newRefreshCookie = new Cookie('refreshCookie',token.signature+' '+userTokens.Externaluser__c,null,600,true);
                        data = tokens[0];
                        token = new HashTokenForCookie(data);
                        Cookie newAccessCookie = new Cookie('accessCookie',token.signature+' '+userTokens.Externaluser__c,null,1440,true);
                        ApexPages.currentPage().setCookies(new Cookie[]{newRefreshCookie,newAccessCookie});
                        return newTokensCreated;
                    }
                }
            }
        }return newTokensCreated;
    }       
}