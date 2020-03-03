public with sharing class ParticipantsController {
    private ApexPages.StandardSetController standardController;

    public ParticipantsController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
    }

    public PageReference updateParticipants(){       
        return standardController.save();   
    }
}