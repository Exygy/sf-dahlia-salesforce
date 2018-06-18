public class SFMOHCD_DAO {

    public static String getPortalUserCreator() {
            UserRole ur = [Select Id, Name from UserRole where Name = 'PortalAccountCreator'];
            User portalaccountcreator = [SELECT Id, Name FROM User 
                                            WHERE UserRoleId = :ur.Id AND IsActive =: TRUE LIMIT 1];
            
            return portalaccountcreator.Id;
        }

    public static String createNewAccount(String incomingAccount, String ownerid) {
            Account newAccount = new Account();
            newAccount.Name = incomingAccount;
            newAccount.OwnerId = ownerid;
            insert newAccount;
            
            return newAccount.Id;
        }
    
  

    public static String registerExistingUser(String accountId, String profileId, String firstName, String lastName, String email, String zipcode, String val, String val2, String contactId) {
            User newUser = new User();
            newUser.FirstName = firstName;
            newUser.LastName = lastName;
            newUser.CommunityNickname = email+zipcode+val+val2;
            newUser.Email = email;
            newUser.Username = email;
            newUser.ContactId = contactId;
            newUser.EmailEncodingKey = 'ISO-8859-1';
            newUser.ProfileId = profileId;
            String alias = firstName.substring(0) + lastName.substring(0, 3);
            newUser.Alias = alias;
            newUser.LanguageLocaleKey = 'en_US';
            newUser.LocaleSidKey = 'en_US';
            newUser.TimeZoneSidKey = 'America/Los_Angeles';
            
            insert newUser;
            return newUser.Id;
        }

    public static Contact getUserContDet(){
        
        string current_user_id = UserInfo.getUserId();
        User current_contact_id = [select Id, ContactId from User where id = :current_user_id];
        Contact contDet = [SELECT Id, AccountId FROM Contact WHERE Id = :current_contact_id.ContactId];
        
        return contDet;


    }

    public static Account getUserAccount(){
        string current_user_id = UserInfo.getUserId();
        User current_contact_id = [select Id, ContactId from User where id = :current_user_id];
        Contact contAcctId = [SELECT AccountId FROM Contact WHERE Id = :current_contact_id.ContactId];
        Account userAcct = [SELECT Id FROM Account WHERE Id =: contAcctId.AccountId];

        return userAcct; 
    }

    public static Housing_Application__c createHousingApp(String hhAccountId, String propertyId, String contId){
        Housing_Application__c housingAppToInsert = new Housing_Application__c();
        
        Contact contDet = [SELECT Contact.Account.Current_Monthly_Mortgage_Rent_Amount__c,
                                  Current_Address__c,
                                  Live_Or_Work_in_San_Francisco__c,
                                  Phone,
                                  MobilePhone,
                                  Work_Phone__c,
                                  Email,
                                  Prior_Tax_Year_Total_Income_Amount__c
                                  FROM Contact
                                  WHERE Id = : contId];
        
        // Pattern nonWordChar = Pattern.compile('[^\\w]');
        // String refactored_address = nonWordChar.matcher(contDet.Current_Address__c).replaceAll(' ').replace('br', '');
        String refactored_address = contDet.Current_Address__c.replace('<br>', ' ');

        
        housingAppToInsert.Household_Account__c = hhAccountId;
        housingAppToInsert.Property_of_Interest__c = propertyId;
        housingAppToInsert.Primary_Applicant_Cell_Phone__c = contDet.MobilePhone;
        housingAppToInsert.Primary_Applicant_Current_Address__c = refactored_address;
        housingAppToInsert.Primary_Applicant_Email__c = contDet.Email;
        housingAppToInsert.Primary_Applicant_Home_Phone__c = contDet.Phone;
        housingAppToInsert.Primary_Applicant_Work_Phone__c = contDet.Work_Phone__c;
        housingAppToInsert.Live_Or_Work_in_San_Francisco__c = contDet.Live_Or_Work_in_San_Francisco__c;
        housingAppToInsert.Current_Monthly_Mortgage_Rent_Amount__c = contDet.Account.Current_Monthly_Mortgage_Rent_Amount__c;
        
        return housingAppToInsert;
    }

    public static List<Housing_Application_Member__c> createhAppMem(String hAppId, String accId){
        //Housing_Application_Member__c housingMemToInsert = new Housing_Application_Member__c();
        List<Housing_Application_Member__c> housingMemList = new List<Housing_Application_Member__c>();

        List<Contact> contDetails = [SELECT Id,
                                            Address_Line_2__c,
                                            Apt_Unit__c,
                                            MobilePhone,
                                            Certificate_of_Preference__c,
                                            Certificate_of_Preference_Holder__c,
                                            City__c,
                                            Birthdate,
                                            EAHP_Cert_Exp_Date_Existing_Dev__c,
                                            EAHP_Cert_Exp_Date_New_Dev__c,
                                            EAHP_Certificate_Holder__c,
                                            EAHP_Certificate_Issue_Date__c,
                                            Email,
                                            FirstName,
                                            Full_Time_Student__c,
                                            Gender__c,
                                            Head_of_Household__c,
                                            HomePhone,
                                            In_School__c,
                                            LastName,
                                            Live_Or_Work_in_San_Francisco__c,
                                            Contact_Mailing_Address__c,
                                            Married_or_Domestic_Partnered__c,
                                            Age__c,
                                            Name,
                                            Middle_Name__c,
                                            Occupation__c,
                                            Race_Ethnicity_optional__c,
                                            Relationship_to_Head_of_HH_if_Other__c,
                                            Relationship_to_Head_of_Household__c,
                                            Salutation,
                                            State__c,
                                            Street_Name__c,
                                            Street_Number__c,
                                            Street_Type__c,
                                            Name_Suffix__c,
                                            Work_Phone__c,
                                            Zip_Code__c,
                                            Current_Address__c,
                                            Prior_Tax_Year_Total_Income_Amount__c
                                            FROM Contact
                                            WHERE AccountId = :accId];

        for (Contact c : contDetails) {
            Housing_Application_Member__c housingMemToInsert = new Housing_Application_Member__c();
            housingMemToInsert.ContactId__c = c.Id;
            housingMemToInsert.Address_Line_2__c = c.Address_Line_2__c;
            housingMemToInsert.Apt_Unit__c = c.Apt_Unit__c;
            housingMemToInsert.Cell_Phone__c = c.MobilePhone;
            housingMemToInsert.Certificate_of_Preference_Holder__c = c.Certificate_of_Preference_Holder__c;
            housingMemToInsert.Certificate_of_Preference__c = c.Certificate_of_Preference__c;
            housingMemToInsert.City__c = c.City__c;
            housingMemToInsert.Date_of_Birth__c = c.Birthdate;
            housingMemToInsert.EAHP_Certificate_Holder__c = c.EAHP_Certificate_Holder__c;
            housingMemToInsert.EAHP_Certificate_Issue_Date__c = c.EAHP_Certificate_Issue_Date__c;
            housingMemToInsert.EAHP_Cert_Exp_Date_Existing_Dev__c = c.EAHP_Cert_Exp_Date_New_Dev__c;
            housingMemToInsert.EAHP_Cert_Exp_Date_New_Dev__c = c.EAHP_Cert_Exp_Date_New_Dev__c;
            housingMemToInsert.Email_Address__c = c.Email;
            housingMemToInsert.First_Name__c = c.FirstName;
            housingMemToInsert.Full_Time_Student__c = c.Full_Time_Student__c;
            housingMemToInsert.Gender__c = c.Gender__c;
            housingMemToInsert.Home_Phone__c = c.HomePhone;
            housingMemToInsert.Housing_Application__c = hAppId;
            housingMemToInsert.In_School__c  = c.In_School__c;
            housingMemToInsert.Last_Name__c = c.LastName;
            housingMemToInsert.Live_Or_Work_in_San_Francisco__c  = c.Live_Or_Work_in_San_Francisco__c;
            housingMemToInsert.Mailing_Address__c  = c.Contact_Mailing_Address__c;
            housingMemToInsert.Married_or_Domestic_Partnered__c  = c.Married_or_Domestic_Partnered__c;
            housingMemToInsert.Middle_Name__c = c.Middle_Name__c;
            housingMemToInsert.Occupation__c = c.Occupation__c;
            housingMemToInsert.Race_Ethnicity_optional__c = c.Race_Ethnicity_optional__c;
            housingMemToInsert.Relationship_to_Head_of_HH_if_Other__c = c.Relationship_to_Head_of_HH_if_Other__c;
            housingMemToInsert.Relationship_to_Head_of_Household__c = c.Relationship_to_Head_of_Household__c;
            housingMemToInsert.Salutation__c = c.Salutation;
            housingMemToInsert.State__c = c.State__c;
            housingMemToInsert.Street_Name__c = c.Street_Name__c;
            housingMemToInsert.Street_Number__c = c.Street_Number__c;
            housingMemToInsert.Street_Type__c = c.Street_Type__c;
            housingMemToInsert.Suffix__c = c.Name_Suffix__c;
            housingMemToInsert.Work_Phone__c = c.Work_Phone__c;
            housingMemToInsert.Zip_Code__c = c.Zip_Code__c;

            housingMemList.add(housingMemToInsert);


        }

        return housingMemList;


    }

    public static List<Housing_Application_Asset__c> createhAppAsset(String accId, String hAppId){
        
        List<Housing_Application_Asset__c> hAppAssetList = new List<Housing_Application_Asset__c>();
        List<Contact> contactId = [SELECT Id FROM Contact WHERE AccountId = :accId];
        List<Housing_Application_Member__c> hAppMem = [SELECT Id, ContactId__c FROM Housing_Application_Member__c WHERE Housing_Application__c = :hAppId];
        
        Map<String, Housing_Application_Member__c> hMemMap = new Map<String, Housing_Application_Member__c>();

        for (Housing_Application_Member__c ham : hAppMem) {
            hMemMap.put(ham.ContactId__c, ham);
        }
        

        

        

        List<Personal_Asset__c> contAsset = [SELECT Account_Number__c,
                                                    Amount_of_Gift_Deposited_into_Rec_Acct__c,
                                                    Asset_Type__c,
                                                    Cash_or_Market_Value__c,
                                                    Current_Cash_Value_of_Gift__c,
                                                    Date_of_Gift_Letter__c,
                                                    Date_of_Most_Recent_Statement__c,
                                                    Escrow_Account_Number__c,
                                                    Escrow_Acct_Institution_Address__c,
                                                    Escrow_Acct_Institution_Name__c,
                                                    Escrow_Acct_Institution_Phone_Number__c,
                                                    Escrow_Amount_Deposited__c,
                                                    Escrow_Date_of_Deposit__c,
                                                    Escrow_Type_of_Account__c,
                                                    Gifter_Donor_Address__c,
                                                    Gifter_Donor_Name__c,
                                                    Gifter_Donor_Phone_Number__c,
                                                    Gifter_Donor_Relationship_to_Recipient__c,
                                                    Gift_Funds_Bank_Depository_Account__c,
                                                    Gift_Funds_Location_Address__c,
                                                    Gift_Funds_Location_Phone__c,
                                                    Gift_Funds_Location_Bank_Depository_Name__c,
                                                    Gift_Funds_Type_of_Account__c,
                                                    Gift_Funds_Type_Other_description__c,
                                                    Gift_Recipient_s_Account_Number__c,
                                                    Gift_Recipient_Account_Address__c,
                                                    Gift_Recipient_Account_Institution_Name__c,
                                                    GR_Acct_Inst_Date_of_Last_Statement__c,
                                                    GR_Acct_Inst_Phone__c,
                                                    GR_Acct_Most_Recent_Balance__c,
                                                    Household_Member__c,                                                    
                                                    Is_this_a_joint_account__c,
                                                    Most_Recent_Balance__c,
                                                    Name_of_Institution__c,
                                                    Name_of_joint_account_holders__c,
                                                    Relationship_if_Other__c,
                                                    Settlement_or_Other_Description__c,
                                                    Stock_Bond_Description__c,
                                                    Total_Cash_Not_Deposited_in_Any_Account__c,
                                                    Withdrawn_From_Acct_Inst_Account_Number__c,
                                                    Withdrawn_From_Acct_Inst_Address__c,
                                                    Withdrawn_From_Acct_Inst_Name__c,
                                                    Withdrawn_From_Acct_Inst_Phone__c, RecordType.Name
                                                    FROM Personal_Asset__c
                                                    WHERE Household_Member__c IN: contactId];

     

        for(Personal_Asset__c pa : contAsset){
            Housing_Application_Asset__c hAppAssetToInsert = new Housing_Application_Asset__c();
            hAppAssetToInsert.Account_Number__c = pa.Account_Number__c;
            hAppAssetToInsert.Amount_of_Gift_Deposited_into_Rec_Acct__c = 0;
            hAppAssetToInsert.Asset_Type__c = pa.Asset_Type__c;
            hAppAssetToInsert.Cash_or_Market_Value__c = 0;
            hAppAssetToInsert.Current_Cash_Value_of_Gift__c = 0;
            hAppAssetToInsert.Date_of_Gift_Letter__c = pa.Date_of_Gift_Letter__c;
            hAppAssetToInsert.Date_of_Most_Recent_Statement__c = pa.Date_of_Most_Recent_Statement__c;
            hAppAssetToInsert.Escrow_Account_Number__c = pa.Escrow_Account_Number__c;
            hAppAssetToInsert.Escrow_Acct_Institution_Address__c = pa.Escrow_Acct_Institution_Address__c;
            hAppAssetToInsert.Escrow_Acct_Institution_Name__c = pa.Escrow_Acct_Institution_Name__c;
            hAppAssetToInsert.Escrow_Acct_Institution_Phone_Number__c = pa.Escrow_Acct_Institution_Phone_Number__c;
            hAppAssetToInsert.Escrow_Amount_Deposited__c = 0;
            hAppAssetToInsert.Escrow_Date_of_Deposit__c = pa.Escrow_Date_of_Deposit__c;
            hAppAssetToInsert.Escrow_Type_of_Account__c = pa.Escrow_Type_of_Account__c;
            hAppAssetToInsert.Gifter_Donor_Address__c = pa.Gifter_Donor_Address__c;
            hAppAssetToInsert.Gifter_Donor_Name__c = pa.Gifter_Donor_Name__c;
            hAppAssetToInsert.Gifter_Donor_Phone_Number__c = pa.Gifter_Donor_Phone_Number__c;
            hAppAssetToInsert.Gifter_Donor_Relationship_to_Recipient__c = pa.Gifter_Donor_Relationship_to_Recipient__c;
            hAppAssetToInsert.Gift_Funds_Bank_Depository_Account__c = pa.Gift_Funds_Bank_Depository_Account__c;
            hAppAssetToInsert.Gift_Funds_Location_Address__c = pa.Gift_Funds_Location_Address__c;
            hAppAssetToInsert.Gift_Funds_Location_Phone__c = pa.Gift_Funds_Location_Phone__c;
            hAppAssetToInsert.Gift_Funds_Location_Bank_Depository_Name__c = pa.Gift_Funds_Location_Bank_Depository_Name__c;
            hAppAssetToInsert.Gift_Funds_Type_of_Account__c = pa.Gift_Funds_Type_of_Account__c;
            hAppAssetToInsert.Gift_Recipient_s_Account_Number__c = pa.Gift_Recipient_s_Account_Number__c;
            hAppAssetToInsert.Gift_Recipient_Account_Address__c = pa.Gift_Recipient_Account_Address__c;
            hAppAssetToInsert.Gift_Recipient_Account_Institution_Name__c = pa.Gift_Recipient_Account_Institution_Name__c;
            hAppAssetToInsert.GR_Acct_Inst_Date_of_Last_Statement__c = pa.GR_Acct_Inst_Date_of_Last_Statement__c;
            hAppAssetToInsert.GR_Acct_Inst_Phone__c = pa.GR_Acct_Inst_Phone__c;
            hAppAssetToInsert.GR_Acct_Most_Recent_Balance__c = 0;
            hAppAssetToInsert.Housing_Application__c = hAppId;
            hAppAssetToInsert.Most_Recent_Balance__c = 0;
            hAppAssetToInsert.Name_of_Institution__c = pa.Name_of_Institution__c;
            hAppAssetToInsert.Relationship_if_Other__c = pa.Relationship_if_Other__c;
            hAppAssetToInsert.Settlement_or_Other_Description__c = pa.Settlement_or_Other_Description__c;
            hAppAssetToInsert.Stock_Bond_Description__c = pa.Stock_Bond_Description__c;
            hAppAssetToInsert.Total_Cash_Not_Deposited_in_Any_Account__c = 0;
            hAppAssetToInsert.Withdrawn_From_Acct_Inst_Account_Number__c = pa.Withdrawn_From_Acct_Inst_Account_Number__c;
            hAppAssetToInsert.Withdrawn_From_Acct_Inst_Address__c = pa.Withdrawn_From_Acct_Inst_Address__c;
            hAppAssetToInsert.Withdrawn_From_Acct_Inst_Name__c = pa.Withdrawn_From_Acct_Inst_Name__c;
            hAppAssetToInsert.Withdrawn_From_Acct_Inst_Phone__c = pa.Withdrawn_From_Acct_Inst_Phone__c;
            hAppAssetToInsert.Is_this_a_joint_account__c = pa.Is_this_a_joint_account__c;
            hAppAssetToInsert.Name_of_joint_account_holders__c = pa.Name_of_joint_account_holders__c;
            hAppAssetToInsert.Gift_Funds_Type_Other_description__c = pa.Gift_Funds_Type_Other_description__c;
            hAppAssetToInsert.Housing_Application_Member__c = hMemMap.get(pa.Household_Member__c).Id;
           //Assign RecordType using AssetType
           hAppAssetToInsert.RecordTypeId = Schema.SObjectType.Housing_Application_Asset__c.getRecordTypeInfosByName().get(pa.RecordType.Name).getRecordTypeId();            

            hAppAssetList.add(hAppAssetToInsert);



    
        }
        
        return hAppAssetList;


    }

    public static List<Housing_Application_Income__c> createhAppIncome(String accId, String hAppId){
        List<Housing_Application_Income__c> hAppIncomeList = new List<Housing_Application_Income__c>();
        List<Contact> contactId = [SELECT Id FROM Contact WHERE AccountId = :accId];
        List<Housing_Application_Member__c> hAppMem = [SELECT Id, ContactId__c FROM Housing_Application_Member__c WHERE Housing_Application__c = :hAppId];

        Map<String, Housing_Application_Member__c> hMemMap = new Map<String, Housing_Application_Member__c>();

        for (Housing_Application_Member__c ham : hAppMem) {
            hMemMap.put(ham.ContactId__c, ham);
        }
                  
        List<Personal_Income__c> contIncome = [SELECT Annual_Commissions_Bonuses_Tips__c,
                                                      Annualized_Income__c,
                                                      Annual_Overtime__c,
                                                      Annual_Unemployment_Benefits_Amount__c,
                                                      Applicant_Self_employed__c,
                                                      Applicant_Unemployed__c,
                                                      Base_Annual_Employment_Income__c,
                                                      Child_Support_Alimony_Received_Annually__c,
                                                      Date_Of_Most_Recent_P_L_Stmt__c,
                                                      Employer_Address__c,
                                                      Employer_Name__c,
                                                      Employment_Status__c,
                                                      First_Date_of_Employment__c,
                                                      Household_Member__c,
                                                      Household_Member_Name__c,
                                                      How_many_times_year_get_P_L_Statement__c,
                                                      Income_from_Land_or_Business_Annually__c,
                                                      Interest_Dividends_Received_Annually__c,
                                                      Month_Unemployed__c,
                                                      Most_Recent_Tax_Year_1__c,
                                                      Most_Recent_Tax_Year_2__c,
                                                      Other_Incomes_Received_Annually__c,
                                                      Pay_Amount__c,
                                                      Paycheck_1_Total_Gross_Amount__c,
                                                      Paycheck_1_Gross_Pay_Annualized__c,
                                                      Paycheck_1_Gross_Pay_Period_Average__c,
                                                      Paycheck_1_Pay_Date__c,
                                                      Paycheck_1_Period__c,
                                                      Paycheck_1_Year_To_Date_Gross_Amount__c,
                                                      Paycheck_2_Total_Gross_Amount__c,
                                                      Paycheck_2_Gross_Pay_Annualized__c,
                                                      Paycheck_2_Gross_Pay_Period_Average__c,
                                                      Paycheck_2_Pay_Date__c,
                                                      Paycheck_2_Period__c,
                                                      Paycheck_2_Year_To_Date_Gross_Amount__c,
                                                      Paycheck_3_Total_Gross_Amount__c,
                                                      Paycheck_3_Gross_Pay_Annualized__c,
                                                      Paycheck_3_Gross_Pay_Period_Average__c,
                                                      Paycheck_3_Pay_Date__c,
                                                      Paycheck_3_Period__c,
                                                      Paycheck_3_Year_To_Date_Gross_Amount__c,
                                                      Pay_Date__c,
                                                      Pay_Period_Frequency__c,
                                                      Most_Recent_Profit_or_Loss_Amount__c,
                                                      Most_Recent_Profit_or_Loss_Status__c,
                                                      Public_Assistance_Received_Annually__c,
                                                      Self_Employment_Starting_Month__c,
                                                      Self_Employment_Starting_Year__c,
                                                      Self_Employment_Income_Declaration_Type__c,
                                                      Social_Security_Pensions_Rec_d_Annually__c,
                                                      Tax_Year_1_Taxable_Annual_Income__c,
                                                      Tax_Year_2_Taxable_Annual_Income__c,
                                                      Total_Number_of_Pay_Periods_Annually__c,
                                                      Total_Other_Income_Rec_d_Annually__c,
                                                      Year_Unemployed__c,RecordType.Name
                                                      FROM Personal_Income__c
                                                      WHERE Household_Member__c IN: contactId];

        for (Personal_Income__c pi : contIncome) {
            Housing_Application_Income__c hAppIncomeToInsert = new Housing_Application_Income__c();
            hAppIncomeToInsert.Annual_Commissions_Bonuses_Tips__c = 0;
            hAppIncomeToInsert.Annualized_Income__c = 0;
            hAppIncomeToInsert.Annual_Overtime__c = 0;
            hAppIncomeToInsert.Applicant_Self_employed__c = pi.Applicant_Self_employed__c;
            hAppIncomeToInsert.Applicant_Unemployed__c = pi.Applicant_Unemployed__c;
            hAppIncomeToInsert.Base_Annual_Employment_Income__c = 0;
            hAppIncomeToInsert.Child_Support_Alimony_Received_Annually__c = 0;
            hAppIncomeToInsert.Date_Of_Most_Recent_P_L_Stmt__c = pi.Date_Of_Most_Recent_P_L_Stmt__c;
            hAppIncomeToInsert.Employer_Address__c = pi.Employer_Address__c;
            hAppIncomeToInsert.Employer_Name__c = pi.Employer_Name__c;
            hAppIncomeToInsert.Employment_Status__c = pi.Employment_Status__c;
            hAppIncomeToInsert.First_Date_of_Employment__c = pi.First_Date_of_Employment__c;
            hAppIncomeToInsert.Housing_Application__c = hAppId;
            hAppIncomeToInsert.Income_from_Land_or_Business_Annually__c = 0;
            hAppIncomeToInsert.Interest_Dividends_Received_Annually__c = 0;
            hAppIncomeToInsert.Month_Unemployed__c = pi.Month_Unemployed__c;
            hAppIncomeToInsert.Other_Incomes_Received_Annually__c = 0;
            hAppIncomeToInsert.Pay_Amount__c = 0;
            hAppIncomeToInsert.Paycheck_1_Total_Gross_Amount__c = 0;
            hAppIncomeToInsert.Paycheck_1_Pay_Date__c = pi.Paycheck_1_Pay_Date__c;
            hAppIncomeToInsert.Paycheck_1_Period__c = pi.Paycheck_1_Period__c;
            hAppIncomeToInsert.Paycheck_1_Year_To_Date_Gross_Amount__c = 0;
            hAppIncomeToInsert.Paycheck_2_Total_Gross_Amount__c = 0;
            hAppIncomeToInsert.Paycheck_2_Pay_Date__c = pi.Paycheck_2_Pay_Date__c;
            hAppIncomeToInsert.Paycheck_2_Period__c = pi.Paycheck_2_Period__c;
            hAppIncomeToInsert.Paycheck_2_Year_To_Date_Gross_Amount__c = 0;
            hAppIncomeToInsert.Paycheck_3_Total_Gross_Amount__c = 0;
            hAppIncomeToInsert.Paycheck_3_Pay_Date__c = pi.Paycheck_3_Pay_Date__c;
            hAppIncomeToInsert.Paycheck_3_Period__c = pi.Paycheck_3_Period__c;
            hAppIncomeToInsert.Paycheck_3_Year_To_Date_Gross_Amount__c = 0;
            hAppIncomeToInsert.Pay_Date__c = pi.Pay_Date__c;
            hAppIncomeToInsert.Pay_Period_Frequency__c = pi.Pay_Period_Frequency__c;
            hAppIncomeToInsert.Most_Recent_Profit_or_Loss_Amount__c = 0;
            hAppIncomeToInsert.Most_Recent_Profit_or_Loss_Status__c = pi.Most_Recent_Profit_or_Loss_Status__c;
            hAppIncomeToInsert.Public_Assistance_Received_Annually__c = 0;
            hAppIncomeToInsert.Self_Employment_Starting_Month__c = pi.Self_Employment_Starting_Month__c;
            hAppIncomeToInsert.Self_Employment_Starting_Year__c = pi.Self_Employment_Starting_Year__c;
            hAppIncomeToInsert.Social_Security_Pensions_Rec_d_Annually__c = 0;
            hAppIncomeToInsert.Total_Number_of_Pay_Periods_Annually__c = pi.Total_Number_of_Pay_Periods_Annually__c;
            hAppIncomeToInsert.Year_Unemployed__c = pi.Year_Unemployed__c;
            hAppIncomeToInsert.Annual_Unemployment_Benefits_Amount__c = 0;
            hAppIncomeToInsert.Self_Employment_Income_Declaration_Type__c = pi.Self_Employment_Income_Declaration_Type__c;
            hAppIncomeToInsert.How_many_times_year_get_P_L_Statement__c = pi.How_many_times_year_get_P_L_Statement__c;
            hAppIncomeToInsert.Tax_Year_1_Taxable_Annual_Income__c = 0;
            hAppIncomeToInsert.Tax_Year_2_Taxable_Annual_Income__c = 0;
            hAppIncomeToInsert.Most_Recent_Tax_Year_1__c = pi.Most_Recent_Tax_Year_1__c;
            hAppIncomeToInsert.Most_Recent_Tax_Year_2__c = pi.Most_Recent_Tax_Year_2__c;
            hAppIncomeToInsert.Housing_Application_Member__c = hMemMap.get(pi.Household_Member__c).Id;
            //Assign RecordType using AssetType
           hAppIncomeToInsert.RecordTypeId = Schema.SObjectType.Housing_Application_Income__c.getRecordTypeInfosByName().get(pi.RecordType.Name).getRecordTypeId();            
 
           hAppIncomeList.add(hAppIncomeToInsert);
            
        }

        return hAppIncomeList;

    }

    public static List<Financial_Application_Member__c> createfinAppMem(String finAppId, String accId){
        //Housing_Application_Member__c housingMemToInsert = new Housing_Application_Member__c();
        List<Financial_Application_Member__c> finMemList = new List<Financial_Application_Member__c>();

        List<Contact> contDetails = [SELECT Id,
                                            Address_Line_2__c,
                                            Apt_Unit__c,
                                            MobilePhone,
                                            Certificate_of_Preference__c,
                                            Certificate_of_Preference_Holder__c,
                                            City__c,
                                            Birthdate,
                                            EAHP_Cert_Exp_Date_Existing_Dev__c,
                                            EAHP_Cert_Exp_Date_New_Dev__c,
                                            EAHP_Certificate_Holder__c,
                                            EAHP_Certificate_Issue_Date__c,
                                            Email,
                                            FirstName,
                                            Full_Time_Student__c,
                                            Gender__c,
                                            Head_of_Household__c,
                                            HomePhone,
                                            In_School__c,
                                            LastName,
                                            Live_or_Work_in_San_Francisco__c,
                                            Contact_Mailing_Address__c,
                                            Married_or_Domestic_Partnered__c,
                                            Age__c,
                                            Name,
                                            Middle_Name__c,
                                            Occupation__c,
                                            Race_Ethnicity_optional__c,
                                            Relationship_to_Head_of_HH_if_Other__c,
                                            Relationship_to_Head_of_Household__c,
                                            Salutation,
                                            State__c,
                                            Street_Name__c,
                                            Street_Number__c,
                                            Street_Type__c,
                                            Name_Suffix__c,
                                            Work_Phone__c,
                                            Zip_Code__c
                                            FROM Contact
                                            WHERE AccountId = :accId];

        for (Contact c : contDetails) {
            Financial_Application_Member__c finMemToInsert = new Financial_Application_Member__c();
            finMemToInsert.ContactId__c = c.Id;
            finMemToInsert.Address_Line_2__c = c.Address_Line_2__c;
            finMemToInsert.Apt_Unit__c = c.Apt_Unit__c;
            finMemToInsert.Cell_Phone__c = c.MobilePhone;
            finMemToInsert.Certificate_of_Preference_Holder__c = c.Certificate_of_Preference_Holder__c;
            finMemToInsert.Certificate_of_Preference__c = c.Certificate_of_Preference__c;
            finMemToInsert.City__c = c.City__c;
            finMemToInsert.Date_of_Birth__c = c.Birthdate;
            finMemToInsert.EAHP_Certificate_Holder__c = c.EAHP_Certificate_Holder__c;
            finMemToInsert.EAHP_Certificate_Issue_Date__c = c.EAHP_Certificate_Issue_Date__c;
            finMemToInsert.EAHP_Cert_Exp_Date_Existing_Dev__c = c.EAHP_Cert_Exp_Date_New_Dev__c;
            finMemToInsert.EAHP_Cert_Exp_Date_New_Dev__c = c.EAHP_Cert_Exp_Date_New_Dev__c;
            finMemToInsert.Email_Address__c = c.Email;
            finMemToInsert.First_Name__c = c.FirstName;
            finMemToInsert.Full_Time_Student__c = c.Full_Time_Student__c;
            finMemToInsert.Gender__c = c.Gender__c;
            finMemToInsert.Home_Phone__c = c.HomePhone;
            finMemToInsert.Financial_Application__c = finAppId;
            finMemToInsert.In_School__c  = c.In_School__c;
            finMemToInsert.Last_Name__c = c.LastName;
            finMemToInsert.Live_Or_Work_in_San_Francisco__c  = c.Live_Or_Work_in_San_Francisco__c;
            finMemToInsert.Mailing_Address__c  = c.Contact_Mailing_Address__c;
            finMemToInsert.Married_or_Domestic_Partnered__c  = c.Married_or_Domestic_Partnered__c;
            finMemToInsert.Middle_Name__c = c.Middle_Name__c;
            finMemToInsert.Occupation__c = c.Occupation__c;
            finMemToInsert.Race_Ethnicity_optional__c = c.Race_Ethnicity_optional__c;
            finMemToInsert.Relationship_to_Head_of_HH_if_Other__c = c.Relationship_to_Head_of_HH_if_Other__c;
            finMemToInsert.Relationship_to_Head_of_Household__c = c.Relationship_to_Head_of_Household__c;
            finMemToInsert.Salutation__c = c.Salutation;
            finMemToInsert.State__c = c.State__c;
            finMemToInsert.Street_Name__c = c.Street_Name__c;
            finMemToInsert.Street_Number__c = c.Street_Number__c;
            finMemToInsert.Street_Type__c = c.Street_Type__c;
            finMemToInsert.Suffix__c = c.Name_Suffix__c;
            finMemToInsert.Work_Phone__c = c.Work_Phone__c;
            finMemToInsert.Zip_Code__c = c.Zip_Code__c;

            finMemList.add(finMemToInsert);


        }

        return finMemList;


    }

    public static List<Financial_Application_Asset__c> createfinAppAsset(String accId, String finAppId){
        
        List<Financial_Application_Asset__c> finAppAssetList = new List<Financial_Application_Asset__c>();
        List<Contact> contactId = [SELECT Id FROM Contact WHERE AccountId = :accId];
        List<Financial_Application_Member__c> finAppMem = [SELECT Id, ContactId__c FROM Financial_Application_Member__c WHERE Financial_Application__c = :finAppId];
        
        Map<String, Financial_Application_Member__c> fMemMap = new Map<String, Financial_Application_Member__c>();

        for (Financial_Application_Member__c fam : finAppMem) {
            fMemMap.put(fam.ContactId__c, fam);
        }
        

        

        

        List<Personal_Asset__c> contAsset = [SELECT Account_Number__c,
                                                    Amount_of_Gift_Deposited_into_Rec_Acct__c,
                                                    Asset_Type__c,
                                                    Cash_or_Market_Value__c,
                                                    Current_Cash_Value_of_Gift__c,
                                                    Date_of_Gift_Letter__c,
                                                    Date_of_Most_Recent_Statement__c,
                                                    Escrow_Account_Number__c,
                                                    Escrow_Acct_Institution_Address__c,
                                                    Escrow_Acct_Institution_Name__c,
                                                    Escrow_Acct_Institution_Phone_Number__c,
                                                    Escrow_Amount_Deposited__c,
                                                    Escrow_Date_of_Deposit__c,
                                                    Escrow_Type_of_Account__c,
                                                    Gifter_Donor_Address__c,
                                                    Gifter_Donor_Name__c,
                                                    Gifter_Donor_Phone_Number__c,
                                                    Gifter_Donor_Relationship_to_Recipient__c,
                                                    Gift_Funds_Bank_Depository_Account__c,
                                                    Gift_Funds_Location_Address__c,
                                                    Gift_Funds_Location_Phone__c,
                                                    Gift_Funds_Location_Bank_Depository_Name__c,
                                                    Gift_Funds_Type_of_Account__c,
                                                    Gift_Funds_Type_Other_description__c,
                                                    Gift_Recipient_s_Account_Number__c,
                                                    Gift_Recipient_Account_Address__c,
                                                    Gift_Recipient_Account_Institution_Name__c,
                                                    GR_Acct_Inst_Date_of_Last_Statement__c,
                                                    GR_Acct_Inst_Phone__c,
                                                    GR_Acct_Most_Recent_Balance__c,
                                                    Household_Member__c,
                                                    Is_this_a_joint_account__c,
                                                    Most_Recent_Balance__c,
                                                    Name_of_Institution__c,
                                                    Name_of_joint_account_holders__c,
                                                    Relationship_if_Other__c,
                                                    Settlement_or_Other_Description__c,
                                                    Stock_Bond_Description__c,
                                                    Total_Cash_Not_Deposited_in_Any_Account__c,
                                                    Withdrawn_From_Acct_Inst_Account_Number__c,
                                                    Withdrawn_From_Acct_Inst_Address__c,
                                                    Withdrawn_From_Acct_Inst_Name__c,
                                                    Withdrawn_From_Acct_Inst_Phone__c
                                                    FROM Personal_Asset__c
                                                    WHERE Household_Member__c IN: contactId];

     

        for(Personal_Asset__c pa : contAsset){
            Financial_Application_Asset__c finAppAssetToInsert = new Financial_Application_Asset__c();
            finAppAssetToInsert.Account_Number__c = pa.Account_Number__c;
            finAppAssetToInsert.Amount_of_Gift_Deposited_into_Rec_Acct__c = pa.Amount_of_Gift_Deposited_into_Rec_Acct__c;
            finAppAssetToInsert.Asset_Type__c = pa.Asset_Type__c;
            finAppAssetToInsert.Cash_or_Market_Value__c = pa.Cash_or_Market_Value__c;
            finAppAssetToInsert.Current_Cash_Value_of_Gift__c = pa.Current_Cash_Value_of_Gift__c;
            finAppAssetToInsert.Date_of_Gift_Letter__c = pa.Date_of_Gift_Letter__c;
            finAppAssetToInsert.Date_of_Most_Recent_Statement__c = pa.Date_of_Most_Recent_Statement__c;
            finAppAssetToInsert.Escrow_Account_Number__c = pa.Escrow_Account_Number__c;
            finAppAssetToInsert.Escrow_Acct_Institution_Address__c = pa.Escrow_Acct_Institution_Address__c;
            finAppAssetToInsert.Escrow_Acct_Institution_Name__c = pa.Escrow_Acct_Institution_Name__c;
            finAppAssetToInsert.Escrow_Acct_Institution_Phone_Number__c = pa.Escrow_Acct_Institution_Phone_Number__c;
            finAppAssetToInsert.Escrow_Amount_Deposited__c = pa.Escrow_Amount_Deposited__c;
            finAppAssetToInsert.Escrow_Date_of_Deposit__c = pa.Escrow_Date_of_Deposit__c;
            finAppAssetToInsert.Escrow_Type_of_Account__c = pa.Escrow_Type_of_Account__c;
            finAppAssetToInsert.Gifter_Donor_Address__c = pa.Gifter_Donor_Address__c;
            finAppAssetToInsert.Gifter_Donor_Name__c = pa.Gifter_Donor_Name__c;
            finAppAssetToInsert.Gifter_Donor_Phone_Number__c = pa.Gifter_Donor_Phone_Number__c;
            finAppAssetToInsert.Gifter_Donor_Relationship_to_Recipient__c = pa.Gifter_Donor_Relationship_to_Recipient__c;
            finAppAssetToInsert.Gift_Funds_Bank_Depository_Account__c = pa.Gift_Funds_Bank_Depository_Account__c;
            finAppAssetToInsert.Gift_Funds_Location_Address__c = pa.Gift_Funds_Location_Address__c;
            finAppAssetToInsert.Gift_Funds_Location_Phone__c = pa.Gift_Funds_Location_Phone__c;
            finAppAssetToInsert.Gift_Funds_Location_Bank_Depository_Name__c = pa.Gift_Funds_Location_Bank_Depository_Name__c;
            finAppAssetToInsert.Gift_Funds_Type_of_Account__c = pa.Gift_Funds_Type_of_Account__c;
            finAppAssetToInsert.Gift_Recipient_s_Account_Number__c = pa.Gift_Recipient_s_Account_Number__c;
            finAppAssetToInsert.Gift_Recipient_Account_Address__c = pa.Gift_Recipient_Account_Address__c;
            finAppAssetToInsert.Gift_Recipient_Account_Institution_Name__c = pa.Gift_Recipient_Account_Institution_Name__c;
            finAppAssetToInsert.GR_Acct_Inst_Date_of_Last_Statement__c = pa.GR_Acct_Inst_Date_of_Last_Statement__c;
            finAppAssetToInsert.GR_Acct_Inst_Phone__c = pa.GR_Acct_Inst_Phone__c;
            finAppAssetToInsert.GR_Acct_Most_Recent_Balance__c = pa.GR_Acct_Most_Recent_Balance__c;
            finAppAssetToInsert.Financial_Application__c = finAppId;
            finAppAssetToInsert.Financial_Application_Member__c = fMemMap.get(pa.Household_Member__c).Id;
            //finAppAssetToInsert.Institution_Address__c = pa.Institution_Address__c;
            //finAppAssetToInsert.Institution_Phone_Number__c = pa.Institution_Phone_Number__c;
            finAppAssetToInsert.Most_Recent_Balance__c = pa.Most_Recent_Balance__c;
            finAppAssetToInsert.Name_of_Institution__c = pa.Name_of_Institution__c;
            finAppAssetToInsert.Relationship_if_Other__c = pa.Relationship_if_Other__c;
            finAppAssetToInsert.Settlement_or_Other_Description__c = pa.Settlement_or_Other_Description__c;
            finAppAssetToInsert.Stock_Bond_Description__c = pa.Stock_Bond_Description__c;
            finAppAssetToInsert.Total_Cash_Not_Deposited_in_Any_Account__c = pa.Total_Cash_Not_Deposited_in_Any_Account__c;
            finAppAssetToInsert.Withdrawn_From_Acct_Inst_Account_Number__c = pa.Withdrawn_From_Acct_Inst_Account_Number__c;
            finAppAssetToInsert.Withdrawn_From_Acct_Inst_Address__c = pa.Withdrawn_From_Acct_Inst_Address__c;
            finAppAssetToInsert.Withdrawn_From_Acct_Inst_Name__c = pa.Withdrawn_From_Acct_Inst_Name__c;
            finAppAssetToInsert.Withdrawn_From_Acct_Inst_Phone__c = pa.Withdrawn_From_Acct_Inst_Phone__c;
            
            finAppAssetToInsert.Is_this_a_joint_account__c = pa.Is_this_a_joint_account__c;
            finAppAssetToInsert.Name_of_joint_account_holders__c = pa.Name_of_joint_account_holders__c;
            finAppAssetToInsert.Gift_Funds_Type_Other_description__c = pa.Gift_Funds_Type_Other_description__c;

            finAppAssetList.add(finAppAssetToInsert);



    
        }
        
        return finAppAssetList;


    }

    public static List<Financial_Application_Income__c> createfinAppIncome(String accId, String finAppId){
        List<Financial_Application_Income__c> finAppIncomeList = new List<Financial_Application_Income__c>();
        List<Contact> contactId = [SELECT Id FROM Contact WHERE AccountId = :accId];
        List<Financial_Application_Member__c> finAppMem = [SELECT Id, ContactId__c FROM Financial_Application_Member__c WHERE Financial_Application__c = :finAppId];

        Map<String, Financial_Application_Member__c> fMemMap = new Map<String, Financial_Application_Member__c>();

        for (Financial_Application_Member__c fam : finAppMem) {
            fMemMap.put(fam.ContactId__c, fam);
        }


        List<Personal_Income__c> contIncome = [SELECT Annual_Commissions_Bonuses_Tips__c,
                                                      Annualized_Income__c,
                                                      Annual_Overtime__c,
                                                      Annual_Unemployment_Benefits_Amount__c,
                                                      Applicant_Self_employed__c,
                                                      Applicant_Unemployed__c,
                                                      Base_Annual_Employment_Income__c,
                                                      Child_Support_Alimony_Received_Annually__c,
                                                      Date_Of_Most_Recent_P_L_Stmt__c,
                                                      Employer_Address__c,
                                                      Employer_Name__c,
                                                      Employment_Status__c,
                                                      First_Date_of_Employment__c,
                                                      Household_Member__c,
                                                      Household_Member_Name__c,
                                                      Income_from_Land_or_Business_Annually__c,
                                                      Interest_Dividends_Received_Annually__c,
                                                      Month_Unemployed__c,
                                                      Other_Incomes_Received_Annually__c,
                                                      Pay_Amount__c,
                                                      Paycheck_1_Total_Gross_Amount__c,
                                                      Paycheck_1_Gross_Pay_Annualized__c,
                                                      Paycheck_1_Gross_Pay_Period_Average__c,
                                                      Paycheck_1_Pay_Date__c,
                                                      Paycheck_1_Period__c,
                                                      Paycheck_1_Year_To_Date_Gross_Amount__c,
                                                      Paycheck_2_Total_Gross_Amount__c,
                                                      Paycheck_2_Gross_Pay_Annualized__c,
                                                      Paycheck_2_Gross_Pay_Period_Average__c,
                                                      Paycheck_2_Pay_Date__c,
                                                      Paycheck_2_Period__c,
                                                      Paycheck_2_Year_To_Date_Gross_Amount__c,
                                                      Paycheck_3_Total_Gross_Amount__c,
                                                      Paycheck_3_Gross_Pay_Annualized__c,
                                                      Paycheck_3_Gross_Pay_Period_Average__c,
                                                      Paycheck_3_Pay_Date__c,
                                                      Paycheck_3_Period__c,
                                                      Paycheck_3_Year_To_Date_Gross_Amount__c,
                                                      Pay_Date__c,
                                                      Pay_Period_Frequency__c,
                                                      Most_Recent_Profit_or_Loss_Amount__c,
                                                      Most_Recent_Profit_or_Loss_Status__c,
                                                      Public_Assistance_Received_Annually__c,
                                                      Self_Employment_Starting_Month__c,
                                                      Self_Employment_Starting_Year__c,
                                                      Social_Security_Pensions_Rec_d_Annually__c,
                                                      Total_Number_of_Pay_Periods_Annually__c,
                                                      Total_Other_Income_Rec_d_Annually__c,
                                                      Year_Unemployed__c
                                                      FROM Personal_Income__c
                                                      WHERE Household_Member__c IN: contactId];

        for (Personal_Income__c pi : contIncome) {
            Financial_Application_Income__c finAppIncomeToInsert = new Financial_Application_Income__c();
            finAppIncomeToInsert.Annual_Commissions_Bonuses_Tips__c = pi.Annual_Commissions_Bonuses_Tips__c;
            finAppIncomeToInsert.Annualized_Income__c = pi.Annualized_Income__c;
            finAppIncomeToInsert.Annual_Overtime__c = pi.Annual_Overtime__c;
            finAppIncomeToInsert.Applicant_Self_employed__c = pi.Applicant_Self_employed__c;
            finAppIncomeToInsert.Applicant_Unemployed__c = pi.Applicant_Unemployed__c;
            finAppIncomeToInsert.Base_Annual_Employment_Income__c = pi.Base_Annual_Employment_Income__c;
            finAppIncomeToInsert.Child_Support_Alimony_Received_Annually__c = pi.Child_Support_Alimony_Received_Annually__c;
            finAppIncomeToInsert.Date_Of_Most_Recent_P_L_Stmt__c = pi.Date_Of_Most_Recent_P_L_Stmt__c;
            finAppIncomeToInsert.Employer_Address__c = pi.Employer_Address__c;
            finAppIncomeToInsert.Employer_Name__c = pi.Employer_Name__c;
            finAppIncomeToInsert.Employment_Status__c = pi.Employment_Status__c;
            finAppIncomeToInsert.First_Date_of_Employment__c = pi.First_Date_of_Employment__c;
            finAppIncomeToInsert.Financial_Application__c = finAppId;
            finAppIncomeToInsert.Financial_Application_Member__c = fMemMap.get(pi.Household_Member__c).Id;
            finAppIncomeToInsert.Income_from_Land_or_Business_Annually__c = pi.Income_from_Land_or_Business_Annually__c;
            finAppIncomeToInsert.Interest_Dividends_Received_Annually__c = pi.Interest_Dividends_Received_Annually__c;
            finAppIncomeToInsert.Month_Unemployed__c = pi.Month_Unemployed__c;
            finAppIncomeToInsert.Other_Incomes_Received_Annually__c = pi.Other_Incomes_Received_Annually__c;
            finAppIncomeToInsert.Pay_Amount__c = pi.Pay_Amount__c;
            finAppIncomeToInsert.Paycheck_1_Total_Gross_Amount__c = pi.Paycheck_1_Total_Gross_Amount__c;
            finAppIncomeToInsert.Paycheck_1_Pay_Date__c = pi.Paycheck_1_Pay_Date__c;
            finAppIncomeToInsert.Paycheck_1_Period__c = pi.Paycheck_1_Period__c;
            finAppIncomeToInsert.Paycheck_1_Year_To_Date_Gross_Amount__c = pi.Paycheck_1_Year_To_Date_Gross_Amount__c;
            finAppIncomeToInsert.Paycheck_2_Total_Gross_Amount__c = pi.Paycheck_2_Total_Gross_Amount__c;
            finAppIncomeToInsert.Paycheck_2_Pay_Date__c = pi.Paycheck_2_Pay_Date__c;
            finAppIncomeToInsert.Paycheck_2_Period__c = pi.Paycheck_2_Period__c;
            finAppIncomeToInsert.Paycheck_2_Year_To_Date_Gross_Amount__c = pi.Paycheck_2_Year_To_Date_Gross_Amount__c;
            finAppIncomeToInsert.Paycheck_3_Total_Gross_Amount__c = pi.Paycheck_3_Total_Gross_Amount__c;
            finAppIncomeToInsert.Paycheck_3_Pay_Date__c = pi.Paycheck_3_Pay_Date__c;
            finAppIncomeToInsert.Paycheck_3_Period__c = pi.Paycheck_3_Period__c;
            finAppIncomeToInsert.Paycheck_3_Year_To_Date_Gross_Amount__c = pi.Paycheck_3_Year_To_Date_Gross_Amount__c;
            finAppIncomeToInsert.Pay_Date__c = pi.Pay_Date__c;
            finAppIncomeToInsert.Pay_Period_Frequency__c = pi.Pay_Period_Frequency__c;
            finAppIncomeToInsert.Most_Recent_Profit_or_Loss_Amount__c = pi.Most_Recent_Profit_or_Loss_Amount__c;
            finAppIncomeToInsert.Most_Recent_Profit_or_Loss_Status__c = pi.Most_Recent_Profit_or_Loss_Status__c;
            finAppIncomeToInsert.Public_Assistance_Received_Annually__c = pi.Public_Assistance_Received_Annually__c;
            finAppIncomeToInsert.Self_Employment_Starting_Month__c = pi.Self_Employment_Starting_Month__c;
            finAppIncomeToInsert.Self_Employment_Starting_Year__c = pi.Self_Employment_Starting_Year__c;
            finAppIncomeToInsert.Social_Security_Pensions_Rec_d_Annually__c = pi.Social_Security_Pensions_Rec_d_Annually__c;
            finAppIncomeToInsert.Total_Number_of_Pay_Periods_Annually__c = pi.Total_Number_of_Pay_Periods_Annually__c;
            finAppIncomeToInsert.Year_Unemployed__c = pi.Year_Unemployed__c;
            
            finAppIncomeToInsert.Annual_Unemployment_Benefits_Amount__c = pi.Annual_Unemployment_Benefits_Amount__c;

            finAppIncomeList.add(finAppIncomeToInsert);
            
        }

        return finAppIncomeList;

    }
    
    public static Map<ID,Lottery_Preference__c> prefMap {
    	get {
    		if (prefMap == null) {
	    		prefMap = getPreferences();
	    	}
	    	return prefMap;
    	}
    	set;
    }
    
    public static Map<ID,Lottery_Preference__c> getPreferences() {
		
		return new Map<ID, Lottery_Preference__c> ([Select id, Auto_Grants_Preference__c From Lottery_Preference__c ]);
	}

}