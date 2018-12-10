({
	/*********Success Toast************/
    showToast : function(type, message) {
        console.log('hello toast');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type, 
            "key" : "action:announcement", 
            "message": message
        });
        toastEvent.fire();
	}
})