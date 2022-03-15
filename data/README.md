# Data description

`data/raw/scores.csv` was obtained by manually filling a spreadsheet with game statistics extracted from a gameplay available at youtube.

The columns are:

- game: game id
- time: time at which the scores were recorded
- blue: score of the blue team (the team of the player from the gameplay)
- read: score of the red team (the enemy team of the player from the gameplay)

# Source

Respectively, the games were obtained from:

- Game 1: https://youtu.be/cANMWiYTD84

# Concerns

- The data was extracted from a gameplay available at youtube and, therefore, might not be representative. This is because people tend to publish only games where they (and therefore their team) had a good performance.

- The data was manually extracted, which means that there may be a difference between the recorded and the actual time of each score.

- The best time resolution is 1 second as the in-game timer was used to measure time between kills.

- As explained in the notes, multiple kills were artificially recorded with a one second of time-to-kill instead of zero. The impact of this measure is a likely inflation of 1's and a deflation of 0's in the time-to-kill variable.

# Notes

## Multiple kills

If two or more kills from the same team happened at the same time (e.g., double kill), they were falsely recorded as happening at two different times with 1 second of difference. For instance,

```
game,time,blue,red
1,14:12:00,5,3
1,14:09:00,7,3
```

was recorded like

```
game,time,blue,red
1,14:12:00,5,3
1,14:10:00,6,3
1,14:09:00,7,3
```

instead of, in hindsight, a better approach like

```
game,time,blue,red
1,14:12:00,5,3
1,14:09:00,6,3
1,14:09:00,7,3
```
