<cfsetting requestTimeOut = "600">

<!--- make_table.cfm: used to make tables out of json data, called via AJAX--->
<cfoutput>
	<!--- Set up variables.--->
	<cfset arrBytes 		= (structKeyExists(FORM, 'json')		? 	FORM['json'].GetBytes()	: 0)>
	<cfset orderList 		= (structKeyExists(FORM, 'rawSQL')		? 	Trim(FORM['rawSQL'])	: '')>
	<cfset turnOffNums 		= (structKeyExists(FORM, 'RowOption')	? 	Trim(FORM['RowOption'])	: 'No')>
	<cfset jsonStr 			= "">
	<cfset jsonArray		= []>
	<cfset jsonArrayKeys 	= []>
	<cfset rules 			= "hotelsbots,pageview,homepage,testpage,ajaxdealpaging,bots_hotels_forms,search,signin,quote,ajaxProcessContactFrom,ajaxDealPaging,ajaxDealSearch,ajaxUploadLogo,ajaxClearLogoNSelectThemes,ajaxProcessBlogComment,ajaxProcessSigninNProcessPasswordNProcessSubmitSugession,ajaxProcessInlineContentEditing,ajaxHotelSearchNHotelLocations,ajaxHotelResultPaging,ajaxHotelBaseSearch">
	<cfset sqlKeywords 		= "\bCOUNT\b|\bSUM\b|\bMIN\b|\bMAX\b|\bFIRST\b|\bLAST\b|\bMEDIAN\b|\bAGGR\b|\bARRAY\b|\bABS\b|\bCUBE\b|\bROLLUP\b|\bGROUPING\b|\bSETS\b|\bCAST\b|\bCOVERT\b|\bFORMAT\b|\bDISTINCT\b|\b::\b|\bas\b">

	<!--- Convert JSON String into char array, rebuild string to properly fit the JSON standard set by the ECMA/IEFF(RFC) --->
	<cfloop index="intChar" from="1" to="#ArrayLen(arrBytes)#" step="1">
		<cfif Chr(arrBytes[intChar]) EQ "{" AND intChar EQ 1>
				<cfset jsonStr = jsonStr & "[{">
		</cfif>
		<cfif Chr(arrBytes[intChar]) EQ "," AND intChar EQ ArrayLen(arrBytes)>
				<cfset jsonStr = jsonStr & "]">
		</cfif>
		<cfif intChar NEQ 1 AND intChar NEQ ArrayLen(arrBytes)>
			<cfset jsonStr = jsonStr & Chr(arrBytes[intChar])>
		</cfif>
	</cfloop>

	<!--- for some reason the brackets weren't placed on the string during the rebuild so we just force them on there. will look into later. --->
	<cfset jsonStr = "[" & jsonStr & "]">

	<!--- Check for null set, if not null convert JSON into an array with structs,
	also get the rawSQL passed in, parse the order of selected fields, unless it's * or a sqlKeyword,
	then order doesn't matter and we get the list of jsonArrayKeys given to us by the jsonArray
	IF NOT NULL, HOWEVER ... just tell the app it's a null set and stop. --->
	<cfif jsonStr NEQ "[]">
		<cfset jsonArray 				= deserializeJSON(jsonStr)>
		<cfset jsonArrayKeys			= trim(REReplaceNoCase(orderList, '\bSELECT(.*)FROM\b(.*)', '\1'))>

		<cfif trim(jsonArrayKeys) EQ '*'>
			<cfset jsonArrayKeys		= structKeyList(jsonArray[1], ",")>
			<cfset jsonArrayKeys 		= listToArray(jsonArrayKeys)>
		<cfelseif ArrayLen(REMatchNoCase(sqlKeywords,trim(jsonArrayKeys))) GT 0>
			<cfset jsonArrayKeys		= structKeyList(jsonArray[1], ",")>
			<cfset jsonArrayKeys 		= listToArray(jsonArrayKeys)>
		<cfelse>
			<cfset jsonArrayKeys 		= listToArray(jsonArrayKeys)>
		</cfif>
	<cfelse>
		<strong>Null Set</strong>
		<cfabort>
	</cfif>

	<!--- This was a check written in response to the array being empty if there's an error with the query before hand.
	This was put in before placing the cfabort in the if else statement in the last code block --->
	<cfif NOT arrayIsEmpty(jsonArrayKeys)>
		<!--- We build a table based on the json data.
		There is an unholy mess of arrays in a arrays in here.
		I-I-I don't want to talk about it.--->
		<table border="1" >
			<tbody>
					<tr>
						<cfif turnOffNums NEQ 'No'>
							<th style="background-color: ##000; color: ##fff">Row</th>
						</cfif>
						<cfloop index="name" array="#jsonArrayKeys#">
							<th class="json-key #name#">#name#</th>
						</cfloop>
					</tr>
				<cfloop index="idx" from="1" to="#arrayLen(jsonArray)#">
					<tr>
						<cfif turnOffNums NEQ 'No'>
							<td style="background-color: ##000; color: ##fff">#idx#</td>
						</cfif>
						<cfloop index="key" array="#jsonArrayKeys#">
							<cfif structKeyExists(jsonArray[idx], trim(key))>
								<td class="json-values <cfif ListFind(trim(rules),jsonArray[idx][trim(key)])>#jsonArray[idx][trim(key)]#</cfif> <cfif trim(key) EQ 'QUERY_STRING'>#trim(key)#</cfif>">#jsonArray[idx][trim(key)]#<cfif trim(lcase(key)) EQ 'remote_host'><a href="javascript:reverseIPLookup('#jsonArray[idx][trim(key)]#');" class="get-reverse-lookup" alt="lookup ips">&nbsp;[lip]</a></cfif></td>
							</cfif>
						</cfloop>
					</tr>
				</cfloop>
					<!--- We place the raw json and raq sql in here for .xls processing later. --->
					<tr style="display:none;">
						<td id="json-raw">#jsonStr#</td>
						<td id="sql-raw">#orderList#</td>
						<input type="hidden" name="hidden_json_data" value="#trim(jsonStr)#">
						<input type="hidden" name="hidden_sql_data" value="#trim(orderList)#">
					</tr>
			</tbody>
		</table>
	<cfelse>
		<!--- Do Nothing --->
	</cfif>
</cfoutput>