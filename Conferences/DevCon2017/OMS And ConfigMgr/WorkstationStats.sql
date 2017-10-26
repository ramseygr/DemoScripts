--workstationstats
SELECT  vWorkstationStatus.ResourceID
		, (v_R_System.Name0 + '.' + v_R_System.Full_Domain_Name0) AS Computer
		, vWorkstationStatus.ClientVersion
		, concat(convert(varchar(19), vWorkstationStatus.LastHardwareScan, 127),'Z')  AS LastHardwareScan
		, concat(convert(varchar(19), vWorkstationStatus.LastDDR, 127),'Z')  AS LastDDR
		, concat(convert(varchar(19), vWorkstationStatus.LastPolicyRequest, 127),'Z')  AS LastPolicyRequest
		, vWorkstationStatus.LastMPServerName
		, vWorkstationStatus.OperatingSystem
FROM            vWorkstationStatus INNER JOIN
                         v_R_System  ON vWorkstationStatus.ResourceID = v_R_System.ResourceID


