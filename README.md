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
- ### Day 08
Luckily this puzzle was much more straightforward than the previous one. It was only a matter of parsing the input and building a list of functions which represented the instructions. After that in steps, by recursive calls of the runInstructions function, we get registers after each step. Then we can find the max value after each instruction and the same at the end.
- ### Day 09
Really enjoyed this puzzle for some reason, maybe because it didn't seem overly complex, although there was a lot of text. The solution is a single function which reduces the input to a few numbers and a couple of flags. We need to monitor different cases, when we're ignoring the next letter, or if we're in the garbage section. Other than that we count groups when we encounter an opened curly brace, and decrease current group counter when we encounter a closed curly brace. It takes a couple of seconds to go through the input since it quite long.
- ### Day 10
The solution for this puzzle is not particulary complex. After solving the first part, most of the job for the part 2 is done. It only required running the hash rounds 64 times, and then xor sections of 16 numbers in the total result list of 256, which was quite easy to do using Elm's built in array and list functions (only had to add Hex package for Int -> String conversion). Quite satisfied with the end result, although it was a bit scary on the first glance, there was a lot of description.
- ### Day 11
This puzzle reminded me immediatelly of something I've read about pathfinding algorithms in games. Some RTS games use hexagonal grids for pathfinding (among other things, like calculating splash damage depending on the distance from the source). The trick is only to figure out how hex x,y coordinates would change with each move, and what does this mean for the minimum distance from the origin.
- ### Day 12
Solution for the first part consists of building a "tree", with keeping in mind circular connections, and counting nodes. The second part was about building as many of those trees as it's possible with the given input. In our case "tree" was built by using dicts, and the size of the dict was the solution of the first part, while in the second part we had to go through the input and build trees while filtering out programs which have been used in a tree previously. Not sure if this is the optimal solution, but it worked really good in this case.
- ### Day 13
After reading the text of this puzzle, my first thought was about a list which would contain information about each layer of the firewall and at which current depth is currently the security scanner. But current depth of the security scanner is a function of the time, so as long as we know the time, we should know at which depth is the scanner. I struggled a little bit to get the maths to work, because at first I didn't consider that the number of steps a security scanner makes in each up or down cycle is one less than the depth. Then, figuring out the first part was just a matter of going through the input, increasing the time with each element and checking if the element is on the position zero, and if it is calculate its severity and add to the total. With the second part, we were looking for the time delay, so we had to count time until positions of all the scanners didn't align so we could cross safely through the firewall. It took about 60 sec for elm to find the solution for the second part, but with pure nodejs javascript this would probably take less than a second.
- ### Day 14
In the first part of the puzzle it was neccessary to count all 1's in the binary representations of 128 different hashes, which we got from the input using knot hash (implemented on day 10). This gave us a number of "memory blocks" currently being used, and the task was not complex it took some time to extract the solution of the day 10 to a different component and use it to solve the first part. Also, calculating knot hashes in elm isn't really efficient and it takes a bit of time to generate 128 hashes (perhaps that solution needs revisiting).

The second part was a bit more challenging, and at first I thought a good solution might be to go line by line, checking indices on which 1's appear and comparing them to the rows above. Unfortunatelly, that solution wouldn't work because there could be 1's in the same row which are not connected directly but through rows below them, so a different approach was needed. To find the solution a square matrix was used, size 128, filled with 1 and 0 to represent our binary hashes. Then starting from the location (0, 0) go through each line and search for 1. When found, increase number of groups by one and use recursion to go through the matrix and set all 1's connected to the first one to 0 (clear group). As we went further along, only 1's which did not belog to any of the previous groups remained. This in the end gave the right solution.