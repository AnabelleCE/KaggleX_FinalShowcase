--Issues total by quarter
SELECT TOP (1000) [name]
      ,[year]
      ,[quarter]
      ,[count]
 FROM [KaggleX Project Data].[dbo].[issues];

--Pull Requests (PR)count total by quarter
SELECT TOP (1000) [name]
      ,[year]
      ,[quarter]
      ,[prs_cnt]
 FROM [KaggleX Project Data].[dbo].[prs];

  -- Repositories total
SELECT TOP (1000) [name]
      ,[num_repos]
 FROM [KaggleX Project Data].[dbo].[repos];

 /*rename the column name where programming languages listed to match others.
 Not necessary to change this column name*/
EXEC sp_rename 'dbo.repos.language', 'name', 'COLUMN';

EXEC sp_rename 'dbo.issues.count', 'issues_cnt', 'COLUMN';

EXEC sp_rename 'dbo.prs.count', 'prs_cnt', 'COLUMN';