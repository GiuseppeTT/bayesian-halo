# Data description

`data/raw/` was obtained by manually filling a spreadsheet with game statistics extracted from a gameplay available at youtube.

The columns are:

- time: time at which the scores were recorded
- blue: score of the blue team (the team of the player from the gameplay)
- read: score of the red team (the enemy team of the player from the gameplay)

# Source

Respectively, the games were obtained from:

- Train: https://youtu.be/cANMWiYTD84
- Test: https://youtu.be/kuH9nhdzt64

# Concerns

- The data was extracted from a gameplay available at youtube and, therefore, might not be representative. This is because people tend to publish only games where they (and therefore their team) had a good performance.

- The data was manually extracted, which means that there may be a difference between the recorded and the actual time of each score. Besides, there are times in which the scoreboard is not visible or partially visible which might have impacted the annotated data.

- The best time resolution is 1 second as the in-game timer was used to measure time between kills.
