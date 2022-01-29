public class HomePageController {
    
    public List<SelectOption> countryOptionList {get; set;}
    public List<SelectOption> cityOptionList {get; set;}
    public List<SelectOption> destinationeOptionList {get;set;}
    public List<String> flightDates {get;set;}
    public String selectedCountry {get;set;}
    public String selectedCity {get;set;}
    public String selectedRoute {get;set;}
    
    public Date dat{get;set;}
    
    public HomePageController(){
        getCountry(); 
    }
    
    public void getCountry(){
        countryOptionList = new List<SelectOption>();
        countryOptionList.add(new SelectOption('    ', '   '));
        for(Country__c country : [SELECT id,Name 
                                  FROM Country__c]) {
        	countryOptionList.add(new SelectOption(country.Id,country.Name));
                                      
        }
    }
    
    public void getCity(){
        if(selectedCountry != null) {
            cityOptionList = new List<SelectOption>();
            for(City__c city : [SELECT Id,Name 
                                FROM City__c 
                                WHERE Country__c =: selectedCountry 
                                ORDER BY Name]) {
            	cityOptionList.add(new SelectOption(city.Id,city.Name));
            }
        }
    }
    
    public void getDestinations(){
        destinationeOptionList = new List<SelectOption>();
        destinationeOptionList.add(new SelectOption('    ', '   '));
        for(Route__c routes : [SELECT Id,Name,CityTo__c 
                               FROM Route__c
                               WHERE CityFrom__c =: selectedCity]){
            City__c cityTo = [SELECT Name 
                              FROM City__c
                              WHERE Id =: routes.CityTo__c 
							  Limit 1];
        	destinationeOptionList.add(new SelectOption(routes.Id,cityTo.Name));                            
        }       
    }
    
    public void getDates(){
        flightDates = new List<String>();
        for(Flight_Information__c flyInfo : [SELECT Flight_Time_From__c
											 FROM Flight_Information__c
                                             WHERE Route__c =: selectedRoute]){                                
            flightDates.add(flyInfo.Flight_Time_From__c.format('d-m-yyyy'));                                   
        }
    }
    
    public void search(){
        
    }
    
    public PageReference redirectToLoginPage(){
        return new PageReference('/apex/LoginPage');
    }
    public PageReference redirectToRegistrationeForm(){
        return new PageReference('/apex/RegistrationeForm');
    }
    
}