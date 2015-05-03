trigger Application on Application__c (before update, after update) {
    if(Trigger.isBefore){
        for(Application__c app : trigger.new){
            try{
                if((app.Created_Channel__c=='Online' || app.Current_Channel__c=='Online') && app.Created_Channel__c!=app.Current_Channel__c){
                    app.Assisted_Application__c=true;
                }
            }
            catch(Exception e){
                system.debug('Error in Setting the "Assited Application" field' +e.getMessage());
            }
        }
    }
 /*   if(Trigger.isAfter){
        if(Trigger.isUpdate){
           Set<Id>  submittedApplicationIds = new Set<Id>();
           List<User> chatterUsers = new List<User>();
           for(Application__c app : Trigger.new){
           try{
                if(app.Application_Status__c == 'Submitted' && Trigger.oldMap.get(app.Id).Application_Status__c !='Submitted'){
                   submittedApplicationIds.add(app.Id);
                }
             }
             catch(Exception e){
                 system.debug('Error in setting Submitted Application ids to Application' +e.getMessage());
             }          
           }
           User newChatterUser = new User();
           List<Profile> profileList = new List<Profile>();
           profileList = [select id from Profile where Name='Chatter Free User' limit 1];
           for(Application__c appl : [select id,First_Name__c,Last_Name__c,Email_Address__c from Application__c where ID IN :submittedApplicationIds]){
           try{    
                if(profileList.size() > 0){
                       newChatterUser.FirstName = appl.First_Name__c;
                       newChatterUser.LastName = appl.Last_Name__c;
                       newChatterUser.Email = appl.Email_Address__c;
                       newChatterUser.UserName = appl.Email_Address__c+'.dsp';
                       newChatterUser.ProfileId = profileList.get(0).Id;
                       chatterUsers.add(newChatterUser);
                }
              }
              catch(Exception e){
                     system.debug('Error in adding the new chatter user.' +e.getMessage());
              }
           }
           if(chatterUsers.size()>0)
             try{
                 insert chatterUsers;
             }
             catch(Exception e){
                 system.debug('Error in inserting Chatter User'+e.getMessage());
             }
        }
    } */
    // End of 
 }