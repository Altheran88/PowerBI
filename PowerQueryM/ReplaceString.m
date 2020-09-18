let
ReplaceAll = (InputTable as table, ColumnName as text, ReplacementTable as table, optional StartRow as number) =>
let
ActualRow = if (StartRow =null) then 0 else StartRow,
result = Table.ReplaceValue(InputTable, ReplacementTable{ActualRow}[Old], ReplacementTable{ActualRow}[New] ,Replacer.ReplaceText, {ColumnName}),

NextRow = ActualRow + 1,

OutputTable = if NextRow > (Table.RowCount(ReplacementTable)-1)
then result
else
@ReplaceAll(result, ColumnName, ReplacementTable, NextRow)
in
OutputTable
in
ReplaceAll

// Super amazin function to mass replace a liste of "words" or characters, much faster and simpler then doing a lot of "Table.ReplaceValue()"
// Require a pre-existing table as "ReplacementTable" of 2 columns : Word_to_replace and Words_to_replace_with
// Words can be single characters,  you can replace with "" if you want to remove "words"
// Might be Query time heavy depending on the text field cleaned
// I'm running it after having split by delemiter " " on a freetext field then remove duplicate rows to extract unique word in my IDs, then it's WordCloud Happy time ;)
// Still takes a while (10minutes?) on 22K unique words spread overs 300K tickets for a table of 2.5M rows
