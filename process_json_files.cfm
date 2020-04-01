<cfoutput>
	<cfscript>
		// basic vars breh
		// dateFrom 				= '11-15-2016';
		// dateTo 					= '11-16-2016';
		dateFrom 				= (structKeyExists(FROM, "select-date-from") 	? FROM['select-date-from']	: '');
		dateTo 					= (structKeyExists(FROM, "select-date-to") 		? FROM['select-date-to']	: '');
		filesDirName 			= 'graph_json_testing/files';
		jsonDir 				= directoryList(expandPath("./" & filesDirName), false, "query");
		fileArray 				= {};
		fileArray['name']		= [];
		searchFromArray 		= [];
		searchToArray 			= [];
		fileContent 			= '';

		//make a regex pattern that fits the file name pattern and accepts the dates from the form.
		fileAppend 				= 'antibot_ban_events_';
		suffixNum 				= '\.([0-9])?'; // e.g. .01
		fileExt 				= '\.([log])?';

		searchFrom 				= fileAppend & dateFrom  & suffixNum 	& fileExt;
		searchTo 				= fileAppend & dateTo 	 & suffixNum 	& fileExt;

		//check the dates
		// writeDump(dateDiff("d", dateFrom, 	dateTo));
		// writeDump(dateDiff("d", dateTo, 	dateFrom));
		if(dateDiff("d", dateFrom, 	dateTo) < 0){
			writeOutput('Please correct the date range.');
			abort;
		}

		//regex check for files with dates that match the searchFrom and searchTo patterns.
		for( i = 0; i < jsonDir.recordCount; i++){
			fileArray['name'][i + 1] 	= jsonDir['name'][i + 1];
			if(REFindNoCase( searchFrom , fileArray['name'][i + 1]) > 0){
				arrayAppend(searchFromArray, fileArray['name'][i + 1]);
			}
			if(REFindNoCase( searchTo , fileArray['name'][i + 1]) > 0){
				arrayAppend(searchToArray, fileArray['name'][i + 1]);
			}
		}

		// writeOutput('files');
		// writeDump(fileArray);
		// writeOutput('search from');
		// writeDump(searchFromArray);
		// writeOutput('search to');
		// writeDump(searchToArray);

		//get all the json from all the files from the date range, and dump it all out.
		for(i = 0; i < arrayLen(searchFromArray); i++){
			fileContent = fileContent & fileRead(expandPath("./" 	& filesDirName 	& "/" & searchFromArray[i + 1]));
		}

		for(i = 0; i < arrayLen(searchToArray); i++){
			fileContent = fileContent & fileRead(expandPath("./"  	& filesDirName 	& "/" & searchToArray[i + 1]));
		}

		// writeOutput("<pre>");
		writeOutput(fileContent);
		// writeOutput("</pre>");

		abort;


	</cfscript>
</cfoutput>