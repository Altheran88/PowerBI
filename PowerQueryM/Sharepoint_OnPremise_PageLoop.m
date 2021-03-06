let SHPQueries = 
    (SiteURL as text, ListName as text, PageLimit as text) =>

    let
        url = (SiteURL&"_api/web/lists/getbytitle('"&ListName&"')/items?$top="&PageLimit),

        FnGetOnePage =
        (url) as record =>
        let
            Source = Json.Document(Web.Contents(url, [Headers=[Accept="application/json;odata=verbose"]]))[d],
            data = try Source[results] otherwise null,
            next = try Source[__next] otherwise null,
            res = [Data=data, Next=next]
        in res,

        GeneratedList =
        List.Generate(
        ()=>[i=0, res = FnGetOnePage(url)],
        each [res][Data]<>null,
        each [i=[i]+1, res = FnGetOnePage([res][Next])],
        each [res][Data]),

        #"Converted to Table" = Table.FromList(GeneratedList, Splitter.SplitByNothing(), null, null, ExtraValues.Error)
        #"Expand Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1")
    in
    #"Expand Column1"

in 
SHPQueries
        
// This will not refresh in PowerBI online as it is for Sharepoint "ON PREMISE", I am not aware of any way to have your OnPremise Sharepoint
// accessible from Power BI Online .. also I never looked for it .. Go Online !
// Very usefull for Excel : For when you on-premise lists get bigger than the limitation your admin put on your site lists, your can't even use the 
// "export to excel" built-in functionality.
