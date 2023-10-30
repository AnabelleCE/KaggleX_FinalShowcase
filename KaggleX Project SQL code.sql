/*Combining quaterly data to see yearly issue totals,
organized by name and year*/
SELECT [name], 
	   [year],
	   SUM([issues_cnt]) AS 'yrttl_issues'
	FROM dbo.issues
	GROUP BY [name],[year]
	ORDER BY [name],[year]
;

-- Same as above for Pull Request totals
SELECT [name], 
	   [year],
	   SUM([prs_cnt]) AS 'yrttl_prs'
	FROM dbo.prs
	GROUP BY [name],[year]
	ORDER BY [name],[year]
;

/*Combining historical issue count and sorting 
in descending order to see most popular overall*/
SELECT "name",
	SUM("count") AS 'lftm_issues'
	FROM dbo.issues
	GROUP BY "name"
	ORDER BY [lftm_issues] DESC
;

-- Same as above for Pull Request totals
SELECT "name",
	SUM("count") AS 'lftm_prs'
	FROM dbo.prs
	GROUP BY "name"
	ORDER BY [lftm_prs] DESC
;

/*Create temporary table, combining issues, pull request data, 
adding drop table to ensure rerunning query will not result in error 
of table already existing */

--We will use this table to build a Supervised Machine Learning model
IF OBJECT_ID('issues_prs', 'U') IS NOT NULL
    DROP TABLE issues_prs

SELECT [issues].[name],
	   [issues].[year], 
	   SUM([issues_cnt]) AS 'yrttl_issues',
	   SUM([prs_cnt]) AS 'yrttl_prs'
	INTO issues_prs
	FROM dbo.issues
	   JOIN dbo.prs ON [prs].[name] = [issues].[name]
	   AND [prs].[year] = [issues].[year]
	 GROUP BY [issues].[name],[issues].[year]
;

SELECT *
	FROM issues_prs
	ORDER BY [issues_prs].[name], [issues_prs].[year]
;

/*Create temporary table combining issues, pull request, and repositories 
total historical data, as quearterly/yearly data not avaialble for repos*/

--We will use this table to build an Unsupervised Machine Learning model
IF OBJECT_ID('issues_prs_repos', 'U') IS NOT NULL
    DROP TABLE issues_prs_repos

SELECT [issues_prs].[name],
	   [issues_prs].[lftm_issues],
	   [issues_prs].[lftm_prs],
	   [repos].[num_repos]
	INTO issues_prs_repos
	--A subquery for sum to allow us to include repos in the result w/o aggregation
	FROM (SELECT [issues].[name], 
			    SUM([issues_cnt]) AS 'lftm_issues',
			    SUM([prs_cnt]) AS 'lftm_prs'
			FROM dbo.issues
			  JOIN dbo.prs ON [prs].[name] = [issues].[name]
			GROUP BY [issues].[name]) AS issues_prs
		JOIN dbo.repos ON [repos].[name] = [issues_prs].[name]
;

SELECT *
	FROM issues_prs_repos
;