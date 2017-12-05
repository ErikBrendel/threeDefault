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
  msCrackingTime: 4000
  maxCrackTime: 10
  Items:
    Coins:
      title: "Sack of coins"
      description: "While carrying at least one Sack of coins, guards in adjacent rooms will get alerted you when entering a room."
      value: 40
    GoldIngot:
      title: "Gold ingot"
      description: "This object is very heavy and will decrease your movement speed."
      value: 200
      moveDelay: 1
    SuitCase:
      title: "Suitcase"
      description: "A suitcase filled with money. Each suitcase you carry might drop bills when you leave a room. When a guard sees these, he will get alerted."
      value: 90