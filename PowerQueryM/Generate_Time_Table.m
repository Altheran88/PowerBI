let
    StartDate = Time.From("00:00:00"),
    CurrentTime = Time.From(Number.RoundDown((Decimal.From(Time.From(DateTime.FixedLocalNow()))+(1/86400))*86400)/86400),
    ListSecondes = List.Times(StartDate, 86400, #duration(0,0,0,1)),
    #"Converted to Table" = Table.FromList(ListSecondes, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Column1 as Temps" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Temps"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Renamed Column1 as Temps",{{"Temps", type time}}),
    #"Temps_5m inséré" = Table.AddColumn(#"Type modifié", "Temps_5m", each Time.From(Number.RoundDown((Decimal.From([Temps])*288)+(1/8400))/288), type time),
    #"Temps_10m inséré" = Table.AddColumn(#"Temps_5m inséré", "Temps_10m", each Time.From(Number.RoundDown((Decimal.From([Temps])*144)+(1/8400))/144), type time),
    #"Temps_15m inséré" = Table.AddColumn(#"Temps_10m inséré", "Temps_15m", each Time.From(Number.RoundDown((Decimal.From([Temps])*96)+(1/8400))/96), type time),
    #"Temps_30m inséré" = Table.AddColumn(#"Temps_15m inséré", "Temps_30m", each Time.From(Number.RoundDown((Decimal.From([Temps])*48)+(1/8400))/48), type time),
    #"Temps_HR inséré" = Table.AddColumn(#"Temps_30m inséré", "Temps_HR", each Time.From(Number.RoundDown((Decimal.From([Temps])*24)+(1/8400))/24), type time),
    #"Écart Minutes inséré" = Table.AddColumn(#"Temps_HR inséré", "Écart Minutes", each (Number.RoundDown(Decimal.From([Temps])*1440+(1/86400)) - Number.RoundDown(Decimal.From(CurrentTime)*1440+(1/86400))), Int64.Type),
    #"Écart Heures inséré" = Table.AddColumn(#"Écart Minutes inséré", "Écart Heures", each (Number.RoundDown(Decimal.From([Temps])*24+(1/86400)) - Number.RoundDown(Decimal.From(CurrentTime)*24+(1/86400))), Int64.Type),
    #"No_Heure inséré" = Table.AddColumn(#"Écart Heures inséré", "No_Heure", each Time.Hour([Temps]), Int64.Type),
    #"No_Minute inséré" = Table.AddColumn(#"No_Heure inséré", "No_Minute", each Time.Minute([Temps]), Int64.Type )
in
    #"No_Minute inséré"
    
 // Please people, split your Timestamps into Dates and Time columns, your Dataset Size will love you
 
 // Sorry for the french, didn't have the will to fix it
 // Temps = Time
 // inséré = inserted
 // Écart = Gap/Offset (These are the count of periods between said time and now), very usefull to filter to always see the last x minutes or hours.
 // Heures = Hour
