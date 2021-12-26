global class HashTokenForCookie {
    private final string SECRET_KEY = 'veryHardKey123';
    public string data {public get;private set;}
    
    global string signature{
        global get{
            if(String.isNotBlank(this.data))
                return EncodingUtil.base64Encode(Crypto.generateMac('HmacSHA256',
                                                                    Blob.valueOf(this.data), 
                                                                    EncodingUtil.base64Decode(SECRET_KEY)));
            return null;
        }
    }
    
    global boolean verifySignature (String mac){
        return Crypto.verifyHmac('HmacSHA256',
                                 Blob.valueOf(this.data),
                                 EncodingUtil.base64Decode(SECRET_KEY),
                                 EncodingUtil.base64Decode(mac));
    }
    
    global HashTokenForCookie(String data){
        this.data=data;
    }
    
}