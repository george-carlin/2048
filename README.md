# TwoOhFourEight

A multiplayer 2048 game built with Phoenix LiveView. The server hosts a single
instance of a 2048 game to which any number of players can connect and play simultaneously. When starting a new game (which resets the game for all players), you can choose to have up to 4 fixed obstacles blocking the grid.

The app is written entirely in Elixir and, thanks to the magic of Phoenix LiveView, contains no custom JavaScript.

Developed using Elixir 1.11.3 (compiled with Erlang/OTP 23). You need to have Elixir and Mix installed. Once you've installed them, run the server with  `./start_2048.sh`. By default the server starts on [`localhost:4000`](http://localhost:4000). View the game in multiple browser windows and you can see how changes made by one player are immediately visible to all others.

You can run the test suite with `mix test`.

Note that the 6x6 grid means it takes a long time to run out of space even if you're trying deliberately to fail. If you want to see what happens when the game is over (don't get too excited as the UI is very plain), it's easier to open `lib/two_oh_four_eight/game/grid.ex` and change the `@size` module attribute to something like `2` to make the grid smaller.

Similarly, if you want to see what happens when you reach the target, rather
than trying to get a 2048 tile (which takes a long time) it's easier to open `lib/two_oh_four_eight/game/game.ex` and change the default value of `target` (line 3) to something smaller than 2048 that can be reached more easily. (It needs to be a power of 2 or there'll never be a tile for it!)

See `tile_styles.png` for a preview of how the styling looks for all the differently numbered tiles. I copied the color scheme from [play2048.co](http://play2048.co). It's possible to continue playing after reaching 2048, so all tiles higher than that have the same style (which is how play2048.co does it.
