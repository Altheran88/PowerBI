let
    StartTime = Time.From("00:00:00"),
    CurrentTime = Time.From(Number.RoundDown((Decimal.From(Time.From(DateTime.FixedLocalNow()))+(1/86400))*86400)/86400),
    ListSeconds = List.Times(StartTime, 86400, #duration(0,0,0,1)),
    #"Converted to Table" = Table.FromList(ListSeconds, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Column1 as Time" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Time"}}),
    #"Time to Time type" = Table.TransformColumnTypes(#"Renamed Column1 as Time",{{"Time", type time}}),
    #"Added Time_5 minutes" = Table.AddColumn(#"Time to Time type", "Time_5 minutes", each Time.From(Number.RoundDown((Decimal.From([Time])*288)+(1/8400))/288), type time),
    #"Added Time_10 minutes" = Table.AddColumn(#"Added Time_5 minutes", "Time_10 minutes", each Time.From(Number.RoundDown((Decimal.From([Time])*144)+(1/8400))/144), type time),
    #"Added Time_15 minutes" = Table.AddColumn(#"Added Time_10 minutes", "Time_15 minutes", each Time.From(Number.RoundDown((Decimal.From([Time])*96)+(1/8400))/96), type time),
    #"Added Time_30 minutes" = Table.AddColumn(#"Added Time_15 minutes", "Time_30 minutes", each Time.From(Number.RoundDown((Decimal.From([Time])*48)+(1/8400))/48), type time),
    #"Added Time_Hour" = Table.AddColumn(#"Added Time_30 minutes", "Time_Hour", each Time.From(Number.RoundDown((Decimal.From([Time])*24)+(1/8400))/24), type time),
    #"Added CurMinutesOffset" = Table.AddColumn(#"Added Time_Hour", "CurMinutesOffset", each (Number.RoundDown(Decimal.From([Time])*1440+(1/86400)) - Number.RoundDown(Decimal.From(CurrentTime)*1440+(1/86400))), Int64.Type),
    #"Added CurHoursOffset" = Table.AddColumn(#"Added CurMinutesOffset", "CurHoursOffset", each (Number.RoundDown(Decimal.From([Time])*24+(1/86400)) - Number.RoundDown(Decimal.From(CurrentTime)*24+(1/86400))), Int64.Type),
    #"Added HourNum" = Table.AddColumn(#"Added CurHoursOffset", "HourNum", each Time.Hour([Time]), Int64.Type),
    #"Added MinuteNum" = Table.AddColumn(#"Added HourNum", "MinuteNum", each Time.Minute([Time]), Int64.Type )
in
    #"Added MinuteNum"
    
 // Please people, split your Timestamps into Dates and Time columns, your Dataset Size will love you
