let func =  
 (String as text, optional Delimiter as text) as text =>
let
    delimiter = if Delimiter = null then " " else Delimiter,
    TextToList = List.Buffer(Text.Split(String, delimiter)),
    FilterList = List.Select(TextToList, each _ <> ""),
    Result = Text.Combine(FilterList, delimiter)
in
    Result
 in 
func

//Apply function to a Text column and specify the repeating character to remove.
//This exemple revoves repeating spaces :
//= Table.TransformColumns(#"Query or Previous Step", {{"ColumnName", each Remove_Repeating_Char(_," "), type text}})
