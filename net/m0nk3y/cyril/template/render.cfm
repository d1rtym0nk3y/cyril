<cfif thistag.executionmode eq "start"><cfsilent>
<cfparam name="attributes.includepath" />
<cfparam name="attributes.variables" default="#structnew()#" />
<cfset structappend(variables, attributes.variables) />
</cfsilent><cfinclude template="#attributes.includepath#" /></cfif>