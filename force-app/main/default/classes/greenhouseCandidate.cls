public class greenhouseCandidate{

    public class Type_Z {
        public String id {get;set;} 
        public String name {get;set;} 

        public Type_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Type_Z consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public String id {get;set;} 
    public String first_name {get;set;} 
    public String last_name {get;set;} 
    public String company {get;set;} 
    public String title {get;set;} 
    public String created_at {get;set;} 
    public String updated_at {get;set;} 
    public String last_activity {get;set;} 
    public Boolean is_private {get;set;} 
    public String photo_url {get;set;} 
    public List<Attachments> attachments {get;set;} 
    public List<String> application_ids {get;set;} 
    public List<Phone_numbers> phone_numbers_Z {get;set;} 
    public List<Addresses> addresses {get;set;} 
    public List<Phone_numbers> email_addresses {get;set;} 
    public List<Addresses> website_addresses {get;set;} 
    public List<Addresses> social_media_addresses {get;set;} 
    public Recruiter recruiter {get;set;} 
    public Recruiter coordinator {get;set;} 
    public List<String> tags {get;set;} 
    public List<Applications> applications {get;set;} 
    public List<Addresses> educations {get;set;} 
    public List<Addresses> employments {get;set;} 
    public Custom_fields custom_fields {get;set;} 
    public Keyed_custom_fields keyed_custom_fields {get;set;} 
    public map<String,String> fieldName=new map<String,String>();
    
    public greenhouseCandidate(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'id') {
                        fieldName.put(text,parser.getText());
                        id =parser.getText();
                    } else if (text == 'first_name') {
                        first_name = parser.getText();
                        fieldName.put(text,parser.getText());
                    } else if (text == 'last_name') {
                        last_name = parser.getText();
                        fieldName.put(text,parser.getText());
                    } else if (text == 'company') {
                        company = parser.getText();
                    } else if (text == 'title') {
                        title = parser.getText();
                        fieldName.put(text,parser.getText());
                    } else if (text == 'created_at') {
                        created_at = parser.getText();
                        fieldName.put(text,parser.getText());
                    } else if (text == 'updated_at') {
                        updated_at = parser.getText();
                        fieldName.put(text,parser.getText());
                    } else if (text == 'last_activity') {
                        last_activity = parser.getText();
                        fieldName.put(text,parser.getText());
                    } else if (text == 'is_private') {
                        is_private = parser.getBooleanValue();
                        fieldName.put(text,parser.getText());
                    } else if (text == 'photo_url') {
                        photo_url = parser.getText();
                        fieldName.put(text,parser.getText());
                    } else if (text == 'attachments') {
                        attachments = arrayOfAttachments(parser);
                    } else if (text == 'application_ids') {
                        application_ids = arrayOfLong(parser);
                    } else if (text == 'phone_numbers') {
                        phone_numbers_z = arrayOfPhone_numbers(parser);
                    } else if (text == 'addresses') {
                        addresses = arrayOfAddresses(parser);
                    } else if (text == 'email_addresses') {
                        email_addresses = arrayOfPhone_numbers(parser);
                    } else if (text == 'website_addresses') {
                        website_addresses = arrayOfAddresses(parser);
                    } else if (text == 'social_media_addresses') {
                        social_media_addresses = arrayOfAddresses(parser);
                    } else if (text == 'recruiter') {
                        recruiter = new Recruiter(parser);
                    } else if (text == 'coordinator') {
                        coordinator = new Recruiter(parser);
                    } else if (text == 'tags') {
                        tags = arrayOfString(parser);
                    } else if (text == 'applications') {
                        applications = arrayOfApplications(parser);
                    } else if (text == 'educations') {
                        educations = arrayOfAddresses(parser);
                    } else if (text == 'employments') {
                        employments = arrayOfAddresses(parser);
                    } else if (text == 'custom_fields') {
                        custom_fields = new Custom_fields(parser);
                    } else if (text == 'keyed_custom_fields') {
                       parser.skipchildren();
                       // keyed_custom_fields = new Keyed_custom_fields(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        ////consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Keyed_custom_fields_Z {
       
        public map<string,string> fieldValmap=new map<string,string>();
        public Keyed_custom_fields_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                   fieldValmap.put(text,parser.getText());
                }
            }
        }
    }
    
    public class Applications {
        public String id {get;set;} 
        public String candidate_id {get;set;} 
        public Boolean prospect {get;set;} 
        public String applied_at {get;set;} 
        public String rejected_at {get;set;} 
        public String last_activity_at {get;set;} 
        public String location {get;set;} 
        public Source source {get;set;} 
        public String credited_to {get;set;} 
        public Rejection_reason rejection_reason {get;set;} 
        public Addresses rejection_details {get;set;} 
        public List<Type_Z> jobs {get;set;} 
        public String status {get;set;} 
        public Type_Z current_stage {get;set;} 
        public List<Addresses> answers {get;set;} 
        public Prospect_detail prospect_detail {get;set;} 

        public Applications(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'candidate_id') {
                            candidate_id = parser.getText();
                        } else if (text == 'prospect') {
                            prospect = parser.getBooleanValue();
                        } else if (text == 'applied_at') {
                            applied_at = parser.getText();
                        } else if (text == 'rejected_at') {
                            rejected_at = parser.getText();
                        } else if (text == 'last_activity_at') {
                            last_activity_at = parser.getText();
                        } else if (text == 'location') {
                            location = parser.getText();
                        } else if (text == 'source') {
                            source = new Source(parser);
                        } else if (text == 'credited_to') {
                            credited_to = parser.getText();
                        } else if (text == 'rejection_reason') {
                            rejection_reason = new Rejection_reason(parser);
                        } else if (text == 'rejection_details') {
                            rejection_details = new Addresses(parser);
                        } else if (text == 'jobs') {
                            jobs = arrayOfType_Z(parser);
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'current_stage') {
                            current_stage = new Type_Z(parser);
                        } else if (text == 'answers') {
                            answers = arrayOfAddresses(parser);
                        } else if (text == 'prospect_detail') {
                            prospect_detail = new Prospect_detail(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Applications consuming unrecognized property: '+text);
                            ////consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Custom_fields {
        public map<string,string> fieldValmap=new map<string,string>();

        public Custom_fields(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                String text;
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    text = parser.getText();
                     if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                         fieldValmap.put(text,parser.getText());
                     }
                    
                 }
                 
            }
        }
    }
    
    public class Attachments {
        public String filename {get;set;} 
        public String url {get;set;} 
        public String type_Z {get;set;} // in json: type

        public Attachments(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'filename') {
                            filename = parser.getText();
                        } else if (text == 'url') {
                            url = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Attachments consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Source {
        public String id {get;set;} 
        public String public_name {get;set;} 

        public Source(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'public_name') {
                            public_name = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Source consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Addresses {

        public Addresses(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Addresses consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Applications_Z {
        public String id {get;set;} 
        public String candidate_id {get;set;} 
        public Boolean prospect {get;set;} 
        public String applied_at {get;set;} 
        public String rejected_at {get;set;} 
        public String last_activity_at {get;set;} 
        public String location {get;set;} 
        public Source source {get;set;} 
        public String credited_to {get;set;} 
        public Rejection_reason rejection_reason {get;set;} 
        public Addresses rejection_details {get;set;} 
        public List<Type_Z> jobs {get;set;} 
        public String status {get;set;} 
        public Type_Z current_stage {get;set;} 
        public List<Answers_Z> answers {get;set;} 
        public Prospect_detail prospect_detail {get;set;} 

        public Applications_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'candidate_id') {
                            candidate_id = parser.getText();
                        } else if (text == 'prospect') {
                            prospect = parser.getBooleanValue();
                        } else if (text == 'applied_at') {
                            applied_at = parser.getText();
                        } else if (text == 'rejected_at') {
                            rejected_at = parser.getText();
                        } else if (text == 'last_activity_at') {
                            last_activity_at = parser.getText();
                        } else if (text == 'location') {
                            location = parser.getText();
                        } else if (text == 'source') {
                            source = new Source(parser);
                        } else if (text == 'credited_to') {
                            credited_to = parser.getText();
                        } else if (text == 'rejection_reason') {
                            rejection_reason = new Rejection_reason(parser);
                        } else if (text == 'rejection_details') {
                            rejection_details = new Addresses(parser);
                        } else if (text == 'jobs') {
                            jobs = arrayOfType_Z(parser);
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'current_stage') {
                            current_stage = new Type_Z(parser);
                        } else if (text == 'answers') {
                            answers = arrayOfAnswers_Z(parser);
                        } else if (text == 'prospect_detail') {
                            prospect_detail = new Prospect_detail(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Applications_Z consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Keyed_custom_fields {
       
        public map<string,string> fieldValmap=new map<string,string>();
        public Keyed_custom_fields(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT || parser.nextToken() !=null) {
                System.debug('parser.gettext()'+parser.gettext());
                 if(parser.getCurrentToken() == JSONTOken.START_ARRAY) {
                 System.debug('yes');
                    while(parser.nextToken() != JSONTOken.END_ARRAY || parser.nextToken() !=null) {
                        parser.skipchildren();
                    }
                 }
                 if(parser.getCurrentToken() == JSONTOken.START_OBJECT) {
                      while (parser.nextToken() != System.JSONToken.END_OBJECT || parser.nextToken() !=null) {
                        parser.skipchildren();
                      }
                 }
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    fieldValmap.put(text,parser.getText());
                }
            }
        }
    }
    
    public class Answers_Z {
        public String question {get;set;} 
        public String answer {get;set;} 

        public Answers_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'question') {
                            question = parser.getText();
                        } else if (text == 'answer') {
                            answer = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Answers_Z consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Prospect_detail {
        public String prospect_pool {get;set;} 
        public String prospect_stage {get;set;} 
        public String prospect_owner {get;set;} 

        public Prospect_detail(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'prospect_pool') {
                            prospect_pool = parser.getText();
                        } else if (text == 'prospect_stage') {
                            prospect_stage = parser.getText();
                        } else if (text == 'prospect_owner') {
                            prospect_owner = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Prospect_detail consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Custom_fields_Z {
        public map<string,string> fieldValmap=new map<string,string>();

        public Custom_fields_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    fieldValmap.put(text,parser.getText());
                }
            }
        }
    }
    
    public class Employment_authorization {
        public String name {get;set;} 
        public String type_Z {get;set;} // in json: type
        public List<String> value {get;set;} 

        public Employment_authorization(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'value') {
                            value = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Employment_authorization consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Rejection_reason {
        public String id {get;set;} 
        public String name {get;set;} 
        public Type_Z type_Z {get;set;} // in json: type

        public Rejection_reason(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'type') {
                            type_Z = new Type_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Rejection_reason consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Phone_numbers {
        public String value {get;set;} 
        public String type_Z {get;set;} // in json: type

        public Phone_numbers(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'value') {
                            value = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Phone_numbers consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Recruiter {
        public String id {get;set;} 
        public String first_name {get;set;} 
        public String last_name {get;set;} 
        public String name {get;set;} 
        public String employee_id {get;set;} 

        public Recruiter(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'first_name') {
                            first_name = parser.getText();
                        } else if (text == 'last_name') {
                            last_name = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'employee_id') {
                            employee_id = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Recruiter consuming unrecognized property: '+text);
                            //consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static List<greenhouseCandidate> parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfJSON2Apex(parser);
    }
    /*
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }*/
    

    private static List<Answers_Z> arrayOfAnswers(System.JSONParser p) {
        List<Answers_Z> res = new List<Answers_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Answers_Z(p));
        }
        return res;
    }






    private static List<Phone_numbers> arrayOfPhone_numbers(System.JSONParser p) {
        List<Phone_numbers> res = new List<Phone_numbers>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Phone_numbers(p));
        }
        return res;
    }


    private static List<Applications> arrayOfApplications(System.JSONParser p) {
        List<Applications> res = new List<Applications>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Applications(p));
        }
        return res;
    }



    private static List<greenhouseCandidate> arrayOfJSON2Apex(System.JSONParser p) {
        List<greenhouseCandidate> res = new List<greenhouseCandidate>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new greenhouseCandidate(p));
        }
        return res;
    }


    private static List<Addresses> arrayOfAddresses(System.JSONParser p) {
        List<Addresses> res = new List<Addresses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Addresses(p));
        }
        return res;
    }




    private static List<Type_Z> arrayOfType_Z(System.JSONParser p) {
        List<Type_Z> res = new List<Type_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Type_Z(p));
        }
        return res;
    }


    private static List<Attachments> arrayOfAttachments(System.JSONParser p) {
        List<Attachments> res = new List<Attachments>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Attachments(p));
        }
        return res;
    }


    private static List<Answers_Z> arrayOfAnswers_Z(System.JSONParser p) {
        List<Answers_Z> res = new List<Answers_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Answers_Z(p));
        }
        return res;
    }


    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }


    private static List<String> arrayOfLong(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }


    private static List<Applications_Z> arrayOfApplications_Z(System.JSONParser p) {
        List<Applications_Z> res = new List<Applications_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Applications_Z(p));
        }
        return res;
    }

}