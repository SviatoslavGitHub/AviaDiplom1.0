public class TokenRandomGenerete {
    
    public static List<String> generateRandomToken() {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        List <String> listAccessAndRefreshTokens = new List <String>{'',''};
            while (listAccessAndRefreshTokens[0].length() < 15 ) {
                Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
                listAccessAndRefreshTokens [0] += chars.substring(idx, idx+1);
                idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length()); 
                listAccessAndRefreshTokens [1] += chars.substring(idx, idx+1);
            }
        return listAccessAndRefreshTokens; 
    }
    
    
}
