# Project 5 - *Chirp*

**Chirp** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **14** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User sees app icon in home screen and styled launch screen
- [x] User can sign in using OAuth login flow
- [x] User can Logout
- [x] Data model classes
- [x] User can view last 20 tweets from their home timeline with the user profile picture, username, tweet text, and timestamp.
- [x] User can pull to refresh.
- [x] User can tap the retweet and favorite buttons in a tweet cell to retweet and/or favorite a tweet.
- [x] Using AutoLayout, the Tweet cell should adjust it's layout for iPhone 7, Plus and SE device sizes as well as accommodate device rotation.

The following **stretch** features are implemented:

- [x] The current signed in user will be persisted across restarts
- [x] Each tweet should display the relative timestamp for each tweet "8m", "7h"
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [X] Links in tweets are clickable.
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

- [x] Custom navbar design with Twitter blue & Twitter logo (+1-3pts)
- [x] Alert to allow user to confirm logout intention (+1-3pts)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to update *all* tweets in the array without having to reload them completely
2. How to change the UI based on user gestures

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='Twitter_demo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I had a number of issues with closures, dealing with Twitter API limits and optional unwrapping crashes.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [ActiveLabel](https://github.com/optonaut/ActiveLabel.swift) - custom label library
- [DateTools](https://github.com/MatthewYork/DateTools) - robust date library

## License

Copyright 2018 Jonathan Grider

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


# Project 6 - *Chirp*

Time spent: **10** hours spent in total

## User Stories

The following **required** stories are completed:

- [x] User can tap on a tweet to view it in a detail view, with controls to retweet, favorite, and reply (2pts)
- [x] User can compose a new tweet by tapping on a compose button. (3pts)
- [x] When composing a tweet, user sees a countdown for the number of characters remaining for the tweet (out of 140) (2pt)
- [x] User can view their profile in a *profile tab* (3pts)
- Contains the user header view: picture and tagline
- Contains a section with the users basic stats: # tweets, # following, # followers

The following **stretch** features are implemented:

- [ ] Profile view includes that user's timeline. (2pts)
- [ ] User can tap the profile image in any tweet to see another user's profile. (1pt)
- Contains the user header view: picture and tagline.
- Contains a section with the users basic stats: # tweets, # following, # followers.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network. (1pt)
- [x] User can reply to any tweet, and replies should be prefixed with the username and the reply_id should be set when posting the tweet. (2pts)
- [ ] User sees embedded images in tweet if available. (3pts)
- [ ] Pulling down the profile page should blur and resize the header image. (2pts)

The following **additional** features are implemented:

- [x] Custom navbar design with Twitter blue & Twitter logo (+1-3pts)
- [x] Alert to allow user to confirm logout intention (+1-3pts)
- [x] Tweet profile pictures are circles just like actual Twitter (+1-3pts)
- [x] Haptic feedback on like and retweet buttons (+1-3pts)
- [x] Custom coloring of links, handles and hashtags (+1-3pts)
- [x] Tweets longer than 140 characters are shown in full (extended tweets) (+1-3pts)
- [x] User can click on links and view them modally with a WKWebView (+1-3pts)


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to embed images in the tweets
2. How to get timelines to scroll on a profile page like Twitter does

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='Twitter_demo2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I had a fair amout of issues with WebKit compiler warnings and the Twitter API's 15-minute request limit

## License

Copyright 2018 Jonathan Grider

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


