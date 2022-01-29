public class LearningTest {
    
    public static void getAccount(){
        List<Account> accList = [SELECT Name FROM Account WHERE Name='test' LIMIT 50];
        for(Integer i = 0;i <= accList.size();i++){
            accList[i].Name = String.valueOf(500);
        } 
    }
}

//в кожен акк присвоїти імя ТЕСТ(апдейт)



// Модифікатори доступу
//public - елемент доступний усюди в організації СФ 

//private - елемент доступний лише на рівні класу

//protected - елемент доступний на рівні класу + у дочірніх класах

//global - елемент доступний на зовні сф (API т.д.т.п.)