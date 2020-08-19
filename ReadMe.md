# Ruby Capstone Project (Ruby Linter)

This is Brandon's Ruby Capstone project

This project was compiled by Brandon in the Ruby section of the Microverse course work as the Ruby capstone project. It involved building a linter from scratch to create a real-world-like project.

This linter performs the following tests:



###### Trailing Whitespace:

![Trailing Whitespace](imgs/trailing_space.png)

##### Excess Whitespace:

![Excess Whitespace](imgs/excess_space.png)

##### Empty Lines:

![Empty Lines](imgs/extra_lines.png)

##### Missing Empty Line:

![Missing Empty Line](imgs/missing_line.png)

##### Indentation Errors:

![Indentation Errors](imgs/indentations.png)

##### Missing Closing Statement:

![Missing Closing Statement](imgs/missing_end.png)

##### Missing Final Closing Statement:

![Missing Final Closing Statement](imgs/final_closing_statement.png)

##### Incorrect Capitalization of Reserved Word:

![Incorrect Capitalization of Reserved Word](imgs/capitalization.png)

##### Missing Matching Bracket:

![Missing Matching Bracket](imgs/matching_brackets.png)

Particularly noteworthy is the active error correction for when one error comes up because of the existence of another, as in the case of lines 18 and 19 where it appears as two empty lines. With error correction it registers a missing closing statement and what should be an empty line once that closing statement is added, without error correction it would register as two extraneous empty lines and a missing closing statement.

## Built With

-   Ruby
-   Atom
-   Ubuntu
-   Rubocop

## Prerequisities

To get this project up and running locally, you must already have ruby installed on your computer.

## Getting Started

To get your own copy of our project simply clone the repository to your local machine. For instructions on how to run this linter live, skip to the Repl.It instructions below and then click on the Repl.It badge.

**Step 1**: Type the following command into a git shell

_git clone <https://github.com/defoebrand/Ruby_Capstone_Linter.git>_

**Step 2**: Direct a terminal into the directory of the cloned repository by typing:

_cd Ruby_Capstone_Linter_

**Step 3**: To ensure all necessary dependencies are present, run the following command:

_bundle install_

## To Test Locally

**Step 1**: With your terminal in the cloned directory type the following command:

<code>ruby ./bin/ruby_linter.rb</code>

**Step 2**: When prompted, enter the relative path of any file you would like to test. To use the _bad_code_ that comes with this repository type:

<code>./bad_code.rb</code>

## To Test on Repl.it

**Step 1**: Direct the repository to the replit-readme branch

**Step 2**: Click run.

**Step 3**: When prompted, enter the relative path of the _bad_code_ file as described above under Testing Locally. Edit the file as you see fit and test for any errors listed in the tests outlined above. If you find any incorrect errors, please submit an issue.


## Try It on Repl.It

[![Run on Repl.it](https://repl.it/badge/github/defoebrand/Ruby_Capstone_Linter)](https://repl.it/github/defoebrand/Ruby_Capstone_Linter)

-   **Note**: Repl.It does not currently support colors so the User Experience may differ between testing online and testing locally.

## Author

👤 **Brandon Defoe**

-   Github: [@defoebrand](https://github.com/defoebrand)
-   LinkedIn: [@defoebrand](https://www.linkedin.com/in/defoebrand/)
-   Gmail: <mailto:defoe.brand@gmail.com>

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](issues/).

## Show your support

Give a ⭐️ if you like this project!

## 📝 License

This project is licensed by Microverse and Notion.so
