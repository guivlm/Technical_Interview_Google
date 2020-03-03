(
    {
        checkBadge: function (component, event, helper) {

            const MESSAGES = {
                'INVALID': 'The number inserted is not a valid Badge Number.',
                'CREATED': 'Badge Assignment record created successfully!'
            };

            const TOAST = {
                'SUCCESS': { LABEL: "Success", VARIANT: "success", MODE: "dismissable" },
                'ERROR': { LABEL: "Error", VARIANT: "error", MODE: "dismissable" },
                'WARNING': { LABEL: "Warning", VARIANT: "warning", MODE: "dismissable" },
            };

            let params = {
                badgeNumber: component.get('v.badgeNumber'),
                contactId: component.get('v.recordId')
            };

            component.set('v.disableButton', true);
            let action = component.get('c.validateBadgeRecord');
            action.setParams(params);

            action.setCallback(this, function (response) {

                let state = response.getState();

                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();

                    if (result.includes('Warning')) {
                        component.set('v.openModal', true);
                        component.set('v.badgeId', result.substring(0, 18));

                    } else if (result === 'Invalid') {
                        this.showToast(TOAST.ERROR, MESSAGES.INVALID);
                    } else {
                        this.showToast(TOAST.SUCCESS, MESSAGES.CREATED);
                        this.refreshPage();
                    }

                } else {
                    this.showToast(TOAST.ERROR, state);
                }
                component.set('v.disableButton', false);
            });
            $A.enqueueAction(action);
        },
        createBadgeAssignment: function (component, event, helper) {

            const MESSAGES = {
                'INVALID': 'The number inserted is not a valid Badge Number.',
                'CREATED': 'Badge Assignment record created successfully!'
            };

            const TOAST = {
                'SUCCESS': { LABEL: "Success", VARIANT: "success", MODE: "dismissable" },
                'ERROR': { LABEL: "Error", VARIANT: "error", MODE: "sticky" },
                'WARNING': { LABEL: "Warning", VARIANT: "warning", MODE: "dismissable" },
            };

            let params = {
                badgeId: component.get('v.badgeId'),
                contactId: component.get('v.recordId')
            };
            component.set('v.disableButton', true);
            let action = component.get('c.createBadgeAssignment');
            action.setParams(params);

            action.setCallback(this, function (response) {

                let state = response.getState();

                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();
                    if (result === 'Created') {
                        this.showToast(TOAST.SUCCESS, MESSAGES.CREATED);
                        this.refreshPage();
                    }
                } else {
                    this.showToast(TOAST.ERROR, state);
                }
            });
            $A.enqueueAction(action);
        },

        showToast: function (toastParams, toastMessage) {
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": toastParams.LABEL,
                "message": toastMessage,
                "type": toastParams.VARIANT,
                "mode": toastParams.MODE
            });
            toastEvent.fire();
        },
        refreshPage: function () {
            setTimeout(function () {
                window.location.reload(1);
            }, 500);
        }
    })