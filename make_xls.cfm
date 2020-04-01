<cfoutput>
	<!--- <cfdump var="#FORM#"> --->
	<cfset arrBytes 		= trim(FORM['json']).GetBytes()>
	<cfset fileName 		= expandPath("./sheets/#trim(FORM['filename'])#")>
	<cfset jsonStr 			= "">
	<cfset jsonArray		= []>
	<cfset format 			= {}>
	<cfset format.bold 		= "true">
	<cfset format.fgcolor 	= "blue">

	<cftry>

		<!--- <cfloop index="intChar" from="1" to="#ArrayLen(arrBytes)#" step="1">
			<cfif Chr(arrBytes[intChar]) EQ "{" AND intChar EQ 1>
					<cfset jsonStr = jsonStr & "[{">
			</cfif>
			<cfif Chr(arrBytes[intChar]) EQ "," AND intChar EQ ArrayLen(arrBytes)>
					<cfset jsonStr = jsonStr & "]">
			</cfif>
			<cfif intChar NEQ 1 AND intChar NEQ ArrayLen(arrBytes)>
				<cfset jsonStr = jsonStr & Chr(arrBytes[intChar])>
			</cfif>
		</cfloop> --->

		<!--- for some reason the brackets weren't placed on the string during the rebuild so we just force them on there. will look into later. --->
		<!--- <cfset jsonStr = "[" & jsonStr & "]"> --->

		<cfif jsonStr NEQ "[]">
			<cfset jsonArray 			= deserializeJSON(trim(FORM['json']))>
			<cfset jsonArray 			= jsonArray[1]>
			<cfset jsonArrayKeys		= structKeyList(jsonArray[1])>
			<cfset jsonQuery 			= QueryNew(trim(jsonArrayKeys))>
			<cfset xls 					= spreadsheetNew()>
			<cfset columnType 		 	= "">
			<cfset columnValue 			= "">
			<cfset columnNum 			= 1>
			<cfset spreadsheetAddRow(xls,"#jsonArrayKeys#")>
			<cfset spreadsheetFormatRow(xls, format, 1)>


<!--- 			<cfloop index="name" list="#jsonArrayKeys#">
				<td class="json-key">#name#</td>
			</cfloop> --->

			<!--- <cfdump var="#jsonQuery#" abort="true"> --->

			<cfloop index="idx" from="1" to="#arrayLen(jsonArray)#">
				<cfloop index="key" list="#jsonArrayKeys#">
					<cfif trim(lcase(key)) EQ 'date'>
						<cfset columnType = "DATE">
					<cfelseif trim(lcase(key)) EQ 'time'>
						<cfset columnType = "TIME">
					<cfelse>
						<cfset columnType = "VARCHAR">
					</cfif>

					<cfif structKeyExists(jsonArray[idx], trim(key))>
						<cfset columnValue 	= jsonArray[idx]["#trim(key)#"]>
						<!--- <cfset newRow 		= QueryAddRow(jsonQuery, idx)> --->
						<!--- <cfset querySetCELL(jsonQuery, trim(key), columnValue, idx)> --->
						<cfset spreadsheetAddRow(xls, jsonQuery, idx, columnNum)>
					</cfif>
				</cfloop>
				<cfset columnNum++>
			</cfloop>

			<!--- <cfset spreadsheetAddRow(xls, jsonQuery)> --->
			<cfset spreadsheetWrite(s, fileName, true)>

			<p>Spreadsheet created.</p>
		</cfif>

		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>

	</cftry>

</cfoutput>