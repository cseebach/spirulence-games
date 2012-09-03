ig.module(
  "game.techs"
).requires(
  "impact.game"
).defines ->
  window.techs =
    advRobotics:
      cost: 1000
      enabled: true
      researched: false
      name: "Advanced Robotics"
      desc: "Awesome robots work the mines more efficiently than humans!"
      bonus: "Increases the efficiency of your mines."
      quote: "Beep. Whiirrrrrrrrr."

      onResearched: ()->
        techs.extremeRobotics.enabled = true

    extremeRobotics:
      cost: 2000
      enabled: false
      researched: false
      name: "Extreme Environment Robotics"
      desc: "Remote control of robots under extreme conditions renders a whole new class
                of exploratory and geology problems solvable."
      bonus: "Further increases the efficiency of your mines. Enables construction of\nAsthenosphere Boreholes."
      quote: "Beep. <lava bubble>. Whirrr."

      onResearched: ()->
        ig.game.buildButtons[4].enabled = true

    highEnergyPhysics:
      cost: 1000
      enabled: true
      researched: false
      name: "High Energy Physics"
      desc: "Development of the tools and methods to handle high energy matter states gives
                you the tools for discovering what the universe is really made of."
      bonus: "Enables construction of Supercolliders."
      quote: "But, but, the chance of forming a black hole is like really really small!"

      onResearched: ()->
        ig.game.buildButtons[5].enabled = true
        techs.quantumComputing.enabled = true

    quantumComputing:
      cost: 2000
      enabled: false
      researched: false
      name: "Quantum Computing"
      desc: "Understanding more of the subatomic particles of the universe, the first
                reliable quantum computers are built and go into service."
      bonus: "Enables construction of Quantum-Optical Comptrollers."
      quote: "Wednesday, we'll calculate all the digits of Pi; Thursday, we should work on
                 that overdue 30-billion-node neural net, and Friday, what the hell, let's
                 simulate the universe."

      onResearched:()->
        ig.game.buildButtons[6].enabled = true
        techs.unifiedTheory.enabled = true

    theoryOfEverything:
      cost: 3000
      enabled: false
      researched: false
      name: "Theory of Everything"
      desc: "Using data from High Energy Physics and analysis tools from Quantum Computing,
                the first truly universal theory of physics is discovered."
      bonus: "Enables construction of Dome Generators."
      quote: "It makes so much sense! Igor, why didn't we think of this before?!"

      onResearched:() ->
        ig.game.buildButtons[7].enabled = true
        techs.secretsOfTheUniverse.enabled = true

    secretsOfTheUniverse:
      cost: 5000
      enabled: false
      researched: false
      name: "Secrets of the Universe"
      desc: "???"
      bonus: "???"
      quote: "And there they were, the mortals, always rushing to the end of their hurried
                 lives. I saw everything, and it was sad and beautiful."

      onResearched:() ->
        ig.game.winning = true
        ig.game.winCondition = "secrets"