module.exports =
  baseMoveDelay: 2
  baseMoveThroughLaserDelay: 4
  basePeekDelay: 2
  basePlayerHealth: 3
  baseTakeItemDelay: 1
  baseOpenSafeDelay: 1
  baseCloseSafeDelay: 1
  baseNumActionsAlerted: 5
  msToMoveToRoom: 900
  msSleep: 300
  msSleeping: 1000
  Items:
    Coins:
      title: "Sack of coins"
      description: "A sack of coins. This is very loud and might alert guards while moving."
      value: 70
    GoldIngot:
      title: "Gold ingot"
      description: "A heavy piece of Gold. You will be slower with this in your bag."
      value: 100
      moveDelay: 1
    SuitCase:
      #TODO: Moneycase description
      title: "Money case"
      description: "A money of cases. This is very loud and might alert guards while moving."
      value: 90