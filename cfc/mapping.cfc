<cfcomponent name="mapping" displayname="mapping" hint="This CFC allowings adding and deleting CF mappings">

	<cffunction name="getVisitorIP" displayname="Get IP Address" hint="Returns Visitor's' IP address" access="remote" output="false" returntype="string">
		<cfset sIP = "#CGI.Remote_Addr#">
		
		<cfreturn sIP />
	</cffunction>

	<cffunction name="getMappings" displayname="getMappings" hint="This function returns a structure of cf mappings" access="remote" output="false" returntype="struct">
		<cfset factory=createObject("java","coldfusion.server.ServiceFactory")>
		<cfset mappings = factory.runtimeService.getMappings()>
		<cfset stMapping = structNew()>
		<cfset aLogicalPath = ArrayNew(1)>
		<cfset aDirectoryPath = ArrayNew(1)>
		<cfloop collection="#mappings#" item="thismapping">
			<cfscript>
			ArrayAppend(aLogicalPath, thismapping);
			ArrayAppend(aDirectoryPath, mappings[thismapping]);
			</cfscript>
		</cfloop>
		<cfscript>
			StructInsert(stMapping, "logicalpath", aLogicalPath);
			StructInsert(stMapping, "directorypath", aDirectoryPath);
		</cfscript>
		
		<cfreturn stMapping/>
	</cffunction>

	<cffunction name="updateMappings" displayname="updateMappings" hint="This function updates a cf mapping" access="remote" output="false" returntype="boolean">
		<cfargument name="mapname" required="true">
		<cfargument name="mappath" required="true">
		<cfset blnSuccess = false>
		<cfset factory=createObject("java","coldfusion.server.ServiceFactory")>
		<cfset mappings = factory.runtimeService.getMappings()>
		<cftry>
			<cfloop collection="#mappings#" item="thismapping">
				<cfif thismapping eq arguments.mapname>
	            	<cfset tmp = StructUpdate(mappings, thismapping, arguments.mappath)>
	            </cfif>
			</cfloop>
			<cfset blnSuccess = true>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.Message# #cfcatch.Detail#">
		</cfcatch>
		</cftry>
		<cfreturn blnSuccess/>
	</cffunction>

	<cffunction name="createMapping" displayname="createMapping" hint="This function creates a new cf mapping" access="remote" output="false" returntype="boolean">
		<cfargument name="mapname" required="true">
		<cfargument name="mappath" required="true">
		<cfset blnSuccess = false>
		<cfset factory=createObject("java","coldfusion.server.ServiceFactory")>
		<cfset mappings = factory.runtimeService.getMappings()>
		<cftry>
			<cfif arguments.mapname IS NOT "" and arguments.mappath IS NOT "">
            	<cfset mappings[arguments.mapname] = arguments.mappath>
            </cfif>
			<cfset blnSuccess = true>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.Message# #cfcatch.Detail#">
		</cfcatch>
		</cftry>
		<cfreturn blnSuccess/>
	</cffunction>

	<cffunction name="deleteMapping" displayname="deleteMapping" hint="This function deletes a cf mapping" access="remote" output="false" returntype="boolean">
		<cfargument name="mapping" required="true">
		<cfset blnSuccess = false>
		<cfset factory=createObject("java","coldfusion.server.ServiceFactory")>
		<cfset mappings = factory.runtimeService.getMappings()>
		<cftry>
	        <cfloop index="m" list="#arguments.mapping#">
	            <cfset tmp = structdelete(mappings,m)>
	        </cfloop>
			<cfset blnSuccess = true>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.Message# #cfcatch.Detail#">
		</cfcatch>
		</cftry>
		<cfreturn blnSuccess/>
	</cffunction>
	
</cfcomponent>