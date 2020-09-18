let SHPQueries = 
    (SiteURL as text, ListName as text, Select as text, PageLimit as text) =>

    let
        url = (SiteURL&"_api/web/lists/getbytitle('"&ListName&"')/items?$select="&Select&"&$top="&PageLimit),

        FnGetOnePage =
        (url) as record =>
        let
            Source = Json.Document(Web.Contents(url, [Headers=[Accept="application/json;odata=nometadata"]])),
            data = try Source[value] otherwise null,
            next = try Source[odata.nextLink] otherwise null,
            res = [Data=data, Next=next]
        in res,

        GeneratedList =
        List.Generate(
        ()=>[i=0, res = FnGetOnePage(url)],
        each [res][Data]<>null,
        each [i=[i]+1, res = FnGetOnePage([res][Next])],
        each [res][Data]),

        #"Converted to Table" = Table.FromList(GeneratedList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        #"Expand Column1" = Table.ExpandListColumn(#"Converted to Table", "Column1")
    in
    #"Expand Column1"

in 
SHPQueries
