<cfset ip = trim(FORM['ip'])>
<!--- balantly stolen from stack overflow, it's called 'bootstrapping' --->
<!-- I like giving credit where it is due however - http://stackoverflow.com/questions/16354818/coldfusion-simple-html-parsing --->

<!--- Get the page. --->
<cfhttp method="post" url="http://www.infobyip.com/ipbulklookup.php" resolveurl="true" useragent="coldfusion" result="myPage" timeout="10" charset="utf-8">
<cfhttpparam type="formfield" name="ips" value="#ip#" />
</cfhttp>

<!--- Load up jSoup and parse the document with it. --->
<cfset jsoup = createObject("java", "org.jsoup.Jsoup") />
<cfset document = jsoup.parse(myPage['filecontent']) />

<!--- Search the parsed document for the contents of the TITLE tag. --->
<cfset title = document.select("table.cellpadding3")[1].html() />

<!--- Let's see what we got. --->
<!--- <cfdump var="#title#" /> --->
<cfoutput>
	<table>
		#title#
	</table>
</cfoutput>