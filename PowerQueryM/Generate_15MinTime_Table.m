let
    StartTime = Time.From("00:00:00"),
    CurrentTime = Time.From(Number.RoundDown((Decimal.From(Time.From(DateTime.FixedLocalNow()))+(1/86400))*96)/96),
    ListSeconds = List.Times(StartTime, 96, #duration(0,0,15,0)),
    #"Converted to Table" = Table.FromList(ListSeconds, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Column1 as Time_15 minutes" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Time_15 minutes"}}),
    #"Time_15 minutes to Time type" = Table.TransformColumnTypes(#"Renamed Column1 as Time_15 minutes",{{"Time_15 minutes", type time}}),
    #"Added Time_30 minutes" = Table.AddColumn(#"Time_15 minutes to Time type", "Time_30 minutes", each Time.From(Number.RoundDown((Decimal.From([Time_15 minutes])*48)+(1/8400))/48), type time),
    #"Added Time_Hour" = Table.AddColumn(#"Added Time_30 minutes", "Time_Hour", each Time.From(Number.RoundDown((Decimal.From([Time_15 minutes])*24)+(1/8400))/24), type time),
    #"Added CurMinutesOffset" = Table.AddColumn(#"Added Time_Hour", "CurMinutesOffset", each (Number.RoundDown(Decimal.From([Time_15 minutes])*1440+(1/86400)) - Number.RoundDown(Decimal.From(CurrentTime)*1440+(1/86400))), Int64.Type),
    #"Added CurHoursOffset" = Table.AddColumn(#"Added CurMinutesOffset", "CurHoursOffset", each (Number.RoundDown(Decimal.From([Time_15 minutes])*24+(1/86400)) - Number.RoundDown(Decimal.From(CurrentTime)*24+(1/86400))), Int64.Type),
    #"Added HourNum" = Table.AddColumn(#"Added CurHoursOffset", "HourNum", each Time.Hour([Time_15 minutes]), Int64.Type),
    #"Added MinuteNum" = Table.AddColumn(#"Added HourNum", "MinuteNum", each Time.Minute([Time_15 minutes]), Int64.Type )
in
    #"Added MinuteNum"
