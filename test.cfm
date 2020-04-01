<cfset sqlKeywords 		= "\bCOUNT\b|\bSUM\b|\bMIN\b|\bMAX\b|\bFIRST\b|\bLAST\b|\bMEDIAN\b|\bAGGR\b|\bARRAY\b|\bABS\b|\bCUBE\b|\bROLLUP\b|\bGROUPING\b|\bSETS\b|\bCAST\b|\bCOVERT\b|\bFORMAT\b|\bDISTINCT\b|\b::\b|\bas\b">

<cfoutput>
	<cfdump var="#ArrayLen(REMatchNoCase(sqlKeywords, trim('REMOTE_HOST')))#">
</cfoutput>

<!--- <cfscript>
	file 	= fileRead(expandPath('./' & "alasql" & "/" & 'get_all_no_query_with_ajax_in_rule.alasql'), "us-ascii");
	writeDump(file);
	writeOutput(expandPath('./' & "alasql" & "/" & 'get_all_no_query_with_ajax_in_rule.alasql'));
</cfscript> --->