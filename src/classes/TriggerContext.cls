public class TriggerContext {

    public static boolean gateway = true;
    public static boolean AutoGrantPreLotteryGateway = true;

    public static Boolean shouldRun() {
        if(gateway) {
            gateway = false;
            return true;
        }
        else return gateway;
    }
    
    public static Boolean shouldAutoGrantRun() {
        if(AutoGrantPreLotteryGateway) {
            AutoGrantPreLotteryGateway = false;
            return true;
        }
        else return AutoGrantPreLotteryGateway;
    }
}