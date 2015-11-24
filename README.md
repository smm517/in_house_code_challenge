Renewable Funding: Code Challenge
=================================

Hi there!  We're ecstatic that you're interested in working for Renewable Funding's dev team.  To get a better idea of your current development skills, we'd like for you to complete a code challenge - build an application according to a set of requirements.  The actual business requirements are listed below, but as for technology:

1. We've bootstrapped a Rails app in the `dr_deal_a_day` folder; feel free to use this, though it's not required, if you'd rather start from scratch or use a different framework.
  * The bootstrapped Rails app already has migrations and models generated, as well as initial setup of both RSpec and Test::Unit.
  * To change the test framework used for both generators and the default rake task, see the settings in `config/application.rb`
  * You're not required to write tests in both - we've just provided them both as options.
  * One test has been written for you (in each framework) to get you started; you can remove/replace it if you want.
1. Do not require any for-pay software.
1. Add instructions (to the README file in the app folder) for running your application, interacting with it, and running tests.
1. Make sure your app is runnable on Mac OS X or Linux.
1. Feel free to use any resources you want (books, online resources, etc.) - this is not a test of what esoteric formulae you have memorized.  If you have any issues connecting to the internet, please let us know.
1. If you decide not to use the bootstrapped Rails app:
  1. Write your code in Ruby.
  1. Include a README file with the instructions listed above.
  1. Consider whether this route will reduce or increase your chances of completing (or at least making significant progress) within the time alotted.

## Project Description

Imagine that Renewable Funding has just acquired a new company, Dr. Deal-a-Day's "Deal a Day" (dot com).  Unfortunately, the company has never stored their data in a database, and instead uses a plain text file.  We need to create a way for the new subsidiary to import their data into a database.  Your task is to create a web interface that accepts file uploads, normalizes the data, and then stores it in a relational database.

Here are the business requirements, if you're applying for either the **Software Engineer** or **Senior Software Engineer** position:

1. Users must be able to upload (via an HTML form) a comma-separated values (CSV) file with the following columns: purchaser name, item description, item price, purchase quantity, merchant address, and merchant name.  You can assume the columns will always be in that order, that there will always be data in each column, and that there will always be a header line.  An example input file named `example_data.csv` is [included in this repo](example_files/example_data.csv).
1. Your app must parse uploaded files, [normalize](https://en.wikipedia.org/wiki/Database_normalization) the data, and store the information in a relational database.  We've already set up a database schema for you, with migrations, but you can get rid of that and use your own schema if you wish.
1. After upload, your application should display the total revenue from the purchases specifically from the recently uploaded file, as well as the total revenue for *all* purchases uploaded to date.

For applicants for the **Senior Software Engineer** position, there are two additional requirements:

* Users must log in with an email address and password.  User registration & authorization is not required; include instructions on how to log in with your submission.
* Non-logged in users should not have access to upload files.

Your application does not need to:

* handle CSVs that don't adhere to the specifications above
* be aesthetically pleasing

#### Bonus options:

If you're feeling inspired and have extra time, here are some options for bonus points:

* also accepting tab-delimited files with no changes in the submission form ([example file](example_files/example_data.tsv))
* showing a friendly error message if a badly formatted file is uploaded
* allowing a user to delete purchases from the database
* allowing a user to log in with their Github account

## Evaluation

Reviewers will assess your familiarity with standard libraries, object-oriented programming, and testing.

1. Did your application fulfill the basic requirements?
1. Did you document the method for running and using your application?
1. Do you have automated tests for the basic requirements?
