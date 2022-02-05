public class HomePageController {
    
    public List<SelectOption> countryOptionList {get; set;}
    public List<SelectOption> cityOptionList {get; set;}
    public List<SelectOption> destinationeOptionList {get;set;}
    public List<String> flightDates {get;set;}
    public List<Flight_Information__c> flight {get;set;}
    public String selectedCountry {get;set;}
    public String selectedCity {get;set;}
    public String selectedRoute {get;set;}
    public String selectedDate {get;set;}
    
    public Date dat{get;set;}
    
    public HomePageController(){
        getCountry();
        selectedDate = ''; 
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
        	destinationeOptionList.add(new SelectOption(cityTo.Id,cityTo.Name));                            
        }       
    }
    
    public void getDates(){
        flightDates = new List<String>();
        Route__c routes = [SELECT Id
                           FROM Route__c
                           WHERE CityFrom__c =: selectedCity AND CityTo__c =: selectedRoute Limit 1];
        for(Flight_Information__c flyInfo : [SELECT DateFlightFrom__c
											 FROM Flight_Information__c
                                             WHERE Route__c =: routes.id]){ 
            System.debug(flyInfo.DateFlightFrom__c.day()+'-'
            +string.valueof(flyInfo.DateFlightFrom__c.month()).replace('0','')+'-'+flyInfo.DateFlightFrom__c.year());                         
            flightDates.add(flyInfo.DateFlightFrom__c.day()+'-'
            +string.valueof(flyInfo.DateFlightFrom__c.month()).replace('0','')+'-'+flyInfo.DateFlightFrom__c.year());                                   
        }
    }
    
    public void search(){
        System.debug('SelectedDate'+selectedDate);
        List<String> dateSplit = selectedDate.split('-');
        String prepateDate = '';
        for(Integer i = 0; i < dateSplit.size(); i++){
            if(dateSplit[i].length() == 1){
                prepateDate += '0'+dateSplit[i];
                prepateDate +='/';
            }else{
                prepateDate += dateSplit[i];
            }
            if(dateSplit[i].length() == 2){
                prepateDate +='/';
            }
        }

        System.debug('FinalDate'+prepateDate);
        Date finalDate = date.parse(prepateDate);
        System.debug('convertedValue'+finalDate);
        
        flight = [SELECT CityFrom__c,CityTo__c,DateFlightFrom__c,Flight_Time_From__c,Flight_Time_To__c,Price__c,Name 
                  FROM Flight_Information__c
                  WHERE CityFrom__c =: selectedCity AND CityTo__c =: selectedRoute AND DateFlightFrom__c =: finalDate Limit 1]; //
        System.debug('flight>>>>'+flight);
    }
    
    public PageReference redirectToLoginPage(){
        return new PageReference('/apex/LoginPage');
    }
    public PageReference redirectToRegistrationeForm(){
        return new PageReference('/apex/RegistrationeForm');
    }
    
}
