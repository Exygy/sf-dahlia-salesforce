global class LOT_RandomDrawBatch implements Database.Batchable<String>, Database.Stateful {
    
    List<String> winnerList;
    Map<String,ID> entities;
    global Integer rank;
    Id listingId;
    
    global LOT_RandomDrawBatch(List<String> winnerList, Map<String,ID> entities, Id listingId) {
        this.winnerList = winnerList;
        this.entities = entities;
        this.listingId = listingId;
        this.rank = 0;
    }
    
    global Iterable<String> start(Database.BatchableContext BC){
        return winnerList;
    }
    
    global void execute(Database.BatchableContext BC, List<String> winnerList){
    	calculateRank(winnerList);
    }
    
    global void finish(Database.BatchableContext BC){
    	  LOT_RandomDrawService.calculateLotteryRanks(listingId);
    	
        //LOT_RandomDrawService.preferenceLottery(listingId);
    }
    
    public void calculateRank(List<String> winnerList){
		List<Application__c> appRankList= new List<Application__c> ();
		for (String winnerName : winnerList) {
			ID theID = entities.get(winnerName);
			Application__c app = new Application__c();
			app.id = theID;
			rank++;
			app.Lottery_Rank__c = rank; 
			
			appRankList.add(app);
			
		}
		update appRankList;
	}
}