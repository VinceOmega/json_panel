<cfscript>
	file = fileRead(expandPath('./alasql') & "\" & trim(FORM['query_file_select']));
	writeDump(file);
</cfscript>