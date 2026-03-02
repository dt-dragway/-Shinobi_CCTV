var selectedModule = process.argv[2]
if(!selectedModule){
    console.log('You must input arguments.')
    console.log('# node removeCustomAutoLoadModule.js <CUSTOM_AUTOLOAD_FILE_OR_FOLDER_NAME>')
    console.log('Example:')
    console.log('# node removeCustomAutoLoadModule.js ExtraBlocks')
    return
}
var fs = require('fs')
var path = require('path')
var homeDirectory = path.join(__dirname, '..')
var customAutoLoadFolder = path.join(homeDirectory, 'libs', 'customAutoLoad')

var deleteModule = function(myModule){
    // Seguridad: Validar que el nombre del módulo no contenga caracteres de navegación de directorios
    if (myModule.includes('..') || myModule.includes('/') || myModule.includes('\\')) {
        console.error(`[SEGURIDAD] Intento de Path Traversal detectado: "${myModule}"`)
        return
    }

    var targetPath = path.join(customAutoLoadFolder, myModule)
    
    try {
        if (fs.existsSync(targetPath)) {
            fs.rmSync(targetPath, { recursive: true, force: true })
            console.log(`## Removing "${myModule}" (Safe)`)
        } else {
            console.log(`## Module "${myModule}" not found at ${targetPath}`)
        }
    } catch (err) {
        console.error(`## Error removing "${myModule}": ${err.message}`)
    }
}

selectedModule.split(',').forEach(function(myModule){
    deleteModule(myModule.trim())
})
