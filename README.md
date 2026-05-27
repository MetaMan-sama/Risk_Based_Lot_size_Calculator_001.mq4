# 🎯 Risk-Based Lot Size Calculator — `Risk_Based_Lot_size_Calculator_001.mq4`

> **MQL4 Script for MetaTrader 4**  
> Computes the mathematically correct lot size for any trade based on account balance, risk percentage, and stop loss distance — fully normalized to broker constraints.

---

## Overview

This script is a streamlined, focused tool for the single most important calculation in trading: **how large should my position be?**

It takes three inputs — your account risk percentage, your stop loss in pips, and your target symbol — and outputs the precise lot size that limits your risk to exactly the percentage specified. The result is automatically adjusted to respect your broker's lot step, minimum, and maximum constraints.

Every calculation result is printed to the MT4 Experts log so you always have a record of the trade sizing decision.

---

## How It Works

**Core Formula:**

```
riskAmount     = (AccountRiskPercent / 100) × AccountBalance
stopLossValue  = StopLossPips × Point
lotSize        = riskAmount / (stopLossValue / tickValue)
```

**Broker Normalization:**

```
lotSize = floor(lotSize / lotStep) × lotStep
lotSize = max(lotSize, minLot)
lotSize = min(lotSize, maxLot)
```

This ensures the output is always a valid lot size that your broker will accept.

**Input Validation:**

The script validates all inputs before calculating:
- `StopLossPips` must be > 0
- `AccountRiskPercent` must be between 0 and 100
- Account balance must be positive
- Symbol data (tick value, lot step) must be retrievable

If any check fails, a descriptive error is printed and the script exits cleanly.

---

## Input Parameters

| Parameter | Default | Type | Description |
|---|---|---|---|
| `AccountRiskPercent` | `1.0` | double | Percentage of balance to risk per trade |
| `StopLossPips` | `50` | double | Stop loss distance in pips |
| `TargetSymbol` | `""` | string | Symbol to calculate for (empty = current chart symbol) |

---

## Example Output

```
Calculated Lot Size: 0.20
Symbol: EURUSD
Account Balance: 10000.00
Risk Amount: 100.00
Stop Loss (Pips): 50
Tick Value: 1.00
Lot Step: 0.01
Minimum Lot: 0.01
Maximum Lot: 100.00
```

---

## Worked Examples

**Example 1: $10,000 account, 1% risk, 50-pip stop on EURUSD**
```
riskAmount    = 1% × $10,000 = $100
stopLossValue = 50 × 0.00001 = 0.0005
lotSize       = $100 / ($0.0005 / $1.00) = 0.20 lots
```
→ **0.20 lots** — risks exactly $100 if the trade hits the 50-pip stop loss.

**Example 2: $5,000 account, 2% risk, 30-pip stop on GBPUSD**
```
riskAmount    = 2% × $5,000 = $100
stopLossValue = 30 × 0.00001 = 0.0003
lotSize       = $100 / ($0.0003 / $1.00) ≈ 0.33 lots → normalized to 0.33
```

---

## Risk Percentage Reference

| Risk % | $1,000 Account | $5,000 Account | $10,000 Account |
|---|---|---|---|
| 0.5% | $5 | $25 | $50 |
| 1.0% | $10 | $50 | $100 |
| 2.0% | $20 | $100 | $200 |
| 3.0% | $30 | $150 | $300 |

**Professional guideline:** Keep risk per trade between **0.5% and 2%** of account balance. Exceeding 3% significantly accelerates drawdown probability.

---

## Difference from `Position_Sizing_tool_001.mq4`

| Feature | Risk Calculator | Position Sizing Tool |
|---|---|---|
| ATR adjustment | ❌ No | ✅ Yes |
| Margin validation | ❌ No | ✅ Yes |
| Leverage input | ❌ No | ✅ Yes |
| Output focus | Lot size only | Full diagnostic report |
| Complexity | Simple, fast | Advanced |

Use this script when you need a **quick, clean calculation**. Use `Position_Sizing_tool_001.mq4` when you need full diagnostic validation including margin checks and volatility adjustment.

---

## Installation

1. Copy `Risk_Based_Lot_size_Calculator_001.mq4` to:
   ```
   MetaTrader 4/MQL4/Scripts/
   ```
2. Restart MT4 or right-click **Navigator** → **Refresh**
3. Drag onto the chart of the instrument you're about to trade
4. Enter your parameters and click **OK**
5. Read the lot size from the Experts log (Ctrl+T to open the Terminal)

---

## Requirements

- MetaTrader 4 (Build 600+)
- `#property strict` compliance (enforced)
- Valid account (live or demo) with positive balance
- Symbol must be active in Market Watch

---

## Disclaimer

This script is provided for **educational and informational purposes only**. Lot size calculations depend on broker-specific tick values which vary by instrument and account type. Always verify the output before placing a trade. The author accepts no responsibility for trading losses.

---

## License

MIT License — free to use, modify, and distribute with attribution.
