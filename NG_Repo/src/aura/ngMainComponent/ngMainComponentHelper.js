({
    loadList: function(component) {
        const action = component.get("c.allImages");
        const nameFilterString = component.find("nameFilter").get("v.value");
        action.setParams({
            nameFilterString: nameFilterString
        });
        action.setCallback(this, function(a) {
            component.set("v.images", a.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})