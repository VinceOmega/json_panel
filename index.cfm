<!--- This needs to be set up for portions outside of coldfusion aka the <script> tag. --->
<cfparam name="fileContent" type="string" default="">
<!--- JSON Query Panel a la SQL application --->
<cfoutput>
	<html>
		<head>
			<title>Antibot JSON Query Panel a la SQL</title>
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
			<style>
				body,html{margin:0;padding:0;color:##000;background-color:##d8e0d7}
				.heading{text-align:center;}
				.container{width:100%;height:100%;margin:0 auto}
				##date-display{font-weight:600;text-align:center;background-color:red}
				table{font-family:Tahoma,sans-serif}
				fieldset{border:0}
				textarea{width:1200px;height:75px}
				div##query-box{width:800px;height:75px;background-color:##000;color:##fff}
				td,th{background-color:##fff;color:##000}
				td.bots_hotels_forms,td.hotelsbots{background-color:##F50549}
				td.pageview{background-color:##0551F5}
				td.testpage{background-color:##E9F505}
				td.homepage{background-color:##CC08A5}
				td.ajaxdealpaging{background-color:##EDB7DC}
				td.search{background-color:##ff9E00}
				td.signin{background-color:##00FF1E}
				td.quote{background-color:##F4A460}
				td.ajaxProcessContactFrom{background-color:##f296D5}
				td.ajaxDealPaging{background-color:##F576CD}
				td.ajaxDealSearch{background-color:##D48ACB}
				td.ajaxUploadLogo{background-color:##C96FBF}
				td.ajaxClearLogoNSelectThemes{background-color:##F233DC}
				td.ajaxProcessBlogComment{background-color:##F01FD7}
				td.ajaxProcessSigninNProcessPasswordNProcessSubmitSugession{background-color:##ED0CD3}
				td.ajaxProcessInlineContentEditing{background-color:##D40BBC}
				td.ajaxHotelSearchNHotelLocations{background-color:##F2C4ED}
				td.ajaxHotelResultPaging{background-color:##F797EC}
				td.ajaxHotelBaseSearch{background-color:##FF00E1}
			</style>
		</head>
		<body>
			<div class="container">
				<cfif structKeyExists(FORM, 'select-date-from') AND structKeyExists(FORM, "select-date-to")>
					<div id="date-display">
						<span>Dates From <cfif structKeyExists(FORM, 'select-date-from') AND FORM['select-date-from'] NEQ ''>#FORM['select-date-from']#</cfif> - to - <cfif structKeyExists(FORM, 'select-date-to') AND FORM['select-date-to'] NEQ ''>#FORM['select-date-to']#<cfelse>#FORM['select-date-from']#</cfif> are being queried.</span>
					</div>
					<div id="last-sql" contenteditable="true"> Your last SQL query was <span class="get-sql"></span></div><br>
					<div id="status-update"></div>
				</cfif>
				<cfscript>
					// set up vars to sort and display dates.
					dir = directoryList(expandPath("./files"), false, "query");
					dateArray = [];
					idx 	 = 1;
					tmp = "";
				</cfscript>
				<cfloop query="dir">
					<!--- get the dates in their proper format and then stuff them in an array for use later --->
					<cfset cleanDate = REMatchNoCase("([0-9\-]{1,2}\-[0-9\-]{1,2}\-[0-9]{2,4})+", name)[1]>
					<cfif idx EQ 1>
						<cfset dateArray[idx] = cleanDate>
						<cfset idx++>
					<cfelseif dateArray[idx - 1] NEQ cleanDate>
						<cfset dateArray[idx] = cleanDate>
						<cfset idx++>
					</cfif>
				</cfloop>

				<h1 class="heading">Antibot JSON Query Panel a la SQL</h1>

				<form action="##" method="post">
					<fieldset>
						<label for="select-date-from">From:</label>
						<select name="select-date-from">
							<option value="">All</option>
							<cfloop index="date" array="#dateArray#">
								<option value="#date#">#date#</option>
							</cfloop>
						</select>
						<label for="select-date-to">To:</label>
						<select name="select-date-to">
							<option value="">All</option>
							<cfloop index="date" array="#dateArray#">
								<option value="#date#">#date#</option>
							</cfloop>
						</select>
						<input type="submit" name="select-date" value="go">
					</fieldset>
				</form></br>

				<!--- On submit of inital page load, show this : Controls--->
				<cfif structKeyExists(FORM, 'select-date-from') AND structKeyExists(FORM, 'select-date-to') AND FORM['select-date-from'] NEQ "" AND FORM['select-date-to'] NEQ "">
					<cfscript>
						dir = directoryList(expandPath(".\alasql"), false, "query");
					</cfscript>
					<form action="javascript:query();" method="post">
						<fieldset>
							<select name="query_file_select" id="query-file-select">
								<cfloop query="dir">
									<option value="#name#">#name#</option>
								</cfloop>
							</select><button id="query-file-load">Load</button><br>
							<textarea id="query-box">

							</textarea><br>

							<button id="query-post-sub">Query Message</button>
							<label for="rowOption">Turn on Row Numbers?</label>
							<input type="checkbox" value="" id="row-option" name="rowOption" data-checked="NO">
						</fieldset>
					</form>
				</cfif>

				<!--- On submit of inital page load, show this: Display --->
				<cfif structKeyExists(FORM, 'select-date-from') AND structKeyExists(FORM, 'select-date-to') AND FORM['select-date-from'] NEQ "" AND FORM['select-date-to'] NEQ "">
					<div id="display-reverse-lookup">

					</div>
					<p>Data Table</p>
					<div id="display-data"> <!--- contenteditable="true" was here, it's neat but you can't click on href within the editable div --->

					</div>
					<form action="javascript:;" method="post">
						<fieldset>
							<input id="json-to-xls-filename" name="filename" value="" placeholder="Enter filename for excel sheet here." class="rnd-15 grey">
							<button id="convert-to-xls" class="btn">Save As XLS</button>
						</fieldset>
					</form>
					<p>Raw JSON</p>
					<div id="display-json">

					</div>
				</cfif>
			</div>
		</body>
		<script src="js/alasql.min.js"></script>
		<script src="js/sql.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/mootools/1.6.0/mootools-core.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/mootools-more/1.6.0/mootools-more.js"></script>
		<script src="js/highlight.pack.js"></script>

		<!--- On submit of inital page load, get the date ranges and load the data--->
		<cfif structKeyExists(FORM, 'select-date-from') AND structKeyExists(FORM, 'select-date-to') AND FORM['select-date-from'] NEQ "" AND FORM['select-date-to'] NEQ "">
			<cfscript>
					// basic vars breh
					dateFrom 				= (structKeyExists(FORM, "select-date-from") 	? FORM['select-date-from']	: '');
					dateTo 					= (structKeyExists(FORM, "select-date-to") 		? FORM['select-date-to']	: '');
					range 					= dateFrom;
					filesDirName 			= 'files';
					jsonDir 				= directoryList(expandPath("./" & filesDirName), false, "query");
					fileArray 				= {};
					fileArray['name']		= [];
					searchFromArray 		= [];
					searchToArray 			= [];
					searchRangeArray 		= [];
					dataShapingArray 		= [];
					fileContent 			= '';
					jsonStr 				= "";
					jsonDate 				= {};
					jsonArray				= [];
					cnt 					= 1;
					temp 					= "";
					tempArray 				= [];

					//make a regex pattern that fits the file name pattern and accepts the dates from the form.
					fileAppend 				= 'antibot_ban_events_';
					suffixNum 				= '\.([0-9])?'; // e.g. .01
					fileExt 				= '\.([log])?';

					searchFrom 				= fileAppend & dateFrom  & suffixNum 	& fileExt;
					searchTo 				= fileAppend & dateTo 	 & suffixNum 	& fileExt;
					searchRange 			= "";

					//check the dates
					if(dateDiff("d", dateFrom, 	dateTo) < 0){
						writeOutput('Please correct the date range.');
					}

					//regex check for files with dates that match the searchFrom and searchTo patterns.
					for( i = 0; i < jsonDir.recordCount; i++){
						fileArray['name'][i+ 1] 	= jsonDir['name'][i+ 1];
						if(REFindNoCase( searchFrom, fileArray['name'][i + 1]) > 0){
							arrayAppend(searchFromArray, fileArray['name'][i + 1]);
						}

						if(REFindNoCase( searchTo , fileArray['name'][i + 1]) > 0){
							arrayAppend(searchToArray, fileArray['name'][i + 1]);
						}
					}

					// regex check for all the dates inbetween, throw them into an array for later.
					for(i = 1; i < jsonDir.recordCount; i++){
						while(dateDiff("d", range, 	dateTo) NEQ 0){
							range 			= DateFormat(REMatchNoCase("([0-9\-]{1,2}\-[0-9\-]{1,2}\-[0-9]{2,4})+", DateAdd("d", 1, range))[1], "mm-dd-yyyy");
							searchRange 	= fileAppend & range  & suffixNum 	& fileExt;

							if(REFindNoCase(searchRange, fileArray['name'][i]) > 0){
								arrayAppend(searchRangeArray, fileArray['name'][i]);
							} else {
								// do nothing.
							}
						}
						range = dateFrom;
					}

					//get all the json from all the files from the date range, and dump it all out.
					for(i = 0; i < arrayLen(searchFromArray); i++){
						fileContent = fileContent & fileRead(expandPath("./" 		& filesDirName 	& "/" & searchFromArray[i + 1]));
					}

					for(i = 0; i < arrayLen(searchRangeArray); i++){
						fileContent = fileContent & fileRead(expandPath("./" 		& filesDirName 	& "/" & searchRangeArray[i + 1]));
					}

					if(dateFrom NEQ dateTo){
						for(i = 0; i < arrayLen(searchToArray); i++){
							fileContent = fileContent & fileRead(expandPath("./"  	& filesDirName 	& "/" & searchToArray[i + 1]));
						}
					}

					// some shaping bullshit we have to go through in order to do COUNT and SUM stuff correctly.
					// Shout outs to Ben Nadel and Google.
					arrBytes 	= trim(fileContent).GetBytes();
					strChar 	= "";
					for( intChar=1; intChar <= ArrayLen(arrBytes); intChar++){
						strChar = Chr(arrBytes[intChar]);
						if(Chr(arrBytes[intChar]) EQ "{" AND intChar EQ 1){
							jsonStr = jsonStr & "[{";
						}
						if(Chr(arrBytes[intChar]) EQ "," AND intChar EQ ArrayLen(arrBytes)){
							jsonStr = jsonStr & "]";
						}

						if(intChar NEQ 1 AND intChar NEQ ArrayLen(arrBytes)){
							jsonStr = jsonStr & Chr(arrBytes[intChar]);
						}
					}



					//remove the Hotel Search Object. (Only turn this on if you have an issue with getting the data because of the SearchObject. This breaks file combining for some reason.)
					 // jsonStr = reReplaceNoCase(jsonStr, 'SearchObject=(.*),"HTTPS"', 'SearchObject=", "HTTPS"', 'ALL');


					//Store the JSON string into this array of structs, clear jsonStr
					dataShapingArray		= deserializeJSON(jsonStr);
					jsonStr = "";

					//Pull date and time out of EntityDate until we can get Ehrman to alter the console app to do this for us.
					//That way we can get more free clock cycles
					for(intChar = 1; intChar <= ArrayLen(dataShapingArray); intChar++){
						jsonDate	= serializeJSON(dataShapingArray[intChar]['EntryDate']);
						jsonArray 	= dataShapingArray[intChar]['Message'];
						jsonArray[1]['Time'] = ReMatchNoCase("([0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2})",Trim(jsonDate))[1];
						jsonArray[1]['Date'] = ReMatchNoCase("([0-9]{2,4}-[0-9]{1,2}-[0-9]{1,2})",Trim(jsonDate))[1];
						jsonStr 	= jsonStr & serializeJSON(jsonArray) & ",";
					}

					//Put all of that into this variable so we can pass it off to alasal.js later.
					fileContent = reReplaceNoCase(jsonStr, "(\[)|(\])", "", "all");
			</cfscript>
		</cfif>

		<script>

			//domReady
			$(window).addEvent('domready', function(){

				//clear the box on load, set up functions for grabbing data and setting it to the two ajax files, make_table.cfm and make_xls.cfm
				$('query-box').empty();
				rowOption = $('row-option').get('data-checked').trim();


				$('query-post-sub').addEvent('click', function(){
					var sql 		= 	$('query-box').get('value').trim();
					processQuery(sql, rowOption);
				});

				$('convert-to-xls').addEvent('click', function(){
					var json 		= [eval($('json-raw').get('text').trim())];
					var fileName 	= $('json-to-xls-filename').get('value').trim();
					makeIntoSpreadSheet(JSON.stringify(json), fileName);
				});

				$('row-option').addEvent('click', function(){
					rowOption = checkboxChecker('row-option');
					console.log('is this working?');
				});

				$('query-file-load').addEvent('click',function(){
					var path = $('query-file-select').get('value').trim();
					console.log(path);
					loadScript(path);
				});

			});

			function processQuery(sql, rowOption){

				var testdata = [#trim(fileContent)#]
				var rawSQL 	 = sql.trim();
				var sql = '"' + sql + '"';
				// var rowOption = ( ? 'YES' : 'NO');
				console.log(rowOption);
				var jsonStr 	= "";
				$('display-json').empty();
					var res = alasql(eval(sql), [testdata]);
					if(JSON.stringify(res) != "{}"){
						$('display-json').appendHTML(JSON.stringify(res));
						jsonStr = jsonStr + JSON.stringify(res);
					}
				getTableData(jsonStr, rawSQL, rowOption);
			}

			function getTableData(jsonData, sql, option){
				var server = new Request({
					url: "make_table.cfm",
					format: "json",
					method: "post",
					data: {
						json: jsonData,
						rawSQL: sql,
						rowOption: option
					},
					onSuccess: function(text, xml){
						$('display-data').empty().appendHTML(text);
					}
				});

				server.send();
			}

			function makeIntoSpreadSheet(jsonData, fileName){
				var server = new Request({
					url: "make_xls.cfm",
					format: "json",
					method: "post",
					data: {
						json: jsonData,
						filename: fileName
					},
					onSuccess: function(text, xml){
						$('status-update').empty().appendHTML(text);
						console.log(text);
					}
				});
				server.send();
			}

			function checkboxChecker(id){
				if($(id).get('data-checked').trim() === 'YES'){
					$(id).set('data-checked', 'NO');
				 	return 'NO';
				} else {
					$(id).set('data-checked', 'YES');
					return 'YES';
				}
			}

			function loadScript(path){
				var server = new Request({
					url:"read_file.cfm",
					format: "json",
					method: "post",
					data: {
						file: path
					},
					onSuccess: function(text, xml){
						$('query-box').empty().appendHTML(text);
						console.log(text);
					}
				});
			}


			function reverseIPLookup(ips){
				var server = new Request({
					url: "reverse_lookup.cfm",
					format: "json",
					method: "post",
					data: {
						ip: ips,
					},
					onSuccess: function(text, xml){
						$('display-reverse-lookup').empty().appendHTML(text);
						console.log(text);
					}
				});
				server.send();
			}
		</script>
	</html>
</cfoutput>