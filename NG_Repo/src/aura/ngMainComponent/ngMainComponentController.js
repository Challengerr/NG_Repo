({
    init: function(component, event, helper) {
        helper.loadList(component);
    },
    handleClickImageSearch: function (component, event, helper) {
        const target = event.currentTarget;
        const sfid = target.dataset.sfid;

        var navigateEvent = $A.get("e.force:navigateToSObject");
        navigateEvent.setParams({
            "recordId": sfid
        });
        navigateEvent.fire();
    },
    handleNameFilterChange: function (component, event, helper) {
        try {
            helper.loadList(component);
        } catch (e) {
            console.log("cos nie tak:  " + e);
        }
    },

    selectoptionvalue: function(component, event, helper) {
        try {
            var selected = [], checkboxes = component.find("checkbox");

            if(!checkboxes) {
                checkboxes = [];
            } else if(!checkboxes.length) {
                checkboxes = [checkboxes];
            }
            checkboxes
                .filter(checkbox => checkbox.get("v.value"))
                .forEach(checkbox => selected.push(checkbox.get("v.label")));
            component.set("v.selectedImages", selected);

        } catch (e) {
            console.log("cos nie tak:  " + e);
        }
    },

    handleEmailSend: function (component, event, helper) {
        try {
            let listToSEnd = component.get("v.selectedImages");
            let emailTo = component.find("definedEmail").get("v.value");
            if(listToSEnd.length > 0) {

                var action = component.get("c.sendEmailToPatient");

                action.setParams({
                    emailTo: emailTo,
                    listToSend: component.get("v.selectedImages")
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        // cmp.set("v.selectedRows", []);
                        //                         // cmp.set("v.data", data);
                    }
                });
                console.log("email to:  " + emailTo);
                if(emailTo != null) {
                    $A.enqueueAction(action);
                }

                // return component.sendEmailFinal(emailTo, listToSEnd);
                // var oppt = component.get("c.sendEmailToPatient");
                //
                // oppt.setCallback(this, function(response){
                //     var state = response.getState();
                //     if(state === 'SUCCESS'){
                //         component.set("v.opplistAttr", response.getReturnValue());
                //     }
                // });
                // $A.enqueueAction(oppt);

            }
        } catch (e) {
            console.log("cos nie tak:  " + e);
        }

    }
})