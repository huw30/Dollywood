# Dollywood

Dollywood is a movies review app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [ ] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar.
- [x] All images fade in.
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Makes another call the the api to get each movie's details including genres, runtime, and tagline etc.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Video Walkthrough](https://user-images.githubusercontent.com/5446130/30525548-68807730-9bbd-11e7-839e-0a2921879b20.gif)

![Link](https://i.imgur.com/T17Dp22.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes
Difficulties encountered:
- Reused the movie list view controller for both tab bar item view
- Had difficulties figuring out the best practice for code structure
- Added an AlertViewUIController, and show it as a subview to the UIController's view if we encounter any errors during network requests.

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
