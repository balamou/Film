# <img src="images/logo.png" width="30px" height="30px"/> FILM

- [x] Hard drive
- [ ] Apple dev subscription
- [ ] Apple tv

## Player:
- [x] top status bar animation
- [ ] fade in/fade out animation
- [x] timer to hide control panel
- [x] images with proper size
- [x] good font
- [ ] *next episode
- [ ] *episode lists
- [ ] skip intro
- [ ] play next episode when episode done
- [x] Add sound bar
- [x] Add time label when scrolling
- [ ] Add spinner instead of play/pause when loading
- [ ] get rid of the rotation animation on orientation switch
- [ ] when re-entering the player, make sure audio is smooth (or play back a few seconds)
- [ ] Enable video buffering
- [ ] Save position of the video playing when leaving the app (or during a timer interval)
- [ ] Add double tap gesture (for backwards and forward)

## Code:
- [x] Move fonts out
- [x] Move images out
- [ ] Move colors out
- [x] remove observers on disappear or deinit
- [ ] Cut down the size of the VLC library?? (if possible)
- [x] Move Cell setup into the cell

## Other:
- [ ] App expiring soon notification
- [x] Increase button touch size
Efficiency/blocks:
- [ ] Should make hierarchy elements weak var??

## Nitpick:
- [ ] Change tab color (white when selected/dark gray otherwise)
- [ ] Change Font size of the tab bar
- [ ] Decrease tab bar icon sizes
- [ ] Make ShowInfoViewController as a CollectionViewController not just a ViewController

## Future features (optimistic):
- [ ] Tv OS (air play)
- [ ] Download (offline use)
- [ ] Use outside of local network (encryption, security/opening ports/port forwarding, tracking?)

## ShowsVC:
- [x] Pull to refresh
- [ ] Idle image for error (probably cell)
- [ ] Idle image for no data (probably cell)
- [ ] Fix alert style
- [ ] Add alert queue
- [x] Add noMoreData left

## ShowInfoVC:
- [ ] tap to expand plot

## To do:
- [x] Back up pictures
- [ ] Check hard drives
- [ ] Connect hard drive to pi
- [x] Add remaining image assets to showinfo
- [x] Add loading state to show info
- [x] Add change seasons VC

## STAGES:
- [x] Make watched open info
- [x] Abstract out ShowVC
- [x] Make MoviesVC
- [x] Make MoviesInfoVC
- [ ] Make settings work
- [ ] Glue it all together (API to API conversion)
- [ ] Make player work
- [ ] Replan model
- [ ] Make Backend in GO
- [ ] Test JSON decoding
- [ ] Add tests

## BRANCHES:
- [x] master (player works)
- [x] player (player works)
- [x] ui_structure (created most screens)
- [x] mock_data_integration (added mock API calls and more model objects)
- [x] abstracting_collection_view (abstracting collection view to a separate class)
- [x] settings (set up settings view and login view)
- [ ] refactoring-stage-1 (nov 16, 2019, started working on it again, refactoring some architecture)

