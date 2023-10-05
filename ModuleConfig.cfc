/**
 * WireBox Mappings Exporter Module Config
 *
 * After all modules have loaded, this Interceptor exports the WireBox Mappings in VS Code Settings JSON for the ColdBox VS Code Extension
 */
component {

	function configure(){

	}

	function afterAspectsLoad(){
		var wireboxMappings = wirebox.getBinder().getMappings().reduce(
			function(previousValue, key, value){
	  			var mappingStruct = value.getMemento();
				previousValue[ key ] = {
					"name": mappingStruct.name ?: "",
					"path": mappingStruct.path ?: "",
					"type": mappingStruct.type ?: ""
				};
				for( var alias in mappingStruct.alias ){
					if( !structKeyExists( previousValue, alias )){
						previousValue[ alias ] = {
							"name": alias,
							"path": mappingStruct.path,
							"type": mappingStruct.type
						}
					}
				}
				return previousValue;
	   		},
			{}
		);
		var settingsFileFullPath = expandPath( "/.vscode/settings.json" );
		var settings = {};
		if( fileExists( settingsFileFullPath ) ){
			settings = deserializeJSON(
				fileRead(
					settingsFileFullPath
				)
			);
		}
		settings[ "coldbox.wireboxMappings" ] = wireboxMappings
		fileWrite(
			settingsFileFullPath,
			wirebox.getInstance( dsl="JSONPrettyPrint@JSONPrettyPrint" )
				.formatJSON(
					json=serializeJSON( settings ),
					spaceAfterColon=true
				)
		);
	}
}