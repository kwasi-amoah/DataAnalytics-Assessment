Overview:
This repository contains my solutions to a multi-part SQL assessment designed to evaluate my ability to extract business insights from relational data. The scenarios cover customer segmentation, transaction behaviour analysis, account activity monitoring, and lifetime value estimation.
Each query is crafted to balance clarity, performance, and accuracy, with results aligned to realistic business reporting needs.
Tools & Environment:
SQL Dialect: MySQL,
Tables Used:
users_customuser
plans_plan
savings_savingsaccount,
Approach: Modular SQL queries using CTEs and conditional aggregations

NB: While the original instructions recommend including comments for complex sections, I have not added any inline comments within the SQL scripts. This is because:
•	The queries are straightforward and self-explanatory.
•	A detailed breakdown and rationale for each query has already been provided in this README document.
•	This helps maintain clean and uncluttered SQL scripts while ensuring that full context is still available for the reviewers.
Should additional clarification be needed, this README file offers complete insight into how each query was developed.

Task 1: Customers with Both Savings & Investment Plans
Objective: Identify customers who have at least one savings and one investment plan, along with their total confirmed deposits.
The task was in two parts; identify customers with at least one funded savings plan and at least one funded investment plan, AND sort them by total deposits. 
Let me take you through my way of thinking. First of all, I used the users_customuser table because looking at the expected output, I was going to group the results per customer id and extract their full names as well. Moving on to the join statements, the first join on plans_plan was done to find accounts that are either savings or investment plans. This helped me to remove unwanted rows in the result set early enough, to make the query more efficient. The second join on savings_savingsaccount ensured that I extracted only plans with actual deposits. This also acts as a filter further reducing memory usage and computation time.
With the aggregations, the count distinct statements were used to retrieve how many unique savings, and investment plans a user has. The last coalesce statement was used to derive the total deposits in naira by dividing by 100 since the amounts given were in kobo.
After aggregation, I filtered with a having clause to ensure only users who have both types of plans are included as the task demanded and then I finally ordered the results in a descending order by the total deposits.
I chose this approach to filter early, join only what is needed and perform aggregations efficiently. This query can be easily maintained and read.

Task 2: Transaction Frequency Segmentation
Objective: Categorize customers based on how frequently they transact per month.
The task was to calculate the average number of transactions per customer and then categorize them into high frequence, medium frequency and low frequency. 
I approached this task with CTE’s. The first CTE was to gather the number of transactions and the range of activity, grouped by user ids. The second CTE calculated the tenure in months or months of activity and then the average transactions per month. I also put in a clause to make sure there was no division by zero. The third and final CTE then categorized the customers based on the average transactions per month into either high, medium or low frequency using a case statement. Based on the expected output, I then went on to select and display the needed metrics. I went with this approach because it is cleaner and has a clear structure. It also avoids unwanted computation, and the results are easy to read and understand.

Task 3: Inactivity Alert for Accounts
The task was to find all accounts with no transactions in the last year. First of all, I selected the plan id and owner id to identify the accounts and then wrote a case statement to classify the accounts into savings, investments or others. I then found the last time the account was used and then found the difference between that date and the current date to get the number of days of inactivity. I then went on to join on the savings_savingsaccount table to capture all the accounts. In the where clause, I extracted only active, non-deleted savings or investment plans and then based on the expected outcome, I went on to group by plan id, owner id, and plan type. In the having clause, I selected only plans that had been inactive for over a year or had never had a transaction, and then I finally ordered by the number of inactive days. I went with this approach because it is efficient and comprehensive. It is also readable, performs well and gives insightful output.

Task 4: Customer Lifetime Value (CLV) Estimation 
Objective: Estimate CLV using tenure and transaction history with a simplified formula.
The main standout task was to estimate the customer lifetime value (CLV) using account tenure, total number of transactions and the profit (0.1%) per transaction. The CLV formula was also given as CLV= (total_transactions / tenure_months) * 12 * avg_profit_per_transaction, with avg_profit_per_transaction = avg_transaction_value * 0.001.
I started off with a CTE to create a customer summary. This included the name, tenure_months (difference between the date joined and the current date), total_transactions and avg_transaction_value, which is still in kobo. 
The second part of the query selects the desired metrics based on the expected output and the calculated the estimated_clv based on the given formula, and then finally orders by the estimated_clv. I chose this approach because it is clean, mathematically sound and operationally efficient.

Challenges: One of the main challenges I encountered during this project was understanding the structure and semantics of the dataset. Many of the column names were not self-explanatory, and there was no accompanying data dictionary to clarify their meaning. As a result, I had to spend time researching and deducing the purpose of various fields before I could confidently use them in my queries. Access to a proper data dictionary would have significantly improved the initial exploration and analysis process.
Another challenge was my unfamiliarity with the concept of Estimated Customer Lifetime Value (CLV). While I initially found this metric complex, I proactively took the time to research it, understand the underlying formula, and learn how to implement it effectively in SQL. This helped me build the logic needed to derive meaningful business insights from the data.
Beyond these, the rest of the challenges were mostly related to SQL syntax and query structuring which are typical hurdles that were resolved with careful debugging and testing.


