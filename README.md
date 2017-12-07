# Advent of Code 2017
### [http://adventofcode.com/2017](http://adventofcode.com/2017)

In this repo I'll be putting my solutions to daily puzzles of 2017 adventofcode challenge.

Last year I've used Elm lang to solve the adventOfCode puzzles, and I will do the same this year.
I hope to see some improvement in the way how I use the language, and how well I understand it.

I'll also write some thoughts on each day, mostly for myself to keep track of what was going on.

---

- ### Day 01
And we have a kick off to another 25 days filled with moments of frustration and despair, but also satisfaction. Hopefully I will have enough time to complete the whole challenge this year.
- ### Day 02
Interestingly had some minor issues with the input. Had to regex replace all the tabs in the string with spaces to get it to compile.
- ### Day 03
Little bit of mathematics behind this puzzle [https://en.wikipedia.org/wiki/Ulam_spiral](https://en.wikipedia.org/wiki/Ulam_spiral).
The fact that the bottom right corners are powers of odd numbers can be used to solve the first part of the puzzle.
- ### Day 04
Simple but interesting puzzle. Second part runs quick if we check the string lengths first, before checking if it's an anagram.
- ### Day 05
Not particulary difficult, but unfortunately in the second part Elm's Lists didn't really prove to be optimized for 2M+ sequential actions, so JavaScript was used instead to find the solution (first comment in day 5 file). Later modified the Elm solution to use Arrays, which proved to be an improvement, but still slow while runing in elm-reactor with debug turned on. Maybe running a custom solution would be a better option.
- ### Day 06
Again some issues in regards of the speed, it is a bit slow but gives correct solution. Speed issues are probably manifesting because it's running with the debug flag on in elm reactor. Need to move to a standalone solution, might help.
- ### Day 07
Part one was a nice puzzle, but had some problems with part two. My point of view was wrong in the second part, and I had problems finding the propper node in the tree with imbalanced weight. Solution was to find first imbalanced node with balanced child nodes, while at first I was looking only imbalanced weights in the same level, which is obviously wrong. Also, being a bit nervous for no apparent reason does not help with focus and concentration :(...