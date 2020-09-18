let func = (HTML) =>
    let
        Check = if Value.Is(Value.FromText(HTML), type text) then HTML else "",
        Source = Text.From(Check),
        RemoveTags = Html.Table(Source, {{"text",":root"}}),
        GetText = RemoveTags{0},
        SelectText = GetText[text]
    in
        SelectText
in func

//Takes HTML Richtext in your source and removes HTML Tags to leave only the clear text.
//= Table.TransformColumns(#"Query or previous step",{{"ColumnName", HTML_Clean, type text}})
