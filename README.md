# Disclaimer
This is NOT production code!

This only represents about a day's worth of effort. There are no tests, and I was not able to test this on iOS or Mac. THIS IS ONLY THE HAPPY PATH. Errors and corner cases are not handled, and there is only the bare minimum in terms of user input verification.

The intent here is to quickly put together a functional prototype that stake holders can actually see and use. It's supposed to be a concrete discussion piece that elicits feedback, which would then be used to build future iterations of the application.

# Possible Future Improvements
* A LOT of work to be done on parsing & presenting user info, particular for capitalizing proper nouns in location/address info.
* The same goes for formatting dates.
* Need to do more to handle network latency (Turn this into a progressive web app).
* The app starts to bog down when requesting ~1000 users. The API is set up for paging, so that would be an obvious way to manage this.
* Tweak animations (especially speeds)
* Optimize for specific phones, tabs, etc. (based on analytics usage metrics)

# Assumptions
* This should be functional (maybe not beautiful) on mobile devices
* Vanilla ES via TypeScript.
* No frameworks. This is what I can do with the help of a few tools (listed below).
* The Gulp file is just to automate compiling TypeScript.

# Tools
* animate.css
* FontAwesome
* Favicon Generator
* flag-icon-css

# Original Challenge
Create a small Javascript application that pulls data from an api (https://randomuser.me/) and displays a summary of 3 or more users at a time. You should have the ability to select a user and have it show more detail about that user either in a modal or a new page. In addition the application should also have an option to show a new set of users without reloading the page ( generate / refresh button or similar ).
