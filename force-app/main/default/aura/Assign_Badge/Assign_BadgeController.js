({
	handleAssign: function (component, event, helper) {
		helper.checkBadge(component, event, helper);
	},
	closeModal: function (component, event, helper) {
		component.set("v.openModal", false);
	},
	createBadgeAssigment: function (component, event, helper) {
		helper.createBadgeAssignment(component, event, helper);
	}
})