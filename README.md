# Isabel's Leaderboard Implementation

## How to use the Leaderboard

Go to https://powerful-springs-81613.herokuapp.com/

or

1. Download repo
2. Install Ruby and Rails
3. `bundle install` inside repo
4. run `rails server` in your terminal
5. In your browser, go to: localhost:3000

## To do the bare minimum actions...

```
Reads a table, like the one above, from a csv file.

Supports an interface that displays today's leaderboard based on most recent download numbers.

Supports an interface that permits an analyst to provide a date and show the leaderboard for that date
```

1. Upload a file on either side, depending on size of file.
2. If file is uploaded on left side, the leaderboard interface based on `todays` download numbers will display after the file is uploaded. If `today` is not a data point, no table will be shown. For the right side, it will trigger a file download with the table inside.
3. To show the leaderboard for a specific date, you must enter the same date in the `From` and `To` fields. Entering a range of dates will `SUM` the download numbers.

## Helpful Info

- This is a Ruby on Rails application, **without** a database. For that reason, I split
my application into two parts.
- The left side is for small CSV files because the data is stored in a `Cookie` using ther Rails `session` and it can only hold 4K bytes. But this side will provide you with a more interactive UI to action on the data.
- The right side is for bigger CSV files. There is no UI besides indicating how you want your data filtered. It will then output an `html` file with the result inside.
- To filter by one specific date, just put the same date in the `From` and `To` fields.

## Restrictions

- Only CSVs are accepted.
- Filtering by `Dates` and `App Names` is completely separate. It will not work if you try to filter with both.
- The `AVG`, `MIN`, `MAX` only work when dates are provided.
- Currently only shows TOP 10.
- Only the right side that accepts big files, has the option to show `History`.

## Extra Credit

1. A user can specify a date range for summing, by filling out the corresponding `From` and `To` fields.
2. Aggregate functions (must be used with range of dates):
  - `AVG` will average out the download numbers for each company in that date range and sort in order of highest average.
  - `MAX` will give the most downloads for each company in a given date range.
  - `MIN` will give the least downloads for each company in a given date range.
3. You can specify an app name for `today` and it will show its rank and download numbers for `today`.
4. Specifying a range of dates will automatically rank the apps after summing the downloads for that range. Which will show you the top app in that range.
5. To see the top 10 apps in a date range or the `history`, you can upload a file on the right side and click the `History` radio button. This will output a file with the top 10 for each date in the range.
