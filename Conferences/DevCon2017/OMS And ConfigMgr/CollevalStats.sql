--collevalstats
SELECT
'TP1' as [SiteCode],
[t0].[CollectionName] as [CollectionName],
[t0].[SiteID] as CollectionID,
[t1].[EvaluationLength] AS [RunTimeMS],
concat(convert(varchar(19), [t1].[LastRefreshTime], 127),'Z') as [LastEvaluationCompletionTime],
concat(convert(varchar(19), [t2].[NextRefreshTime], 127),'Z') as [NextEvaluationTime],
[t1].[MemberChanges] AS [MemberChanges],
concat(convert(varchar(19), [t1].[LastMemberChangeTime], 127),'Z')  AS [LastMemberChangeTime]
FROM [dbo].[Collections_G] AS [t0]
INNER JOIN [dbo].[Collections_L] AS [t1] ON [t0].[CollectionID] = [t1].[CollectionID]
INNER JOIN [dbo].[Collection_EvaluationAndCRCData] AS [t2] ON [t0].[CollectionID] = [t2].[CollectionID]