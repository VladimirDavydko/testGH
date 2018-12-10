/****************************************************************
* This class is used to parse the Greenhouse Applications.
* Code Written by: Ajay Kumar
* on Date : 10/13/2018 3:38 AM
* Last Modified By Ajay Kumar ,  10/13/2018 4:00 AM
*****************************************************************/

public class greenhouseApplication {

        public String id {get;set;} 
        public String candidate_id {get;set;} 
        public Boolean prospect {get;set;} 
        public String applied_at {get;set;} 
        public String rejected_at {get;set;} 
        public String last_activity_at {get;set;} 
        public Location location {get;set;} 
        public Source source {get;set;} 
        public Credited_to credited_to {get;set;} 
        //public String rejection_reason {get;set;} 
        //public String rejection_details {get;set;} 
        public List<Jobs> jobs {get;set;} 
        public String status {get;set;} 
        public Jobs current_stage {get;set;} 
        public List<Answers> answers {get;set;} 
        public Prospect_detail prospect_detail {get;set;} 
        public Custom_fields custom_fields {get;set;} 
        public Keyed_custom_fields keyed_custom_fields {get;set;} 
        public map<String,String> fieldName=new map<String,String>();
        
        public GreenhouseApplication(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                            fieldName.put(text,parser.getText());
                        } else if (text == 'candidate_id') {
                            candidate_id = parser.getText();
                            fieldName.put(text,parser.getText());
                        } else if (text == 'prospect') {
                            prospect = parser.getBooleanValue();
                            fieldName.put(text,parser.getText());
                        } else if (text == 'applied_at') {
                            applied_at = parser.getText();
                            fieldName.put(text,parser.getText());
                        } else if (text == 'rejected_at') {
                            rejected_at = parser.getText();
                            fieldName.put(text,parser.getText());
                        } else if (text == 'last_activity_at') {
                            last_activity_at = parser.getText();
                        } else if (text == 'location') {
                            location = new Location(parser);
                            fieldName.put(text,parser.getText());
                        } else if (text == 'source') {
                            source = new Source(parser);
                        } else if (text == 'credited_to') {
                            credited_to = new Credited_to(parser);
                        } /*else if (text == 'rejection_reason') {
                            rejection_reason = parser.getText();
                        } else if (text == 'rejection_details') {
                            rejection_details = parser.getText();
                        }*/ else if (text == 'jobs') {
                            jobs = arrayOfJobs(parser);
                        } else if (text == 'status') {
                            fieldName.put(text,parser.getText());
                            status = parser.getText();
                        } else if (text == 'current_stage') {
                            current_stage = new Jobs(parser);
                        } else if (text == 'answers') {
                            answers = arrayOfAnswers(parser);
                        } else if (text == 'prospect_detail') {
                            prospect_detail = new Prospect_detail(parser);
                        } else if (text == 'custom_fields') {
                            custom_fields = new Custom_fields(parser);
                        } else if (text == 'keyed_custom_fields') {
                            keyed_custom_fields = new Keyed_custom_fields(parser);
                        } 
                    }
                }
            }
        }
    
    
    public class Credited_to {
        public String id {get;set;} 
        public String first_name {get;set;} 
        public String last_name {get;set;} 
        public String name {get;set;} 
        public String employee_id {get;set;} 

        public Credited_to(JSONParser parser) {
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
                        }
                    }
                }
            }
        }
    }
    
    public class Keyed_custom_fields {
        public Application_custom_test application_custom_test {get;set;} 

        public Keyed_custom_fields(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'application_custom_test') {
                            application_custom_test = new Application_custom_test(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Answers {
        public String question {get;set;} 
        public String answer {get;set;} 
        public map<string,string> fieldValmap=new map<string,string>();
        public Answers(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    fieldValmap.put(text,parser.getText());
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'question') {
                            question = parser.getText();
                        } else if (text == 'answer') {
                            answer = parser.getText();
                        } 
                    }
                }
            }
        }
    }
    
    public class Jobs {
        public String id {get;set;} 
        public String name {get;set;} 

        public Jobs(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } 
                    }
                }
            }
        }
    }
    
    public class Prospect_detail_Z {
        public Jobs prospect_pool {get;set;} 
        public Jobs prospect_stage {get;set;} 
        public Jobs prospect_owner {get;set;} 

        public Prospect_detail_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'prospect_pool') {
                            prospect_pool = new Jobs(parser);
                        } else if (text == 'prospect_stage') {
                            prospect_stage = new Jobs(parser);
                        } else if (text == 'prospect_owner') {
                            prospect_owner = new Jobs(parser);
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
                            prospect_stage =parser.getText();
                        } else if (text == 'prospect_owner') {
                            prospect_owner = parser.getText();
                        } 
                    }
                }
            }
        }
    }
    
    public class Custom_fields {
       public list<String> name=new list<String>();
       public map<string,string> fieldValmap=new map<string,string>();
        public Custom_fields(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                       
                        //parser.nextToken() ;
                       // value=value+','+parser.getText();
                        //System.debug(LoggingLevel.WARN, 'Custom_fields consuming unrecognized property: '+text);
                        //consumeObject(parser);
                        
                    }
                    fieldValmap.put(text,parser.getText());
                    name.add(text);
                }
            }
        }
    }
    
    public class Application_custom_test {
        public String name {get;set;} 
        public String type_Z {get;set;} // in json: type
        public String value {get;set;} 

        public Application_custom_test(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
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
                        }
                    }
                }
            }
        }
    }
    
    public class Location {
        public String address {get;set;} 

        public Location(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'address') {
                            address = parser.getText();
                        } 
                    }
                }
            }
        }
    }
    
    
    public static List<GreenhouseApplication> parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfGreenhouseApplication(parser);
    }
    
    
    private static List<GreenhouseApplication> arrayOfGreenhouseApplication(System.JSONParser p) {
        List<GreenhouseApplication> res = new List<GreenhouseApplication>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new GreenhouseApplication(p));
        }
        return res;
    }

    private static List<Answers> arrayOfAnswers(System.JSONParser p) {
        List<Answers> res = new List<Answers>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Answers(p));
        }
        return res;
    }

    private static List<Jobs> arrayOfJobs(System.JSONParser p) {
        List<Jobs> res = new List<Jobs>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Jobs(p));
        }
        return res;
    }

}