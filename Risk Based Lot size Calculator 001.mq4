//+------------------------------------------------------------------+
//|                                      RiskBasedLotSizeCalculator.mq4|
//|          Script to Calculate Optimal Lot Size for Risk Management |
//+------------------------------------------------------------------+
#property strict

// Input parameters
input double AccountRiskPercent = 1.0; // Risk percentage per trade
input double StopLossPips = 50;       // Stop loss in pips
input string TargetSymbol = "";       // Symbol (empty = current chart symbol)

//+------------------------------------------------------------------+
//| Main Function                                                   |
//+------------------------------------------------------------------+
void OnStart()
{
   // Determine the symbol
   string symbol = (TargetSymbol == "") ? Symbol() : TargetSymbol;

   // Validate StopLossPips
   if (StopLossPips <= 0) {
      Print("Stop loss distance must be greater than 0.");
      return;
   }

   // Validate AccountRiskPercent
   if (AccountRiskPercent <= 0 || AccountRiskPercent > 100) {
      Print("Risk percentage must be between 0 and 100.");
      return;
   }

   // Get account balance
   double accountBalance = AccountBalance();
   if (accountBalance <= 0) {
      Print("Invalid account balance.");
      return;
   }

   // Get symbol properties
   double lotStep = MarketInfo(symbol, MODE_LOTSTEP);
   double minLot = MarketInfo(symbol, MODE_MINLOT);
   double maxLot = MarketInfo(symbol, MODE_MAXLOT);
   double tickValue = MarketInfo(symbol, MODE_TICKVALUE);
   double point = MarketInfo(symbol, MODE_POINT);

   if (tickValue <= 0 || lotStep <= 0) {
      Print("Unable to retrieve symbol properties.");
      return;
   }

   // Calculate risk in currency
   double riskAmount = (AccountRiskPercent / 100.0) * accountBalance;
   double stopLossValue = StopLossPips * point;
   double lotSize = riskAmount / (stopLossValue / tickValue);

   // Adjust lot size to broker constraints
   lotSize = NormalizeDouble(MathFloor(lotSize / lotStep) * lotStep, 2);
   if (lotSize < minLot) lotSize = minLot;
   if (lotSize > maxLot) lotSize = maxLot;

   // Output result
   Print("Calculated Lot Size: ", lotSize);
   Print("Symbol: ", symbol);
   Print("Account Balance: ", accountBalance);
   Print("Risk Amount: ", riskAmount);
   Print("Stop Loss (Pips): ", StopLossPips);
   Print("Tick Value: ", tickValue);
   Print("Lot Step: ", lotStep);
   Print("Minimum Lot: ", minLot);
   Print("Maximum Lot: ", maxLot);
}
