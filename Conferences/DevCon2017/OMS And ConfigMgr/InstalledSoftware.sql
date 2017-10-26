SELECT    vrs.ResourceID
		, vrs.Netbios_Name0 AS [DeviceName]
		, vrs.Name0 + '.' + vrs.Full_Domain_Name0 AS Computer
		, vProg.DisplayName0 AS [ProgramName]
		, vProg.InstallDate0 AS [InstallDate]
		, vProg.Version0 AS Version
		--converts date to iso 8601 format - YYYY-MM-DDThh:mm:ssZ
		,concat(convert(varchar(19), vprog.timestamp, 127),'Z') as [TimeGenerated]
FROM            v_R_System AS vrs LEFT OUTER JOIN
                         v_Add_Remove_Programs AS vProg ON vProg.ResourceID = vrs.ResourceID
WHERE        (vProg.DisplayName0 <> 'NULL') AND (vrs.Active0 = 1) AND (vrs.ResourceID IN
                             (SELECT        MachineID
                               FROM            _RES_COLL_TP100016))
							   and datediff(day,vprog.TimeStamp,getdate()) < 90
