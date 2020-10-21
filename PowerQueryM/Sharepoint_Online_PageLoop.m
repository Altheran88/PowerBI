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

// This doesn't run in the cloud refresh as it is considered a "dynamic" Web.Contents()
// I pass the Parameters from the first steps of the query being text input to let the user choose the site, listname,
// pagelimit and the query that is executed on the sharepoint site. Be wary that filtering non-indexed columns will fail if your total number of rows in your list exeeds 5000
// or the limit configured by your adminitrator wichever is lower.
        
// Need to try with static values fixed in the function to see if PowerBI online still sees this quesry function as a "Dynamic Web.Contents".
// Like writing the URL as :
// url = (https://companyname.sharepoint.com/sites/sitename&"_api/web/lists/getbytitle('ListName')/items?$top=5000),
// May be suing the built-in parameters would also fix it.
// If you figure it out, make a pull request :)
