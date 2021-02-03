
GetYourReviews app displays a list of reviews in tableview, fetched from given url.

- Every cell has following details of review:
ID,Author(name and country),rating,review date and comments.
- On intial load, default sorting option is 'rating' and limit is 10 and skips zero records(offset)
- once user comes to end of fetched list, on further scrolling another fetch request is made for next page.
- On main screen, user is presented with a sort option view. Here user can sort the options based on rating or date.
  Every time user selects sort option, the existing list is cleared and is loaded with newly sorted data.
- Error is handled for different cases.
  - if invalid request was made.
  - if fetched response has zero records.
  - The api status code is checked and error message returned from error response is displayed in alertview.
-Unit testing is done for model classes and api requests.


Required Versions:
Swift 5
Xcode 12.2
Deployment target iOS 14.2

Assumptions:
1.Review id is always present, hence not optional.
2.Sorting is always by desc order.

