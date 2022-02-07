({

	getSchedule : function(component, event, helper){

	// assign a method from Apex Controller to variable in JavaScript controller
		var getListOfPossibleSchedules = component.get("c.getSchedules");

	// prepare the table pool
		component.set("v.Columns",[
			{label:"Name", fieldName:"Name", type:"text"},
			{label:"Departure Date", fieldName:"Departure_date__c", type:"text"},
			{label:"Arrival Date", fieldName:"Arrival_date__c", type:"text"},
			{label:"Route", fieldName:"Route__c", type:"text"},
			{label:"Vessel", fieldName:"Vessel__c", type:"text"}
		]);

	// send the parameters from attributes to Apex Controller method
		getListOfPossibleSchedules.setParams({
			startDate: component.get("v.scheduleStartDate"),
			endDate: component.get("v.scheduleEndDate"),
			departure: String(component.get("v.departurePort")),
			arrival: String(component.get("v.arrivalPort"))
		});

	// return the result of Apex Controller method and change the boolean value to display table
		getListOfPossibleSchedules.setCallback(this, function(data) {
			component.set("v.Schedule", data.getReturnValue());
			component.set("v.isTableReady", "True")
		});
		$A.enqueueAction(getListOfPossibleSchedules);
	},

	onSelectedSchedule : function (component, event, helper){

		var selectedRows = event.getParam('selectedRows');

		component.set("v.isScheduleSelected", "true");
		component.set("v.selectedSchedule", selectedRows[0].Id);
		console.log(selectedRows[0].Id);
	},

	createBooking : function (component, event, helper){
		$A.get("e.force:closeQuickAction").fire();
		$A.get("e.force:refreshView").fire();
	}


})