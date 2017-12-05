module.exports =
  baseMoveDelay: 2
  baseGuardMoveDelay: 4
  baseMoveThroughLaserDelay: 4
  basePeekDelay: 1
  basePlayerHealth: 3
  baseTakeItemDelay: 1
  baseOpenSafeDelay: 1
  baseCloseSafeDelay: 1
  basicMonitorDelay: 1
  baseNumActionsAlerted: 5
  msToMoveToRoom: 900
  msSleep: 300
  msSleeping: 1000
  msCrackingTime: 7000
  maxCrackTime: 10
  Items:
    Coins:
      title: "Sack of coins"
      description: "A sack of coins. This is very loud and might alert guards while moving."
      value: 40
    GoldIngot:
      title: "Gold ingot"
      description: "A gold ingot. This is very heavy and will slow you down."
      value: 200
      moveDelay: 1
    SuitCase:
      title: "Suitcase"
      description: "A suitcase filled with money. This might drop bills that allow guards to follow you."
      value: 90